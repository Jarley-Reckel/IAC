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
        bne r0,t0,teste2
        addi s0,s0,1
teste2: la a0, vetor2
        addi a1, zero, 4
        jal ra, media
        addi t0, zero, 1
        bne r0,t0, FIM
        addi s0,s0,1
        beq zero,zero, FIM

##### R2 START MODIFIQUE AQUI START #####

media: 
    # Recebe dois argumentos: a0 e a1
    # a0 é o endereço do vetor
    # a1 é o tamanho do vetor
    # Retorna a média dos elementos do vetor em a0

    ########## SALVAR PARAMETROS DA CHAMADA ##################
    add     t0, zero, ra                        # Salva o endereço de retorno
    add     t1, zero, a0                        # Salva o endereço do vetor
    add     t2, zero, a1                        # Salva o tamanho do vetor

    ########## INICIALIZAÇÃO DAS VARIÁVEIS ###################
    add     t3, zero, zero                      # Inicializa a soma dos elementos do vetor
    add     t4, zero, zero                      # Inicializa o contador

    ########## CALCULA A SOMA DOS ELEMENTOS DO VETOR #########
    loop_sum:   
        beq     t4, t2, division                # Se contador == tamanho, termina
        lw      t5, 0(t1)                       # Carrega o elemento do vetor
        add     t3, t3, t5                      # Soma o elemento à soma
        addi    t4, t4, 1                       # Incrementa o contador
        addi    t1, t1, 4                       # Aponta para o próximo elemento
        beq     zero, zero, loop_sum            # Próxima iteração
    
    ########## FINALIZA O CÁLCULO DA MÉDIA ###################
    division:
        div     a0, t3, t2                      # Divide a soma pelo tamanho do vetor
    
    add     ra, zero, t0                        # Restaura o endereço de retorno -- não é necessário, mas é uma boa prática
    jalr    zero, 0(ra)                         # Retorna para a chamadora

covariancia: 
    # Recebe três argumentos: a0, a1 e a2
    # a0 é o endereço do vetor 1
    # a1 é o endereço do vetor 2
    # a2 é o tamanho dos vetores
    # Retorna a covariância dos vetores em a0

    ##########################################################
    ########## INICIO -- SALVAR REGISTRADORES SX #############
    ##########################################################

    addi    sp, sp, -48                         # Aloca espaço para salvar registradores -- 12 registradores sx
    sw      s0, 0(sp)                           # Salva registrador s0
    sw      s1, 4(sp)                           # Salva registrador s1
    sw      s2, 8(sp)                           # Salva registrador s2
    sw      s3, 12(sp)                          # Salva registrador s3
    sw      s4, 16(sp)                          # Salva registrador s4
    sw      s5, 20(sp)                          # Salva registrador s5
    sw      s6, 24(sp)                          # Salva registrador s6
    sw      s7, 28(sp)                          # Salva registrador s7
    sw      s8, 32(sp)                          # Salva registrador s8
    sw      s9, 36(sp)                          # Salva registrador s9
    sw      s10, 40(sp)                         # Salva registrador s10
    sw      s11, 44(sp)                         # Salva registrador s11

    ##########################################################
    ########## FINAL  -- SALVAR REGISTRADORES SX #############
    ##########################################################

    ########## SALVAR PARAMETROS DA CHAMADA ##################
    add     s0, zero, ra                        # Salva o endereço de retorno
    add     s1, zero, a0                        # Salva o endereço do vetor 1
    add     s2, zero, a1                        # Salva o endereço do vetor 2
    add     s3, zero, a2                        # Salva o tamanho dos vetores

    ########## CALCULA A MÉDIA DOS VETORES ###################
    add     a0, zero, s1                        # Carrega endereço do vetor para a0
    add     a1, zero, s3                        # Carrega tamanhos dos vetores para a1
    jal     ra, media                           # Calcula a média do vetor 1
    add     s4, zero, a0                        # Salva a média do vetor 1
    add     a0, zero, s2                        # Carrega endereço do vetor 2 para a0
    jal     ra, media                           # Calcula a média do vetor 2
    add     s5, zero, a0                        # Salva a média do vetor 2

    ########## INICIALIZAÇÃO DAS VARIÁVEIS ###################
    add     s6, zero, zero                      # Inicializa a soma
    add     s7, zero, zero                         # Inicializa o contador
    add     s8, zero, s1                        # Carrega o endereço do vetor 1
    add     s9, zero, s2                        # Carrega o endereço do vetor 2

    ########## CALCULAR SOMA [(xi - x')*(yi - y')] ###########
    sum_cov:
        beq     s7, s3, division_cov            # Se contador == tamanho, termina
        lw      t1, 0(s1)                       # Carrega o elemento do vetor 1
        lw      t2, 0(s2)                       # Carrega o elemento do vetor 2
        sub     t3, t1, s4                      # Subtrai a média do vetor 1
        sub     t4, t2, s5                      # Subtrai a média do vetor 2
        mul     t5, t3, t4                      # Multiplica os elementos
        add     s6, s6, t5                      # Soma a multiplicação à soma
        addi    s7, s7, 1                       # Incrementa o contador
        addi    s1, s1, 4                       # Aponta para o próximo elemento do vetor 1
        addi    s2, s2, 4                       # Aponta para o próximo elemento do vetor 2
        beq     zero, zero, sum_cov             # Próxima iteração

    ########## FINALIZA O CÁLCULO DA CONVOLUÇÃO ##############
    division_cov:
        addi    t0, s3, -1                      # Calcula o denominador
        div     a0, s6, t0                      # Divide a soma por (tamanho - 1) -- salva em a0 
        
    add     ra, zero, s0                        # Restaura o endereço de retorno

    ##########################################################
    ########## INICIO -- RESTAURAR REGISTRADORES SX ##########
    ##########################################################

    lw      s11, 44(sp)                         # Restaura registrador s11
    lw      s10, 40(sp)                         # Restaura registrador s10
    lw      s9, 36(sp)                          # Restaura registrador s9
    lw      s8, 32(sp)                          # Restaura registrador s8
    lw      s7, 28(sp)                          # Restaura registrador s7
    lw      s6, 24(sp)                          # Restaura registrador s6
    lw      s5, 20(sp)                          # Restaura registrador s5
    lw      s4, 16(sp)                          # Restaura registrador s4
    lw      s3, 12(sp)                          # Restaura registrador s3
    lw      s2, 8(sp)                           # Restaura registrador s2
    lw      s1, 4(sp)                           # Restaura registrador s1
    lw      s0, 0(sp)                           # Restaura registrador s0
    addi    sp, sp, 48                          # Restaura o ponteiro de pilha

    ##########################################################
    ########## INICIO -- RESTAURAR REGISTRADORES SX ##########
    ##########################################################

    jalr    zero, 0(ra)                         # Retorna para a chamadora

##### R2 END MODIFIQUE AQUI END #####

FIM: add t0, zero, s0
