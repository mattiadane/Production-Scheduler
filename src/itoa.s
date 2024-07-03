#funzione che converte un intero in ascii e lo stampa a video
# parametro in ingresso ecx 

.section .data
quattroChar:
    .ascii "0000"
treChar:
    .ascii "000"
dueChar:
    .ascii "00"
unChar:
    .ascii "0"
numero: .long 0

.section .text
    .global itoa

.type itoa, @function
itoa:
    movl %ecx,numero
    movl numero,%eax
    
    movl $10,%ebx
    xorl %edx,%edx
                            # controllo quante cifra ha il numero 
    cmpl $10,%ecx
    jl one_digit
    cmpl $100,%ecx
    jl two_digit
    cmpl $1000,%ecx
    jl three_digit

    xorl %esi,%esi
    leal quattroChar,%esi              # carico l'indirizzo in esi
    addl $3,%esi                        # mi spsoto nella cifra meno significativa 
    movl $4,%ecx                        # metto il ciclo in base al numero di cifre che possiede il numero
    jmp dividi
   
                                            # faccio la stessa cosa se il numero possiede una / due / tre cifre 
one_digit:
    xorl %esi,%esi
    leal unChar,%esi
    movl $1,%ecx
    jmp dividi
two_digit:
    xorl %esi,%esi
    leal dueChar,%esi
    addl $1,%esi
    movl $2,%ecx
    jmp dividi
three_digit:
    xorl %esi,%esi
    leal treChar,%esi
    addl $2,%esi
    movl $3,%ecx
    jmp dividi

dividi:
	divl %ebx					# divido per 10 in long, il quoziente e' in eax il resto ovvero lo cifra in edx
	addl $48, %edx				# sommo 48 al al numero per ottenere la cifra in ascii
	movb %dl,(%esi)	           # utilizzo dl e non edx perchè mi bastano 8 bit sposto il carattere nel byte : %esi+il numero di cifre  poi esi+numericfire-1 ecc ecc 
	xorl %edx, %edx				# azzero il registro edx
    decl %ecx                   # decremento il contatore del ciclo
    cmpl $0,%ecx                # se ecx = 0 esco altrimenti continuo a convertire le cifre
    je fine
    decl %esi
    jmp dividi
fine:
    cmpl $10,numero                 # riconfronto il  numero
    jl exit1
    cmpl $100,numero
    jl exit2
    cmpl $1000,numero
    jl exit3

                                    # stampo il numero in base al numero di cifre che possiede
    movl $4,%eax
    movl $1,%ebx
    leal quattroChar,%ecx
    movl $4,%edx
    int $0x80

    movl $0,quattroChar
    ret

exit1:
    movl $4,%eax
    movl $1,%ebx
    leal unChar,%ecx
    movl $1,%edx

    int $0x80

    movl $0,unChar

    ret
exit2:
    movl $4,%eax
    movl $1,%ebx
    leal dueChar,%ecx
    movl $2,%edx
    int $0x80
    movl $0,dueChar

    ret
exit3:
    movl $4,%eax
    movl $1,%ebx
    leal treChar,%ecx
    movl $3,%edx
    int $0x80

    movl $0,treChar
    ret
