TITLE Proj3_maesz     (Proj3_maesz.asm)

; Author: Zachary Maes
; Last Modified: July 17, 2022
; OSU email address: maesz@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  3               Due Date: July 17, 2022
; Description: 
; This program does the following:
;
;	-Display the program title and programmer’s name.
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
;		f.) a parting message (with the user’s name)

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

; (insert variable definitions here)

.code
main PROC

; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
