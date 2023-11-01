.data
	msg_1:		.asciiz "The given values are:\n"
	msg_2:		.asciiz "Sorted values:\n"
	comma:		.asciiz ","
	line_break:	.asciiz "\n"
	filename_1: 	.asciiz	"numbers.txt"	# Put the path of input txt file with
				.align	2	# directories separeted with double "\"
	filename_2: 	.asciiz	"sorted_numbers.txt"	# Path of the output txt file
				.align	2
	buffer:		.asciiz
				.space 20
	array:	.word
				.space 40
	
.text
	#Opening .txt
	li	$v0, 13
	la	$a0, filename_1
	li	$a1, 0	#0: read, 1: write
	li	$a2, 0	
	syscall
	move	$s0, $v0
	#Reading .txt
	li	$v0, 14
	move	$a0, $s0
	la	$a1, buffer
	li	$a2, 20
	syscall
	#Closing .txt
	li	$v0, 16
	move	$a0, $s0
	syscall
	#Print initial values
	li $v0, 4
	la $a0, msg_1
	syscall
	li	$v0, 4
	la	$a0, buffer
	syscall
	li $v0, 4
	la $a0, line_break
	syscall
#Converting each value from string to int and passing to array
	move	$t0, $zero
	move	$t3, $zero
	li	$t1, 20
loop:
	beq	$t0, $t1, Bubblesort
	lb	$t8, buffer($t0)
	move	$a0, $t8
	jal	converte
	move	$s1, $v0
	sw	$s1, array($t3)
	addi	$t0, $t0, 2
	addi	$t3, $t3, 4
	j loop
converte: 
#To convert to string to int you need to sub 48 (ASCII code)
	sub		$v0, $a0, 48
	jr		$ra

Bubblesort:
	move	$t0, $zero	#i = 0
	move	$t2, $zero	#j = 0
	move	$t6, $zero	#aux
	li	$t1, 40		#array.lenght
	li	$t8, 36 
	move	$t7, $t1
	fori:	
		beq	$t0, $t1, end_fori	#if i == array.lenght --> jump to end
		sub	$t7, $t8, $t0	# (array.lenght - i)
			forj:
				beq 	$t2, $t7, end_forj
				addi	$t3, $t2, 4	#j+4
				lw	$t4, array($t2)
				lw	$t5, array($t3)
				bgt	$t5, $t4, jump_change	#if the next number ir greater than the current number --> skip
				move	$t6, $t5		#else --> change the position of the numbers
				sw	$t4, array($t3)		
				sw	$t6, array($t2)
			jump_change:
				addi $t2, $t2, 4	# j = j + 4
				j forj
			end_forj:
				move	$t2, $zero	#reset j: j = 0
					
				
		
		addi	$t0, $t0, 4	#i = i + 4
		j fori
		
		
	end_fori:


#Converting each value from int to string and passing to buffer
	move	$t0, $zero
	move	$t3, $zero
	li	$t1, 20
loop_2:
	beq	$t0, $t1, end
	lw	$t8, array($t3)
	move	$a0, $t8
	jal	converte_2
	move	$s1, $v0
	sb	$s1, buffer($t0)
	addi	$t0, $t0, 2
	addi	$t3, $t3, 4
	j loop_2
converte_2: 
#To convert to int to string you need to add 48 (ASCII code)
	addi		$v0, $a0, 48
	jr		$ra
end:

#Print final values
	li $v0, 4
	la $a0, msg_2
	syscall
	li	$v0, 4
	la	$a0, buffer
	syscall

#Opening .txt
	li	$v0, 13
	la	$a0, filename_2
	li	$a1, 1	#0: read, 1: write
	li	$a2, 0	
	syscall
	move	$s0, $v0
#Writing .txt
	li	$v0, 15
	move	$a0, $s0
	la	$a1, buffer
	li	$a2, 20
	syscall
#Closing .txt
	li	$v0, 16
	move	$a0, $s0
	syscall
