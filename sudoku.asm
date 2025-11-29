.MODEL SMALL
.STACK 100h

.DATA
    board DB 5,3,0, 0,7,0, 0,0,0
          DB 6,0,0, 1,9,5, 0,0,0
          DB 0,9,8, 0,0,0, 0,6,0
          DB 8,0,0, 0,6,0, 0,0,3
          DB 4,0,0, 8,0,3, 0,0,1
          DB 7,0,0, 0,2,0, 0,0,6
          DB 0,6,0, 0,0,0, 2,8,0
          DB 0,0,0, 4,1,9, 0,0,5
          DB 0,0,0, 0,8,0, 0,7,9

    orig_board DB 5,3,0, 0,7,0, 0,0,0
               DB 6,0,0, 1,9,5, 0,0,0
               DB 0,9,8, 0,0,0, 0,6,0
               DB 8,0,0, 0,6,0, 0,0,3
               DB 4,0,0, 8,0,3, 0,0,1
               DB 7,0,0, 0,2,0, 0,0,6
               DB 0,6,0, 0,0,0, 2,8,0
               DB 0,0,0, 4,1,9, 0,0,5
               DB 0,0,0, 0,8,0, 0,7,9

    sol   DB 5,3,4, 6,7,8, 9,1,2
          DB 6,7,2, 1,9,5, 3,4,8
          DB 1,9,8, 3,4,2, 5,6,7
          DB 8,5,9, 7,6,1, 4,2,3
          DB 4,2,6, 8,5,3, 7,9,1
          DB 7,1,3, 9,2,4, 8,5,6
          DB 9,6,1, 5,3,7, 2,8,4
          DB 2,8,7, 4,1,9, 6,3,5
          DB 3,4,5, 2,8,6, 1,7,9

    header  DB 13,10, '    1 2 3   4 5 6   7 8 9', 13, 10, '$'
    h_line  DB '  +-------+-------+-------+', 13, 10, '$'
    v_bar   DB '| $'
    row_num DB '0 $'
    
    msg_row DB 13, 10, 'Row (1-9) [0 to Exit]: $'   
    msg_col DB 13, 10, 'Col (1-9) [0 to Back]: $'   
    msg_num DB 13, 10, 'Val (1-9) [0 to Back]: $'   
    
    msg_win DB 13,10, 'YOU WON!$'
    msg_ok  DB 13, 10, ' [<<--Correct!-->>]', 13, 10, '$'
    msg_err DB 13, 10, ' [--Wrong!--]', 13, 10, '$'
    
    ; --- [????] ????? ?????? ??????? ---
    msg_full DB 13, 10, ' [!! Occupied Field !!]', 13, 10, '$'

    msg_fail DB 13, 10, 'GAME OVER (3 Mistakes)! Restarting...', 13, 10, '$'
    mistakes DB 0 
    
    newline DB 13,10, '$'

.CODE
MAIN PROC
    MOV AX, DGROUP
    MOV DS, AX

RESET_GAME:
    MOV mistakes, 0     
    MOV CX, 81          
    MOV SI, 0
RESTORE_LOOP:
    MOV AL, orig_board[SI] 
    MOV board[SI], AL      
    INC SI
    LOOP RESTORE_LOOP

GAME_LOOP:
    ; --- 1. Print Header & Board ---
    LEA DX, newline
    MOV AH, 9
    INT 21h
    LEA DX, header
    INT 21h

    MOV SI, 0           
    MOV CH, 0           

PRINT_ROW_LOOP:
    CMP CH, 0
    JE PR_HLINE
    CMP CH, 3
    JE PR_HLINE
    CMP CH, 6
    JE PR_HLINE
    JMP PR_ROW_NUM

PR_HLINE:
    LEA DX, h_line
    MOV AH, 9
    INT 21h

PR_ROW_NUM:
    MOV DL, CH
    ADD DL, '1'
    MOV row_num, DL
    LEA DX, row_num
    MOV AH, 9
    INT 21h

    MOV CL, 0           

PRINT_COL_LOOP:
    CMP CL, 0
    JE PR_VBAR
    CMP CL, 3
    JE PR_VBAR
    CMP CL, 6
    JE PR_VBAR
    JMP PR_VAL

PR_VBAR:
    LEA DX, v_bar
    MOV AH, 9
    INT 21h

PR_VAL:
    MOV DL, board[SI]
    ADD DL, '0'         
    CMP DL, '0'         
    JNE SKIP_DOT
    MOV DL, '.'         
SKIP_DOT:
    MOV AH, 2
    INT 21h             
    
    MOV DL, ' '         
    INT 21h
    
    INC SI
    INC CL
    CMP CL, 9
    JL PRINT_COL_LOOP

    LEA DX, v_bar
    MOV AH, 9
    INT 21h

    LEA DX, newline     
    INT 21h
    
    INC CH
    CMP CH, 9
    JL PRINT_ROW_LOOP
    
    LEA DX, h_line
    MOV AH, 9
    INT 21h

    ; --- 2. Check Win ---
    MOV CX, 81
    MOV SI, 0
CHECK_ZEROS:
    CMP board[SI], 0
    JE GET_INPUT        
    INC SI
    LOOP CHECK_ZEROS
    JMP WIN             

GET_INPUT:
    ; --- Input Logic ---

ASK_ROW:
    LEA DX, msg_row
    MOV AH, 9
    INT 21h

    MOV AH, 1
    INT 21h
    
    CMP AL, '0'         
    JE REPEAT_LOOP      
    
    SUB AL, '1'
    MOV BL, AL          

ASK_COL:
    LEA DX, msg_col
    MOV AH, 9
    INT 21h

    MOV AH, 1
    INT 21h
    
    CMP AL, '0'         
    JE ASK_ROW          
    
    SUB AL, '1'
    MOV BH, AL          

    ; ====================================================
    ; [????] ???? ?????? ??????? ??? ??? ??? ?????
    ; ====================================================
    PUSH BX             ; ??? ??? ???? ???????
    
    MOV AL, BL          ; ??? ???? ?? AL
    MOV CL, 9
    MUL CL              ; AX = ???? * 9
    
    MOV BL, BH          ; ??? ?????? ?? BL
    XOR BH, BH
    ADD AX, BX          ; AX = (???? * 9) + ??????
    MOV SI, AX          ; SI ???? ???? ???? ?????? ?? ???????
    
    POP BX              ; ??????? ??? ???? ???????
    
    CMP board[SI], 0    ; ?? ?????? ????? (????? 0)?
    JE ASK_VAL          ; ?? ???? ???? ????? ?? ??????
    
    ; -- ?? ?? (?????? ?????) --
    LEA DX, msg_full    ; ???? ????? ?????? ???????
    MOV AH, 9
    INT 21h
    JMP REPEAT_LOOP     ; ???? ?????? ?????? ?? ????

    ; ====================================================

ASK_VAL:
    LEA DX, msg_num
    MOV AH, 9
    INT 21h

    MOV AH, 1
    INT 21h
    
    CMP AL, '0'         
    JE ASK_COL          
    
    SUB AL, '0'
    MOV CL, AL          

    ; SI ?????? ?????? ?????? ?? ?????? ???????
    ; ???? ???????? ?????

    CMP sol[SI], CL
    JNE SHOW_ERROR      

    ; Correct
    MOV board[SI], CL   
    LEA DX, msg_ok
    MOV AH, 9
    INT 21h
    JMP REPEAT_LOOP

SHOW_ERROR:
    LEA DX, msg_err
    MOV AH, 9
    INT 21h

    INC mistakes        
    CMP mistakes, 3     
    JNE REPEAT_LOOP     

    LEA DX, msg_fail
    MOV AH, 9
    INT 21h
    
    MOV AH, 1
    INT 21h
    
    JMP RESET_GAME      

REPEAT_LOOP:
    JMP GAME_LOOP       

WIN:
    LEA DX, msg_win
    MOV AH, 9
    INT 21h
    
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN