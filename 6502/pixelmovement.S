.define x $00
.define y $01
.define cell $02

.org $8000
start:
; init
    loop:
        STA $0200, X
        INX
        BNE loop
    LDX #$FF
    TXS
    LDA #$0
    LDX #$8
    LDY #$8
    STX x
    STY y
    JSR find_cell

game:
; move
    LDA $4000
    ; clear if move
    CMP #$00
    BEQ clear
        JSR find_cell
        LDA #$00
        STA $0200, X
    clear:
    ; go up
    LDA $4000
        CMP #$01
        BNE up
        DEC y
        LDA y
        CMP #$01
        BCS underflowy
        LDA #$0F
        STA y
        underflowy:
    up:
    LDA $4000
    ; go down
        CMP #$02
        BNE down
        INC y
        LDA y
        CMP #$0F
        BCC overflowy
        LDA #$01
        STA y
        overflowy:
    down:
    LDA $4000
    ; go left
        CMP #$04
        BNE left
        INC x
        LDA x
        CMP #$0F
        BCC overflowx
        LDA #$01
        STA x
        overflowx:
    left:
    LDA $4000
    ; go right
        CMP #$08
        BNE right
        DEC x
        LDA x
        CMP #$01
        BCS underflowx
        LDA #$0F
        STA x
        underflowx:
    right:

; draw
    JSR find_cell
    LDA #$0F
    STA $0200, X

JMP game

find_cell:
    LDA #$0
    STA cell
    LDX #$0F
    LDY y
    cell_loop:
        INC cell
        DEX
        CPX #$0
        BNE cell_loop
        INC cell
        DEY
        LDX #$0F
        CPY #$0
        BNE cell_loop
        LDA cell
        SBC x
        TAX
    RTS

.goto $FFFA
.dw start ; not maskable
.dw start ; reset
.dw start ; interrupt