#funzione che converta la stringa in intero e la ritorna al menu, 
#prende il valore di ingresso dall'registro %eax
# e valore di ritorno ovvero il numero convertit0o in eax
.section .bss
input:
    .ascii

.section .text
    .global atoi 

.type atoi, @function

atoi:
# Carico il valore all'interno di eax nella variabile input, il valore all'interno di eax proviene dalla funzione menu
    movl %eax,input
# Azzero i registri
    xorl %eax,%eax
    xorl %ebx,%ebx
    xorl %ecx,%ecx
    xorl %edx,%edx
# Carico l'indirizzo di memoria della variabile input al registro esi
    leal input,%esi
repeat:
# Carcico il contenuto all'interno dell'indirizzo di memoria ecx+esi all'interno del registro bl
    movb (%ecx,%esi),%bl  
    cmpb $10,%bl # verico se è stato letto il carattere '\n' che indica la fine della string 
    je finish # in caso positivo ritorno il valore alla funzine menu
    subb $48,%bl # converto il codice ASCII nella cifra del numero corrispondente
    movl $10,%edx 
    mulb %dl   # ebx = ebx * 10
    addl %ebx,%eax
    inc %ecx # incremto ecx cosi se ci fosse un altra cifra punto alla prossima cella di memeoria 
    jmp repeat
finish:    
    ret 

