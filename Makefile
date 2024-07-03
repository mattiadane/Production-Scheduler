AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

all: bin/pianificatore

# creazione del file eseguibile principale
bin/pianificatore: obj/main.o obj/menu.o obj/atoi.o obj/hpf.o obj/edf.o obj/esecuzione.o obj/itoa.o obj/stampa.o
	ld $(LD_FLAGS) obj/main.o obj/menu.o obj/atoi.o obj/hpf.o obj/edf.o obj/esecuzione.o obj/itoa.o obj/stampa.o -o bin/pianificatore

obj/main.o: src/main.s
	as $(AS_FLAGS) $(DEBUG) src/main.s -o obj/main.o

obj/menu.o: src/menu.s
	as $(AS_FLAGS) $(DEBUG) src/menu.s -o obj/menu.o

obj/esecuzione.o: src/esecuzione.s 
	as $(AS_FLAGS) $(DEBUG) src/esecuzione.s -o obj/esecuzione.o

obj/atoi.o: src/atoi.s
	as $(AS_FLAGS) $(DEBUG) src/atoi.s -o obj/atoi.o

obj/itoa.o: src/itoa.s
	as $(AS_FLAGS) $(DEBUG) src/itoa.s -o obj/itoa.o


obj/hpf.o: src/hpf.s
	as $(AS_FLAGS) $(DEBUG) src/hpf.s -o obj/hpf.o

obj/edf.o: src/edf.s
	as $(AS_FLAGS) $(DEBUG) src/edf.s -o obj/edf.o

obj/stampa.o: src/stampa.s
	as $(AS_FLAGS) $(DEBUG) src/stampa.s -o obj/stampa.o

# make clean rimuove tutti i file oggetto nella cartella obj e rimuove l'eseguibile dalla cartella bin
clean:
	rm -f obj/*.o bin/pianificatore
