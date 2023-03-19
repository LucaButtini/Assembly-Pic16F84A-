;**************************************************
;*** Struttura base programma con la PIC 16F84A ***
;***                                            ***
;    Lampeggio led con Fhz=1s
;
; (c) 2022, Federico Melon
;
;**************************************************
        PROCESSOR       16F84A	     ;definizione del tipo di Pic per il quale è stato scritto il programma
        RADIX           DEC	         ;i numeri scritti senza notazione sono da intendersi come decimali
        INCLUDE         "P16F84A.INC" ;inclusione del file che contiene la definizione delle costanti di riferimento al file dei
        							 ;registri (memoria Ram)
        ERRORLEVEL      -302		 ;permette di escludere alcuni errori di compilazione, la  segnalazione  302  ricorda  di 
                                     ;commutare il banco di memoria qualora si utilizzino registri che non stanno nel banco 0


        ;Setup of PIC configuration flags
        ;XT oscillator
        ;Disable watch dog timer
        ;Enable power up timer
        ;Disable code protect
;        __CONFIG        0x3FF1	      ; definizione del file di configurazione
		__CONFIG   _XT_OSC & _CP_OFF & _WDT_OFF &_PWRTE_ON

;=============================================================
;       DEFINE
;=============================================================
;Definizione comandi
;#define  Bank1	bsf     STATUS,RP0			  ; Attiva banco 1
;#define  Bank0 bcf     STATUS,RP0	          ; Attiva banco 0
;=============================================================
; 		SIMBOLI
;=============================================================
;LABEL	CODE 	OPERANDO	COMMENTO
;=============================================================
LED_ON  EQU     B'00000001' 				;Led acceso    dato che lo converto in binario, 01, e quindi accende il primo led 
LED_OFF EQU	    B'00000010'				  ; Led spento   in binario esce 10 quindi spegne il led 0 e accende il led 1
;=============================================================
;       AREA DATI
;=============================================================	
;LABEL	CODE 	OPERANDO	COMMENTO
;=============================================================
delay0 	EQU     0x0C
delay1 	EQU     0x0D
delay2 	EQU     0x0E					  

					
;=============================================================
;       PROGRAMMA PRINCIPALE
;=============================================================
;LABEL	CODE 	OPERANDO	COMMENTO
;=============================================================        ;Reset Vector
        ;Start point at CPU reset
        ORG     0x0000				  ;	indirizzo di inizio programma
		
;=============================================================
;       AREA PROGRAMMA PRINCIPALE
;=============================================================
		Main
;Codice Programma
;        Bank1						  ;	accedo al banco zero del file register per settare I/O porta A e B
        bsf     STATUS,RP0			  ; attiva banco 1
        movlw   B'00000000'
        movwf   TRISA 				  ; bit della porta A definiti come uscite
        movlw   B'00000000'			  ; bit della porta B definiti come uscite
        movwf   TRISB
;        Bank0						  ; rinposta l'accesso ai registri del banco 1
	    bcf     STATUS,RP0	          ; attiva banco 0
;=============================================================		
accendi	
		movlw   LED_ON				  ; sposta in W il valore di LED_ON
		movwf	PORTB				  ; invio in uscita sulla Porta B, B0=1  
		call 	delay
		movlw   LED_OFF				  ; sposta in W il valore di LED_OFF
		movwf	PORTB
		call	delay
		goto	accendi			; torno all'inizio
		
;=============================================================
;       AREA ROUTINE
;=============================================================
;										
		delay
		clrf	delay0
		movlw   130					; sposta in W il valore 130
		movwf	delay1				; iniziallizo delay1 con il valore dentro W
		movlw   5					; sposta in W il valore 5
		movwf   delay2 
loop1	decfsz	delay0				  ; decremento delay0 fino a 0 
		goto	loop1				; quanto delay0 = 0 esco dal loop
		decfsz 	delay1				; decremento delay1 fino a 0 
		goto	loop1				; quanto delay1 = 0 esco dal loop
		movlw 	130					; sposta in W il valore 130
		movwf	delay1				 ;iniziallizo delay1 con il valore dentro W
		decfsz 	delay2				; decremento delay2 fino a 0 
		goto 	loop1
		return	
		END                           ; Fine programma


 