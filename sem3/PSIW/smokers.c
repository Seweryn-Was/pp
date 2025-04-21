#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/shm.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/msg.h>
#include <stdbool.h>
#include <sys/wait.h>
#include <errno.h>
#include <string.h> // For strerror()

#define NUM_PROCESSES 3
#define SEM_KEY 0x2345

// Struktura wiadomości
struct message {
    long mtype;       // Typ wiadomości (proces docelowy)
    int sender;       // Nadawca wiadomości
    int op;          // op >0 kwota op do przesłana do danego  
    int id; 
};

#define SHM_SIZE 1024  // rozmiar segmentu pamięci współdzielonej
#define AGENT 0
#define TOBACCO 1 
#define PAPER 2
#define MATCHES 3
// Struktura do przechowywania trzech liczb całkowitych
struct shared_data {
    int a;
    int b;
    int c;
    //bool can_do_business; 
    bool can_do_business; 
};

struct smoker_card {
  int id; 
  int ingredient1;
  int *ingredient1_price;
  bool has_ingredient1; 
  int ingredient2; 
  int *ingredient2_price;
  int ingredients_in_posession; 
};


const char* get_smoker_name(int smoker_id) {
    switch (smoker_id) {
        case TOBACCO: return "Tobacco";
        case PAPER:   return " Paper ";
        case MATCHES: return "Matches";
        default: return "Unknown";
    }
}

int msgid_cleanup; 

void cleanup(int signum){
  if(msgctl(msgid_cleanup, IPC_RMID, NULL) == -1){ 
    perror("msgctl cleanupError\n"); 
    exit(1); 
  }
  printf("Zamyknie Aplikacji powiodło się zamknięciem kolejki komunikatów\n"); 
  exit(0); 
}

void init_semaphore(int sem_id, int value) {
    if (semctl(sem_id, 0, SETVAL, value) == -1) {
        perror("semctl failed");
        exit(EXIT_FAILURE);
    }
}

void semaphore_wait(int sem_id, int decrement) {
    if (decrement <= 0) {
        fprintf(stderr, "Invalid decrement value: %d\n", decrement);
        exit(EXIT_FAILURE);
    }
    struct sembuf op = {0, -decrement, 0}; // Opuszczanie semafora o `decrement`
    if (semop(sem_id, &op, 1) == -1) {
        perror("semop wait failed");
        exit(EXIT_FAILURE);
    }
}

void semaphore_signal(int sem_id, int increment) {
    if (increment <= 0) {
        fprintf(stderr, "Invalid increment value: %d\n", increment);
        exit(EXIT_FAILURE);
    }
    struct sembuf op = {0, increment, 0}; // Podnoszenie semafora o `increment`
    if (semop(sem_id, &op, 1) == -1) {
        perror("semop signal failed");
        exit(EXIT_FAILURE);
    }
}


// Funkcja dla każdego procesu potomnego
void smoker(int process_id, int msgid, int sem_id,  struct shared_data *data) {
  int i;
  struct message msg;
  msg.sender = -1; 
  msg.mtype = 7; 
  msg.op = 0; 

  int msg_num = 100; 
  bool inTransaction = false; 

  struct smoker_card smoker_card;
  smoker_card.ingredients_in_posession = 0;  
  smoker_card.id = process_id; 
  if(process_id == TOBACCO){
    smoker_card.ingredient1 = PAPER; 
    smoker_card.ingredient2 = MATCHES; 
    smoker_card.ingredient1_price = &(data->b); 
    smoker_card.ingredient2_price = &(data->c);
  }
  if(process_id == PAPER){
    smoker_card.ingredient1 = TOBACCO; 
    smoker_card.ingredient2 = MATCHES; 
    smoker_card.ingredient1_price = &(data->a); 
    smoker_card.ingredient2_price = &(data->c);
  }
  if(process_id == MATCHES){
    smoker_card.ingredient1 = TOBACCO; 
    smoker_card.ingredient2 = PAPER; 
    smoker_card.ingredient1_price = &(data->a); 
    smoker_card.ingredient2_price = &(data->b);
  }

  int my_money = 100; 

  printf("Palacz (%s):\t Jestem procesem %d Potrzebuję składnika: \n\t-%s za %d \n\t-%s za %d \n",
    get_smoker_name(smoker_card.id), process_id,  get_smoker_name(smoker_card.ingredient1), *(smoker_card.ingredient1_price),   get_smoker_name(smoker_card.ingredient2), *(smoker_card.ingredient2_price)); 
  
  while(1){ 
    sleep(1);
    if(msgrcv(msgid, &msg, sizeof(msg) - sizeof(long), smoker_card.id + 3, IPC_NOWAIT) != -1){ 
      if(msg.op > 0){
        my_money += msg.op; 
        printf("Palacz (%s)[%d$]:\t Otrzymałem kwotę %d$ od Palacza %s\n", 
          get_smoker_name(smoker_card.id), my_money, msg.op, get_smoker_name(msg.sender));
        msg.mtype = msg.sender;
        msg.sender = process_id;
        msg.id = msg.id + 10; 
        msg.op = -1; 
        printf("Palacz (%s)[%d$]:\t Wysyłam mój składnik do Palacza %s.\n", 
          get_smoker_name(smoker_card.id), my_money, get_smoker_name(msg.mtype));
        msgsnd(msgid, &msg, sizeof(msg) - sizeof(long), 0);
      }
    }
    int total_cost = *(smoker_card.ingredient1_price) + *(smoker_card.ingredient2_price); 

    if(((my_money - total_cost) >= 0) && !inTransaction && data->can_do_business){ 
      int price;
      inTransaction = true; 
      semaphore_wait(sem_id, 1); 

      msg.mtype = smoker_card.ingredient1 + 3; 
      msg.sender = smoker_card.id; 
      msg.op = *(smoker_card.ingredient1_price); 
      my_money -= *(smoker_card.ingredient1_price); 
      msg.id = smoker_card.ingredient1 + 10;

      printf("Palacz (%s)[%d$]:\t wysyłam pieniądze %d$ do  %s.\n", 
        get_smoker_name(smoker_card.id), my_money, *(smoker_card.ingredient1_price), get_smoker_name(smoker_card.ingredient1));
      msgsnd(msgid, &msg, sizeof(msg) - sizeof(long), 0);

      msg.mtype = smoker_card.ingredient2 + 3; 
      msg.sender = smoker_card.id; 
      price = *(smoker_card.ingredient2_price); 
      msg.op = price; 
      my_money -= price; 
      msg.id = smoker_card.ingredient2  + 10;

      printf("Palacz (%s)[%d$]:\t wysyłam pieniądze %d$ do  %s.\n", 
        get_smoker_name(smoker_card.id), my_money,price, get_smoker_name(smoker_card.ingredient2));
      msgsnd(msgid, &msg, sizeof(msg) - sizeof(long), 0);
    }

    for(int i = 1; i<=NUM_PROCESSES; i++){
      if(i == smoker_card.id) continue; 
      if(msgrcv(msgid, &msg, sizeof(msg) - sizeof(long), smoker_card.id, IPC_NOWAIT) != -1){
        if(msg.op == -1){  
          printf("Palacz (%s)[%d$]:\t Otrzymałem składnik %s.\n", get_smoker_name(smoker_card.id), my_money, get_smoker_name(msg.sender));
          smoker_card.ingredients_in_posession +=1; 
        }
      }
    }
    if(smoker_card.ingredients_in_posession == 2){ 
      semaphore_signal(sem_id, 1); 
      printf("Palacz (%s)[%d$]:\t Palę.\n", get_smoker_name(smoker_card.id), my_money);
      sleep(5); 
      printf("Palacz (%s)[%d$]:\t Skończyłem palić.\n", get_smoker_name(smoker_card.id), my_money); 
      inTransaction = false; 
      smoker_card.ingredients_in_posession = 0; 
    }
  }
}

void agent(int sem_id,  struct shared_data *data){ 
  printf("Agent: Jestem Agentem. Ustalam ceny.\n"); 
  while(1){ 
    sleep(10);
    data->can_do_business = false; 
    semaphore_wait(sem_id, 3); 
    data->a = (rand() % 50) + 10;
    data->b = (rand() % 50) + 10;
    data->c = (rand() % 50) + 10;

    printf("Agent:\t Wprowadzam nowe ceny: Tobacco: %d, Paper: %d, Matches: %d.\n",
      data->a, data->b, data->c);
    semaphore_signal(sem_id, 3); 
    data->can_do_business = true; 
    
  }
}




int main() {

  key_t key_shared_data = ftok("shmfile", 34);  // Tworzymy unikalny klucz dla pamięci współdzielonej
  if (key_shared_data == -1) {
      perror("ftok shmfile");
      exit(1);
  }
  int shmid = shmget(key_shared_data, 4*sizeof( int/*struct shared_data*/), 0666 | IPC_CREAT);
  if (shmid == -1) {
    perror("shmget");
    exit(EXIT_FAILURE);
  }
  

  // Podłączamy segment pamięci współdzielonej do przestrzeni adresowej procesu
  struct shared_data *data = (struct shared_data*) shmat(shmid, NULL, 0);
  if (data == (void*) -1) {
      perror("shmat");
      exit(1);
  }

  int sem_id = semget(SEM_KEY, 3, IPC_CREAT | 0666);
  if (sem_id == -1) {
      perror("semget failed");
      exit(EXIT_FAILURE);
  }
  init_semaphore(sem_id, 3); 

  // Inicjalizacja danych w pamięci współdzielonej
  data->a = 49;
  data->b = 51;
  data->c = 52;
  data->can_do_business = true; 

  key_t key;
  int msgid, i;
  pid_t pid;

  // Utworzenie klucza IPC
  key = ftok("progfile1", 66);
  if (key == -1) {
      perror("ftok failed");
      exit(EXIT_FAILURE);
  }
  

  // Utworzenie kolejki komunikatów
  msgid = msgget(key, 0666 | IPC_CREAT | IPC_EXCL);
  if (msgid == -1) {
      perror("msgget failed");
      exit(EXIT_FAILURE);
  }
  msgid_cleanup = msgid; 



  // Tworzenie procesów potomnych
  for (i = 1; i <= NUM_PROCESSES; i++) {
      pid = fork();
      if (pid == 0) {
          // Proces potomny
          smoker(i, msgid, sem_id, data);
      } else if (pid < 0) {
          perror("fork failed");
          exit(EXIT_FAILURE);
      }
  }
  signal(SIGINT, cleanup); 
  
  agent(sem_id, data); 

  // Oczekiwanie na zakończenie procesów potomnych
  for (i = 0; i < NUM_PROCESSES; i++) {
      wait(NULL);
  }

  // Usunięcie kolejki komunikatów
  msgctl(msgid, IPC_RMID, NULL);

  printf("Main process finished.\n");
  return 0;
}
