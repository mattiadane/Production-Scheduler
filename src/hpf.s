# file per ordinare gli ordini nello stack secondo l'algoritmo HPF (High Priority First)
# gli ordini sono sistemati nello stack in modo da riuscire a prenderli in modo ordinato
# dal primo all'ultimo
# Parametri ingresso %eax che contiene il numero di righe

.section .data
rows: .int 0
hpf: .ascii "Pianificazione HPF:\n"
hpf_len : .long . - hpf

.section .bss
cella: .long        # variabile dove carico la cima dello stack 

.section .text
    .global HPF

.type HPF, @function

HPF:
    popl cella              #  metto nella variabile cella il PC cosi posso manipolare lo stack
    movl %eax,rows
    decw rows
    xorl %ecx,%ecx          # inizializzo il contatore esterno i = 0
 
# ciclo esterno bubble sort
extern_HPF:
    
    xorl %esi,%esi
    cmpl rows,%ecx
    
    jge exit_extern_HPF  # Se i e' maggiore o uguale  numero di righe del file esco dal ciclo esterno
    
    xorl %edx,%edx        # inizializzo il contatore interno j = 0
    
# ciclo interno bubble sort
inner_HPF:

    movl rows,%edi      # righe = righe - i
    subl %ecx,%edi



    cmpl %edi,%edx
    jge exit_inner_HPF     # j e' maggiore o uguale  numero di righe del file - i esco dal ciclo interno 

    
    movl (%esp,%esi),%eax
    addl $16,%esi
    cmpl %eax,(%esp,%esi)     # vado a confrontare le due priorita'
    jl inc_inner_counter      # se priorita'2 e' minore di priorita'1 incremento il contatore del ciclo interno e ciclo ancora internamente
                              # se priorita'2 e' magggiore di priorita'1 sposto priorita'2 nella riga di priorita1 e viceversa
    
    cmpl %eax,(%esp,%esi)    # vado a confrontare le due priorita'
    je check_scadenza        # se uguali confronto la scadenza 

swap:
    # sposto la priorita'
    subl $16,%esi
    movl (%esp,%esi), %eax
    addl $16,%esi
    movl (%esp,%esi), %ebx
    movl %eax, (%esp,%esi)
    subl $16,%esi
    movl %ebx, (%esp,%esi)

    # sposto la scandeza
    addl $4,%esi
    movl (%esp,%esi), %eax
    addl $16,%esi
    movl (%esp,%esi), %ebx
    movl %eax, (%esp,%esi)
    subl $16,%esi
    movl %ebx, (%esp,%esi)

    # sposto la durata
    addl $4,%esi
    movl (%esp,%esi), %eax
    addl $16,%esi
    movl (%esp,%esi), %ebx
    movl %eax, (%esp,%esi)
    subl $16,%esi
    movl %ebx,(%esp,%esi)

    # sposto l'id 
    addl $4,%esi
    movl (%esp,%esi), %eax
    addl $16,%esi
    movl (%esp,%esi), %ebx
    movl %eax, (%esp,%esi)
    subl $16,%esi
    movl %ebx,(%esp,%esi)


    incl %edx         # incremento contatore ciclo interno 
    addl $4,%esi      # aggiungo 4 ad esi per andare all'indirizzo %esp+4 al prossimo ciclo 
    jmp inner_HPF     # ciclo di nuovo all'interno 


check_scadenza:
    subl $12,%esi      # sottraggo  12 per puntare alla prima  scadenza
    movl (%esp,%esi),%eax
    addl $16,%esi     # aggiungo 16 per puntare alla seconda scadenza 
    cmpl %eax,(%esp,%esi)   # confronto le due scadenze
    jg inc_inner_counter2      # se scadenza2  e' maggiore scadenza1  incremento il contatore del ciclo interno ed eseguo di il ciclo interno
                              # se invece scadenza2 e' minore scadenza1 sposto le due righe scadenza1 
    subl $4,%esi            
    jmp swap                # vado a fare lo scambio


inc_inner_counter2:
    incl %edx        # incremento contatore ciclo interno e vado al prossimo ciclo
    subl $4,%esi     # sottraggo  4 per far puntare di nuovo alla priorita prossima
    jmp inner_HPF

inc_inner_counter:
    incl %edx       # incremento contatore ciclo interno 
    jmp inner_HPF


exit_inner_HPF:    # incremento contatore ciclo esterno 
    incl %ecx      
    jmp extern_HPF   # torno ad eseguire dal ciclo esterno


# finito l'ordinamento e stampo la riga per pianificazione HPF
exit_extern_HPF:

    movl $4,%eax
    movl $1,%ebx
    leal hpf,%ecx
    movl hpf_len,%edx
    int $0x80 

    pushl cella    # rimetto il PC in cima allo stack

    ret

