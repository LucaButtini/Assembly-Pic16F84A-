;******************
;* Struttura base programma con la PIC 16F84A *
;*                                            *
;        [Ritardare l'accensione di un led]
;
;             (c) 2023, Federico Melon
;
;******************
	PROCESSOR       16F84A               ;definizione del tipo di Pic per il quale è stato scritto il programma
	RADIX           DEC                  ;i numeri scritti senza notazione sono da intendersi come decimali
	INCLUDE         "P16F84A.INC"        ;inclusione del file che contiene la definizione delle costanti di riferimento al file dei
	                                     ;registri (memoria Ram)
	ERRORLEVEL      -302                 ;permette di escludere alcuni errori di compilazione, la  segnalazione  302  ricorda  di 
	                                     ;commutare il banco di memoria qualora si utilizzino registri che non stanno nel banco 0
	__CONFIG        _XT_OSC & _CP_OFF & _WDT_OFF &_PWRTE_ON ; Configurazioni

;=============================================================
;                           DEFINE
;=============================================================
;Definizione comandi
;#define  Bank1bsf      STATUS,RP0            ;Attiva banco 1
;#define  Bank0         bcf STATUS,RP0        ;Attiva banco 0
;=============================================================
;                    Area SIMBOLI e DATI
;=============================================================
;LABEL       CODE      OPERANDO         COMMENTO
;=============================================================
Contatore1   EQU       0x0C
Contatore2   EQU       0x0D
Contatore3   EQU       0x0E
LED_ON       EQU       B'00000001'
LED_OFF      EQU       B'00000000'

;=============================================================
;                  PROGRAMMA PRINCIPALE
;=============================================================
;   LABELCODE         OPERANDO      COMMENTO
;=============================================================
;Reset Vector
;Start point at CPU reset

	ORG               0x0000        ;indirizzo di inizio programma, origine
	goto              Main
;=============================================================
;                       INTERRUPT AREA
;=============================================================
	ORG               0x0004       ;indirizzo inizio routine interrupt
	retfie                         ;ritorno programma principale

;=============================================================
;                  AREA PROGRAMMA PRINCIPALE
;=============================================================

Main
Ritardo
        bsf       STATUS,RP0      ; Metto a 1 il bit RP0, attivo il banco 1
        movlw     0
        movlw     TRISA
        movlw     TRISB           ; Metto tutte le porte del Banco0 e Banco1 come output
        bcf       STATUS,RP0      ; Metto 0 il bit RP0, attivo il banco 0
        movlw     LED_ON
        movwf     PORTB           ; Porto il valore di LED_ON sulla Porta B
        movlw     5
        movwf     Ciclo3          ; Inizializzo il contatore del Ciclo3 a 5
        ; -- Inizio Terzo Ciclo --
Ciclo3  movlw     130
        movwf     Contatore2      ; Inizializzo il contatore del Ciclo2 a 130
        ; -- Inizio Secondo Ciclo --
Ciclo2  clrf      Contatore1      ; Inzializzo il contatore del Ciclo1 a 0 così il ciclo va 255 volte (0-1 = 255)
        ; -- Inizio Primo Ciclo --
Ciclo1  decfsz    Contatore1      ; Decrementa il valore del contatore e continua il ciclo finchè non è 0
        goto      Ciclo1
        ; -- Fine Primo Ciclo --
        decfsz    Contatore2
        goto      Ciclo2
        ; -- Fine Secondo Ciclo --
        decfsz    Contatore3
        goto      Ciclo3
        ; -- Fine Terzo Ciclo --
        movwf     LED_OFF 
	movlw     B'00000001'
		movwf     PORTB
Left	rlf       PORTB
		call      Ritardo
        btfss     PORTB, 7
        goto      Left
Right   rrf       PORTB
        btfss     PORTB, 0
		call      Ritardo
        goto      Right
        goto      Left        ; Porto il valore di LED_OFF sulla Porta B
        goto      Main
		
        END                       ;Fine programma