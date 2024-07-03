#Funzione che fa la stampa nel segunte modo id:tempo_in_cui_inizia
#parametro di ingresso ecx il quale contiene il tempo ed edx che contiene l'id

.section .data
due_punti: .ascii ":"
a_capo: .ascii "\n"
treChar:
    .ascii "000"
dueChar:
    .ascii "00"
unChar:
    .ascii "0"
tempo: .long 0
id: .long 0
.section .text
    .global stampa

.type stampa, @function

stampa:

    movl %ecx,tempo         
    xorl %ecx,%ecx
    movl %edx,%ecx
                        # converto l'id in ascii e lo stampo
    call itoa
                        # stampo i due punti
    movl $4,%eax
    movl $1,%ebx
    leal due_punti,%ecx
    movl $1,%edx
    int $0x80
                        # converto il tempo in ascii e lo stampo
    movl tempo,%ecx

    call itoa
                        # stampo \n
    movl $4,%eax
    movl $1,%ebx
    leal a_capo,%ecx
    movl $1,%edx
    int $0x80

    ret                 # torno alla funzione esecuzione


