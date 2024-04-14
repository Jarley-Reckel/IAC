.data

##### R1 START MODIFIQUE AQUI START #####
#
# Este espaço é para você definir as suas constantes e vetores auxiliares.
#

vetor: .word 1 2 3 4 5 6 7 8 9 10


##### R1 END MODIFIQUE AQUI END #####

.text
        add s0, zero, zero #Quantidade de testes em que seu programa passou
        la a0, vetor
        addi a1, zero, 10
        addi a2, zero, 2
        jal ra, multiplos
        addi t0, zero, 5
        bne a0,t0,teste2
        addi s0,s0,1
teste2: la a0, vetor
        addi a1, zero, 10
        addi a2, zero, 3
        jal ra, multiplos
        addi t0, zero, 3
        bne a0,t0, FIM
        addi s0,s0,1
        beq zero,zero,FIM

##### R2 START MODIFIQUE AQUI START #####
multiplos:
    # Recebe três argumentos: a0, a1 e a2
    # a0: endereço do vetor
    # a1: tamanho do vetor
    # a2: número a ser verificado se é múltiplo
    # Retorna a quantidade de números múltiplos de a2 no vetor em a0
    
    add     s1, zero, ra                    # Salva o endereço de retorno
    add     s2, zero, a0                    # Salva o endereço do vetor
    add     s3, zero, a1                    # Salva o tamanho do vetor
    add     s4, zero, a2                    # Salva o número a ser verificado

    add     s5, zero, zero                  # Inicializa o contador de múltiplos
    add     s6, zero, zero                  # Inicializa o contador da posição no vetor
    
    jal     ra, verifyConditions            # Verifica se as condições de entrada são válidas
    beq     a0, zero, set_return            # Se as condições não forem válidas, retorna 0

    loop:
        # Conta quantos números são múltiplos de a2
        beq     s6, s3, set_return          # Se o vetor acabou, retorna o contador
        slli    t0, s6, 2                   # t0 = s6 * 4 -- Define o deslocamento para a posição atual do vetor
        add     t1, s2, t0                  # t1 = s2 + t0 -- Define o endereço do vetor na posição atual
        lw      t2, 0(t1)                   # Carrega o número do vetor na posição atual
        rem     t3, t2, s4                  # t3 = t2 % s4 -- Calcula o resto da divisão
        addi    s6, s6, 1                   # Incrementa o contador da posição no vetor
        beq     t3, zero, increment         # Se o resto for 0, incrementa o contador de múltiplos
        beq     zero, zero, loop            # Se o vetor não acabou, volta para o início

    increment:
        # Incrementa o contador de múltiplos
        addi    s5, s5, 1                   # Incrementa o contador
        beq     zero, zero, loop            # Retorna ao loop

    set_return:
        # Retorna o contador de múltiplos
        add     a0, zero, s5                # Define o valor de retorno
        add     ra, zero, s1                # Restaura o endereço de retorno
        beq     zero, zero, return          # Retorna para a chamadora

    verifyConditions:
        # Verifica se as condições de entrada são válidas
        divisionByZero:
            # Tratamento de divisão por zero
            bne     a2, zero, vectorSize        # Se s2 != 0, pula para a próxima etapa
            beq     zero, zero, return          # Retorna para a chamadora
        
        vectorSize: 
            # Se a1 for zero, retorna 0 - tratamento de vetor vazio
            bne     a1, zero, return            # Se a1 != 0, pula para a próxima etapa 
            beq     zero, zero, return          # Retorna para a chamadora

    return:     
        jalr    zero, 0(ra)                     # Retorna para a chamadora

##### R2 END MODIFIQUE AQUI END #####

FIM: addi t0, s0, 0
