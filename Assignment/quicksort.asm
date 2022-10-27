 .data
# defines testcase for quicksort
testcase1: .word 129, 10, 31, 44, 16, 3, 33, 34, 35, 44, 44, 25, 48, 16, 32, 37, 8, 33, 30, 6, 18, 26, 0, 37, 40, 30, 50, 32, 5, 41, 0, 32, 12, 33, 22, 14, 34, 1, 0, 41, 45, 8, 39, 27, 23, 45, 10, 50, 34, 47
testcase2: .word 39, 49, 2, 6, 46, 8, 18, 31, 3, 3, 21, 28, 24, 46, 16, 29, 9, 4, 8, 11, 3, 49, 23, 11, 34, 30, 48, 2, 5, 45, 8, 30, 14, 14, 0, 6, 33, 31, 16, 12, 20, 36, 3, 37, 8, 36, 44, 45, 9, 7
testcase3: .word 1010, 10, 25, 11, 15, 41, 15, 4, 20, 0, 11, 123, 35, 17, 20, 16, 48, 29, 8, 2, 28, 13, 17, 40, 3, 45, 40, 29, 40, 28, 12, 45, 46, 28, 5, 40, 24, 6, 42, 32, 29, 33, 45, 27, 11, 26, 38, 29, 25, 21
testcase4: .word -349, 95, 395, -277, 164, 241, -110, -64, -158, -1010, 66, -197, -52, 158, 2022, 88, -192, 344, -180, -201, -384, -422, 333, 488, -331, -7, 372, 37, 331, -106, 370, 482, -159, 265, -294, -495, 359, 448, 297, 53, -351, 212, 239, 449, 611, 53, 37, -118, 249, 357	
# message
aftersort: .asciiz "After sorting: "
indexOfpivots: .asciiz "Index of pivots: "
space: .asciiz " "

.text
.globl main
main:

# Print message
li	$v0, 4
la	$a0, indexOfpivots
syscall
# Store value to argument
la 	$t0, testcase1	# Address of array store, line to change testcase for quicksort

addi 	$a0, $t0, 0 	# Set argument 1 to the array.
addi 	$a1, $zero, 0 	# Set argument 2 to (low = 0)
addi 	$a2, $zero, 49	# Set argument 3 to (high = 49, last index in array)

jal	quicksort	# Call quicksort

# Print array after sort
li	$t1, 0
move	$t0, $a0	# Move array address to t0
# Print endline
li	$v0, 11		# Code = 11 to print character
li	$a0, 10		# Ascii = 10: endline
syscall
# Print message "After sorting: "
li	$v0, 4
la	$a0, aftersort
syscall

print_sort:
        	beq     $t1, 200, exit_print	# if (t1 == 200) break
        	lw      $s0, 0($t0)     	# Load arr[i] into s0
        	# Print integer
        	li      $v0, 1          	# Code = 1 to print int
        	addi    $a0, $s0, 0    	 	# Argument a0 = s0
       	 	syscall
        	addi    $t1, $t1, 4     	# i += 4
        	addi    $t0, $t0, 4    	 	# arr = arr + 4
        	# Print space
        	li      $v0, 4
        	la      $a0, space
        	syscall
        	j       print_sort
exit_print:

li $v0, 10 # exit()
syscall 

swap:	# Implement swap function
	sll	$t1, $a1, 2	# t1 = 4 * a1 = 4 * i
	sll	$t2, $a2, 2	# t2 = 4 * a2 = 4 * j
	add	$t1, $a0, $t1	# t1 = arr + 4i
	add	$t2, $a0, $t2	# t2 = arr + 4j
	ld	$s3, 0($t1)	# s3 = arr[i]
	ld	$s4, 0($t2)	# s4 = arr[j] = temp
	
	# swap two elements
	sw	$s3, 0($t2)	# arr[j] = arr[i]
	sw	$s4, 0($t1)	# arr[i] = temp
	jr 	$ra		# Jump back
endswap:

partition:	# Implement partion function

	addi 	$sp, $sp, -16	# Adjust stack for 4 items 

	sw 	$a0, 0($sp)	# Store a0
	sw 	$a1, 4($sp)	# Store a1
	sw 	$a2, 8($sp)	# sStore a2
	sw 	$ra, 12($sp)	# Store return address
	
	move	$s1, $a1	# s1 = start		
	move	$s2, $a2	# s2 = end
	
	sll	$t3, $s1, 2	# t3 = 4 * start
	add	$t3, $a0, $t3	# t3 = pivot = arr + start;
	lw	$t3, 0($t3)
	
	addi	$t4, $s1, 1	# t4 = index i = start + 1;
	add	$t5, $s2, $zero	# t5 = index j = end;
	
	while:
		bgt	$t4, $t5, endwhile
		search_ge: # Search for element greater than pivot
			# while ((i <= j) && (arr[i] <= pivot)) i++;
			sll	$t6, $t4, 2			# t6 = 4i
			add	$t6, $a0, $t6			# t6 = arr + i
			lw	$t6, 0($t6)			# t6 = arr[i]
			bgt	$t4, $t5, end_search_ge		# if (i > j) break
			bgt	$t6, $t3, end_search_ge		# if (arr[i] > pivot) break
			addi	$t4, $t4, 1			# else i++
			j	search_ge		
		end_search_ge:
		
		search_smaller:	# Search for element smaller than pivot
			# while ((i <= j) && (arr[j] > pivot))
			sll	$t7, $t5, 2			# t6 = 4j
			add	$t7, $a0, $t7			# t7 = arr + j
			lw	$t7, 0($t7)			# t7 = arr[i]
			bgt	$t4, $t5, end_search_smaller	# if (i > j) break
			ble	$t7, $t3, end_search_smaller	# if (arr[j] <= pivot) break
			subi	$t5, $t5, 1			# else j--
			j	search_smaller
		end_search_smaller:
			
		# swap(arr[i], arr[j])
		bgt	$t4, $t5, endwhile			# if (i > j) break
		add	$a1, $t4, $zero				# a1 = t4 = index i
		add	$a2, $t5, $zero				# a0 = t4 = index j
		jal 	swap
			
		j	while				
	endwhile:
			# swap(arr[j], pivot)
			lw	$a1, 4($sp)			# Load start from stack
			add	$a2, $t5, $zero			# a0 = t5 = index j
			jal 	swap
			
			# Print pivot index
			li	$v0, 1				# Code = 1 to print integer
			move	$a0, $a2
			syscall
			# Print space
			li	$v0, 4
			la	$a0, space
			syscall
			
			add	$v0, $a2, $zero			# Return j
			lw	$a0, 0($sp)			# Restore a0
			lw	$ra, 12($sp)			# Return address
			addi 	$sp, $sp, 16			# Pop 4 items from stack
			jr 	$ra				# Junp back to the caller
			
quicksort:		# Implement quicksort method
			addi 	$sp, $sp, -20			# Adjust stack for 5 items

			sw 	$a0, 0($sp)			# Array address
			sw 	$a1, 4($sp)			# Start
			sw 	$a2, 8($sp)			# End
			sw 	$ra, 12($sp)			# Return address
			sw	$s0, 16($sp)			# Pivot index
			
			bge  	$a1, $a2, endif			# If start >= end, endif

			jal 	partition			# Call partition 
			
			add	$s0, $v0, $zero			# s0 pivot index = v0 (pi)
			lw 	$a1, 4($sp)			# a1 = start
			addi 	$a2, $s0, -1			# a2 = pi -1
			jal 	quicksort			# Call quicksort
		
			addi 	$a1, $s0, 1			# a1 = pi + 1
			lw 	$a2, 8($sp)			# a2 = end
			jal 	quicksort			# Call quicksort
		endif:
 			lw	$a0, 0($sp)			# Restore a0
 			lw 	$a1, 4($sp)			# Restore a1
 			lw 	$a2, 8($sp)			# Restore a2
 			lw 	$ra, 12($sp)			# Restore return address
 			lw	$s0, 16($sp)
 			addi 	$sp, $sp, 20			# Pop 5 items from stack
 			jr 	$ra				# Junp back to the caller
