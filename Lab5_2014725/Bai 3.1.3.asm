.data 
	maxMessage:  .asciiz "\nGia tri lon nhat la: "
	minMessage: .asciiz "\nGia tri nho nhat la: "
	.align 4
	fArray: .space 80
	ZeroAsFloat: .float 0.0
	space: .asciiz " "
.text
	lwc1	$f10, ZeroAsFloat	# $f10 contain Zero as float
	#generate random floating pointer numbers and store into fArray
	li	$t0, 0			# index i
	
generate_fArray:
	li	$a0, 0
	li	$v0, 43			#service 43 is generate random float
	syscall
	
	beq	$t0, 80, exit_generate	# if index = 80 then exit
	s.s	$f0, fArray($t0)	# store f0 into fArray at index i
	addi	$t0, $t0, 4		# index++
	j	generate_fArray
exit_generate:
	# Print fArray to see these random numbers
	li	$t0, 0		# index i
print_fArray:
	beq	$t0, 80, exit_print	# if index = 80 then exit
	l.s	$f2, fArray($t0)	# f2 contains the value of fArray[i]
	addi	$t0, $t0, 4		# index++
	# Print fArray[i]
	li	$v0, 2			#service 2 is print float
	add.s	$f12, $f2, $f10		#f12 is argument
	syscall
	
	li	$v0, 4			#print space: " " 
	la	$a0, space
	syscall
	j	print_fArray
exit_print:
	li	$t0, 0			# index in our loop
	lwc1	$f1, fArray($zero)	# f1 = max = fArray[0]
	# find max
	jal max
	
	#find min		
	li	$t0, 0			# reset index value
	lwc1	$f2, fArray($zero)	# min = fArray[0]
	jal min
	
	# Display message
	li	$v0, 4
	la	$a0, maxMessage
	syscall
	# Print max
	li	$v0, 2
	add.s	$f12, $f1, $f10
	syscall
	
	# Display message
	li	$v0, 4
	la	$a0, minMessage
	syscall
	# Print max
	li	$v0, 2
	add.s	$f12, $f2, $f10
	syscall
	
	
	li	$v0, 10  #exit()
	syscall	
	
	#find max of fArray
max:
	addi	$t0, $t0, 4		# index++
	beq	$t0, 80, exit_find_max	# condition to exit find_max loop
	l.s	$f5, fArray($t0) 	# load fArray[i] and store in $f5
	c.lt.s	$f1, $f5		# max < fArray[i]? 1 : 0
	bc1f	max			# if false (max > fArray[i]) then jump to max label
	lwc1	$f1, fArray($t0)	# else max = fArray[i]
	j	max			
exit_find_max:
	jr	$ra	
	
	#find min of fArray
min:
	addi	$t0, $t0, 4		# index++
	beq	$t0, 80, exit_find_min	# condition to exit find_min loop
	l.s	$f5, fArray($t0) 	# load fArray[i] and store in $f5
	c.lt.s	$f2, $f5		# min < fArray[i]? 1 : 0
	bc1t	min			# if true (min < fArray[i]) then jump to min label
	lwc1	$f2, fArray($t0)	# else min = fArray[i]
	j	min			
exit_find_min:
	jr	$ra			

