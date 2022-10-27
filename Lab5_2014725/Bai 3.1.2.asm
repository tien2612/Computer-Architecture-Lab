.data
cMessage: .asciiz "\nChu vi cua hinh tron la: "
sMessage: .asciiz "\nDien tich cua hinh tron la: "
message: .asciiz "Nhap vao ban kinh hinh tron : "
Error: .asciiz "\nVui long nhap ban kinh la mot so khong am"
pi: .float 3.14
TwoAsFloat: .float 2.0
ZeroAsFloat: .float 0.0
.text
	#Display the message
	li	$v0, 4
	la	$a0, message
	syscall
	
	#Enter user's floating point radius
	li	$v0, 6
	syscall

	#Store pi, zero and two value into register
	lwc1	$f1, pi
	lwc1 	$f2, TwoAsFloat
	lwc1	$f10, ZeroAsFloat
		
	#check if user's radius is negative
	c.lt.s	$f0, $f10 		#flag = 1 if radius < 0
	bc1t	exit			#branch if true
	#Caculate circumference = 2pi.R
	mul.s	$f4, $f1, $f0		#pi * R
	mul.s	$f4, $f4, $f2		#2pi * R
	
	#Caculate Area
	mul.s	$f5, $f1, $f0		#pi * R
	mul.s	$f5, $f5, $f0		#pi * R * R
	
	#Display message and print result
	li	$v0, 4
	la	$a0, cMessage
	syscall
	#Print Circumference of cicle
	li	$v0, 2
	add.s	$f12, $f4, $f10
	syscall
	
	li	$v0, 4
	la	$a0, sMessage
	syscall
	#print Area of cicle
	li	$v0, 2
	add.s	$f12, $f5, $f10
	syscall
	
	li	$v0, 10		#exit()
	syscall
exit:
	#Display error message
	li	$v0, 4
	la	$a0, Error
	syscall
	
	
