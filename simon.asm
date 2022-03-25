.data
	buffer: .space 100
.text
	addi $t7, $zero, 16		# t1 = Start Game (16)
	add  $t9, $zero, $zero		# Clear $t9 to 0
	 
wait:	beq  $t9, $zero, wait		# Wait until $t9 is not 0
	beq  $t9, $t7, startGame	# If $t9 is 16, go to start game
startGame: 
	addi $t8, $zero, 16		# Play the start game sound (also activate color buttons)
game:
	add $t2, $zero, $zero		# clear $t2 variable 
	add $t9, $zero, $zero		# clear user input
	jal setInt			# set random integer for display
	add $a0, $v0, $zero		# v0 is generated random button value, store in a0 for store function
	jal storeInt
	jal playSequence
	jal userPlay
	beq $v0, $zero, game		# if user input all correctly, display next sound sequence
	j wait				# if user input wrong, restart game

# random int generator
setInt:	
	addi $a1, $zero, 4		# set upper bound exclusive 
	addi $v0, $zero, 42		# syscall 42: random integer
	syscall
	addi $v0, $zero, 1		# v0 = 1
	sllv $v0, $v0, $a0		# shift by amount generated = set button according to random int
	jr $ra

# store rand int in memory stack
storeInt:	
	add $t0, $a0, $zero		# t0 is button number
	add $t2, $zero, $zero		# local counter
	storeLoop:
		lb $t1, buffer($t2)	# load data in t1 at buffer location t2
		beq $t1, $zero, store	# if no data in at t2, store curr button number there
		addi $t2, $t2, 1	# if occupied, increment counter
		j storeLoop
	store:
		sb $t0, buffer($t2)	# store curr data t0 into buffer at location t2
	
	jr $ra

playSequence:
	add $t2, $zero, $zero		# counter
	# same thing as store loop except for store, it displays
	seqLoop:
		lb $t1, buffer($t2)	
		beq $t1, $zero, seqDone	# if no data to be displayed, done
		add $t8, $t1, $zero	# display button
		addi $t2, $t2, 1
		j seqLoop
	seqDone:
		jr $ra
		
userPlay:
	add $t2, $zero, $zero		# counter
	add $t9, $zero, $zero		# clear $t9
	compareLoop:
		lb $t1, buffer($t2)
		beq $t1, $zero, nextRound	# if empty buffer, go next round
		waitInput:
			beq  $t9, $zero, waitInput
		bne $t9, $t1, lose		# if user input != sequence, you lose
	# otherwise keep going
		add $t8, $t9, $zero		# display user input
		#clear
		add $t9, $zero, $zero		
		add $t8, $zero, $zero		
		# increment counter, test next input
		addi $t2, $t2, 1
		j compareLoop
	
	nextRound:
		add $v0, $zero, $zero	# if success, set v0 = 0, go again
		jr $ra
	
	lose:
		addi $t8, $zero, 15	# display lose game
		add $t9, $t9, $zero
		# clear buffer
		clearLoop:
			lb $t1, buffer($t2)
			beq $t1, $zero, return
			sb $zero, buffer($t2)
			addi $t2, $t2, 1
			j clearLoop
		return:
			add $t9, $zero, $zero
			jr $ra