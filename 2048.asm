.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Exemplu proiect desenare",0
area_width EQU 640
area_height EQU 480
area DD 0

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc

button_x EQU 50
button_y EQU 50
button_size EQU 100

score dd 0
aux dd 0

matrice dd 0,0,0,0
		dd 0,0,0,0
		dd 0,0,0,0
		dd 0,0,0,0
	
matrice_1 dd 0,0,0,0
		  dd 0,0,0,0
		  dd 0,0,0,0
		  dd 0,0,0,0

matrice_2 dd 0,0,0,0
		  dd 0,0,0,0
		  dd 0,0,0,0
		  dd 0,0,0,0
		
matrice_3 dd 0,0,0,0
		  dd 0,0,0,0
		  dd 0,0,0,0
		  dd 0,0,0,0
		
matrice_4 dd 0,0,0,0
		  dd 0,0,0,0
		  dd 0,0,0,0
		  dd 0,0,0,0
		
matrice_5 dd 0,0,0,0
		  dd 0,0,0,0
		  dd 0,0,0,0
		  dd 0,0,0,0
	
coordonateX dd 95, 195, 295, 395
			dd 95, 195, 295, 395
			dd 95, 195, 295, 395
			dd 95, 195, 295, 395
			
coordonateY dd 90, 190, 290, 390
			dd 90, 190, 290, 390
			dd 90, 190, 290, 390
			dd 90, 190, 290, 390
			


.code

generate_number proc

	din_nou:
	rdtsc
	mov ECX, 16
	mov EDX, 0
	div ECX
	;in EDX am pozitia de la 0 la 15
	cmp dword ptr matrice[EDX*4], 0
	jne din_nou
	
	mov dword ptr matrice[EDX*4], 2
	;acum sa vedem daca pun 2 sau 4 pe acea pozitie
	mov ECX, EDX
	rdtsc
	mov EBX, 16
	mov EDX, 0
	div EBX
	cmp EDX, 12
	jle skip
	shl dword ptr matrice[ECX*4], 1
	skip:
	ret

generate_number endp


print_score macro score

	mov ebx, 10
	mov eax, score
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 585, 140
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 575, 140
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 565, 140
	;cifra miilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 555, 140
	
endm


copy_matrix macro m1, m2
local bucla
	mov EAX, 0
	bucla:
		mov EBX, m2[EAX]
		mov m1[EAX], EBX
		add EAX, 4
		cmp EAX, 60
		jle bucla
endm


color_square macro x, y, len, color
local bucla
	mov eax, 0
	mov ecx, 99
bucla:
	mov eax, y
	add eax, ecx
	push ecx
	
	line_horizontal x+1, eax, len-1, color
	pop ecx
	mov eax, 0
loop bucla

endm


coloreaza_boss macro poz, x, y
local sari1, sari2, sari3, sari4, sari5, sari6, sari7, sari8, sari9, sari10, sari11, sari12
	
	
	cmp matrice[poz], 2
	jne sari2
	color_square x, y, 100, 0FFD700h
	sari2:
	
	cmp matrice[poz], 4
	jne sari3
	color_square x, y, 100, 0FFBF00h
	sari3:
	
	cmp matrice[poz], 8
	jne sari4
	color_square x, y, 100, 0FF4F00h
	sari4:
	
	cmp matrice[poz], 16
	jne sari5
	color_square x,y, 100, 0FF2400h
	sari5:
	
	cmp matrice[poz], 32
	jne sari6
	color_square x,y, 100, 0DA2C43h
	sari6:
	
	cmp matrice[poz], 64
	jne sari7
	color_square x,y, 100, 0FF0080h
	sari7:
	
	cmp matrice[poz], 128
	jne sari8
	color_square x,y, 100, 0C21E56h
	sari8:
	
	cmp matrice[poz], 256
	jne sari9
	color_square x,y, 100, 0A50021h
	sari9:
	
	cmp matrice[poz], 512
	jne sari10
	color_square x,y, 100, 0B31B1Bh
	sari10:
	
	cmp matrice[poz], 1024
	jne sari11
	color_square x,y, 100, 00FFBFh
	sari11:
	
	cmp matrice[poz], 2048
	jne sari12
	color_square x,y, 100, 1B4D3Eh
	sari12:

endm

deseneaza_numar macro poz, x, y
local sari1, sari2, sari3, sari4, sari5, sari6, sari7, sari8, sari9, sari10, sari11, sari12
	cmp matrice[poz], 0
	jne sari1
	make_text_macro ' ', area, x, y
	sari1:
	
	cmp matrice[poz], 2
	jne sari2
	;color_square 50, 50, 100, 0fbab3ah
	make_text_macro '2', area, x, y
	sari2:
	
	cmp matrice[poz], 4
	jne sari3
	make_text_macro '4', area, x, y
	sari3:
	
	cmp matrice[poz], 8
	jne sari4
	make_text_macro '8', area, x, y
	sari4:
	
	cmp matrice[poz], 16
	jne sari5
	make_text_macro '1', area, x, y
	add x, 10
	make_text_macro '6', area, x, y
	sub x,10
	sari5:
	
	cmp matrice[poz], 32
	jne sari6
	make_text_macro '3', area, x, y
	add x, 10
	make_text_macro '2', area, x, y
	sub x,10
	sari6:
	
	cmp matrice[poz], 64
	jne sari7
	make_text_macro '6', area, x, y
	add x, 10
	make_text_macro '4', area, x, y
	sub x,10
	sari7:
	
	cmp matrice[poz], 128
	jne sari8
	make_text_macro '1', area, x, y
	add x, 10
	make_text_macro '2', area, x, y
	add x,10
	make_text_macro '8', area, x, y
	sub x, 20
	sari8:
	
	cmp matrice[poz], 256
	jne sari9
	make_text_macro '2', area, x, y
	add x, 10
	make_text_macro '5', area, x, y
	add x,10
	make_text_macro '6', area, x, y
	sub x, 20
	sari9:
	
	cmp matrice[poz], 512
	jne sari10
	make_text_macro '5', area, x, y
	add x, 10
	make_text_macro '1', area, x, y
	add x,10
	make_text_macro '2', area, x, y
	sub x, 20
	sari10:
	
	cmp matrice[poz], 1024
	jne sari11
	make_text_macro '1', area, x, y
	add x, 10
	make_text_macro '0', area, x, x
	add x,10
	make_text_macro '2', area, x, y
	add x,10
	make_text_macro '4', area, x, y
	sub x, 30
	sari11:
	
	cmp matrice[poz], 2048
	jne sari12
	make_text_macro '2', area, x, y
	add x, 10
	make_text_macro '0', area, x, y
	add x,10
	make_text_macro '4', area, x, y
	add x,10
	make_text_macro '8', area, x, y
	sub x, 30
	sari12:

endm


stanga proc

		mov EAX, dword ptr matrice[0]
		mov EBX, dword ptr matrice[4]
		mov ECX, dword ptr matrice[8]
		mov EDX, dword ptr matrice[12]
		
		cmp ECX,0
		jne skip1
		mov ECX, EDX
		mov EDX, 0
		
		skip1:
		cmp EBX, 0
		jne skip2
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip2:
		cmp EAX, 0
		jne skip3
		mov EAX, EBX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip3:
		cmp EAX, EBX
		jne nu_aduna1	
		shl EAX, 1
		add score, EAX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX,0
		
		nu_aduna1:
		cmp EBX, ECX
		jne nu_aduna2
		shl EBX,1
		add score, EBX
		mov ECX, EDX
		mov EDX, 0
		
		nu_aduna2:
		cmp ECX, EDX
		jne nu_aduna3
		shl ECX,1
		add score, ECX
		mov EDX, 0
		
		nu_aduna3:
		mov dword ptr matrice[0], EAX
		mov dword ptr matrice[4], EBX
		mov dword ptr matrice[8], ECX
		mov dword ptr matrice[12], EDX
		
		
		
		
		mov EAX, dword ptr matrice[16]
		mov EBX, dword ptr matrice[20]
		mov ECX, dword ptr matrice[24]
		mov EDX, dword ptr matrice[28]
		
		cmp ECX,0
		jne skip4
		mov ECX, EDX
		mov EDX, 0
		
		skip4:
		cmp EBX, 0
		jne skip5
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip5:
		cmp EAX, 0
		jne skip6
		mov EAX, EBX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip6:
		cmp EAX, EBX
		jne nu_aduna4
		shl EAX, 1
		add score, EAX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX,0
		
		nu_aduna4:
		cmp EBX, ECX
		jne nu_aduna5
		shl EBX, 1
		add score, EBX
		mov ECX, EDX
		mov EDX, 0
		
		nu_aduna5:
		cmp ECX, EDX
		jne nu_aduna6
		shl ECX, 1
		add score, ECX
		mov EDX, 0
		
		nu_aduna6:
		mov dword ptr matrice[16], EAX
		mov dword ptr matrice[20], EBX
		mov dword ptr matrice[24], ECX
		mov dword ptr matrice[28], EDX
		
		
		
		
		mov EAX, dword ptr matrice[32]
		mov EBX, dword ptr matrice[36]
		mov ECX, dword ptr matrice[40]
		mov EDX, dword ptr matrice[44]
		
		cmp ECX,0
		jne skip7
		mov ECX, EDX
		mov EDX,0
		
		skip7:
		cmp EBX, 0
		jne skip8
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip8:
		cmp EAX, 0
		jne skip9
		mov EAX, EBX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip9:
		cmp EAX, EBX
		jne nu_aduna7
		shl EAX, 1
		add score, EAX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX,0
		
		nu_aduna7:
		cmp EBX, ECX
		jne nu_aduna8
		shl EBX, 1
		add score, EBX
		mov ECX, EDX
		mov EDX, 0
		
		nu_aduna8:
		cmp ECX, EDX
		jne nu_aduna9
		shl ECX, 1
		add score, ECX
		mov EDX, 0
		
		nu_aduna9:
		mov dword ptr matrice[32], EAX
		mov dword ptr matrice[36], EBX
		mov dword ptr matrice[40], ECX
		mov dword ptr matrice[44], EDX
		
		
		
		
		mov EAX, dword ptr matrice[48]
		mov EBX, dword ptr matrice[52]
		mov ECX, dword ptr matrice[56]
		mov EDX, dword ptr matrice[60]
		
		cmp ECX,0
		jne skip10
		mov ECX, EDX
		mov EDX, 0
		
		skip10:
		cmp EBX, 0
		jne skip11
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip11:
		cmp EAX, 0
		jne skip12
		mov EAX, EBX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip12:
		cmp EAX, EBX
		jne nu_aduna10
		shl EAX, 1
		add score, EAX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX,0
		
		nu_aduna10:
		cmp EBX, ECX
		jne nu_aduna11
		shl EBX, 1
		add score, EBX
		mov ECX, EDX
		mov EDX, 0
		
		nu_aduna11:
		cmp ECX, EDX
		jne nu_aduna12
		shl ECX, 1
		add score, ECX
		mov EDX, 0
		
		nu_aduna12:
		mov dword ptr matrice[48], EAX
		mov dword ptr matrice[52], EBX
		mov dword ptr matrice[56], ECX
		mov dword ptr matrice[60], EDX
		
		ret 
stanga endp	



dreapta proc

		mov EAX, dword ptr matrice[0]
		mov EBX, dword ptr matrice[4]
		mov ECX, dword ptr matrice[8]
		mov EDX, dword ptr matrice[12]
		
		cmp EBX,0
		jne skip1
		mov EBX, EAX
		mov EAX, 0
		
		skip1:
		cmp ECX, 0
		jne skip2
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip2:
		cmp EDX, 0
		jne skip3
		mov EDX, ECX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip3:
		cmp EDX, ECX
		jne nu_aduna1
		shl EDX, 1
		add score, EDX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX,0
		
		nu_aduna1:
		cmp ECX, EBX
		jne nu_aduna2
		shl ECX, 1
		add score, ECX
		mov EBX, EAX
		mov EAX, 0
		
		nu_aduna2:
		cmp EBX, EAX
		jne nu_aduna3
		shl EBX, 1
		add score, EBX
		mov EAX, 0
		
		nu_aduna3:
		mov dword ptr matrice[0], EAX
		mov dword ptr matrice[4], EBX
		mov dword ptr matrice[8], ECX
		mov dword ptr matrice[12], EDX
		
		
		
		
		mov EAX, dword ptr matrice[16]
		mov EBX, dword ptr matrice[20]
		mov ECX, dword ptr matrice[24]
		mov EDX, dword ptr matrice[28]
		
		cmp EBX,0
		jne skip4
		mov EBX, EAX
		mov EAX, 0
		
		skip4:
		cmp ECX, 0
		jne skip5
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip5:
		cmp EDX, 0
		jne skip6
		mov EDX, ECX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip6:
		cmp EDX, ECX
		jne nu_aduna4
		shl EDX, 1
		add score, EDX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX,0
		
		nu_aduna4:
		cmp ECX, EDX
		jne nu_aduna5
		shl ECX, 1
		add score, ECX
		mov EBX, EAX
		mov EAX, 0
		
		nu_aduna5:
		cmp EBX, EAX
		jne nu_aduna6
		shl EBX, 1
		add score, EBX
		mov EAX, 0
		
		nu_aduna6:
		mov dword ptr matrice[16], EAX
		mov dword ptr matrice[20], EBX
		mov dword ptr matrice[24], ECX
		mov dword ptr matrice[28], EDX
		
		
		
		
		mov EAX, dword ptr matrice[32]
		mov EBX, dword ptr matrice[36]
		mov ECX, dword ptr matrice[40]
		mov EDX, dword ptr matrice[44]
		
		cmp EBX,0
		jne skip7
		mov EBX, EAX
		mov EAX,0
		
		skip7:
		cmp ECX, 0
		jne skip8
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip8:
		cmp EDX, 0
		jne skip9
		mov EDX, ECX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip9:
		cmp EDX, ECX
		jne nu_aduna7
		shl EDX, 1
		add score, EDX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX,0
		
		nu_aduna7:
		cmp ECX, EBX
		jne nu_aduna8
		shl ECX, 1
		add score, ECX
		mov EBX, EAX
		mov EAX, 0
		
		nu_aduna8:
		cmp EBX, EAX
		jne nu_aduna9
		shl EBX, 1
		add score, EBX
		mov EAX, 0
		
		nu_aduna9:
		mov dword ptr matrice[32], EAX
		mov dword ptr matrice[36], EBX
		mov dword ptr matrice[40], ECX
		mov dword ptr matrice[44], EDX
		
		
		
		
		mov EAX, dword ptr matrice[48]
		mov EBX, dword ptr matrice[52]
		mov ECX, dword ptr matrice[56]
		mov EDX, dword ptr matrice[60]
		
		cmp EBX,0
		jne skip10
		mov EBX, EAX
		mov EAX, 0
		
		skip10:
		cmp ECX, 0
		jne skip11
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip11:
		cmp EDX, 0
		jne skip12
		mov EDX, ECX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip12:
		cmp EDX, ECX
		jne nu_aduna10
		shl EDX, 1
		add score, EDX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX,0
		
		nu_aduna10:
		cmp ECX, EBX
		jne nu_aduna11
		shl ECX, 1
		add score, ECX
		mov EBX, EAX
		mov EAX, 0
		
		nu_aduna11:
		cmp EBX, EAX
		jne nu_aduna12
		shl EBX, 1
		add score, EBX
		mov EAX, 0
		
		nu_aduna12:
		mov dword ptr matrice[48], EAX
		mov dword ptr matrice[52], EBX
		mov dword ptr matrice[56], ECX
		mov dword ptr matrice[60], EDX
		
		ret 
dreapta endp	





sus proc

		mov EAX, dword ptr matrice[0]
		mov EBX, dword ptr matrice[16]
		mov ECX, dword ptr matrice[32]
		mov EDX, dword ptr matrice[48]
		
		cmp ECX,0
		jne skip1
		mov ECX, EDX
		mov EDX, 0
		
		skip1:
		cmp EBX, 0
		jne skip2
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip2:
		cmp EAX, 0
		jne skip3
		mov EAX, EBX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip3:
		cmp EAX, EBX
		jne nu_aduna1
		shl EAX, 1
		add score, EAX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX,0
		
		nu_aduna1:
		cmp EBX, ECX
		jne nu_aduna2
		shl EBX, 1
		add score, EBX
		mov ECX, EDX
		mov EDX, 0
		
		nu_aduna2:
		cmp ECX, EDX
		jne nu_aduna3
		shl ECX, 1
		add score, ECX
		mov EDX, 0
		
		nu_aduna3:
		mov dword ptr matrice[0], EAX
		mov dword ptr matrice[16], EBX
		mov dword ptr matrice[32], ECX
		mov dword ptr matrice[48], EDX
		
		
		
		
		mov EAX, dword ptr matrice[4]
		mov EBX, dword ptr matrice[20]
		mov ECX, dword ptr matrice[36]
		mov EDX, dword ptr matrice[52]
		
		cmp ECX,0
		jne skip4
		mov ECX, EDX
		mov EDX, 0
		
		skip4:
		cmp EBX, 0
		jne skip5
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip5:
		cmp EAX, 0
		jne skip6
		mov EAX, EBX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip6:
		cmp EAX, EBX
		jne nu_aduna4
		shl EAX, 1
		add score, EAX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX,0
		
		nu_aduna4:
		cmp EBX, ECX
		jne nu_aduna5
		shl EBX, 1
		add score, EBX
		mov ECX, EDX
		mov EDX, 0
		
		nu_aduna5:
		cmp ECX, EDX
		jne nu_aduna6
		shl ECX, 1
		add score, ECX
		mov EDX, 0
		
		nu_aduna6:
		mov dword ptr matrice[4], EAX
		mov dword ptr matrice[20], EBX
		mov dword ptr matrice[36], ECX
		mov dword ptr matrice[52], EDX
		
		
		
		
		mov EAX, dword ptr matrice[8]
		mov EBX, dword ptr matrice[24]
		mov ECX, dword ptr matrice[40]
		mov EDX, dword ptr matrice[56]
		
		cmp ECX,0
		jne skip7
		mov ECX, EDX
		mov EDX,0
		
		skip7:
		cmp EBX, 0
		jne skip8
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip8:
		cmp EAX, 0
		jne skip9
		mov EAX, EBX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip9:
		cmp EAX, EBX
		jne nu_aduna7
		shl EAX, 1
		add score, EAX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX,0
		
		nu_aduna7:
		cmp EBX, ECX
		jne nu_aduna8
		shl EBX, 1
		add score, EBX
		mov ECX, EDX
		mov EDX, 0
		
		nu_aduna8:
		cmp ECX, EDX
		jne nu_aduna9
		shl ECX, 1
		add score, ECX
		mov EDX, 0
		
		nu_aduna9:
		mov dword ptr matrice[8], EAX
		mov dword ptr matrice[24], EBX
		mov dword ptr matrice[40], ECX
		mov dword ptr matrice[56], EDX
		
		
		
		
		mov EAX, dword ptr matrice[12]
		mov EBX, dword ptr matrice[28]
		mov ECX, dword ptr matrice[44]
		mov EDX, dword ptr matrice[60]
		
		cmp ECX,0
		jne skip10
		mov ECX, EDX
		mov EDX, 0
		
		skip10:
		cmp EBX, 0
		jne skip11
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip11:
		cmp EAX, 0
		jne skip12
		mov EAX, EBX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX, 0
		
		skip12:
		cmp EAX, EBX
		jne nu_aduna10
		shl EAX, 1
		add score, EAX
		mov EBX, ECX
		mov ECX, EDX
		mov EDX,0
		
		nu_aduna10:
		cmp EBX, ECX
		jne nu_aduna11
		shl EBX, 1
		add score, EBX
		mov ECX, EDX
		mov EDX, 0
		
		nu_aduna11:
		cmp ECX, EDX
		jne nu_aduna12
		shl ECX, 1
		add score, ECX
		mov EDX, 0
		
		nu_aduna12:
		mov dword ptr matrice[12], EAX
		mov dword ptr matrice[28], EBX
		mov dword ptr matrice[44], ECX
		mov dword ptr matrice[60], EDX
		
		ret 
sus endp	





jos proc

		mov EAX, dword ptr matrice[0]
		mov EBX, dword ptr matrice[16]
		mov ECX, dword ptr matrice[32]
		mov EDX, dword ptr matrice[48]
		
		cmp EBX,0
		jne skip1
		mov EBX, EAX
		mov EAX, 0
		
		skip1:
		cmp ECX, 0
		jne skip2
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip2:
		cmp EDX, 0
		jne skip3
		mov EDX, ECX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip3:
		cmp EDX, ECX
		jne nu_aduna1
		shl EDX, 1
		add score, EDX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX,0
		
		nu_aduna1:
		cmp ECX, EBX
		jne nu_aduna2
		shl ECX, 1
		add score, ECX
		mov EBX, EAX
		mov EAX, 0
		
		nu_aduna2:
		cmp EBX, EAX
		jne nu_aduna3
		shl EBX, 1
		add score, EBX
		mov EAX, 0
		
		nu_aduna3:
		mov dword ptr matrice[0], EAX
		mov dword ptr matrice[16], EBX
		mov dword ptr matrice[32], ECX
		mov dword ptr matrice[48], EDX
		
		
		
		
		mov EAX, dword ptr matrice[4]
		mov EBX, dword ptr matrice[20]
		mov ECX, dword ptr matrice[36]
		mov EDX, dword ptr matrice[52]
		
		cmp EBX,0
		jne skip4
		mov EBX, EAX
		mov EAX, 0
		
		skip4:
		cmp ECX, 0
		jne skip5
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip5:
		cmp EDX, 0
		jne skip6
		mov EDX, ECX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip6:
		cmp EDX, ECX
		jne nu_aduna4
		shl EDX, 1
		add score, EDX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX,0
		
		nu_aduna4:
		cmp ECX, EDX
		jne nu_aduna5
		shl ECX, 1
		add score, ECX
		mov EBX, EAX
		mov EAX, 0
		
		nu_aduna5:
		cmp EBX, EAX
		jne nu_aduna6
		shl EBX, 1
		add score, EBX
		mov EAX, 0
		
		nu_aduna6:
		mov dword ptr matrice[4], EAX
		mov dword ptr matrice[20], EBX
		mov dword ptr matrice[36], ECX
		mov dword ptr matrice[52], EDX
		
		
		
		
		mov EAX, dword ptr matrice[8]
		mov EBX, dword ptr matrice[24]
		mov ECX, dword ptr matrice[40]
		mov EDX, dword ptr matrice[56]
		
		cmp EBX,0
		jne skip7
		mov EBX, EAX
		mov EAX,0
		
		skip7:
		cmp ECX, 0
		jne skip8
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip8:
		cmp EDX, 0
		jne skip9
		mov EDX, ECX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip9:
		cmp EDX, ECX
		jne nu_aduna7
		shl EDX, 1
		add score, EDX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX,0
		
		nu_aduna7:
		cmp ECX, EBX
		jne nu_aduna8
		shl ECX, 1
		add score, ECX
		mov EBX, EAX
		mov EAX, 0
		
		nu_aduna8:
		cmp EBX, EAX
		jne nu_aduna9
		shl EBX, 1
		add score, EBX
		mov EAX, 0
		
		nu_aduna9:
		mov dword ptr matrice[8], EAX
		mov dword ptr matrice[24], EBX
		mov dword ptr matrice[40], ECX
		mov dword ptr matrice[56], EDX
		
		
		
		
		mov EAX, dword ptr matrice[12]
		mov EBX, dword ptr matrice[28]
		mov ECX, dword ptr matrice[44]
		mov EDX, dword ptr matrice[60]
		
		cmp EBX,0
		jne skip10
		mov EBX, EAX
		mov EAX, 0
		
		skip10:
		cmp ECX, 0
		jne skip11
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip11:
		cmp EDX, 0
		jne skip12
		mov EDX, ECX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX, 0
		
		skip12:
		cmp EDX, ECX
		jne nu_aduna10
		shl EDX, 1
		add score, EDX
		mov ECX, EBX
		mov EBX, EAX
		mov EAX,0
		
		nu_aduna10:
		cmp ECX, EBX
		jne nu_aduna11
		shl ECX, 1
		add score, ECX
		mov EBX, EAX
		mov EAX, 0
		
		nu_aduna11:
		cmp EBX, EAX
		jne nu_aduna12
		shl EBX, 1
		add score, EBX
		mov EAX, 0
		
		nu_aduna12:
		mov dword ptr matrice[12], EAX
		mov dword ptr matrice[28], EBX
		mov dword ptr matrice[44], ECX
		mov dword ptr matrice[60], EDX
		
		ret 
jos endp


; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	;mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

line_horizontal macro x, y, len, color
local bucla_line
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov ecx, len
bucla_line:
	mov dword ptr[eax], color
	add eax, 4
	loop bucla_line
endm

line_vertical macro x, y, len, color
local bucla_line
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov ecx, len
bucla_line:
	mov dword ptr[eax], color
	add eax, 4*area_width
	loop bucla_line
endm

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click, 3 - s-a apasat o tasta)
; arg2 - x (in cazul apasarii unei taste, x contine codul ascii al tastei care a fost apasata)
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	cmp eax, 3
	jz evt_key
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	
evt_click:
	mov EAX, [ebp+arg2]
	cmp eax, 500
	jle button_fail
	cmp eax, 600
	jge button_fail
	mov eax, [ebp+arg3]
	cmp eax, 50
	jle button_fail
	cmp eax,100
	jge button_fail
	
	mov matrice[0], 0
	mov matrice[4], 0
	mov matrice[8], 0
	mov matrice[12], 0
	mov matrice[16], 0
	mov matrice[20], 0
	mov matrice[24], 0
	mov matrice[28], 0
	mov matrice[32], 0
	mov matrice[36], 0
	mov matrice[40], 0
	mov matrice[44], 0
	mov matrice[48], 0
	mov matrice[52], 0
	mov matrice[56], 0
	mov matrice[60], 0
	mov score, 0
	call draw
	call generate_number
	call generate_number
	jmp gata1
	
	button_fail:
	mov EAX, [ebp+arg2]
	cmp eax, 535
	jle button_fail2
	cmp eax, 600
	jge button_fail2
	mov eax, [ebp+arg3]
	cmp eax, 210
	jle button_fail2
	cmp eax, 260
	jge button_fail2
	
	
	copy_matrix matrice, matrice_1
	copy_matrix matrice_1, matrice_2
	copy_matrix matrice_2, matrice_3
	copy_matrix matrice_3, matrice_4
	copy_matrix matrice_4, matrice_5
	button_fail2:
	call draw
	jmp afisare_litere
	gata1:
		
evt_key:
	copy_matrix matrice_5, matrice_4
	copy_matrix matrice_4, matrice_3
	copy_matrix matrice_3, matrice_2
	copy_matrix matrice_2, matrice_1
	copy_matrix matrice_1, matrice


mov eax,[ebp+arg2]

	cmp eax,'A'
	jne nu_face1
	call stanga
	jmp gata
	
	nu_face1:
	cmp eax,'D'
	jne nu_face2
	call dreapta
	jmp gata
	
	nu_face2:
	cmp eax,'W'
	jne nu_face3
	call sus
	jmp gata
	
	nu_face3:
	cmp eax,'S'
	jne nu_face4
	call jos
	
	nu_face4:
	
	gata:
	call generate_number
	call draw
	jmp afisare_litere
	jmp evt_timer
	
evt_timer:
	inc counter
	
afisare_litere:
	 
	
	;scriem un mesaj
	
	line_horizontal button_x, button_y, button_size*4, 0
	line_horizontal button_x, button_y + button_size, button_size*4, 0
	line_horizontal button_x, button_y + 2*button_size, button_size*4, 0
	line_horizontal button_x, button_y + 3*button_size, button_size*4, 0
	line_horizontal button_x, button_y + 4*button_size, button_size*4, 0
	
	line_vertical button_x, button_y, button_size*4, 0
	line_vertical button_x + button_size, button_y, button_size*4, 0
	line_vertical button_x + 2*button_size, button_y, button_size*4, 0
	line_vertical button_x + 3*button_size, button_y, button_size*4, 0
	line_vertical button_x + 4*button_size, button_y, button_size*4, 0
	
	
	
	coloreaza_boss 0, 50, 50
	coloreaza_boss 4, 150, 50
	coloreaza_boss 8, 250, 50
	coloreaza_boss 12, 350, 50
	coloreaza_boss 16, 50, 150
	coloreaza_boss 20, 150, 150
	coloreaza_boss 24, 250, 150
	coloreaza_boss 28, 350, 150
	coloreaza_boss 32, 50, 250
	coloreaza_boss 36, 150, 250
	coloreaza_boss 40, 250, 250
	coloreaza_boss 44, 350, 250
	coloreaza_boss 48, 50, 350
	coloreaza_boss 52, 150, 350
	coloreaza_boss 56, 250, 350
	coloreaza_boss 60, 350, 350
	
	

	deseneaza_numar	0, coordonateX[0], coordonateY[0]
	deseneaza_numar	4, coordonateX[4], coordonateY[0]
	deseneaza_numar	8, coordonateX[8], coordonateY[0]
	deseneaza_numar	12, coordonateX[12], coordonateY[0]
	deseneaza_numar	16, coordonateX[0], coordonateY[4]
	deseneaza_numar	20, coordonateX[4], coordonateY[4]
	deseneaza_numar	24, coordonateX[8], coordonateY[4]
	deseneaza_numar	28, coordonateX[12], coordonateY[4]
	deseneaza_numar	32, coordonateX[0], coordonateY[8]
	deseneaza_numar	36, coordonateX[4], coordonateY[8]
	deseneaza_numar	40, coordonateX[8], coordonateY[8]
	deseneaza_numar	44, coordonateX[12], coordonateY[8]
	deseneaza_numar	48, coordonateX[0], coordonateY[12]
	deseneaza_numar	52, coordonateX[4], coordonateY[12]
	deseneaza_numar	56, coordonateX[8], coordonateY[12]
	deseneaza_numar	60, coordonateX[12], coordonateY[12]

	
	line_horizontal 500, 50, 100, 0
	line_horizontal 500, 100, 100, 0
	line_vertical 500, 50, 50, 0
	line_vertical 600, 50, 50, 0
	
	
	make_text_macro 'S', area, 510, 60
	make_text_macro 'T', area, 527, 60
	make_text_macro 'A', area, 544, 60
	make_text_macro 'R', area, 561, 60
	make_text_macro 'T', area, 578, 60
	
	
	line_horizontal 480, 130, 120, 0
	line_horizontal 480, 180, 120, 0
	line_vertical 480, 130, 50, 0
	line_vertical 600, 130, 50, 0
	
	make_text_macro 'S', area, 485, 140
	make_text_macro 'C', area, 495, 140
	make_text_macro 'O', area, 505, 140
	make_text_macro 'R', area, 515, 140
	make_text_macro 'E', area, 525, 140
	print_score score
	
	
	line_horizontal 535, 210, 65, 0
	line_horizontal 535, 260, 65, 0
	line_vertical 535, 210, 50, 0
	line_vertical 600, 210, 50, 0
	
	make_text_macro 'U', area, 545, 223
	make_text_macro 'N', area, 555, 223
	make_text_macro 'D', area, 565, 223
	make_text_macro 'O', area, 575, 223
	
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
