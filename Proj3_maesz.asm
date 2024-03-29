TITLE Project Three: Data Validation, Looping, Constants     (Proj3_maesz.asm)

; Author: Zachary Maes
; Last Modified: July 17, 2022
; OSU email address: maesz@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  3               Due Date: July 17, 2022
; Description: 
; This program does the following:
;
;	-Display the program title and programmer�s name.
;	-Get the user's name, and greet the user.
;	-Display instructions for the user.
;	-Repeatedly prompt the user to enter a number.
;		a.) Validate the user input to be in [-200, -100] or [-50, -1] (inclusive).
;		b.) Notify the user of any invalid negative numbers (negative, but not in the ranges specified)
;		c.) Count and accumulate the valid user numbers until a non-negative number is entered. Detect this using the SIGN flag.
;				(The non-negative number and any numbers not in the specified ranges are discarded.)

;	-Calculate the (rounded integer) average of the valid numbers and store in a variable.
;	-Display:
;		a.) the count of validated numbers entered
;			NOTE: if no valid numbers were entered, display a special message and skip to (f)
;		b.) the sum of valid numbers
;		c.) the maximum (closest to 0) valid user value entered
;		d.) the minimum (farthest from 0) valid user value entered
;		e.) the average, rounded to the nearest integer
;			i.) -20.01 rounds to -20
;			ii.) -20.5 rounds to -20
;			iii.) -20.51 rounds to -21
;			iv.) -20.99 rounds to -21
;		f.) a parting message (with the user�s name)

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

; (insert variable definitions here)

intro_1 BYTE	"Well howdy there Partner! Welcome to the Good Ol' Gator Country Number Round Up! I'm Zac Maes and I'll be y'alls airboat captain today.", 0
intro_2 BYTE	"Please keep your hands, feet, flip flops, and crocs inside the airboat at all times. This programs fixin' to do a little bit of Everglades Croc-ulus.", 0
intro_3 BYTE	"We will be accumulating user-input negative integers between the specified bounds, then displaying statistics of the input values including minimum, maximum, and average values, total sum, andtotal number of valid inputs.", 0

prompt_1 BYTE	"Hey! You there! What is your name? Please enter it here: ", 0	; data for getting the user's name

greeting_start BYTE	"Well ya darn tootin! I got a cousin up in Loxahatchee named ", 0	; first part of greeting.
greeting_end   BYTE	", nice to meet you!", 0	; second part of greeting, comes after user_name

input_buffer   BYTE 21 DUP(0)					; input buffer holds buffer for ReadString
byte_count	   DWORD ?							; holds counter for ReadString

instruct_1 BYTE	"Instructions:", 0																		; data for instructions.
instruct_2 BYTE	"Please enter numbers in [-200, -100] or [-50, -1].", 0									; data for instructions.
instruct_3 BYTE	"Enter a non-negative number when you getter done to see the croc-ulated results.", 0	; data for instructions.

num_prompt BYTE	"Enter Number: ", 0

invalid_num BYTE "Number Invalid!", 0

valid_count SDWORD	?	; count of valid numbers
valid_sum	SDWORD	?	; value of the sum of all valid numbers
valid_max SDWORD	?	; the maximum valid number
valid_min SDWORD	?	; the minimum valid number
valid_average SDWORD	?	; average







return_confirmation_1 BYTE "You entered ", 0
; surround the ammount of numbers entered with these return statements
return_confirmation_2 BYTE " valid numbers.", 0		; "You entered 3 valid numbers."


result_0 BYTE "The maximum valid number is ", 0 ; The maximum valid number is -15
result_1 BYTE "The minimum valid number is ", 0 ; The minimum valid number is -110
result_2 BYTE "The sum of your valid numbers is ", 0 ; The sum of your valid numbers is -161
result_3 BYTE "The rounded average is ", 0 ; The rounded average is -54


good_bye_1 BYTE	", we hope you enjoyed your fresh freshwater integers!", 0	; parting message 
good_bye_2 BYTE	"Ill tell you what, I reckon we better head back to the dock over yonder before them no-see-ums come out and start bitin'.", 0	; parting message.
good_bye_3 BYTE	"Well thats all she wrote yall, yall come back now.", 0	; parting message.


.code
main PROC

; (insert executable instructions here)

; -------------INTRODUCTION---------------------
mov EDX, OFFSET intro_1
call WriteString
call CrLf
call CrLf

mov EDX, OFFSET intro_2
call WriteString
call CrLf
call CrLf

mov EDX, OFFSET intro_3
call WriteString
call CrLf
call CrLf

; -------------PROMPT USER FOR NAME---------------------

mov EDX, OFFSET prompt_1
call WriteString
call CrLf
mov EDX, OFFSET input_buffer	; point to the buffer
mov ECX, SIZEOF input_buffer	; specify max characters
call ReadString			; EDX is addres of string
mov	byte_count, EAX		; number of characters saved in byte_count


; -------------Greet USER---------------------

call CrLf
mov EDX, OFFSET greeting_start		; string defined above
call WriteString

mov EDX, OFFSET input_buffer		; entererd name is read from input_buffer
call WriteString

mov EDX, OFFSET greeting_end	; punctuation to end the greeting immediatly after user_name is written to the console.
call WriteString
call CrLf
call CrLf


; -----------INSTRUCTIONS FOR USER------------------
mov EDX, OFFSET instruct_1		; string defined above
call WriteString
call CrLf

mov EDX, OFFSET instruct_2		; string defined above
call WriteString
call CrLf

mov EDX, OFFSET instruct_3		; string defined above
call WriteString
call CrLf
call CrLf


; ------ INITIALIZE TO 0 so that I can Add to them
mov  valid_count, 0
mov  valid_sum, 0

_getNum:
	mov EDX, OFFSET num_prompt		; string defined above
	call WriteString
	call ReadInt
	cmp  EAX, 0
	JGE  _positiveNumCheck				; COULD NOT FIGURE OUT JNE with sign flag for the life of me!!!!!!
	JL	_isNegNum

; ---------INVALID NUMBER ERROR Message
_invalidNum:
	mov EDX, OFFSET invalid_num		; string defined above
	call WriteString
	call CrLf
	JMP  _getNum

_isNegNum:
	cmp EAX, -200
	JL	_invalidNum
	JGE _twoHundoUp

_twoHundoUp:
	cmp EAX, -100
	JLE _lowerBound
	JG	_aboveOneHundo

_aboveOneHundo:
	cmp EAX, -50
	JL	_invalidNum
	JGE _aboveFiftyIncl

_aboveFiftyIncl:
	cmp EAX, -1
	JLE _upperBound


_lowerBound:	; If we made it here, the number is between -200 and -100 inclusive
	ADD  valid_sum, EAX
	jmp  _maxMinify

_upperBound:	; if we made it here, the number is between -50 and -1 inclusive
	ADD  valid_sum, EAX
	jMP  _maxMinify

_positiveNumCheck:	; land here when done with a positve num
	cmp  valid_count, 0
	JLE   _invalidNum
	JG   _endValidation


_maxMinify:		; assigns max or min
	cmp  valid_count, 0
	JLE   _assignToBothMaxMin
	JG	  _checkMax
	

_assignToBothMaxMin:
	mov  valid_max, EAX
	mov  valid_min, EAX
	ADD  valid_count, 1
	JMP  _getNum

_checkMax:
	cmp  EAX, valid_max
	JL   _checkMin
	mov  valid_max, EAX
	ADD  valid_count, 1
	JMP  _getNum

_checkMin:
	cmp  EAX, valid_min
	JG   _validNotMinOrMax
	mov valid_min, EAX
	ADD  valid_count, 1
	JMP  _getNum

_validNotMinOrMax:
	ADD  valid_count, 1
	JMP  _getNum
	
	

_endValidation:
	jmp  _calculateAverage

_calculateAverage:
	; ???? figure out rounding with IDIV


	jmp  _returnConfirmation

_returnConfirmation:
	mov EDX, OFFSET return_confirmation_1		; string defined above
	call WriteString
	
	mov EAX, valid_count
	call WriteInt

	mov EDX, OFFSET return_confirmation_2		; string defined above
	call WriteString
	call CrLf

;	-Calculate the (rounded integer) average of the valid numbers and store in a variable.
;	-Display:
;		a.) the count of validated numbers entered
;			NOTE: if no valid numbers were entered, display a special message and skip to (f)
;		b.) the sum of valid numbers
;		c.) the maximum (closest to 0) valid user value entered
;		d.) the minimum (farthest from 0) valid user value entered
;		e.) the average, rounded to the nearest integer
;			i.) -20.01 rounds to -20
;			ii.) -20.5 rounds to -20
;			iii.) -20.51 rounds to -21
;			iv.) -20.99 rounds to -21
;		f.) a parting message (with the user�s name)




; ----------FINAL RETURN------------------
mov EDX, OFFSET result_0		; string defined above
call WriteString

mov EAX, valid_max
call WriteInt
call CrLf

mov EDX, OFFSET result_1		; string defined above
call WriteString

mov EAX, valid_min
call WriteInt
call CrLf

mov EDX, OFFSET result_2		; string defined above
call WriteString

mov EAX, valid_count
call WriteInt
call CrLf

mov EDX, OFFSET result_3		; string defined above
call WriteString

mov EAX, valid_average
call WriteInt
call CrLf
call CrLf



;---------Goood bye----------------------

mov EDX, OFFSET input_buffer		; string defined above
call WriteString

mov EDX, OFFSET good_bye_1		; string defined above
call WriteString
call CrLf

mov EDX, OFFSET good_bye_2		; string defined above
call WriteString
call CrLf

mov EDX, OFFSET good_bye_3		; string defined above
call WriteString
call CrLf



	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
