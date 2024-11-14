
;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR              EQU     0Ah
FIM_TEXTO       EQU     '@'
IO_READ         EQU     FFFFh
IO_WRITE        EQU     FFFEh
IO_STATUS       EQU     FFFDh
INITIAL_SP      EQU     FDFFh
CURSOR		    EQU     FFFCh
CURSOR_INIT		EQU		FFFFh
ROW_POSITION	EQU		0d
COL_POSITION	EQU		0d
ROW_SHIFT		EQU		8d
COLUMN_SHIFT	EQU		8d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
Text0		    STR     '**********************************************************************************', FIM_TEXTO
Text1			STR     '*                                    PONTUAÇÃO:                                  *', FIM_TEXTO
Text2			STR     '**********************************************************************************', FIM_TEXTO
Text3			STR     '*                                                                                *', FIM_TEXTO
Text4			STR     '*                                                                                *', FIM_TEXTO
Text5			STR     '*                                                                                *', FIM_TEXTO
Text6			STR     '*                                                                                *', FIM_TEXTO
Text7			STR     '*                                                                                *', FIM_TEXTO
Text8			STR     '*                                                                                *', FIM_TEXTO
Text9			STR     '*                                                                                *', FIM_TEXTO
Text10			STR     '*                                                                                *', FIM_TEXTO
Text11			STR     '*                                                                                *', FIM_TEXTO
Text12			STR     '*                                                                                *', FIM_TEXTO
Text13			STR     '*                                                                                *', FIM_TEXTO
Text14			STR     '*                                                                                *', FIM_TEXTO
Text15			STR     '*                                                                                *', FIM_TEXTO
Text16			STR     '*                                                                                *', FIM_TEXTO
Text17			STR     '*                                                                                *', FIM_TEXTO
Text18			STR     '*                                                                                *', FIM_TEXTO
Text19			STR     '*                                                                                *', FIM_TEXTO
Text20			STR     '*                                                                                *', FIM_TEXTO
Text21			STR     '*                                                                                *', FIM_TEXTO
Text22			STR     '*                                                                                *', FIM_TEXTO
Text23			STR     '**********************************************************************************', FIM_TEXTO



RowIndex		WORD	0d
ColumnIndex		WORD	0d
TextIndex		WORD	0d


;------------------------------------------------------------------------------
; ZONA II: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
;INT0           WORD    WriteCharacter

;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main

;------------------------------------------------------------------------------
; Rotina Print
;------------------------------------------------------------------------------
print:  PUSH 	R1
        PUSH    R2
        PUSH 	R3
		PUSH 	R4

        MOV     R1, 0
        MOV     M[ TextIndex] , R1

exec:   MOV     R1, M[ TextIndex ]
        MOV     R2, M[ R2 + TextIndex ]
        CMP     R2, FIM_TEXTO
        JMP.Z   fim

		MOV     R3, M[ ColumnIndex ]
		MOV 	R4, M[ RowIndex ]
		SHL		R4, ROW_SHIFT
		OR 		R3,	R4
        MOV     M[ CURSOR ], R3

        MOV     M[ IO_WRITE ], R2
        INC     M[ TextIndex]
        INC     M[ ColumnIndex]
        
        JMP     exec 

    
fim:	POP 	R4
		POP     R3
        POP     R2
        POP     R1
        RET 
        


;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------

Main:			ENI

				MOV		R1, INITIAL_SP
				MOV		SP, R1		 		; We need to initialize the stack
				MOV		R1, CURSOR_INIT		; We need to initialize the cursor 
				MOV		M[ CURSOR ], R1		; with value CURSOR_INIT

                MOV     R2, M[ Text0 ] 
                CALL    print
                SHL     R2, 1d


Cycle: 			BR		Cycle	
Halt:           BR		Halt