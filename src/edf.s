# file per la funzione di ordinamento degli ordini nello stack secondo l'algoritmo che prende in
# considerazione il tempo di scadenza e li sistema nello stack in ordine corretto
# Parametri ingresso %eax che contiene il numero di righe

.section .data
rows: .int 0
edf: .ascii "Pianificazione EDF:\n"
edf_len : .long . - edf

.section .bss
cella: .long     # variabile dove carico il PC



.section .text
    .global EDF

.type EDF, @function

EDF:
    popl cella           #  metto nella variabile cella il PC cosi posso manipolare lo stack
    movl %eax,rows       # decremento le righe lette da file di uno
    decw rows
    xorl %ecx,%ecx          # inizializzo il contatore esterno i = 0
           
# ciclo esterno dell bubble sort
extern_EDF:
    
    movl $4,%esi
    cmpl rows,%ecx
    
    jge exit_extern_EDF  # Se i maggiore o uguale numero di righe del file esco dal ciclo esterno
    
    xorl %edx,%edx        # inizializzo il contatore interno j = 0
    
# ciclo interno del bubble sort
inner_EDF:

    movl rows,%edi   # righe = righe - i
    subl %ecx,%edi



    cmpl %edi,%edx
    jge exit_inner_EDF     # se j e' maggiore o uguale  numero di righe del file - i esco dal ciclo interno 

    
    movl (%esp,%esi),%eax
    addl $16,%esi
    cmpl %eax,(%esp,%esi)     # vado a confrontare le due scadenza 
    jg inc_inner_counter      # se scadenza2  e' maggiore scadenza1  incremento il contatore del ciclo interno ed eseguo di il ciclo interno
                              # se invece scadenza2 e' minore scadenza1 sposto le due righe scadenza1 
    
    cmpl %eax,(%esp,%esi)     # vado a confrontare le due scadenza 
    je check_priority         # se hanno scadenza uguale confronto la priorita

swap:
    # sposto la priorita'
    subl $20,%esi
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


    incl %edx       # incremento ciclo interno
    addl $8,%esi    # aggiungo 8 per andare all'indirizzo %esp+8 al prossimo ciclo 
    jmp inner_EDF 

check_priority:
    subl $20,%esi              # sottraggo 20 per puntare alla riga della priorita
    movl (%esp,%esi),%eax
    addl $16,%esi
    cmpl %eax,(%esp,%esi)    # confronto le due priorita 
    jl inc_inner_counter2      # se priorita'2 e' minore di priorita'1 incremento il contatore del ciclo interno e ciclo ancora internamente
                              # se priorita'2 e' magggiore di priorita'1 sposto priorita'2 nella riga di priorita1 e viceversa
    addl $4,%esi               # incremento di 4 per far puntare di nuovo alla scadenza
    jmp swap

inc_inner_counter2:
    incl %edx        # incremento contatore ciclo interno e vado al prossimo ciclo
    addl $4,%esi     # incremento di 4 per far puntare di nuovo alla scadenza
    jmp inner_EDF

inc_inner_counter:
    incl %edx        # incremento contatore ciclo interno e vado al prossimo ciclo
    jmp inner_EDF


exit_inner_EDF:
    incl %ecx       # incremento contatore ciclo esterno e torno al esterno
    jmp extern_EDF


exit_extern_EDF:
    # finito l'ordinamento e stampo pianificazione edf
    movl $4,%eax
    movl $1,%ebx
    leal edf,%ecx
    movl edf_len,%edx
    int $0x80 

    pushl cella          # rimetto il PC in cima allo stack
    ret
