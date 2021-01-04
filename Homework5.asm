# Homework 5
# Christy Jacob

.data
# memory to hold bmi
bmi: 			.float	0
# memory to hold height and weight
height:			.word   1
weight:			.word	1
# memory to hold name
name:			.space	20
# memory to hold bmi range values
underweightBMI:		.float	18.5
normalWeightBMI:	.float	25.0
overweightBMI:		.float	30.0
# memory to hold 703 multiplier
multiplier: 		.float	703.0
# memory to hold prompts
namePrompt:		.asciiz	"What is your name? "
heightPrompt:		.asciiz "Please enter your height in inches: "
weightPrompt:		.asciiz	"Now enter your weight in pounds (round to a whole number): "
# memory to hold messages we are printing
bmiMessage: 		.asciiz	", your bmi is: "
underweightMessage:	.asciiz	"\nThis is considered underweight. \n"
normalWeightMessage:	.asciiz	"\nThis is a normal weight. \n"
overweightMessage:	.asciiz	"\nThis is considered overweight. \n"
obeseMessage:		.asciiz "\nThis is considered obese. \n"

.text
main:
	# prompting for and taking in the name
	li	$v0, 4
	la	$a0, namePrompt
	syscall
	
	li	$v0, 8
	la	$a0, name
	li	$a1, 20
	syscall
	
	# prompting for and taking in height and weight and storing them in memory
	li	$v0, 4
	la	$a0, heightPrompt
	syscall
	
	li	$v0, 5
	syscall
	sw	$v0, height
	
	li	$v0, 4
	la	$a0, weightPrompt
	syscall
	
	li	$v0, 5
	syscall
	sw	$v0, weight
	
	# loading height and weight from memory
	lw	$t1, weight
	lw	$t2, height
	
	# moving height and weight to floating point registers for bmi calculations
	mtc1	$t1, $f0
	cvt.s.w	$f0, $f0
	
	mtc1	$t2, $f2
	cvt.s.w	$f2, $f2
	
	# calculating weight times 703 and storing it in $f0
	lwc1	$f16, multiplier
	mul.s	$f0, $f0, $f16	
	
	# calculating height squared and storing it in $f2
	mul.s	$f2, $f2, $f2
	
	# dividing weight times 703 by height squared and storing it in memory
	div.s	$f4, $f0, $f2
	swc1	$f4, bmi
	
	# printing message displaying the name, bmi message, and bmi
	li	$v0, 4
	la	$a0, name
	syscall
	
	li	$v0, 4
	la	$a0, bmiMessage
	syscall
	
	li	$v0, 2
	lwc1	$f12, bmi
	syscall
	
	# loading the bmi range values from memory
	lwc1	$f6, underweightBMI
	lwc1	$f8, normalWeightBMI
	lwc1	$f10, overweightBMI
	
	# branch statement for if bmi is less than 18.5, then underweight
	c.lt.s	$f4, $f6
	bc1t	underweightPrint
	
	# branch statement for else if bmi is less than 25, then normal weight
	c.lt.s	$f4, $f8
	bc1t	normalWeightPrint
	
	# branch statement for else if bmi is less than 30, then overweight
	c.lt.s	$f4, $f10
	bc1t	overweightPrint
	
	# if not less than 30, then obese
	bc1f	obesePrint
	
	# print that they are considered obese if above 30 and exit
obesePrint:
	li	$v0, 4
	la	$a0, obeseMessage
	syscall
	
	j exit
	
	# print that they are considered underweight if below 18.5 and exit
underweightPrint:

	li	$v0, 4
	la	$a0, underweightMessage
	syscall
	
	j exit
	
	# print that they are considered normal weight if below 25 and greater than or equal to 18.5 and exit
normalWeightPrint:

	li	$v0, 4
	la	$a0, normalWeightMessage
	syscall
	
	j exit
	
	# print that they are considered overweight if below 30 and greater than or equal to 25 and exit
overweightPrint:
	li	$v0, 4
	la	$a0, overweightMessage
	syscall

	# exit program
exit:
	li	$v0, 10
	syscall
