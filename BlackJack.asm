#BLACKJACK 21

#Este trabajo es de:

#Mónica Alonso Mateos
#Estefanía Carrera Castro
#Alba de Pedro López
#Eva Hernández García


#Esperamos que se diviertan jugando.


.data
.align 2
cartas_jugador1: .space 40 
cartas_jugador2: .space 40
cadenaBienvenida: .asciiz "Bienvenidos al BlackJack, esperamos que disfruten de la partida.\n"
cadenaPlantarse: .asciiz "\nIntroduzca un 2 si desea plantarse, o un 1 si desea volver a pedir una carta:"
cadenaCartasJugador1: .asciiz "\nJugador 1, sus cartas son: "
sumaJugador1: .asciiz "\nLa suma del valor de las cartas del jugador 1 es: "
cadenaCartasJugador2: .asciiz "\nJugador 2, sus cartas son: "
sumaJugador2: .asciiz "\nLa suma del valor de las cartas del jugador 2 es: "
coma: .asciiz ", "
sobrepaso: .asciiz "\nHa perdido, ha superado los 21 puntos."
ganaJugador1: .asciiz "\nEnhorabuena jugador 1, ha ganado la partida."
ganaJugador2: .asciiz "\nEnhorabuena jugador 2, ha ganado la partida."
empate: .asciiz "\nAmbos jugadores han empatado la partida. Lo sentimos, gana la banca."
.text
.globl main

main:
	la $a0, cadenaBienvenida		
	li $v0, 4
	syscall
	
	li $a0, 1				#Empieza en 1 porque en la primera jugada se reparten dos cartas y luego en 
						#el bucle, al final lo inicializas a cero y aquí le sumas uno.
	
	li $t6, 0				#CONTADOR DE CARTAS
	
	bucleSacarCartasJugador1:
	
		addi $a0, $a0, 1		#En la primera iteración a0 es dos, en las demás será 1.
		la $a1, cartas_jugador1	
		mul $t7, $t6, 4			#t7 almacena el numero de cartas por la longitud de un word.
		add $a1, $a1, $t7		#la direccion de memoria donde iría la siguiente carta.
		la $a2, coma			
	
	
		jal generarCartas
	
		add $t6, $t6, $v0		#CONTADOR DE CARTAS DEL JUGADOR1.
		move $a1, $t6			#Para pasarselo como atributo a mostrarCartas.
	
		la $a0, cadenaCartasJugador1
		li $v0, 4
		syscall
		
		la $a0 coma
		la $a2 cartas_jugador1
	
		jal mostrarCartas
	
		la $a0, cartas_jugador1			
		move $a1, $t6			#Para pasarselo como atributo a calcularValor.
	
		jal calcularValor
	
		move $a3, $v0			#Almacena en a3 la suma de los valores de las cartas.
	
		la $a0, sumaJugador1		
		li $v0, 4
		syscall
	
		move $a0, $a3					
		li $v0, 1
		syscall				#Imprime la suma la suma jugador1 esta en a3.
	
		bgt $a3, 21, finJuegoSobrepaso	#Pierdes si te pasas de 21.
		
		move $t5, $a3			#En t5 está almacenada la suma de las cartas del jugador1 que 
						#posteriormente compararemos con la suma del jugador2.
	
	
		la $a0, cadenaPlantarse
	
		jal preguntarJugador
	
		move $t4, $v0
		li $a0, 0
		beq $t4, 1, bucleSacarCartasJugador1	#Compara tu respuesta a la pregunta de si te plantas y salta dependiendo del valor.
		beq $t4, 2, jugadorDos
		
	jugadorDos:					#Comienza el turno del jugador2. (Bucle igual al del jugador1).
	
	li $a0, 1
	li $t6, 0
	
	bucleSacarCartasJugador2:
	
		addi $a0, $a0, 1		
		la $a1, cartas_jugador2	
		mul $t7, $t6, 4
		add $a1, $a1, $t7			
		la $a2, coma			
	
	
		jal generarCartas
	
		add $t6, $t6, $v0		#CONTADOR DE CARTAS DEL JUGADOR2
		move $a1, $t6		
	
		la $a0, cadenaCartasJugador2
		li $v0, 4
		syscall
		
		la $a0 coma
		la $a2 cartas_jugador2
	
		jal mostrarCartas
	
		la $a0, cartas_jugador2
		move $a1, $t6
	
		jal calcularValor
	
		move $a3, $v0
	
		la $a0, sumaJugador2
		li $v0, 4
		syscall
	
		move $a0, $a3
		li $v0, 1
		syscall 			
	
		bgt $a3, 21, finJuegoSobrepaso
	
		la $a0, cadenaPlantarse
	
		jal preguntarJugador
	
		move $t4, $v0
		li $a0, 0
		beq $t4, 1, bucleSacarCartasJugador2
		beq $t4, 2, fin
	
	fin:
		bgt $t5, $a3, finGanaJugador1 		#Compara la suma de puntos de los dos jugadores: t5 es el 1 y a3 es el 2
		blt $t5, $a3, finGanaJugador2
		beq $t5, $a3, finEmpate  
	
	
#FIN DEL MAIN Y COMIENZO DE LAS SUBRUTINAS


#Los 4 casos por los que puede acabar una jugada.
			
finJuegoSobrepaso:
	la $a0, sobrepaso
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall



finGanaJugador1:
	la $a0, ganaJugador1
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
	
	
finGanaJugador2:
	la $a0, ganaJugador2
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
	
	
finEmpate:
	la $a0, empate
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall



generarCartas:

	# en a0 va el tamaño del array, es decir, el numero de cartas a generar
	# en a1 la direccion de memoria del array
	
	
	move $t0, $a0
	move $t1, $a1
	li $t3, 0			#contador generar cartas
	
	
	bucleGenerarCartas:
		beq $t3, $t0, finGenerarCartas	#cuando el bucle se repita el numero de veces de cartas a generar para
		li $a1, 13			 # indicamos el límite máximo. Significa que el número aleatorio está entre 0 y 12
		li $v0, 42
		syscall
	
		addi $a0, $a0, 1 		# para que el número aleatorio esté entre 1 y 13
		sw $a0, ($t1)			#Guardamos el número en cartas_jugador1 y le sumamos 4 a la direccion de memoria
	
		addi $t1, $t1, 4
		addi $t3, $t3, 1		#suma uno al contador
	
		j bucleGenerarCartas
	
	finGenerarCartas:
		move $v0, $t3
		jr $ra
	


mostrarCartas:

	# en a0 cadena para imprimir una coma
	# en a1 tamaño del array
	# en a2 la direccion de memoria del array de cartas del jugador al que le toque
	
	li $t2, 1 			#Inicializamos contador
	
	bucleImprimir:
	
		move $t0, $a0
		lw $t1, ($a2)
	
		move $a0, $t1
		li $v0, 1
		syscall
		
		beq $a1, $t2, finMostrarCartas
		
		move $a0, $t0
		li $v0, 4
		syscall
		
		addi $t2, $t2, 1
		addi $a2, $a2, 4
		 
		 j bucleImprimir
		 
		 
	finMostrarCartas:
	
		jr $ra



calcularValor:

	# en a0 array que contiene cartas del jugador
	# en a1 el tamaño de dicho array
	
	li $t0, 0				
 	li $t2, 0
 	
 	bucleCalcularValor:
 	
 		lw $a2, ($a0)				#Recorre el array de cartas
 		beq $t0, $a1, finCalcularValor		#Compara ontador y numero de cartas que tiene que sumar
 		beq $a2, 1, sumaAS
 		beq $a2, 11, sumarDiez
 		beq $a2, 12, sumarDiez
 		beq $a2, 13, sumarDiez			
 		addi $a0, $a0, 4			#Suma 4 ya que cada word son 4 bytes.
 		add $t2, $a2, $t2			#Suma.
 		add $t0, $t0, 1				#Contador repeticiones bucle.
 		j bucleCalcularValor
 	
 	#Casos especiales de los valores de las cartas: figuras y AS.
 		sumarDiez:
 			addi $t2, $t2, 10
 			addi $a0, $a0, 4		
 			add $t0, $t0, 1	
 			j bucleCalcularValor
 		
 		sumaAS:
 			addi $t2, $t2, 11
 			bgt $t2, 21, restarDiez
 			addi $a0, $a0, 4		
 			add $t0, $t0, 1
 			j bucleCalcularValor
 			
 	#Se resta 10 al valor si el AS debe valer 1 en lugar de 11.
 		restarDiez:
 			sub $t2, $t2, 10
 			addi $a0, $a0, 4		
 			add $t0, $t0, 1
 			j bucleCalcularValor
 	
 	finCalcularValor:
 		move $v0, $t2
 		jr $ra
	

preguntarJugador:

	#En a1 direccion de la cadena que solicita al usuario si desea volver a pedir una carta o plantarse.
	pregunta:
		li $v0, 4		#Imprime la cadena que le hemos pasado.
		syscall
	
		li $v0, 5			#Lee entero por pantalla.
		syscall
	
		#Te vuelve a pedir que introduzcas un número si éste es diferente a 1 o 2.
		beq $v0, 1, finPreguntarJugador
		beq $v0, 2, finPreguntarJugador
		bne $v0, 1, pregunta

	finPreguntarJugador:
		jr $ra