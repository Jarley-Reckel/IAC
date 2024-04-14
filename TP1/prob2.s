.data

##### R1 START MODIFIQUE AQUI START #####

#
# Este espaço é para você definir as suas constantes e vetores auxiliares.
#

vetor1: .word 1 2 3 4 #Primeiro vetor
vetor2: .word 1 1 1 1 #Segundo vetor

##### R1 END MODIFIQUE AQUI END #####
      
.text    

        add s0, zero, zero
        la a0, vetor1
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, 2
        bne a0,t0,teste2
        addi s0,s0,1
teste2: la a0, vetor2
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, 1
        bne a0,t0, FIM
        addi s0,s0,1
        beq zero,zero, FIM

##### R2 START MODIFIQUE AQUI START #####

media: 
    # Recebe dois argumentos: a0 e a1
    # a0 é o endereço do vetor
    # a1 é o tamanho do vetor
    # Retorna a média dos elementos do vetor em a0

    add     s1, zero, ra                        # Salva o endereço de retorno
    add     s2, zero, a0                        # Salva o endereço do vetor
    add     s3, zero, a1                        # Salva o tamanho do vetor

    add     s4, zero, zero                      # Inicializa a soma
    add     s5, zero, zero                      # Inicializa o contador

    loop_sum:   
        # Loop para somar os elementos do vetor
        beq     s5, s3, division                # Se contador == tamanho, termina
        lw      t0, 0(s2)                       # Carrega o elemento do vetor
        add     s4, s4, t0                      # Soma o elemento à soma
        addi    s5, s5, 1                       # Incrementa o contador
        addi    s2, s2, 4                       # Aponta para o próximo elemento
        beq     zero, zero, loop_sum            # Próxima iteração
    
    division:
        div     a0, s4, s3                      # Divide a soma pelo tamanho do vetor
    
    add     ra, zero, s1                        # Restaura o endereço de retorno -- não é necessário, mas é uma boa prática
    jalr    zero, 0(ra)                         # Retorna para a chamadora

covariancia: 
    # Recebe três argumentos: a0, a1 e a2
    # a0 é o endereço do vetor 1
    # a1 é o endereço do vetor 2
    # a2 é o tamanho dos vetores
    # Retorna a covariância dos vetores em a0

    add     s1, zero, ra                        # Salva o endereço de retorno
    add     s2, zero, a0                        # Salva o endereço do vetor 1
    add     s3, zero, a1                        # Salva o endereço do vetor 2
    add     s4, zero, a2                        # Salva o tamanho dos vetores

    add     s5, zero, zero                      # Inicializa a soma
    add     s6, zero, zero                      # Inicializa o contador

    # Calcula a média dos vetores
    add     a1, zero, s4                        # Carrega tamanhos dos vetores para a1
    jal     ra, media                           # Calcula a média do vetor 1
    add     s7, zero, a0                        # Salva a média do vetor 1
    add     a0, zero, s3                        # Carrega endereço do vetor 2 para a0
    jal     ra, media                           # Calcula a média do vetor 2
    add     s8, zero, a0                        # Salva a média do vetor 2

    loop_cov:
        # Loop para calcular a covariância
        beq     s6, s4, division_cov            # Se contador == tamanho, termina
        lw      t0, 0(s2)                       # Carrega o elemento do vetor 1
        lw      t1, 0(s3)                       # Carrega o elemento do vetor 2
        sub     t0, t0, s7                      # Subtrai a média do vetor 1
        sub     t1, t1, s8                      # Subtrai a média do vetor 2
        mul     t2, t0, t1                      # Multiplica os elementos
        add     s5, s5, t2                      # Soma o resultado à soma
        addi    s6, s6, 1                       # Incrementa o contador
        addi    s2, s2, 4                       # Aponta para o próximo elemento do vetor 1
        addi    s3, s3, 4                       # Aponta para o próximo elemento do vetor 2
        beq     zero, zero, loop_cov            # Próxima iteração

    division_cov:
        addi    t3, s4, -1                      # Calcula o denominador
        div     a0, s5, t3                      # Divide a soma pelo tamanho - 1 -- salva em a0 
        
    add     ra, zero, s1                        # Restaura o endereço de retorno -- não é necessário, mas é uma boa prática
    jalr zero, 0(ra) # Retorna para a chamadora


##### R2 END MODIFIQUE AQUI END #####

FIM: add t0, zero, s0
