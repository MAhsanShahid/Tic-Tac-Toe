; tic-tac-toe
; (L12-4062) (L12-4176)
; assembly-Lab (sec-B1)

[org 0x0100]
jmp start

P1_winning_msg: db 'Player 1 wins!!!',0
P2_winning_msg: db 'Player 2 wins!!!',0
draw_msg: db 'Game drawn!!!',0
menu: db 'Enter these numbers to fill the Grid(00,01,02,10,11,12,20,21,22) 00 for topLeft and 22 for bottom right and so on!!!',10,0
userInputRow: db 0
userInputCol: db 0
row1: db ' | |  ',10,0  
row2: db ' | |  ',10,0
row3: db ' | |  ',10,0
separator:  db '----- ',10,0
gridSeparator: db '------------------------',10,0


;SUBROUTINES

print:
mov si,dx           
printLoop:
mov cl,[si]      
inc si           
cmp cl, 0 
jne printLoop
dec si  
sub si,dx
mov cx,si    

mov ah, 0x40	
mov bx, 0x01    
int 0x21
ret 

inputMove:
mov ah,0x07       
int 0x21            
sub al, 0x30 		 
mov [userInputRow],al

mov ah, 0x07			
int 0x21
sub al, 0x30
mov [userInputCol],al
ret 

updateBoard:
xor  ax,ax
mov  al,[userInputCol]
shl  ax,1 
xor  cx,cx
mov  cl,[userInputRow]
shl  cx,3  
add  ax,cx
add  ax,row1
mov  si,ax
mov  [si],dl
ret 

printBoard:
push dx
mov dx,row1
call print
mov dx,separator
call print

mov dx,row2
call print
mov dx,separator
call print

mov dx,row3
call print
pop dx
ret 




;MAIN PROGRAM
start:
mov dx, menu 
call print  
mov cx,9
mov dl,'1'
looop:
push cx
push dx
mov dx, gridSeparator
call print
call inputMove
pop dx

call updateBoard
call printBoard

cmp dl,'1'
je  l1
mov dl,'1'
jmp en
l1:
mov dl,'2'
en:
push dx

checkWin:
mov si,row1
mov cx,3
rowLoop:
push cx       
xor cx,cx     
mov cl,[si]   
mov ax,cx     
mov cl,[si+2] 
add ax,cx     
mov cl,[si+4] 
add ax,cx     
cmp ax,3*'2'  
je found
cmp ax,3*'1'  
je found
add si,8      
pop cx        
dec cx      
jne rowLoop 
mov si,row1
mov cx,3
colLoop:
push cx       
xor cx,cx     
mov cl,[si]   
mov ax,cx     
mov cl,[si+8] 
add ax,cx     
mov cl,[si+2*8] 
add ax,cx     
cmp ax,3*'2' 
je found
cmp ax,3*'1'  
je found
add si,2      
pop cx        
dec cx        
jne colLoop ; 

mov si,row1
xor cx,cx     
mov cl,[si]   
mov ax,cx     
mov cl,[si+8+2]
add ax,cx     
mov cl,[si+2*8+4]
add ax,cx     
cmp ax,3*'2'  
je found
cmp ax,3*'1'  
je found

mov si,row1
xor cx,cx     
mov cl,[si+4] 
mov ax,cx     
mov cl,[si+8+2]
add ax,cx     
mov cl,[si+2*8]
add ax,cx     
cmp ax,3*'2'  
je found
cmp ax,3*'1'  
je found

pop dx
pop cx
dec cx
jne looop
found:
cmp ax,3*'2'
je P2_wins
cmp ax,3*'1'
jne draw
mov dx, P1_winning_msg
call print
jmp exit
P2_wins:
mov dx, P2_winning_msg
call print
jmp exit
draw:
mov dx, draw_msg
call print

exit:
mov ax, 0x4c00
int 0x21