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

CABECA          EQU     '@'
BORRACHA        EQU     ' '
FRUTA           EQU     '+'

CIMA            EQU     -1d
BAIXO           EQU     1d                 
DIREITA         EQU     2d
ESQUERDA        EQU     -2d

ON              EQU     1d
OFF             EQU     0d

VIVO		EQU	1d
MORTO		EQU	0d

; padrao de bits para geracao de numero aleatorio
RND_MASK		EQU	8016h	; 1000 0000 0001 0110b
LSB_MASK		EQU	0001h	; Mascara para testar o bit menos significativo do Random_Var
PRIME_NUMBER_1	        EQU     11d
PRIME_NUMBER_2	        EQU     13d

MAXIMO_LINHAS           EQU     20d
MAXIMO_COLUNAS          EQU     77d
LIMITE_ESQUERDO_TELA    EQU     0d 
LIMITE_INFERIOR_TELA    EQU     23d
LIMITE_SUPERIOR_TELA    EQU     2d
LIMITE_DIREITO_TELA     EQU     79d

PONTUACAO_MAXIMA        EQU     1560d
POSICAO_PLACAR_1        EQU     0000000101001101b ; 01L x 77C  
POSICAO_PLACAR_2        EQU     0000000101001100b ; 01L x 76C
POSICAO_PLACAR_3        EQU     0000000101001011b ; 01L x 75C
POSICAO_PLACAR_4        EQU     0000000101001010b ; 01L x 74C

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;-----------------------------------------------------------------------------

                ORIG    8000h
L0              STR     '********************************************************************************', FIM_TEXTO
L1              STR     '* A COBRA VAI FUMAR                                              Tamanho: 0000 *', FIM_TEXTO
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

Perdeu_L1       STR     '*             _   _                 ______            _                        *', FIM_TEXTO
Perdeu_L2       STR     '*            | | | |                | ___ \          | |                       *', FIM_TEXTO
Perdeu_L3       STR     '*            | | | | ___   ___ ___  | |_/ /__ ____ __| | ___ _   _             *', FIM_TEXTO
Perdeu_L4       STR     '*            | | | |/ _ \ / __/ _ \ |  __/ _ \ __/ _   |/ _ \ | | |            *', FIM_TEXTO
Perdeu_L5       STR     '*            \ \_/ / (_) | (_|  __/ | | |  __/ | | (_| |  __/ |_| |            *', FIM_TEXTO
Perdeu_L6       STR     '*             \___/ \___/ \___\___| \_|  \___|_|  \____|\___|\____|            *', FIM_TEXTO


LinhaTexto      WORD    0d
ColunaTexto     WORD    0d
PosicaoTexto    WORD    0d

Random_Var	WORD	A5A5h  ; 1010 0101 1010 0101
RandomState     WORD	1d

LinhaCabeca     WORD    12d
ColunaCabeca    WORD    40d
PosicaoCabeca   WORD    0d

LinhaCalda      WORD    12d
ColunaCalda     WORD    40d
PosicaoCalda    WORD    0d

ColunaFruta     WORD    0d
LinhaFruta      WORD    0d
PosicaoFruta    WORD    0d

Estado		WORD	1d
Direcao         WORD    DIREITA
Tamanho         WORD    1d
TempoDeCiclo    WORD    2d

Pontuacao1      WORD    '8'
Pontuacao2      WORD    '9'
Pontuacao3      WORD    '0'
Pontuacao4      WORD    '0'

Corpo           WORD    'o'

Vetor           TAB     1560d

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
Timer:  PUSH    R1
        PUSH    R2

        MOV     M[ CURSOR ], R1
        MOV     R1, M[ CABECA ]

        CALL    Mov_cobra
        CALL    ConfiguraTimer

        POP     R2
        POP     R1
        RTI

;------------------------------------------------------------------------------
; Função Configura Timer
;------------------------------------------------------------------------------
ConfiguraTimer: PUSH 	R1

                MOV 	R1, M [ TempoDeCiclo ]
                MOV 	M [ TIMER_UNITS ], R1

		MOV	R1, M [ Estado ]
                MOV     M [ ACTIVATE_TIMER], R1

Morto:          POP 	R1

                RET

;------------------------------------------------------------------------------
; Rotina Print
;------------------------------------------------------------------------------
print:  PUSH    R1
        PUSH    R2
        PUSH    R3 
        PUSH    R4
        PUSH    R5

        MOV     R1, 0d
        MOV     M[ PosicaoTexto ], R1
        MOV     M[ ColunaTexto], R1

exec:   MOV     R1, M[ PosicaoTexto ]
        ADD     R1, R5
        MOV     R2, M[ R1 ]
        CMP     R2, FIM_TEXTO
        JMP.Z   fim     
        MOV     R3, M[ LinhaTexto ]
        MOV     R4, M[ ColunaTexto ]

        SHL     R3, ROW_SHIFT
        OR      R3, R4

        MOV     M[ CURSOR ], R3
        MOV     M[ IO_WRITE ], R2

        INC     M[ PosicaoTexto ]
        INC     M[ ColunaTexto ] 
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
                INC     M [ LinhaTexto ] 
                CMP     R5, 8798h
                JMP.NP  exec1 

                POP R5
                POP R1
                RET

;------------------------------------------------------------------------------
; Rotina Fim de Jogo
;------------------------------------------------------------------------------
FimDeJogo:      PUSH R1

                MOV     R1, 'X'
                MOV     M [ Corpo ], R1

                CALL    PrintCorpo
                
                
                MOV     R1, M [ Perdeu_L1 ]
                MOV     M [ L10 ], R1
                MOV     R1, M [ Perdeu_L2 ]
                MOV     M [ L11 ], R1
                MOV     R1, M [ Perdeu_L3 ]
                MOV     M [ L12 ], R1
                MOV     R1, M [ Perdeu_L4 ]
                MOV     M [ L13 ], R1
                MOV     R1, M [ Perdeu_L5 ]
                MOV     M [ L14 ], R1
                MOV     R1, M [ Perdeu_L6 ]
                MOV     M [ L15 ], R1

                CALL    print_tela
                
                MOV     R1, MORTO
                MOV     M[ Estado ], R1

                POP    R1

;------------------------------------------------------------------------------
; Rotina Print Cobra
;------------------------------------------------------------------------------
printCobra:     PUSH    R1

                CALL    PrintCabeca
                CALL    PrintCorpo

                POP     R1
                RET

;------------------------------------------------------------------------------
; Rotina Print Cabeca
;------------------------------------------------------------------------------
PrintCabeca:    PUSH    R1
                PUSH    R2


                MOV     R1, M [ LinhaCabeca ]
                SHL     R1, 8d
                MOV     R2, M [ ColunaCabeca ]
                OR      R1, R2

                MOV     M [ PosicaoCabeca], R1
                MOV     R2, CABECA

                MOV     M [ CURSOR ], R1
                MOV     M [ IO_WRITE ], R2

                POP     R2
                POP     R1
                RET


;------------------------------------------------------------------------------
; Rotina Print Corpo
;------------------------------------------------------------------------------
PrintCorpo:     PUSH    R1
                PUSH    R2
                PUSH    R3


                MOV     R1, 0d
LoopPrintCorpo: MOV     R2, M [ R1 + Vetor ]     ; R2 Recebe a posição do corpo de deve ser imprimido
                MOV     R3, M [ Corpo ]

                MOV     M [ CURSOR ], R2
                MOV     M [ IO_WRITE ], R3

                INC     R1
                CMP     R1, M [ Tamanho ]
                JMP.NZ  LoopPrintCorpo

                MOV     R3, BORRACHA            ; Apaga a ultima posição 
                MOV     M [ IO_WRITE ], R3    


                POP     R3
                POP     R2
                POP     R1
                RET

;------------------------------------------------------------------------------
; Função Movimenta Cobra
;------------------------------------------------------------------------------
Mov_cobra:      PUSH 	R1
                PUSH    R2
                PUSH    R3
                            
                MOV 	R1, M[ Direcao ]

                CMP     R1, CIMA
                CALL.Z  MovCobraCima
                JMP.Z   FimMov_Cobra

                CMP     R1, BAIXO
                CALL.Z  MovCobraBaixo
                JMP.Z   FimMov_Cobra

                CMP     R1, ESQUERDA
                CALL.Z  MovCobraEsquerda
                JMP.Z   FimMov_Cobra

                CMP     R1, DIREITA
                CALL.Z  MovCobraDireita
                JMP.Z   FimMov_Cobra                 

                CALL    printCobra
                CALL    AttPosicoes

                MOV     R1, M [ PosicaoCabeca ]
                CMP     R1, M [ PosicaoFruta ]
                JMP.NZ  FimMov_Cobra

                CALL    ComeFruta

FimMov_Cobra:   POP 	R3
                POP     R2
                POP     R1
                RET
;------------------------------------------------------------------------------
; Função Função Atualiza Posições
;------------------------------------------------------------------------------
AttPosicoes:            PUSH    R1
                        PUSH    R2
                        PUSH    R3               
               
                        MOV     R2, M [ PosicaoCabeca ]
                        MOV     R1, 0d
LoopAttPosicoes:        MOV     R3, M [ R1 + Vetor ]
                        MOV     M [ R1 + Vetor ], R2
                        MOV     R2, R3

                        CMP     M [ PosicaoCabeca], R3 ; compara a posição atual da cabeça da cobra com uma das posições do corpo
                        CALL.Z  FimDeJogo
                        JMP.Z   FimMov_Cobra

                        INC     R1
                        CMP     R1, M [ Tamanho ]
                        JMP.NZ  LoopAttPosicoes

                        POP     R3
                        POP     R2
                        POP     R1
                        RET



;------------------------------------------------------------------------------
; Função Movimenta Cobra Cima
;------------------------------------------------------------------------------
MovCobraCima:           PUSH    R1       

                        DEC     M[ LinhaCabeca ]

                        MOV     R1, M [ LinhaCabeca]
                        CMP     R1, LIMITE_SUPERIOR_TELA
                        CALL.Z  FimDeJogo

                        
			POP     R1
                        RET

;------------------------------------------------------------------------------
; Função Movimenta Cobra Baixo
;------------------------------------------------------------------------------
MovCobraBaixo:          PUSH    R1       

                        INC     M[ LinhaCabeca ]

                        MOV     R1, M [ LinhaCabeca]
                        CMP     R1, LIMITE_INFERIOR_TELA
                        CALL.Z  FimDeJogo                     
                        
                        POP     R1
                        RET

;------------------------------------------------------------------------------
; Função Movimenta Cobra Direita
;------------------------------------------------------------------------------
MovCobraDireita:        PUSH    R1       

                        INC     M[ ColunaCabeca ]


                        MOV     R1, M [ ColunaCabeca ]
                        CMP     R1, LIMITE_DIREITO_TELA
                        CALL.Z  FimDeJogo
                        

                        POP     R1
                        RET

;------------------------------------------------------------------------------
; Função Movimenta Cobra Esquerda
;------------------------------------------------------------------------------
MovCobraEsquerda:       PUSH    R1       

                        DEC     M[ ColunaCabeca ]

                        MOV     R1, M [ ColunaCabeca ]
                        CMP     R1, LIMITE_ESQUERDO_TELA
                        CALL.Z  FimDeJogo
                        
                        POP     R1
                        RET



;------------------------------------------------------------------------------
; Função MudaDirecaoCima
;------------------------------------------------------------------------------
MudaDirecaoCima:        PUSH    R1
                        PUSH    R2

                        MOV     R1, CIMA
                        MOV     R2, M [ Direcao ]
                        ADD     R1, R2
                        CMP     R1, 0d                  ; verifica se a nova direção não é inversa da posição atual
                        JMP.Z   FimMudaDirecaoCima
                        
                        MOV     R1, CIMA
                        MOV     M [ Direcao ], R1
                        
FimMudaDirecaoCima:     POP     R2
                        POP     R1
                        RTI

;------------------------------------------------------------------------------
; Função MudaDirecaoBaixo
;------------------------------------------------------------------------------
MudaDirecaoBaixo:       PUSH    R1
                        PUSH    R2

                        MOV     R1, BAIXO
                        MOV     R2, M [ Direcao ]
                        ADD     R1, R2
                        CMP     R1, 0d       
                        JMP.Z   FimMudaDirecaoBaixo
                        MOV     R1, BAIXO 
                        MOV     M [ Direcao ], R1
                        
FimMudaDirecaoBaixo:    POP     R2
                        POP     R1
                        RTI

;------------------------------------------------------------------------------
; Função MudaDirecaoEsquerda
;-------------------------------------------------------------------------------
MudaDirecaoEsquerda:    PUSH    R1
                        PUSH    R2

                        MOV     R1, ESQUERDA
                        MOV     R2, M [ Direcao ]
                        ADD     R1, R2
                        CMP     R1, 0d
                        JMP.Z   FimMudaDirecaoEsq
                        MOV     R1, ESQUERDA
                        MOV     M [ Direcao ], R1
                        
FimMudaDirecaoEsq:      POP     R2
                        POP     R1
                        RTI

;------------------------------------------------------------------------------
; Função MudaDirecaoDireita
;------------------------------------------------------------------------------
MudaDirecaoDireita:     PUSH    R1
                        PUSH    R2

                        MOV     R1, DIREITA
                        MOV     R2, M [ Direcao ]
                        ADD     R1, R2
                        CMP     R1, 0d
                        JMP.Z   FimMudaDirecaoDir
                        MOV     R1, DIREITA
                        MOV     M [ Direcao ], R1
                        
FimMudaDirecaoDir:      POP     R2
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


;------------------------------------------------------------------------------
; Função Come Fruta
;------------------------------------------------------------------------------
ComeFruta:     PUSH R1


                CALL    AtualizaPontuacao
                CALL    VerificaPontuacao
                CALL    GeraFruta
                
                POP R1
                RET

;-------------------------------------------------------------------------------
;ATUALIZA PONTUAÇÃO
;-------------------------------------------------------------------------------                        
AtualizaPontuacao:      PUSH    R1
                        PUSH    R2

                        MOV     R1, M [ Pontuacao1 ]
                        CMP     R1, '9'
                        JMP.Z   AttDecimal

                        INC     M [ Pontuacao1 ]        ; atualiza as unidades
                        MOV     R1, POSICAO_PLACAR_1
                        MOV     M [ CURSOR ], R1
                        MOV     R1, M[ Pontuacao1 ]
                        MOV     M [ IO_WRITE ], R1
                        JMP     FimAttPontuacao

AttDecimal:             MOV     R1, M [ Pontuacao2 ]
                        CMP     R1, '9'
                        JMP.Z   AttCentena

                        MOV     R2, '0'                  ; altera as unidades para 0
                        MOV     M [ Pontuacao1], R2
                        MOV     R2, POSICAO_PLACAR_1
                        MOV     M [ CURSOR ], R2
                        MOV     R2, M[ Pontuacao1 ]
                        MOV     M [ IO_WRITE ], R2
                        
                        INC     M [ Pontuacao2 ]
                        MOV     R1, POSICAO_PLACAR_2
                        MOV     M [ CURSOR ], R1
                        MOV     R1, M[ Pontuacao2 ]
                        MOV     M [ IO_WRITE ], R1
                        JMP     FimAttPontuacao

AttCentena:             MOV     R1, M [ Pontuacao2 ]
                        CMP     R1, '9'
                        JMP.Z   AttMilhares

                        MOV     R2, '0'                 ; altera as unidades para 0
                        MOV     M [ Pontuacao1], R2
                        MOV     R2, POSICAO_PLACAR_1
                        MOV     M [ CURSOR ], R2
                        MOV     R2, M[ Pontuacao1 ]
                        MOV     M [ IO_WRITE ], R2

                        MOV     M [ Pontuacao2 ], R2    ; altera a dezana para 0
                        MOV     R2, POSICAO_PLACAR_2
                        MOV     M [ CURSOR ], R2
                        MOV     R2, M[ Pontuacao2 ]
                        MOV     M [ IO_WRITE ], R2
                        
                        INC     M [ Pontuacao3 ]
                        MOV     R1, POSICAO_PLACAR_3
                        MOV     M [ CURSOR ], R1
                        MOV     R1, M[ Pontuacao3 ]
                        MOV     M [ IO_WRITE ], R1
                        JMP     FimAttPontuacao
                        
AttMilhares:            MOV     R1, M [ Pontuacao4 ]
                        CMP     R1, '9'
                        JMP.Z   FimAttPontuacao

                        MOV     R2, '0'                  ; altera as unidades para 0
                        MOV     M [ Pontuacao1], R2
                        MOV     R2, POSICAO_PLACAR_1
                        MOV     M [ CURSOR ], R2
                        MOV     R2, M[ Pontuacao1 ]
                        MOV     M [ IO_WRITE ], R2

                        MOV     M [ Pontuacao2 ], R2     ; altera a dezana para 0
                        MOV     R2, POSICAO_PLACAR_2
                        MOV     M [ CURSOR ], R2
                        MOV     R2, M[ Pontuacao2 ]
                        MOV     M [ IO_WRITE ], R2

                        MOV     M [ Pontuacao3 ], R2     ; altera a centena para 0
                        MOV     R2, POSICAO_PLACAR_3
                        MOV     M [ CURSOR ], R2
                        MOV     R2, M[ Pontuacao3 ]
                        MOV     M [ IO_WRITE ], R2
                        
                        INC     M [ Pontuacao4 ]
                        MOV     R1, POSICAO_PLACAR_4
                        MOV     M [ CURSOR ], R1
                        MOV     R1, M[ Pontuacao4 ]
                        MOV     M [ IO_WRITE ], R1

FimAttPontuacao:        INC     M [ Tamanho ]

                        POP     R2
                        POP     R1
                        RET

;------------------------------------------------------------------------------
; Função Geradora de Fruta
;------------------------------------------------------------------------------
GeraFruta:              PUSH    R1
                        PUSH    R2


                        CALL    RandomV2
                        MOV     R1, M[ Random_Var ]
                        MOV     R2, MAXIMO_COLUNAS
                        DIV     R1, R2
                        ADD     R2, 2d
                        MOV     M[ ColunaFruta ], R2

                        CALL    RandomV2
                        MOV     R1, M[ Random_Var ]
                        MOV     R2, MAXIMO_LINHAS
                        DIV     R1, R2
                        ADD     R2, 2d
                        MOV     M[ LinhaFruta ], R2
                        
                        MOV     R1, M [ LinhaFruta ]
                        SHL     R1, 8d
                        MOV     R2, M [ ColunaFruta ]
                        OR      R1, R2
                        MOV     M [ PosicaoFruta ], R1

                        MOV     R1, M [ PosicaoFruta ]
                        MOV     M [ CURSOR ], R1
                        MOV     R1, FRUTA
                        MOV     M [ IO_WRITE ], R1

FimFruta:               POP R2
                        POP R1

                        RET
;-------------------------------------------------------------------------------
;VERIFICA PONTUAÇÃO MAXIMA
;------------------------------------------------------------------------------
VerificaPontuacao:      PUSH     R1

                        MOV     R1, M [ Tamanho ]
                        CMP     R1, PONTUACAO_MAXIMA
                        JMP.NZ  FimVerificaPontuacao
                        MOV     R1,  MORTO
                        MOV     M [ Estado ], R1

FimVerificaPontuacao:   POP     R1
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
                        CALL    GeraFruta
                        CALL    ConfiguraTimer


Cycle:                  BR      Cycle
Halt:                   BR      Halt
