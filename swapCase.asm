;;; Turn into an executable with the following two commands
;;; 1. nasm -f elf64 <filename>.asm
;;; 2. ld <filename>.o
;;; 1 assembles to code to produce the object file <filename>".o"
;;; 2 links to produce the executable "a.out"


	SYS_READ   equ     0          ; read text from stdin
	SYS_WRITE  equ     1          ; write text to stdout
	SYS_EXIT   equ     60         ; terminate the program
	STDIN      equ     0          ; standard input
	STDOUT     equ     1          ; standard output
; --------------------------------
section .bss
    MaxLength equ     24         ; 24 bytes for user input
    UserInput     resb    MaxLength ; buffer for user input
; --------------------------------
section .data
    prompt     db      "Please input some text (max 23 characters): "
    prompt_len equ     $ - prompt
    text       db      10, "When swapped you get: "
    text_len   equ     $ - text
; --------------------------------
section .text
	global _start
	global swapcase

_start:
	;; Output a prompt to user
	mov     rdx, prompt_len
	mov     rsi, prompt
	mov     rdi, STDOUT
	mov     rax, SYS_WRITE
	syscall

	;; Read a string from console into uinput
	mov     rdx, MaxLength
	mov     rsi, UserInput
	mov     rdi, STDIN
	mov     rax, SYS_READ
	syscall                      ; -> RAX
	push    rax                  ; (1)

	;; Call procedure to swap the string case
	;; uppercase becomes lowercase
	;; lowercase becomes uppercase
	;; Remember to pass in correct parameters
	mov rdi,UserInput
	mov rsi,MaxLength
	call swapcase
	
;;; here is sample call to procedure that does a rot47 encoding
;;; Just for comparison like
;;;	mov rdi,UserInput
;;;	mov rsi,MaxLength
;;;	call rot47
	
	;; Write out prompt to console
	mov     rdx, text_len
	mov     rsi, text
	mov     rdi, STDOUT
	mov     rax, SYS_WRITE
	syscall

	;; Write out string that was swapcased
	pop     rdx                  ; (1)
	mov     rsi, UserInput
	mov     rdi, STDOUT
	mov     rax, SYS_WRITE
	syscall
	
	;; Exit the program with exit code 0
	xor     edi, edi             ; successful exit
	mov     rax, SYS_EXIT
	syscall

	;; Procedure to swap case in a string
	;; Upper becomes lower and lower becomes upper
	;; e.g. "Hello Joey Boy" becomes "hELLO jOEY bOY"
	;; Implement this!
	
;;; Parameter passed in are:
;;; string (RDI)
;;; length of string (RSI)
;;; Returns 1 if successful (RAX)
swapcase:
	push rbp			;initialise stack
	mov rbp,rsp
loop:
	mov al,[rdi]		; move first letter of text into al
	cmp al,65			; less than ASCII 65? leave alone
	jl next
	cmp al,122			; greater than ASCII 122? leave alone
	jg next
	cmp al,90			; if letter in range ASCII 65-90 -> is uppercase so convert to lower
	jle conv_lower
	cmp al,97			; if letter in range ASCII 97-122 -> is lowercase so convert to upper
	jge conv_upper
conv_upper:
	sub al,32			; subtract 32 to convert to uppercase
	jmp next			; done with this letter now so move onto next
conv_lower:
	add al,32			; add 32 to convert to lowercase
	jmp next			; done with this letter now so move onto next
next:
	mov [rdi], al		; override old letter with new, changed case latter
	add rdi,1			; add 1 to our counter
	sub rsi,1			; subtract 1 from the overall length of our text
	cmp rsi,0			; check to see if we have reached the end of out text
	je end				; if so, jump to end
	jmp loop			; otherwise, keep looping
end:
	mov rax,1			; return 1
	mov rsp,rbp			; reset our stack
	pop rbp
	ret					; return to main
	

;;; Sample procedure that does a ROT47 encryption/decryption routine
;;; if char ascii code between 32 and 127 then it is printable
;;; and we rotate it 47 places either up or down to get wraparound
;;; if it is not in those bounds we leave it alone
;;;rot47:
;;;	push rbp
;;;	mov rbp,rsp
	
;;;loop:	mov al,[rdi]
;;;	cmp al,32
;;;	jle next		;<32 leave it alone
;;;	cmp al,127
;;;	jge next		;>127 leave it alone
;;;	cmp al,80		;move up or down?
;;;	jl add			;less than 80 move up
;;;	sub al,47		;otherwise move down
;;;	jmp next
;;;				;then move to next char 
;;;add:    add al,47
	
;;;next:   mov [rdi],al 		;put result back in memory
;;;	add rdi,1		;move to next char
;;;	sub rsi,1		;sub 1 from strenlen
;;;	cmp rsi,0		;at end of string?
;;;	je end			;yes then exit
;;;	jmp loop		;otherwise loop back 
;;;
;;;end:	xor rax,rax
;;;	mov rsp,rbp
;;;	pop rbp
;;;	ret
	
