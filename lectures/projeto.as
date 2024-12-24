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
CURSOR		EQU     FFFCh
CURSOR_INIT	EQU	FFFFh
ROW_POSITION	EQU	0d
COL_POSITION	EQU	0d
ROW_SHIFT	EQU	8d
COLUMN_SHIFT	EQU	8d
COMP_LINHA      EQU     81d
NUM_LINHA       EQU     24d

TIMER_UNITS     EQU     FFF6h
ACTIVATE_TIMER  EQU     FFF7h

Cabeca          EQU    '@'

CIMA            EQU     0d
BAIXO           EQU     1d
DIREITA         EQU     2d
ESQUERDA        EQU     3d

ON              EQU     1d
OFF             EQU     0d

; padrao de bits para geracao de numero aleatorio
RND_MASK		EQU	8016h	; 1000 0000 0001 0110b
LSB_MASK		EQU	0001h	; Mascara para testar o bit menos significativo do Random_Var
PRIME_NUMBER_1	        EQU 11d
PRIME_NUMBER_2	        EQU 13d

MAXIMO_LINHAS           EQU 20d
MAXIMO_COLUNAS          EQU 72d
LIMITE_ZERO_TELA        EQU 0d 
LIMEITE_INFERIOR_TELA   EQU 23d
LIMITE_HORIZONTAL       EQU 79d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;-----------------------------------------------------------------------------

                ORIG    8000h
L0              STR     '********************************************************************************', FIM_TEXTO
L1              STR     '* Snakezinha                                                      Pontos: 0000 *', FIM_TEXTO
L2              STR     '********************************************************************************', FIM_TEXTO
L3              STR     '*                                                                              *', FIM_TEXTO
L4              STR     '*                                                                              *', FIM_TEXTO
L5              STR     '*                                                                              *', FIM_TEXTO
L6              STR     '*                                                                              *', FIM_TEXTO
L7              STR     '*                                                                              *', FIM_TEXTO
L8              STR     '*                                                                              *', FIM_TEXTO
L9              STR     '*                                                                              *', FIM_TEXTO
L10             STR     '*                                                                              *', FIM_TEXTO
L11             STR     '*                                                                              *', FIM_TEXTO
L12             STR     '*                                                                              *', FIM_TEXTO
L13             STR     '*                                                                              *', FIM_TEXTO
L14             STR     '*                                                                              *', FIM_TEXTO
L15             STR     '*                                                                              *', FIM_TEXTO
L16             STR     '*                                                                              *', FIM_TEXTO
L17             STR     '*                                                                              *', FIM_TEXTO
L18             STR     '*                                                                              *', FIM_TEXTO
L19             STR     '*                                                                              *', FIM_TEXTO
L20             STR     '*                                                                              *', FIM_TEXTO
L21             STR     '*                                                                              *', FIM_TEXTO
L22             STR     '*                                                                              *', FIM_TEXTO
L23             STR     '********************************************************************************', FIM_TEXTO    


RowIndex        WORD    0d
ColumnInde      WORD    0d
TextIndex       WORD    0d

Direcao         WORD    DIREITA


Random_Var	WORD	A5A5h  ; 1010 0101 1010 0101
RandomState     WORD	1d

LinhaCabeca     WORD     12d
ColunaCabeca    WORD     40d
PosicaoCabeca   WORD     0d

LinhaCalda      WORD     12d
Colunacalda     WORD     40d
PosicaoCalda    WORD     0d

ColunaFruta     WORD    0d
LinhaFruta      WORD    0d





;------------------------------------------------------------------------------
; ZONA II: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0            WORD    MudaDirecaoCima
INT1            WORD    MudaDirecaoEsquerda
INT2            WORD    MudaDirecaoBaixo
INT3            WORD    MudaDirecaoDireita

                ORIG    FE0Fh

INT15           WORD    Timer


;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main 


;------------------------------------------------------------------------------
; Rotina Interrupção Timer
;------------------------------------------------------------------------------
Timer:  PUSH R1
        PUSH R2

        MOV  M[ CURSOR ], R1
        MOV  R1, M[ Cabeca ]

        CALL Mov_cobra

        CALL ConfiguraTimer

        POP R2
        POP R1
        RTI

;------------------------------------------------------------------------------
; Rotina Print
;------------------------------------------------------------------------------
print:  PUSH R1
        PUSH R2
        PUSH R3 
        PUSH R4
        PUSH R5

        MOV     R1, 0d
        MOV     M[ TextIndex ], R1
        MOV     M[ ColumnIndex], R1

exec:   MOV     R1, M[ TextIndex ]
        ADD     R1, R5
        MOV     R2, M[ R1 ]
        CMP     R2, FIM_TEXTO
        JMP.Z   fim     
        MOV     R3, M[ RowIndex ]
        MOV     R4, M[ColumnIndex]

        SHL     R3, ROW_SHIFT
        OR      R3, R4

        MOV     M[CURSOR], R3
        MOV     M[IO_WRITE], R2

        INC     M[TextIndex]
        INC     M[ColumnIndex] 
        JMP     exec 
    
fim:    POP     R5
        POP     R4
        POP     R3 
        POP     R2
        POP     R1
        RET 
;------------------------------------------------------------------------------
; Rotina Print de Tela
;------------------------------------------------------------------------------
print_tela:     PUSH R1
                PUSH R5


                MOV     R5, 8000h
                MOV     R1, COMP_LINHA

exec1:          CALL    print
                ADD     R5, R1
                INC     M [ RowIndex ] 
                CMP     R5, 8798h
                JMP.NP  exec1 

                POP R5
                POP R1
                RET

;------------------------------------------------------------------------------
; Rotina Print Cabeça
;------------------------------------------------------------------------------
printCabeca:    PUSH R1
                PUSH R2

                MOV     R1, M [ LinhaCabeca]
                SHL     R1, 8d
                MOV     R2, M [ ColunaCabeca]
                OR      R1, R2

                MOV     M [ PosicaoCabeca], R1
                MOV     R2, Cabeca

                MOV     M [ CURSOR ], R1
                MOV     M [ IO_WRITE], R2

                POP R2
                POP R1
                RET

;------------------------------------------------------------------------------
; Função Configura Timer
;------------------------------------------------------------------------------
ConfiguraTimer: PUSH R1

                MOV R1, 5d
                MOV M[ TIMER_UNITS ], R1

                MOV R1, ON
                MOV M[ ACTIVATE_TIMER ], R1

                POP R1

                RET
;------------------------------------------------------------------------------
; Função Movimenta Cobra
;------------------------------------------------------------------------------
Mov_cobra:      PUSH R1

                MOV R1, M[ Direcao ]

                CMP     R1, CIMA
                CALL.Z  MovCobraCima

                CMP     R1, BAIXO
                CALL.Z  MovCobraBaixo

                CMP     R1, ESQUERDA
                CALL.Z  MovCobraEsquerda

                CMP     R1, DIREITA
                CALL.Z  MovCobraDireita

                CALL    printCabeca

                POP R1
                RET

;------------------------------------------------------------------------------
; Função Movimenta Cobra Cima
;------------------------------------------------------------------------------
MovCobraCima:           PUSH    R1       

                        DEC     M[ LinhaCabeca ]
                        CMP     M [ LinhaCabeca], LIMITE_ZERO_TELA

                        POP     R1
                        RET

;------------------------------------------------------------------------------
; Função Movimenta Cobra Baixo
;------------------------------------------------------------------------------
MovCobraBaixo:          PUSH    R1       

                        INC     M[ LinhaCabeca ]
                        CMP     M [ LinhaCabeca], LIMITE_ZERO_TELA

                        POP     R1
                        RET

;------------------------------------------------------------------------------
; Função Movimenta Cobra Direita
;------------------------------------------------------------------------------
MovCobraDireita:        PUSH    R1       

                        INC     M[ ColunaCabeca ]

                        POP     R1
                        RET

;------------------------------------------------------------------------------
; Função Movimenta Cobra Esquerda
;------------------------------------------------------------------------------
MovCobraEsquerda:       PUSH    R1       

                        DEC     M[ ColunaCabeca ]

                        POP     R1
                        RET



;------------------------------------------------------------------------------
; Função MudaDirecaoCima
;------------------------------------------------------------------------------
MudaDirecaoCima:        PUSH    R1

                        MOV     R1, CIMA
                        MOV     M [Direcao], R1

                        POP     R1
                        RTI

;------------------------------------------------------------------------------
; Função MudaDirecaoBaixo
;------------------------------------------------------------------------------
MudaDirecaoBaixo:       PUSH    R1

                        MOV     R1, BAIXO
                        MOV     M [Direcao], R1

                        POP     R1
                        RTI

;------------------------------------------------------------------------------
; Função MudaDirecaoEsquerda
;------------------------------------------------------------------------------
MudaDirecaoEsquerda:    PUSH    R1

                        MOV     R1, ESQUERDA
                        MOV     M [Direcao], R1

                        POP     R1
                        RTI

;------------------------------------------------------------------------------
; Função MudaDirecaoDireita
;------------------------------------------------------------------------------
MudaDirecaoDireita:     PUSH    R1

                        MOV     R1, DIREITA
                        MOV     M [Direcao], R1

                        POP     R1
                        RTI

;------------------------------------------------------------------------------
; Função: RandomV1 (versão 1)
;
; Random: Rotina que gera um valor aleatório - guardado em M[Random_Var]
; Entradas: M[Random_Var]
; Saidas:   M[Random_Var]
;------------------------------------------------------------------------------

RandomV1:	PUSH	R1

			MOV	R1, LSB_MASK
			AND	R1, M[Random_Var] ; R1 = bit menos significativo de M[Random_Var]
			BR.Z	Rnd_Rotate
			MOV	R1, RND_MASK
			XOR	M[Random_Var], R1

Rnd_Rotate:	ROR	M[Random_Var], 1
			
			POP	R1

			RET

;------------------------------------------------------------------------------
; Função: RandomV2 (versão 2)
;
; Random: Rotina que gera um valor aleatório - guardado em M[Random_Var]
; Entradas: 
; Saidas:   M[Random_Var]
;------------------------------------------------------------------------------

RandomV2:	PUSH R1
			PUSH R2
			PUSH R3
			PUSH R4

			MOV R1, M[ RandomState ]
			MOV R2, PRIME_NUMBER_1
			MOV R3, PRIME_NUMBER_2

			MUL R1, R2 ; Atenção: O resultado da operacao fica em R1 e R2!!!
			ADD R2, R3 ; Vamos usar os 16 bits menos significativos da MUL
			MOV M[ RandomState ], R2
                        MOV M[ Random_Var ], R2

			POP R4
			POP R3
			POP R2
			POP R1

			RET


GenerateFruitRow: PUSH R1
                  PUSH R2


                  CALL RandomV2
                  MOV  R1, M[ Random_Var ]
                  MOV  R2, MAX_NUMBER_FRUIT_ROWS
                  DIV  R1, R2
                  MOV  M[ ColunaFruta ], R2


                  POP R2
                  POP R1

                  RET

;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------

Main:			ENI

			MOV	R1, INITIAL_SP
			MOV	SP, R1		 	; We need to initialize the stack
			MOV	R1, CURSOR_INIT	        ; We need to initialize the cursor 
			MOV	M[ CURSOR ], R1		; with value CURSOR_INIT


                        MOV  R1, 12d                    ;posiciona o cursor no
                        MOV  R2, 40d                    ;meio da tela
                        SHL  R1, 8d 
                        OR   R1, R2 

                        CALL    print_tela
                        CALL    printCabeca
                        CALL    ConfiguraTimer
