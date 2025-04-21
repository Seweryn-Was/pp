-- Wersja układu z magistralą BUS, MUX8 i MUX2
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Processor_Core IS
    PORT (
        SW           : IN STD_LOGIC_VECTOR(17 DOWNTO 0);   -- Switches
        KEY          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);    -- Keys
        LEDR         : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);   -- LEDs
		  
		  R0Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
		  R1Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
		  R2Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
		  R3Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
		  R4Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
		  R5Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
		  R6Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
		  AQ : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
		  IRQ:  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  T_step: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END Processor_Core;

ARCHITECTURE Behavioral OF Processor_Core IS

    COMPONENT regn IS
        PORT(
              R : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
              Rin, Clock : IN STD_LOGIC;
              Q : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0)
            );
    END COMPONENT;
    
    COMPONENT upcount IS
        PORT (
            Clear, Clock : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT dec3to8 IS
        PORT (
            W  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            En : IN STD_LOGIC;
            Y  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT MUX2 IS
        PORT (
            IN0     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IN1     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            SEL     : IN STD_LOGIC;
            DATA_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT Mux8to1 IS
        PORT (
            IN_0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IN_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IN_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IN_3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IN_4 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IN_5 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IN_6 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IN_7 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IN_8 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            SEL  : IN STD_LOGIC_VECTOR(8 DOWNTO 0);       
            MUX_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT Adder IS
        PORT (
            A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            SUM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            ADD_SUB : IN STD_LOGIC
        ); 
    END COMPONENT;
	 
	 COMPONENT hex_to_7seg IS
    PORT (
        binary_in : in  STD_LOGIC_VECTOR (3 downto 0); 
        seg_out   : out STD_LOGIC_VECTOR (6 downto 0)
    );
	 END COMPONENT;

   SIGNAL BUS_WIRES : STD_LOGIC_VECTOR(15 DOWNTO 0); -- BUS displayed as LEDR(15 DOWNTO 0)
   SIGNAL DIN : STD_LOGIC_VECTOR(15 DOWNTO 0);      -- DIN connected to SW(15 DOWNTO 0)
   SIGNAL CLK : STD_LOGIC;                          -- Clock connected to KEY(1)
   SIGNAL Resetn : STD_LOGIC;                       -- Resetn connected to KEY(0)
   SIGNAL Run : STD_LOGIC;
	SIGNAL Done : STD_LOGIC;
	
	SIGNAL Rin : STD_LOGIC_VECTOR(7 DOWNTO 0); -- R0in, R1in, R2in, R3in, R4in, R5in, R6in, Ain  
	SIGNAL IRin : STD_LOGIC;
	
	SIGNAL Rout : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL DINout : STD_LOGIC; 

	SIGNAL MUX_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
			  
   SIGNAL MUX_SEL_A  : STD_LOGIC;  
	SIGNAL ADD_SUB    : STD_LOGIC;
	
	SIGNAL A_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL IR_OUTPUT : STD_LOGIC_VECTOR(8 DOWNTO 0);
	
	SIGNAL R0_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL R1_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL R2_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL R3_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL R4_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL R5_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL R6_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL SUM_SUB_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL Xreg : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Yreg : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL MUX_SEL_REG : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL Clear : STD_LOGIC; 
	SIGNAL Tstep_Q : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL I : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	CONSTANT High : STD_LOGIC := '1';   -- Defining High as '1'
   CONSTANT Low  : STD_LOGIC := '0';   -- Optionally, you can define Low too
	
BEGIN
	DIN <= SW(15 DOWNTO 0);        -- Switches 15:0 are the DIN input
	CLK <= KEY(1);                 -- KEY(1) is the Clock signal  !!!!!!!!!!!!!DODAĆ POTEM NOT !!!!!!!!!!!!!
	Resetn <= KEY(0);              -- KEY(0) is the Resetn signal
	Run <= SW(17);                 -- SW(17) is the Run signal
	LEDR(15 DOWNTO 0) <= BUS_WIRES;-- BUS_WIRES drives LEDs 15:0
	LEDR(17) <= Done;              -- Done signal drives LEDR(17)
	
	

	Clear <=  (((NOT Run OR Done) OR (NOT Resetn) )AND NOT(Tstep_Q(0) OR Tstep_Q(1))) OR Done; --OR (NOT Resetn);
	
	Tstep: upcount PORT MAP (Clear, CLK, Tstep_Q);
	T_step <= Tstep_Q;
	
	I <= IR_OUTPUT(2 DOWNTO 0);
	decX: dec3to8 PORT MAP (IR_OUTPUT(5 DOWNTO 3), High, Xreg);
	decY: dec3to8 PORT MAP (IR_OUTPUT(8 DOWNTO 6), High, Yreg); 	
	
	--restet: PROCESS(Resetn, CLK)
	--BEGIN 
	--   IF CLK'EVENT AND CLK = '1' THEN
	--		IF Resetn = '0' THEN
	--		  Rout <= (OTHERS => '0');
	--		  Rin <= (OTHERS => '1');
	--		  DINout <= '0';
	--		  Done <= '0';
	--		  MUX_SEL_A <= '1'; 
	--		  ADD_SUB <= '0';
	--		 END IF;
	--	 END IF;
	--END PROCESS;
	
	controlsignals: PROCESS (Tstep_Q, I, Xreg, Yreg)
	BEGIN
		Rout <= (OTHERS => '0');
		Rin <= (OTHERS => '0');
		DINout <= '0';
		MUX_SEL_A <= '0';
		Done <= '0';
		ADD_SUB <= '0';
		IRin <= '0';
	
	   IF Resetn = '0' THEN
        Rout <= (OTHERS => '0');
        Rin <= (OTHERS => '1');
        DINout <= '0';
        Done <= '0';
		  MUX_SEL_A <= '1'; 
		  ADD_SUB <= '0';
		ELSE
			CASE Tstep_Q IS
				 WHEN "00" => -- store DIN in IR as long as Tstep_Q = 0
						IRin <= '1';
				 WHEN "01" => -- step T1
					 CASE I IS
						WHEN "000" => -- instrukcja mv RX, RY  
							Rout <= Yreg; --Rxout <= Yreg
							Rin <= Xreg; 
							Done <= High; 
						WHEN "001" => -- instrukcja mvi RX,#D 
							DINout <= High; 
							Rin <= Xreg; 
							Done <= High; 
						WHEN "010" => -- instrukcja add RX, RY
							MUX_SEL_A <= High; 
							Rin(7) <= High; -- Ain 
							Rout <= Xreg; 
						WHEN "011" => -- instrukcja sub RX, RY
							MUX_SEL_A <= High; 
							Rin(7) <= High; -- Ain 
							Rout <= Xreg; 
						WHEN OTHERS =>
							Done <= High;
					 END CASE;
				 WHEN "10" => -- step T2
					 CASE I IS
						WHEN "010" => -- instrukcja add RX, RY
							Rout <= Yreg; 
							Rin(7) <= High;
							Done <= High; 
						WHEN "011" => -- instrukcja sub RX, RY
							Rout <= Yreg;  
							Rin(7) <= High;
							ADD_SUB <= High;
							Done <= High; 
						WHEN OTHERS => 
							Done <= High;
					 END CASE;
				 WHEN OTHERS =>
			 END CASE;
		  END IF; 
	 END PROCESS; 

 
	A: regn PORT MAP(R => MUX_OUTPUT, Rin=>Rin(7), Clock =>CLK, Q=>A_OUTPUT);
	
	R0: regn PORT MAP(R => BUS_WIRES, Rin=>Rin(0), Clock =>CLK, Q=>R0_OUTPUT);
	R1: regn PORT MAP(R => BUS_WIRES, Rin=>Rin(1), Clock =>CLK, Q=>R1_OUTPUT);
	R2: regn PORT MAP(R => BUS_WIRES, Rin=>Rin(2), Clock =>CLK, Q=>R2_OUTPUT);
	R3: regn PORT MAP(R => BUS_WIRES, Rin=>Rin(3), Clock =>CLK, Q=>R3_OUTPUT);
	R4: regn PORT MAP(R => BUS_WIRES, Rin=>Rin(4), Clock =>CLK, Q=>R4_OUTPUT);
	R5: regn PORT MAP(R => BUS_WIRES, Rin=>Rin(5), Clock =>CLK, Q=>R5_OUTPUT);
	R6: regn PORT MAP(R => BUS_WIRES, Rin=>Rin(6), Clock =>CLK, Q=>R6_OUTPUT);
	
	--HEX_DECODER0: hex_to_7seg PORT MAP(binary_in => A_OUTPUT(3 DOWNTO 0), seg_out => HEX0); 
	--HEX_DECODER1: hex_to_7seg PORT MAP(binary_in => A_OUTPUT(7 DOWNTO 4), seg_out => HEX1); 
	--HEX_DECODER2: hex_to_7seg PORT MAP(binary_in => A_OUTPUT(11 DOWNTO 8), seg_out => HEX2); 
	--HEX_DECODER3: hex_to_7seg PORT MAP(binary_in => A_OUTPUT(15 DOWNTO 12), seg_out => HEX3); 
	
	--HEX_DECODER4: hex_to_7seg PORT MAP(binary_in => R0_OUTPUT(3 DOWNTO 0), seg_out => HEX4); 
	--HEX_DECODER5: hex_to_7seg PORT MAP(binary_in => R0_OUTPUT(7 DOWNTO 4), seg_out => HEX5); 
	--HEX_DECODER6: hex_to_7seg PORT MAP(binary_in => R0_OUTPUT(11 DOWNTO 8), seg_out => HEX6); 
	--HEX_DECODER7: hex_to_7seg PORT MAP(binary_in => R0_OUTPUT(15 DOWNTO 12), seg_out => HEX7);
	
	IR: regn PORT MAP(R => DIN, Rin=>IRin, Clock =>CLK AND RUN, Q(8 DOWNTO 0) => IR_OUTPUT);
	
	mux: MUX2 PORT MAP (IN0 => SUM_SUB_OUTPUT, IN1 => BUS_WIRES, SEL => MUX_SEL_A, DATA_OUT => MUX_OUTPUT);
	reg_mux : Mux8to1 PORT MAP (
        IN_0 => R0_OUTPUT, 
		  IN_1 => R1_OUTPUT, 
		  IN_2 => R2_OUTPUT,
		  IN_3 => R3_OUTPUT, 
		  IN_4 => R4_OUTPUT, 
		  IN_5 => R5_OUTPUT, 
		  IN_6 => R6_OUTPUT, 
		  IN_7 => A_OUTPUT, 
		  IN_8 => DIN, 
		  SEL => MUX_SEL_REG, --Rout & DINout, 
		  MUX_OUT => BUS_WIRES
    ); 
	 
	 MUX_SEL_REG <= DINout & Rout ; 
	 sumator: Adder PORT MAP(A => A_OUTPUT, B=>BUS_WIRES, SUM=>SUM_SUB_OUTPUT, ADD_SUB=>ADD_SUB);		
	 
	 R0Q <= R0_OUTPUT; 
	 R1Q <= R1_OUTPUT;
	 R2Q <= R2_OUTPUT;
	 R3Q <= R3_OUTPUT;
	 R4Q <= R4_OUTPUT;
	 R5Q <= R5_OUTPUT;
	 R6Q <= R6_OUTPUT;
	 AQ <= A_OUTPUT;
	 IRQ(8 DOWNTO 0) <= IR_OUTPUT; 
	 
	
    
END Behavioral;
