# file nel quale vengono presi gli ordini già ordinati nello stack e calcola eventuali costi di ritardi
# parametro in ingresso eax nel quale trovo il numero di righe

.section .data
tempo: .long 0 # contatore per il tempo utilizzato
costi: .long 0 # contatore per i costi di ritardo dovuti alla timeline
offset: .long 0 # variabile per salvare l'offset di %esi
righe: .long 0
priorita: .long 0
scadenza: .long 0
durata: .long 0
conclusione: .ascii "Conclusione: "
conclusione_len: .long . - conclusione
penalty: .ascii "Penalty: "
penalty_len: .long . - penalty
aCapo: .ascii "\n"
.section .bss
cella: .long

.section .text
.global esecuzione
.type esecuzione, @function

esecuzione:
    popl cella       #  metto nella variabile cella il PC cosi posso manipolare lo stack
   
    movl $0,tempo
    movl $0,costi
    movl %eax, righe # sposto il numero di righe nella variabile per il contatore
    xorl %esi, %esi  # pulisco il registro esi per l'offset nello stack

inner:
    movl (%esp, %esi), %eax # sposto la priorita' nel registro eax
    addl $4, %esi
    movl (%esp, %esi), %ebx # sposto la scadenza nel registro ebx
    addl $4, %esi
    movl (%esp, %esi), %ecx # sposto la durata nel regitro ecx
    addl $4, %esi
    movl (%esp, %esi), %edx # sposto l'id del registro edx
    movl %esi, offset       # salvo l'offset di esi

    movl %eax,priorita
    movl %ebx,scadenza
    movl %ecx,durata
    movl tempo,%ecx

    call stampa

    movl priorita,%eax
    movl scadenza,%ebx
    movl durata,%ecx

    incl tempo  # incremento il tempo la stampa
    decl %ecx   # decremento la durata per i calcoli


    addl %ecx, tempo # calcolo il nuovo tempo dopo la produzione dell'ordine
    
    cmpl tempo, %ebx
    jg decremento    # se siamo sotto la scadenza, passa direttamente al prossimo ciclo

    subl tempo, %ebx # sottraggo alla scadenza il tempo per capire di quanto esco
    movl %eax, priorita  # sposto momentaneamente la priorita'
    movl $-1, %eax   # sposto il valore -1 in eax
    mull %ebx        # moltiplico il valore in eax per il valore in ebx. Il risultato lo trovo in eax
    movl %eax, %ebx  # sposto il risultato in ebx
    movl priorita, %eax  # metto la costante per la moltiplicazione (priorita') in eax
    mull %ebx        # moltiplico la differenza tra tempo e scadenza per la costante della moltiplicativa

    addl %eax, costi # sommo i costi
 
decremento:
    decl righe
    cmpl $0, righe
    jz fine 

    movl offset, %esi # imposto nuovamente l'offset ad %esi
    addl $4, %esi     # mi sposto nella prossima cella dello stack se si esegue un altro ciclo
    jmp inner


fine:
                                    # stampo la stringa conclusione
    movl $4,%eax
    movl $1,%ebx
    leal conclusione,%ecx
    movl conclusione_len,%edx
    int $0x80
                                # converto il tempo in ascii e lo stampo
    movl tempo,%ecx
    call itoa
                                 # stampo \n
    movl $4,%eax
    movl $1,%ebx
    leal aCapo,%ecx
    movl $1,%edx
    int $0x80

                                # stampo la stringa penalty
    movl $4,%eax
    movl $1,%ebx
    leal penalty,%ecx
    movl penalty_len,%edx
    int $0x80
                            # converto la penalita in ascii e lo stampo
    movl costi,%ecx
    call itoa

    movl $4,%eax
    movl $1,%ebx
    leal aCapo,%ecx
    movl $1,%edx
    int $0x80


    
    pushl cella       # rimetto il PC in cima allo stack
    ret               # ritorno al main
