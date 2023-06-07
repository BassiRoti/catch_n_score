[org 0x100]
jmp start
s: db 'score: '
length:dw 7
s6: db 'Time: '
length6:dw 6
oldisr: dd 0
tickcount: dw 0 
tickseconds: dw 0
loc:dw 2960
speed: dd 0
s1: db '10 POINTS'
l1: dw 8
s2: db '15 POINTS'
l2: dw 9
s3: db '30 POINTS'
l3: dw 9
s4: db 'BOMB'
l4: dw 4
s5: db 'PRESS TO START!'
l5: dw 15
oldisr2: dd 0
ttime: dw 0
position: dw 492
choice: dw 0
scores: dw 0
s7: db 'Game Over'
l7: dw 9
s8: db 'Score = '
l8:dw 8

mids:
push ax
push es

check2:
in al,0x60
cmp al,0x0A
jne check2

;mov al,0x20
;out 0x20,al

jmp far[cs:oldisr2]
iret;

clrscreen:
mov ax, 0xb800
mov es, ax
mov di, 0

nextlocat:
mov word[es:di],0x0720
add di,2
cmp di, 4000
jne nextlocat
ret


cursor:
mov ah, 02h
mov bh, 00h
mov dh, 00h
mov dl, 00h
int 10h
ret

endprog:
mov ax,0x4c00
int 21h

greenboxfunc:
call greenbox
jmp tempreturn

blueboxfunc:
call bluebox
jmp tempreturn

yellowboxfunc:
call yellowbox
jmp tempreturn

bombboxfunc:
call bombbox
jmp tempreturn

incspeed:
mov ax, [choice]
cmp ax, 0
je greenboxfunc

cmp ax, 1
je blueboxfunc

cmp ax, 2
je yellowboxfunc

cmp ax, 3
je bombboxfunc

tempreturn:
mov al, [speed]
inc al
mov [speed],al

call checkscore
call scrolldown
jmp skip

decspeed:
mov al, [speed]
dec al
mov [speed],al
jmp skip

clrsc: 

 push es 
 push ax 
 push di 

 mov ax, 0xb800 
 mov es, ax 
 mov di, 0 
 mov bx,0x5820
nextlc: 
 mov word [es:di], bx
 add di, 2 
 cmp di, 4000 
 jne nextlc
 pop di 
 pop ax 
 pop es 

 ret 

print:
 push bp
 mov bp,sp
 push es 
 push ax 
 push di 
 push bx
 push cx
 push si

 mov ax, 0xb800 
 mov es, ax 
 mov di,[bp+8]
 mov si,[bp+6]
 mov cx,[bp+4]
 loop19:
 mov bx,[si]
 mov bh,0x47
 mov word [es:di],bx
 add di,2
 add si,1
 sub cx,1
 cmp cx,0
 jnz loop19

pop si
pop cx
pop bx
pop di
pop ax
pop es
pop bp
ret 6

screen3: 
call clrsc
mov ax,1830
push ax
push s7
push word[l7]
call print

mov ax,1990
push ax
push s8
push word[l8]
call print
mov di, 2008
 mov ax, [scores]
 mov bx, 10 
 mov cx, 0 
nextdigit2: mov dx, 0 
 div bx 
 add dl, 0x30 
 push dx 
 inc cx 
 cmp ax, 0 
 jnz nextdigit2  
 mov di, 2008
nextpos2: pop dx 
 mov dh, 0x07 
 mov [es:di], dx 
 add di, 2 
 loop nextpos2
jmp endprogram

yellowcheck:
add di, 2
mov cx, word[es:di]
cmp cx, 0x6720
je tempreturnloop15
add di, 160
mov cx, word[es:di]
cmp cx, 0x0720
je yellowscore
sub di, 162
add di, 4
jmp returnloop15

bluecheck:
add di, 2
mov cx, word[es:di]
cmp cx, 0x3720
je tempreturnloop15
add di, 160
mov cx, word[es:di]
cmp cx, 0x0720
je bluescore
sub di, 162
add di, 4
jmp returnloop15

greencheck:
add di, 2
mov cx, word[es:di]
cmp cx, 0x2720
je tempreturnloop15
add di, 160
mov cx, word[es:di]
cmp cx, 0x0720
je greenscore
sub di, 162
add di, 4
jmp returnloop15

tempreturnloop15:
jmp returnloop15

bombcheck:
add di, 162
mov cx, word[es:di]
cmp cx, 0x0720
je screen3
sub di, 162
add di, 4
jmp returnloop15

yellowscore:
mov cx, 0
mov cx, [scores]
add cx, 5
mov [scores],cx
sub di, 160
add di, 4
jmp returnloop15

bluescore:
mov cx, 0
mov cx, [scores]
add cx, 10
mov [scores],cx
sub di, 160
add di, 4
jmp returnloop15

greenscore:
mov cx, 0
mov cx, [scores]
add cx, 15
mov [scores],cx
sub di, 160
add di, 4
jmp returnloop15


checkscore:
push ax
push bx
push cx
push dx
push di
push bp
mov bp, sp

mov ax, 0xb800
mov es, ax
mov ax, [score]
mov di, 2720

loop15:
mov bx, word[es:di]
cmp bx, 0x6720
je yellowcheck
cmp bx, 0x3720
je bluecheck
cmp bx, 0x2720
je greencheck
cmp bx, 0xC754
je bombcheck

returnloop15:
add di, 2
cmp di, 2874
jbe loop15

pop bp
pop di
pop dx
pop cx
pop bx
pop ax
ret


	printnum:
 push bp 
 mov bp, sp 
 push es 
 push ax 
 push bx 
 push cx 
 push dx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 mov ax, [bp+4] 
 mov bx, 10 ; use base 10 for division 
 mov cx, 0 ; initialize count of digits 
nextdigit: mov dx, 0 ; zero upper half of dividend 
 div bx ; divide by 10 
 add dl, 0x30 ; convert digit into ascii value 
 push dx ; save ascii value on stack 
 inc cx ; increment count of values 
 cmp ax, 0 ; is the quotient zero 
 jnz nextdigit ; if no divide it again 
 mov di, 332 ; point di to 70th column 
nextpos: pop dx ; remove a digit from the stack 
 mov dh, 0x07 ; use normal attribute 
 mov [es:di], dx ; print char on screen 
 add di, 2 ; move to next screen location 
 loop nextpos ; repeat for all digits on stack 
 pop di 
 pop dx 
 pop cx 
 pop bx 
 pop ax
 pop es 
 pop bp 
 ret 2 


 positionresetgreen:
 mov bx, 492
 mov word[position],bx
 jmp greenreturn

 positionresetblue:
 mov bx, 492
 mov word[position],bx
 jmp bluereturn

 positionresetyellow:
 mov bx, 492
 mov word[position],bx
 jmp yellowreturn

 positionresetbomb:
  mov bx, 492
 mov word[position],bx
 jmp bombreturn



 greenbox:
 push ax
mov ax,[position]
cmp ax, 636
ja positionresetgreen
greenreturn:
mov ax, [position]
push ax
call green
add ax, 30
mov word[position],ax
mov ax, 1
mov word[choice],ax
pop ax
ret


 bluebox:
 push ax
mov ax,[position]
cmp ax, 636
ja positionresetblue
bluereturn:
mov ax, [position]
push ax
call blue
add ax, 30
mov word[position],ax
mov ax, 2
mov word[choice],ax
pop ax
ret

 yellowbox:
 push ax
mov ax,[position]
cmp ax, 636
ja positionresetyellow
yellowreturn:
mov ax, [position]
push ax
call yellow
add ax, 30
mov word[position],ax
mov ax, 3
mov word[choice],ax
pop ax
ret

bombbox:
 push ax
mov ax,[position]
cmp ax, 636
ja positionresetbomb
bombreturn:
mov ax, [position]
push ax
call bomb
add ax, 30
mov word[position],ax
mov ax, 0
mov word[choice],ax
pop ax
ret


; timer interrupt service routine 
timer: push ax
	push cs 
	pop ds
mov ax,320
mov bx,3
push ax
push bx
push s6
push word[length6]
call score
mov ax,0
mov bx,[scores]
push ax
push bx
push s
push word[length]
call score

call cursor
mov ah, 0
mov al, [speed]
cmp ax, 0
je incspeed
jne decspeed

skip:

 inc word [tickcount]; increment tick count 
 
	mov ax,[tickcount]
	xor dx,dx
	mov cx,18
	div cx
	mov [tickseconds],ax
	push word [tickseconds] 
	cmp ax,0x0077
	je screen3
 call printnum ; print tick count 
 ;mov si,word[ttime]
 ;inc si
 ;mov word[ttime],si
 ;cmp si,0x000A
 ;je endprog
 
 mov al, 0x20 
 out 0x20, al ; end of interrupt 
 pop ax 

 ;mov ah,0x7
 ;mov al,2
 ;mov ch,5
 ;mov cl,5
 ;mov dh,19
 ;mov dl,70
 ;int 10

 iret ; return from interrupt 

clrscr:
push bp
mov bp,sp
push es 
 push ax 
 push di 
 push bx
mov ax, 0xb800 
 mov es, ax 

 mov di,[bp+6]
 mov bx,[bp+4]
nextloc: mov word [es:di],bx
 add di, 2 
 cmp di, 4000
 jne nextloc
 pop bx
 pop di 
 pop ax 
 pop es 
 pop bp
 ret 4

 bucket:
  push bp
 mov bp,sp
 push es 
 push ax 
 push di 
 push bx

 mov ax, 0xb800 
 mov es, ax 
 mov di,[bp+4]
 mov bx,0x0720
 mov word [es:di],bx
 add di,2
 mov bx, 0x1720
 mov word [es:di],bx
 add di,2
 mov bx,0x0720
 mov word [es:di],bx
 sub di,4
 add di,160
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx

 pop bx
 pop di 
 pop ax 
 pop es 
 pop bp
 ret 2


 bomb:
  push bp
 mov bp,sp
 push es 
 push ax 
 push di 
 push bx

 mov ax, 0xb800 
 mov es, ax 
 mov di,[bp+4]
 mov bx, 0x4720
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 sub di,4
 add di,160
 mov bx, 0xC754
 mov word [es:di],bx
 add di,2
 mov bx, 0xC74E
 mov word [es:di],bx
 add di,2
 mov bx, 0xC754
 mov word [es:di],bx

 mov di,[bp+6]
 add di,2
 add di,160
 mov bx, 0x4720
 mov word [es:di],bx

 pop bx
 pop di 
 pop ax 
 pop es 
 pop bp
 ret 2


 yellow:
  push bp
 mov bp,sp
 push es 
 push ax 
 push di 
 push bx

 mov ax, 0xb800 
 mov es, ax 
 mov di,[bp+4]
 mov bx,0x6720
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 sub di,4
 add di,160
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx

 mov di,[bp+4]
 add di,2
 add di,160
 mov bx,0x6720
 mov bl,1
 mov word [es:di],bx

 pop bx
 pop di 
 pop ax 
 pop es 
 pop bp
 ret 2


 green:
  push bp
 mov bp,sp
 push es 
 push ax 
 push di 
 push bx

 mov ax, 0xb800 
 mov es, ax 
 mov di,[bp+4]
 mov bx,0x2720
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 sub di,4
 add di,160
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx

 mov di,[bp+4]
 add di,2
 add di,160
 mov bx,0x2720
 mov bl,1
 mov word [es:di],bx

 pop bx
 pop di 
 pop ax 
 pop es 
 pop bp
 ret 2


 blue:
 push bp
 mov bp,sp
 push es 
 push ax 
 push di 
 push bx

 mov ax, 0xb800 
 mov es, ax 
 mov di,[bp+4]
 mov bx, 0x3720
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 sub di,4
 add di,160
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx

 mov di,[bp+4]
 add di,2
 add di,160
 mov bx, 0x3720
 mov bl,1
 mov word [es:di],bx

 pop bx
 pop di 
 pop ax 
 pop es 
 pop bp
 ret 2


 score:
 push bp
 mov bp,sp
 push es 
 push ax 
 push di 
 push bx
 push si
 mov ax, 0xb800 
 mov es, ax 


 mov di,[bp+10]

 mov si,[bp+6]
 
 mov cx,[bp+4]
 l: mov bx,[si]
 mov bh,0x07
 mov word [es:di],bx
 add di,2
 add si,1
  sub cx,1
 cmp cx,0
 jnz l

 mov ax,[bp+8]
 mov bx, 10 
 mov cx, 0 
nextdigit1: mov dx, 0 
 div bx 
 add dl, 0x30 
 push dx 
 inc cx  
 cmp ax, 0 
 jnz nextdigit1 
nextpos1: pop dx 
 mov dh, 0x07 
 mov [es:di], dx  
 add di, 2 
 loop nextpos1  

 pop si
 pop bx
 pop di 
 pop ax 
 pop es 
 pop bp
 ret 8

nextcmp1:
jmp nextcmp

nomatch1:
jmp nomatch

scroll:
mov ax,0xb800
mov es,ax

in al,0x60
cmp al,0x4D
jnz nextcmp1


mov si,[loc]
mov di,3038
cmp si,di
jz nomatch1



mov di,[loc]
mov word[es:di],0x1720
add di,4
mov word[es:di],0x1720
sub di,4
add di,160
mov word[es:di],0x1720
add di,2
mov word[es:di],0x1720
add di,2
mov word[es:di],0x1720

mov di,[loc]
add di,6
mov [loc],di
mov word[es:di],0x0720
add di,2
mov word[es:di],0x1720
add di,2
mov word[es:di],0x0720
sub di,4
add di,160
mov word[es:di],0x0720
add di,2
mov word[es:di],0x0720
add di,2
mov word[es:di],0x0720

jmp nomatch

nextcmp:
mov ax,0xb800
mov es,ax

in al,0x60
cmp al,0x4B
jne nomatch

mov si,[loc]
mov di,2920
cmp si,di
jz nomatch

mov di,[loc]
mov word[es:di],0x1720
add di,4
mov word[es:di],0x1720
sub di,4
add di,160
mov word[es:di],0x1720
add di,2
mov word[es:di],0x1720
add di,2
mov word[es:di],0x1720

mov di,[loc]
sub di,2
mov word[es:di],0x0720
sub di,2
mov word[es:di],0x1720
sub di,2
mov word[es:di],0x0720
mov [loc],di
add di,160
mov word[es:di],0x0720
add di,2
mov word[es:di],0x0720
add di,2
mov word[es:di],0x0720



nomatch:
mov al,0x20
out 0x20,al

jmp far[cs:oldisr]
ret


scrolldown:
mov ah, 7
mov al, 1
mov ch, 3
mov cl, 0
mov dh, 17
mov dl, 80
mov bh, 0x17
int 10h
ret



start:
call clrscreen
mov di, 60
add di, 480
mov dx, di

;yellow
 mov bx,0x6720
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 sub di,4
 add di,160
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx

 mov di,dx
 add di,2
 add di,160
 mov bx,0x6720
 mov bl,1
 mov word [es:di],bx
 add di, 10
 mov si, s1
 mov bx, 0

 loop1:
 mov ch, 0x07
 mov cl, [si+bx]
 mov word[es:di],cx
 add di,2
 inc bx
 cmp bx, [l1]
 jb loop1
 
 sub di, [l1]
 sub di, 20
 add di, 320

 mov dx, di

 ;blue
  mov bx,0x3720
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 sub di,4
 add di,160
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx

 mov di,dx
 add di,2
 add di,160
 mov bx,0x3720
 mov bl,1
 mov word [es:di],bx
 add di, 10
 mov si, s2
 mov bx, 0

 loop2:
 mov ch, 0x07
 mov cl, [si+bx]
 mov word[es:di],cx
 add di,2
 inc bx
 cmp bx, 9
 jb loop2
 
 sub di, 10
 sub di, 20
 add di, 320

 mov dx, di

 ;green
 mov bx,0x2720
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 sub di,4
 add di,160
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx

 mov di,dx
 add di,2
 add di,160
 mov bx,0x2720
 mov bl,1
 mov word [es:di],bx
 add di, 10
 mov si, s3
 mov bx, 0

 loop3:
 mov ch, 0x07
 mov cl, [si+bx]
 mov word[es:di],cx
 add di,2
 inc bx
 cmp bx, 9
 jb loop3
 
 sub di, 10
 sub di, 20
 add di, 320

 mov dx, di

  ;bomb
  mov bx,0x4720
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 add di,2
 mov word [es:di],bx
 sub di,4
 add di,160
 mov bx, 0xC754
 mov word [es:di],bx
 add di,2
 mov bx, 0xC74E
 mov word [es:di],bx
 add di,2
 mov bx, 0xC754
 mov word [es:di],bx
 sub di,2

 add di, 10
 mov si, s4
 mov bx, 0

 loop4:
 mov ch, 0x07
 mov cl, [si+bx]
 mov word[es:di],cx
 add di,2
 inc bx
 cmp bx, 4
 jb loop4
 
 sub di, 4
 sub di, 20
 add di, 800

  mov si, s5
 mov bx, 0

 loop5:
 mov ch, 0x07
 mov cl, [si+bx]
 mov word[es:di],cx
 add di,2
 inc bx
 cmp bx, [l5]
 jb loop5
 ; xor ax, ax 
 ;mov es, ax ; point es to IVT base 
 ;cli ; disable interrupts 
 ;mov word [es:8*4], spacebar; store offset at n*4 
 ;mov [es:8*4+2], cs ; store segment at n*4+2 
 ;sti ; enable interrupts 


mainloop:
 ;xor ax, ax 
 ;mov es, ax ; point es to IVT base 
 ;mov ax, [es:9*4] 
 ;mov [oldisr2], ax ; save offset of old routine 
 ;mov ax, [es:9*4+2] 
 ;mov [oldisr2+2], ax ; save segment of old routine 
 ;cli ; disable interrupts 
 ;mov word [es:9*4], mids ; store offset at n*4 
 ;mov [es:9*4+2], cs ; store segment at n*4+2 
 ;sti ; enable interrupts 
check: 
 mov ah, 0 ; service 0 – get keystroke 
 int 0x16 ; call BIOS keyboard service 
 ;cmp al,0x2A
 ;jne check

 ;mov ax, [oldisr2] ; read old offset in ax 
 ;mov bx, [oldisr2+2] ; read old segment in bx 
 ;cli ; disable interrupts 
 ;mov [es:9*4], ax ; restore old offset from ax 
 ;mov [es:9*4+2], bx ; restore old segment from bx 
 ;sti

 jmp screen2




 screen2:

 
call cursor
mov ax,0
mov bx,0x0720   
push ax
push bx
call clrscr
mov ax,0
mov bx,0x1720 
push ax
push bx
call clrscr  ;blue
mov ax,3200
mov bx,0x4720  
push ax
push bx
call clrscr  ;red
mov ax,3680
mov bx,0x7820
push ax
push bx
call clrscr  ;grey

;bucket
mov ax,2960

mov word[loc],2960 ;bucket location

push ax
call bucket


mov ax,0
mov bx,[scores]
push ax
push bx
push s
push word[length]
call score

mov ax,320
mov bx,3
push ax
push bx
push s6
push word[length6]
call score


 xor ax, ax 
 mov es, ax ; point es to IVT base 
 cli ; disable interrupts 
 mov word [es:8*4], timer; store offset at n*4 
 mov [es:8*4+2], cs ; store segment at n*4+2 
 sti ; enable interrupts 



xor ax,ax
mov es,ax
mov ax,[es:9*4]
mov [oldisr],ax
mov ax,[es:9*4+2]
mov [oldisr+2],ax
cli
mov word[es:9*4],scroll
mov [es:9*4+2],cs
sti
mov ah,0
int 0x16

mov ax,[oldisr]
mov bx,[oldisr+2]
cli
mov [es:9*4],ax
mov [es:9*4+2],bx
sti

endprogram:
mov ax,0x4c00
int 21h