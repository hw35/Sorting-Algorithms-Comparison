.text
	add $t8, $zero, $zero	# Clear the display to 0
	add $s0, $zero, $zero 	# determines if is first input (=0) or not (=1)
	add $s1, $zero, $zero	# first operand
	add $s2, $zero, $zero	# second operand 
	add $s3, $zero, $zero 	# multiplication result
	add $s4, $zero, $zero	# divisor backup
	add $s5, $zero, $zero	# division result
	
	addi $t4, $t4, 10	# + button
	addi $t5, $t5, 11	# - button
	addi $t6, $t6, 12	# * button
	addi $t7, $t7, 13	# / button
	addi $s6, $s6, 14	# = button
	addi $s7, $s7, 15	# C button

# Start Display
# Input in start always stored to $s1 (first operand)
start:	
	beq  $t9, $zero, start	# If $t9 is 0, go back to start
	
	# store curr input into $t0
	sll $t0, $t9, 1	
	srl $t0, $t0, 1	
	
	beq $t0, $t4, additionSet	# + operator
	beq $t0, $t5, subtractSet	# - operator
	beq $t0, $t6, multSet		# * operator
	beq $t0, $t7, divisionSet	# / operator
	beq $t0, $s6, equals		# = operator
	beq $t0, $s7, clear		# C operator
	
	# LCD display first single numerical input on screen
	beq $s0, $zero, singleNum
	
	# after first number, any following number is concatenated to display
	sll $t1, $s1, 1
	sll $t2, $s1, 3
	add $s1, $t1, $t2
	add $s1, $s1, $t0
	
	add $t8, $zero, $s1 	# s1 is final display num
	add  $t9, $zero, $zero
	j start

# goes here when only when first operator after input number is =
equals:
	add $t8, $s1, $zero	# display first/current input
	add $t9, $zero, $zero	# reset input
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	add $s1, $zero, $zero	# reset s1
	add $s2, $zero, $zero	# reset s2
	j start
	
clear:
	add $t0, $zero, $zero
	add $t8, $zero, $zero
	add $t9, $zero, $zero	
	add $s0, $zero, $zero 		
	add $s1, $zero, $zero	
	add $s2, $zero, $zero	
	add $s3, $zero, $zero
	add $s4, $zero, $zero	
	add $s5, $zero, $zero	
	j start

# LCD displays first number inputted
singleNum:
	add $s1, $t0, $zero	# store first ever number in $s1 for future increment use
	add $t8, $zero, $t0	# display this single number 
	add  $t9, $zero, $zero	# clear input
	addi $s0, $s0, 1	# set counter to 1 because no longer first ever input
	j start	
	
	
# Rest of these operations all originally store input in $s2 (second operand)
# Input will be combined into $s1 (first operand) at times for chain operations


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ADDITION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# initializes addition variables
additionSet:
	add $t9, $zero, $zero	# reset input
	beq $s0, $zero, start	# if + is first ever input, ignore it
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	j addition	

# Display second operand (b in a + b) inputted for addition			
addition: 	
	beq  $t9, $zero, addition
	
	sll $t0, $t9, 1	
	srl $t0, $t0, 1
	
	# allow chain operations
	beq $t0, $t4, redunAdd		# Ex: a + b ++ c 
	beq $t0, $t5, changeToSub	# Ex: a + b +- c
	beq $t0, $t6, changeToMult	# Ex: a + b * c  OR  a +* c
	beq $t0, $t7, changeToDiv	# Ex: a + b / c  OR  a +/ c
	
	# return final result of single addition operation
	beq $t0, $s6, equalsAdd		# Ex: a + b =
	
	# clear display
	beq $t0, $s7, clear
	
	# LCD display first single numerical input on screen
	beq $s0, $zero, SNadd
	
	# Concatenate rest of input numbers
	sll $t1, $s2, 1
	sll $t2, $s2, 3
	add $s2, $t1, $t2
	add $s2, $s2, $t0
	add $t8, $zero, $s2 	# $s2 is final display num
	add $t9, $zero, $zero	# clear input 
	
	j addition

# Allow chain addition
redunAdd:
	add $s1, $s1, $s2	# sum both operands into $s1
	add $t9, $zero, $zero	# reset input
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	j addition

# Display single addition operation
equalsAdd:
	add $t8, $s1, $s2	# display input 1 + input 2
	add $t9, $zero, $zero	# reset input
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	add $s1, $zero, $zero	# reset s1
	add $s2, $zero, $zero	# reset s2
	j start			# Exit to default

# Same as singleNum but for Addition display
SNadd:	
	add $s2, $t0, $zero	
	add $t8, $zero, $t0	
	add $t9, $zero, $zero
	addi $s0, $s0, 1
	j addition
	
	

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUBTRACTION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# initializes subtraction variables
subtractSet:
	beq $s0, $zero, negSubtractSet	# if first ever input is -, make number afterwards negative
	add $t9, $zero, $zero		# reset input
	add $s0, $zero, $zero 		# reset counter
	add $t0, $zero, $zero		# reset curVal
	j subtraction

# any commands with "neg" in it means it belongs to the operations starting with a negative number	Ex: (-a)* b 
# reset variables before storing
negSubtractSet:
	add $t9, $zero, $zero	# reset input
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	j negSubtract

# Display second operand inputted for subtraction when first operand is negative
negSubtract:
	beq  $t9, $zero, negSubtract	

	sll $t0, $t9, 1	
	srl $t0, $t0, 1	
	
	beq $t0, $t4, additionSet	# Ex: -+a or -a+b
	beq $t0, $t5, redunNeg		# Ex: -a-b or --a
	beq $t0, $t6, multSet		# Ex: -a * b  or  -*a
	beq $t0, $t7, negDivSet		# Ex: -a / b  or  -/a
	beq $t0, $s6, equals		# Ex: -a = 
	beq $t0, $s7, clear
	
	beq $s0, $zero, singleNeg	
	
	# begin value $s1 is negative, so we concatenate negative too
	sll $t1, $s1, 1
	sll $t2, $s1, 3
	add $s1, $t1, $t2	
	
	# $t0 is positive, make it negative before summing with $s1
	# don't do +1 yet because need to "nor" $s1 again for display (+1 will cancel)
	nor $t0, $t0, $zero	
	
	add $s1, $s1, $t0	# sum
	nor $t8, $zero, $s1 	# make sum positive for display
	addi $s1, $s1, 1	# store final sum as negative
	add  $t9, $zero, $zero
	j negSubtract

# same idea as singleNumber but the begin value is now negative	(for operand 1)
singleNeg:
	nor $s1, $t0, $zero	# Two's complement to make negative
	addi $s1, $s1, 1
	add $t8, $zero, $t0	# display negative number
	add  $t9, $zero, $zero
	addi $s0, $s0, 1	
	j negSubtract

# two scenarios of redundance
redunNeg:
	beq $s0, $zero, redun	# --a 
	add $t9, $zero, $zero	
	j subtraction		# -a - b (go to subtraction to perform subtract b)

# ignore second negative sign and reset to -a
redun:
	add $t9, $zero, $zero
	j negSubtract

# ~~ end of operations with operand 1 as negative ~~
	
# Display second operand inputted for subtraction								
subtraction:
	beq  $t9, $zero, subtraction
	
	#beq $t0, $s7, clear
	
	# store curr input into $t0
	sll $t0, $t9, 1	
	srl $t0, $t0, 1
	
	beq $t0, $t5, redunSub
	beq $t0, $t4, changeToAdd
	beq $t0, $t6, changeToMult
	beq $t0, $t7, changeToDiv
	beq $t0, $s6, equalsSub
	beq $t0, $s7, clear
	
	# LCD display single number on screen
	beq $s0, $zero, SNsub
	
	# else mult last num by $t4 then + curr num to display
	sll $t1, $s2, 1
	sll $t2, $s2, 3
	add $s2, $t1, $t2
	add $s2, $s2, $t0
	nor $s2, $s2, $zero
	nor $t8, $s2, $zero	# s2 is final display num
	addi $s2, $s2, 1
	add $t9, $zero, $zero
	
	j subtraction								

# singleNumber but to set negative (for operand 2)	
SNsub:	
	nor $s2, $t0, $zero	# store first ever number in $s1 for future increment use
	addi $s2, $s2, 1
	add $t8, $zero, $t0
	add $t9, $zero, $zero
	addi $s0, $zero, 1	# set counter to 1, will increment next time around
	j subtraction

# a - b - c
redunSub:
	add $s1, $s1, $s2	# sum first 2 inputs into $s1
	add $t9, $zero, $zero	# reset input
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	j subtraction
	

# single subtraction  Ex: a - b =
equalsSub:
	add $t8, $s1, $s2
	add $t9, $zero, $zero	# reset input
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	add $s1, $zero, $zero	# reset s1
	add $s2, $zero, $zero	# reset s2
	j start

# ~~~~~~~~~~~~~~~~~~~~
# following labels are shared by Addition and Subtraction
# they each change the current operator to whatever the operator is in title 

# a -+ b 
changeToAdd:
	add $s1, $s2, $s1
	addi $s0, $zero, 1
	j additionSet
	
# a +- b
changeToSub:
	add $s1, $s2, $s1
	addi $s0, $zero, 1
	j subtractSet
	
# a +* b or a -* b
changeToMult:
	add $s1, $s2, $s1
	addi $s0, $zero, 1
	j multSet	
	
# a +/ b or a -/ b
changeToDiv:
	add $s1, $s2, $s1
	addi $s0, $zero, 1
	blt $s1, $zero, negDivSet
	j divisionSet



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MULTIPLICATION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# initializes multiplication variables
multSet:
	add $t9, $zero, $zero	# reset input
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	add $s3, $zero, $zero 	# reset s3 (mult result)
	j multiplication

# Display second operand inputted for multiplication 	
multiplication:
	beq  $t9, $zero, multiplication
	
	sll $t0, $t9, 1	
	srl $t0, $t0, 1
	
	beq $t0, $t4, multCASet		# "mult change to add setter"	Ex: a * b + c  or  a *+ c
	beq $t0, $t5, multCSSet		# "mult change to sub setter"	Ex: a * b - c  or  a *- c
	beq $t0, $t6, multRedun		# chain multiplication		Ex: a * b * c  or  a ** c
	beq $t0, $t7, multCDSet		# "mult change to div setter"	Ex: a * b / c  or  a */ c
	beq $t0, $s6, multLoop		# single multiplication		Ex: a * b =
	beq $t0, $s7, clear
	
	beq $s0, $zero, SNmult		
	
	# concant
	sll $t1, $s2, 1
	sll $t2, $s2, 3
	add $s2, $t1, $t2
	add $s2, $s2, $t0
	add $t8, $zero, $s2 	
	add $t9, $zero, $zero
	
	j multiplication

# same as singleNum but for multiplication
SNmult:	
	add $s2, $t0, $zero
	add $t8, $zero, $t0
	add $t9, $zero, $zero
	addi $s0, $s0, 1
	j multiplication

# mult and add, two cases
multCASet:
	# a *+	b	if multiplicand DNE (b in this case has not been inputted), change sign immediately
	blez $s2, multToAdd	
	
	# a * b + c	else calculate curr val (a*b) before changing to add
	# code from lab03
	multLoop1:		
		beq $s2, $zero, multChangeAdd	# when finished computing, change next operation sign to +
		andi $t3, $s2, 1		# set $t3 = LSB of multiplier
		beq $t3, $zero, zeroShift1	# if LSB = 0, then shift left logical of multiplicand without adding
		add $s3, $s3, $s1 		# add current multiplicand to result
		
		sll $s1, $s1, 1			# shift multiplicand left	
		srl $s2, $s2, 1			# index to next LSB in multiplier
		j multLoop1
	
	zeroShift1:
		sll $s1, $s1, 1			# shift
		srl $s2, $s2, 1			# index to next LSB in multiplier
		j multLoop1
	
	# ignore * and go to addition 	
	multToAdd:
		addi $s0, $zero, 1	# not first ever input b/c a *+ 
		j additionSet
	
	# store mult result in $s1 and go to addition
	multChangeAdd:
		add $s1, $s3, $zero
		addi $s0, $zero, 1
		j additionSet
	
# mult and sub, same code as "mult and add" but jump to subtraction instead	
multCSSet:
	blez $s2, multToSub
	multLoop2:
		beq $s2, $zero, multChangeSub
		andi $t3, $s2, 1
		beq $t3, $zero, zeroShift2	
		add $s3, $s3, $s1
		sll $s1, $s1, 1
		srl $s2, $s2, 1		
		j multLoop2	
	zeroShift2:
		sll $s1, $s1, 1		
		srl $s2, $s2, 1		
		j multLoop2	
	multToSub:
		addi $s0, $zero, 1
		j subtractSet	
	multChangeSub:
		add $s1, $s3, $zero
		addi $s0, $zero, 1
		j subtractSet

# mult and div, same code as "mult and add" but jump to division instead	
multCDSet:
	blez $s2, multToDiv	
	multLoop3:
		beq $s2, $zero, multChangeDiv
		andi $t3, $s2, 1
		beq $t3, $zero, zeroShift3	
		add $s3, $s3, $s1 			
		sll $s1, $s1, 1		
		srl $s2, $s2, 1		
		j multLoop3	
	zeroShift3:
		sll $s1, $s1, 1		
		srl $s2, $s2, 1	
		j multLoop3	
	multToDiv:
		addi $s0, $zero, 1
		j divisionSet		
	multChangeDiv:
		add $s1, $s3, $zero
		addi $s0, $zero, 1
		blt $s1, $zero, negDivSet
		j divisionSet
		
# same as "mult and add" but jump back to multiplication instead
multRedun:
	blez $s2, multToMult		
	multLoopRedun:
		beq $s2, $zero, redunMult	
		andi $t3, $s2, 1		
		beq $t3, $zero, zeroShiftRedun	
		add $s3, $s3, $s1 		
		sll $s1, $s1, 1		
		srl $s2, $s2, 1		
		j multLoopRedun
	zeroShiftRedun:
		sll $s1, $s1, 1		
		srl $s2, $s2, 1	
		j multLoopRedun
	redunMult:
		add $s1, $s3, $zero
		j multSet
	multToMult:
		addi $s0, $s0, 1
		j multSet

# single multiplication operation, same multLoop code as before
multLoop:
	beqz, $s2, multDone
	andi $t3, $s2, 1	
	beqz $t3, zeroShift	
	add $s3, $s3, $s1 	
	sll $s1, $s1, 1		
	srl $s2, $s2, 1	
	j multLoop
	
	zeroShift:
	sll $s1, $s1, 1		
	srl $s2, $s2, 1		
	j multLoop
				
	multDone:
		add $t8, $s3, $zero	# display product on LCD
		add $t9, $zero, $zero	# reset input
		add $s0, $zero, $zero 	# reset counter
		add $t0, $zero, $zero	# reset curVal
		add $s1, $zero, $zero	# reset s1
		add $s2, $zero, $zero	# reset s2
		add $s3, $zero, $zero	# reset s3
		j start			# Exit



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DIVISION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

# initializes division variables
divisionSet:
	add $t9, $zero, $zero	# reset input
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	add $s4, $zero, $zero 	# reset s4
	j division

# Display second operand inputted for division 
division:
	beq  $t9, $zero, division

	sll $t0, $t9, 1	
	srl $t0, $t0, 1
	
	beq $t0, $t4, divCASet		# Ex: a / b + c  or  a /+ b
	beq $t0, $t5, divCSSet		# Ex: a / b - c  or  a /- b
	beq $t0, $t6, divCMSet		# Ex: a / b * c  or  a /* c
	beq $t0, $t7, divLoopRedun 	# Ex: a / b / c  or  a // b
	
	beq $t0, $s6, divBackup		# single division	Ex: a / b =
	beq $t0, $s7, clear
	
	beq $s0, $zero, SNdiv
	
	sll $t1, $s2, 1
	sll $t2, $s2, 3
	add $s2, $t1, $t2
	add $s2, $s2, $t0
	add $t8, $zero, $s2 	
	add $t9, $zero, $zero
	
	j division

# singleNumber but for division
SNdiv:	
	add $s2, $t0, $zero	
	add $t8, $zero, $t0
	add $t9, $zero, $zero
	addi $s0, $s0, 1
	j division

# single division operation	Ex: a / b =
divBackup:
	add $s4, $s2, $zero		# store a copy of divisor in $s4 to alternate
	divLoop:
		beq $s4, $zero, start	# if divisor is 0, quit to start (can't divide by 0)
		blt $s1, $s4, divDone	# if divisor > dividend, done (not divisible anymore)
		
		addi $s5, $s5, 1	# else, is divisible, increment result $s5, since every time it's divisible, divisibility++
		add $s4, $s4, $s2	# increase current divisor by original divisor to check divisibility + 1	

		j divLoop
	divDone:
		add $t8, $s5, $zero	# display quotient
		add $t9, $zero, $zero	# reset input
		add $s0, $zero, $zero 	# reset counter
		add $t0, $zero, $zero	# reset curVal
		add $s1, $zero, $zero	# reset s1
		add $s2, $zero, $zero	# reset s2
		add $s4, $zero, $zero	# reset backup
		add $s5, $zero, $zero	# reset result
		j start

# following CA, CS, CM, Redun are same structure with ones in multiplication earlier

# div and add
divCASet:
	# if divisor DNE, change to add immediately
	blez $s2, divToAdd	
	
	# else calculate curr val first before changing to add
	# see details of divLoop
	divLoop1:
	add $s4, $s2, $zero
	Loop1:
		beq $s4, $zero, start
		blt $s1, $s4, divChangeAdd	
		add $s4, $s4, $s2
		addi $s5, $s5, 1	
		j Loop1		
	# ignore division sign and go to addition	Ex: a /+ b
	divToAdd:
		addi $s0, $zero, 1
		j additionSet	
	# perform division and then go to addition	Ex: a / b + c
	divChangeAdd:
		add $s1, $s5, $zero
		addi $s0, $zero, 1
		j additionSet

# div and sub
divCSSet:
	blez $s2, divToSub	
	divLoop2:
		add $s4, $s2, $zero
		Loop2:
			beq $s4, $zero, start
			blt $s1, $s4, divChangeSub
			add $s4, $s4, $s2
			addi $s5, $s5, 1	
			j Loop2		
	divToSub:
		addi $s0, $zero, 1
		j subtractSet
	divChangeSub:
		add $s1, $s5, $zero
		addi $s0, $zero, 1
		j subtractSet

# div and mult
divCMSet:
	blez $s2, divToMult	
	divLoop3:
		add $s4, $s2, $zero
		Loop3:
			beq $s4, $zero, start
			blt $s1, $s4, divChangeMult		
			add $s4, $s4, $s2
			addi $s5, $s5, 1	
			j Loop3		
	divToMult:
		addi $s0, $zero, 1
		j multSet
	divChangeMult:
		add $s1, $s5, $zero
		addi $s0, $zero, 1
		j multSet

# a / b / c
divLoopRedun:
	add $s4, $s2, $zero		
	LoopRedun:
		beq $s4, $zero, start	
		blt $s1, $s4, redunDiv			
		addi $s5, $s5, 1	
		add $s4, $s4, $s2			
		j LoopRedun	
	redunDiv:
		add $s1, $s5, $zero	# store quotient to $s1
		add $t9, $zero, $zero	# reset input
		add $s0, $zero, $zero 	# reset counter
		add $t0, $zero, $zero	# reset curVal
		add $s4, $zero, $zero	# reset backup
		add $s5, $zero, $zero	# reset result
		j division		

# following "neg" operations address division when the dividend is negative	Ex: (-a) / b

# initializes division variables for negative first operand
negDivSet:
	add $t9, $zero, $zero	# reset input
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	
	j negDivision

# Display second operand inputted for division with a negative first operand
negDivision:
	beq  $t9, $zero, negDivision
	
	sll $t0, $t9, 1	
	srl $t0, $t0, 1
	
	beq $t0, $t4, divCASet
	beq $t0, $t5, divCSSet
	beq $t0, $t6, divCMSet
	beq $t0, $t7, negDivLoopRedun	
	
	beq $t0, $s6, equalsNegDiv
	beq $t0, $s7, clear
	
	beq $s0, $zero, SNdivNeg
	
	sll $t1, $s2, 1
	sll $t2, $s2, 3
	add $s2, $t1, $t2
	add $s2, $s2, $t0
	add $t8, $zero, $s2 	
	add $t9, $zero, $zero
	
	j negDivision

# simpleNum but for negative dividend			
SNdivNeg:	
	add $s2, $t0, $zero	
	add $t8, $zero, $t0
	add $t9, $zero, $zero
	addi $s0, $zero, 1	
	j negDivision

# single operation	Ex: (-a) / b =			
equalsNegDiv:
	nor $s1, $s1, $zero	# make dividend $s1 positive for division loop
	addi $s1, $s1, 1
	
	add $s4, $s2, $zero	# copy of divisor
	
	# called negDivLoop but dividend and divisor are both positive in here
	# same code as divLoop
	negDivLoop:
		beq $s4, $zero, start
		blt $s1, $s4, negResult	
		add $s4, $s4, $s2
		addi $s5, $s5, 1	
		j negDivLoop
	negResult:
	nor $s5, $s5, $zero	# Two's complement to make result negative for display
	addi $t8, $s5, 1	# display $s5
	add $t9, $zero, $zero	# reset input
	add $s0, $zero, $zero 	# reset counter
	add $t0, $zero, $zero	# reset curVal
	add $s1, $zero, $zero	# reset s1
	add $s2, $zero, $zero	# reset s2
	add $s4, $zero, $zero	# reset backup
	add $s5, $zero, $zero	# reset result
	j start

# (-a) / b / c
negDivLoopRedun:
	nor $s1, $s1, $zero	
	addi $s1, $s1, 1
	add $s4, $s2, $zero		
	LoopRedun1:
		beq $s4, $zero, start	
		blt $s1, $s4, redunDiv1			
		addi $s5, $s5, 1	
		add $s4, $s4, $s2			
		j LoopRedun1	
	redunDiv1:
		nor $s5, $s5, $zero
		addi $s1, $s5, 1	# store quotient to $s1
		add $t9, $zero, $zero	# reset input
		add $s0, $zero, $zero 	# reset counter
		add $t0, $zero, $zero	# reset curVal
		add $s4, $zero, $zero	# reset backup
		add $s5, $zero, $zero	# reset result
		j negDivision