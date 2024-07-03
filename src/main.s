.section .data
tmp: .int 0
num_gen: .int 0
rows: .int 0
count: .int 0
number: .int 0
fd: .int 0               # File descriptor
buffer: .string ""       # Spazio per il buffer di input
err1: .ascii "Errore! File non passato come parametro\n"
err1_len: .long . - err1
err2: .ascii "Errore! Percorso del file non valido o file inesistente\n"
err2_len: .long . - err2
err3: .ascii "Errore nella lettura del file\n"
err3_len: .long . - err3
err4: .ascii "\nErrore! Il numero inserito non è un numero valido\n"
err4_len : .long . - err4
err5: .ascii "Errore! Il file è vuoto\n"
err5_len : .long . - err5
err6: .ascii "Errore! Il file è stato costruito in maniera non adeguata\n"
err6_len : .long . - err6
err7: .ascii "Errore! Sono stati passati troppi parametri\n"
err7_len : .long . - err7


.section .bss
filename: .string ""  # nome del percorso del file

.section .text
    .global _start

_start:
    popl %ecx          # Rimuovo il primi parametri dallo stack per capire quanti parametri sono stati passati
    cmpl $1,%ecx       # se il numero e' uguale ad 1 non è stato nessun parametro, stampo l'errore ed esco
    je error1
    cmpl $2,%ecx       # se il numero dei parametri e' maggiore di 2 vuol dire che sono stati passati più parametri
    jg error7           # stampo messaggio di errore ed esco
    # se minore di 2 vuol dire che mi e' stato passato solo un parametro e quindo solo il file da dove leggere i dati
    popl %ecx           # tolgo dallo satck il nome del file
    popl %ecx          # tolgo dallo stack il percorso del file
    
readFile:

    movl %ecx,filename

    jmp openFile      # Salto all'etichetta per l'apertura del file

    jmp closeFile     # chiudo il file

# Apre il file
openFile:
    movl $5, %eax       
    movl filename, %ebx  # Carico l'indirizzo del percorso del file , non faccio la lea 
                         # in quanto facendo la popl ho già caricato in filename l'indirizzo del percorso
    movl $0, %ecx        # Modalità di apertura solo lettura
    int $0x80           

    # Se c'è un errore, stampa messaggio di errore e termina il programma
    cmpl $0, %eax
    jl error2

    movl %eax, fd      # Salva il file descriptor nella variabile fd che verrà poi spostato in ebx

# Legge il file riga per riga
readLine:
    movl $3, %eax        
    movl fd, %ebx        # File descriptor
    leal buffer, %ecx    # Buffer di input
    movl $1, %edx        # Lunghezza massima
    int $0x80           

    cmpl $0,%eax        # verifico se ci sono errori 
    jl error3          # Se ci sono errori nella lettura del file chiudo il file stampo un messaggi di errore e termina il programma
    
    cmpl $0,%eax        # verifico se il file è terminato
    je closeFile        # se il file e' terminato chiudo il file e stampo il menu
    

    cmpb $10,buffer     # controllo che il carattere e' uguale a \n se è uguale incremento il contatore delle righe
    je inc_rows
    
    cmpb $44,buffer     # controllo che il carattere e' uguale a , nel caso positivo carico il numero nello stack
    je pushh            # se diverso inizio a creare il numero dai valori presi dal file

create_number:

    movb buffer,%bl
    subb $48,%bl         # trasformo il carattere da ascii a int
    movl $10,%edx        # carico il 10 in edx per fare la moltiplicazione
    movl number,%eax     # carico il numero in eax
    mulb %dl             # eseguo l'operazione eax = eax * 10
    movl %eax,number     
    addl %ebx,number     # aggiungo al numero il valore del carattere attuale 
    

    jmp readLine

pushh:    
    incw tmp
pushh_without_increment:
    incb num_gen            # aggiungo uno ai valori del file totalo
    pushl number            # Carico il numero sulla cima dello stack
    movb $0,number          # resetto la variabile per creare il numero
    jmp readLine            # torno a leggere il prossimo carattere 

inc_rows:
    movl tmp,%eax                     
    cmpl $3,tmp                # se il numero di numeri letti prima del \n = 3 vuol dire che la rig aha 4 valori
                            # e quindi e' costruita bene
    jne error6              # se diverso da 3 il file e' costruito male e stampo a video l'errore e termino il programma
    movl $0,tmp             
    addl %eax,num_gen       # aggiungo il numero di numeri letti nella riga nei numeri in tutto 
    incw rows                               # incremento il contatore delle righe
    jmp pushh_without_increment          # carico l'ultimo elemento della riga sulla cima dello stack


# Chiude il file
closeFile:
    movl $6, %eax        # system call per la chiusura del file
    movl %ebx, %ecx      # sposto il File descriptor
    int $0x80 

    cmpl $0,num_gen      # se i numeri letti sono uguali a 0 il file e' vuoto e quindi il 
    je error5            # programma stampa un messaggio di errore e termina il programma 


    jmp Menu

#gestisco l'errore nel caso in cui non viene passato il file come parametro
# Stampo un messaggio in standard error e termina il porgramma
error1:
    movl $4, %eax
    movl $2, %ebx   # Stampo l'errore su standard error
    leal err1, %ecx
    movl err1_len, %edx
    int $0x80

    jmp exit

#gestisco l'errore nel caso in cui il percorso del file non è corretto o file inesistente
# Stampo un messaggio in standard error e termina il porgramma
error2:
    movl $4, %eax
    movl $2, %ebx   # Stampo l'errore su standard error
    leal err2, %ecx
    movl err2_len, %edx
    int $0x80

    jmp exit


# errore nella lettura del file
error3:
    movl $6, %eax        # system call per la chiusura del file
    movl %ebx, %ecx      # sposto il File descriptor
    int $0x80 

    movl $4, %eax
    movl $2, %ebx   # Stampo l'errore su standard error
    leal err3, %ecx
    movl err3_len, %edx
    int $0x80

    jmp exit

#Gestisco l'errore se il file è vuoto se vuoto termino il programma
error5:
    movl $4, %eax
    movl $2, %ebx   # Stampo l'errore su standard error
    leal err5, %ecx
    movl err5_len, %edx
    int $0x80

    jmp exit
#Gestisco l'errore nel caso in cui il file e' stato costruito male, ovvero non sono presenti 4 numeri per riga
error6:
    movl $4, %eax
    movl $2, %ebx   # Stampo l'errore su standard error
    leal err6, %ecx
    movl err6_len, %edx
    int $0x80

    jmp exit
#Gestisco l'errore nel caso in cui il vengono passati più parametri
error7:
    movl $4, %eax
    movl $2, %ebx   # Stampo l'errore su standard error
    leal err7, %ecx
    movl err7_len, %edx
    int $0x80

    jmp exit

Menu:
    # Richiamo la funzione menu la quale stampa il menu e ritorno il numero scelto dall'utente
    call menu

    # Confronto la scelta dell'utente se uguale a 0 esco dal programma se 1 utilizzo l'algoritmo EDF se 2 utilizzo l'algoritmo HPF, altrimenti gestisco l'errore
    cmpl $0,%eax
    je exit
    cmpl $1,%eax
    je EDF_algorithm
    cmpl $2,%eax
    je HPF_algorithm
    # Caso in cui venga inserimento un numero diverso da 0,1,2 il programma stampa un messaggio di errore e ritorna all etichetta menu e dunque richiede l'input

    movl $4,%eax
    movl $2,%ebx   # Stampo l'errore su standard error
    leal err4,%ecx
    movl err4_len,%edx
    int $0x80
    jmp Menu

EDF_algorithm:
    movl rows,%eax   # sposto il numero di righe in eax cosi da averlo come parametro della funzione 
    call EDF         # richiamo la funzione EDF
    movl rows, %eax  # mi faccio passare il numero di righe
    call esecuzione
    jmp Menu         # ripresento il menu
HPF_algorithm: 
    movl rows,%eax    # sposto il numero di righe in eax cosi da averlo come parametro della funzione
    call HPF          # richiamo la funzione HPF
    movl rows, %eax   # mi faccio passare il numero di righe
    call esecuzione
    jmp Menu          # ripresento il menu

exit:
#Termina il programma
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
    
