#funzione che stampa a video il menu e chiede al utente di sciegliere quale algoritmo utilizzare
# parametro di ritorno il valore scelto dall'utente contenuto nell refistro eax

.section .bss
str: .ascii

.section .data
menu_s:
    .ascii "\nScegli l'algoritmo che vuoi usare\n- 0 per uscire\n- 1 per algoritmo EDF\n- 2 per algoritmo HPF\n"
menu_s_len:
    .long . - menu_s


.section .text
    .global menu

.type menu, @function

menu:   
    # Stampo a video la stringa contenuta all'interno della variabile menu_s
    movl $4, %eax
    movl $1, %ebx
    leal menu_s, %ecx
    movl menu_s_len,%edx
    int $0x80

    # Prendo una stringa da tastiera
    movl $3,%eax
    movl $0,%ebx
    leal str,%ecx
    movl $50,%edx
    int $0x80

    # metto il valore della stringa in eax , così da averla come parametro d'ingresso nella funzione atoi
    movl str,%eax
    # richiamo la funzione atoi
    call atoi
    # ritorno al main con il valore convertitore in intero all interno dell registro %eax
    ret
