set nr_indeksu_studenta $1
set nazwa_pliku $2

set model_name [file rootname $nazwa_pliku]

set library_name "$nr_indeksu_studenta"
vlib $library_name
vlib bramki
vmap bramki $library_name

vcom -work $library_name gates.vhd $nazwa_pliku -autoorder

vsim  $library_name.$model_name

add wave -r /*

force -freeze sim:/test/a 1 0, 0 200 -r 400
force -freeze sim:/test/b 1 0, 0 100 -r 200
force -freeze sim:/test/c 1 0, 0 50 -r 100
force -freeze sim:/test/d 1 0, 0 25 -r 50

run 800ns