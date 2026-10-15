#include <stdio.h>

int main() {
    int opcao = -1;  
    int totalTreinos = 0;
    int totalMinutos = 0;
    float totalCalorias = 0;
    int tipo, minutos, c;
    float caloriasPorMin, calorias;

    
    printf("========================================\n");
    printf("       FITCONTROL - ROTINA DE TREINOS   \n");
    printf("========================================\n");
    printf("Este programa ajuda voce a controlar seus\n");
    printf("treinos e a estimar as calorias queimadas.\n");
    printf("----------------------------------------\n");
    printf("Ola! Que bom ter voce aqui. Vamos\n");
    printf("treinar com saude e disciplina!\n");
    printf("========================================\n\n");

    
    do {
        printf("\n------------- MENU PRINCIPAL -------------\n");
        printf("1 - Registrar treino\n");
        printf("2 - Ver treinos registrados\n");
        printf("3 - Calcular calorias queimadas\n");
        printf("4 - Exibir relatorio\n");
        printf("0 - Sair\n");
        printf("------------------------------------------\n");
        printf("Escolha uma opcao: ");

        
        if (scanf("%d", &opcao) != 1) {
            printf("\n[ERRO] Entrada invalida! Digite apenas numeros (0 a 4).\n");
            while ((c = getchar()) != '\n' && c != EOF) { }  
            opcao = -1;  
            continue;     
        }

        switch (opcao) {
            case 1:
                printf("\n--- Registrar treino ---\n");
                printf("Tipo de atividade:\n");
                printf("1 - Caminhada\n2 - Corrida\n3 - Ciclismo\n4 - Musculacao\n");
                printf("Escolha o tipo: ");

                if (scanf("%d", &tipo) != 1) {
                    printf("\n[ERRO] Entrada invalida! Digite um numero de 1 a 4.\n");
                    while ((c = getchar()) != '\n' && c != EOF) { }
                    break;
                }

                if (tipo < 1 || tipo > 4) {
                    printf("\n[ERRO] Tipo invalido! Digite um numero de 1 a 4. Treino nao registrado.\n");
                    break;
                }

                printf("Duracao em minutos: ");
                if (scanf("%d", &minutos) != 1) {
                    printf("\n[ERRO] Entrada invalida! Digite a duracao em minutos. Treino nao registrado.\n");
                    while ((c = getchar()) != '\n' && c != EOF) { }
                    break;
                }

                if (minutos <= 0) {
                    printf("\n[ERRO] Duracao invalida! Digite um valor maior que zero. Treino nao registrado.\n");
                    break;
                }

                
                if (tipo == 1) {
                    caloriasPorMin = 4.0;
                } else if (tipo == 2) {
                    caloriasPorMin = 10.0;
                } else if (tipo == 3) {
                    caloriasPorMin = 8.0;
                } else {
                    caloriasPorMin = 6.0;
                }

                calorias = minutos * caloriasPorMin;
                totalTreinos++;
                totalMinutos += minutos;
                totalCalorias += calorias;

                printf("Treino registrado! Calorias estimadas: %.1f kcal\n", calorias);
                break;

            case 2:
                printf("\n--- Treinos registrados ---\n");
                printf("Quantidade de treinos: %d\n", totalTreinos);
                printf("Tempo total: %d minutos\n", totalMinutos);
                break;

            case 3:
                printf("\n--- Calorias queimadas ---\n");
                printf("Total acumulado: %.1f kcal\n", totalCalorias);
                break;

            case 4:
                printf("\n====== RELATORIO RESUMIDO ======\n");
                printf("Treinos realizados : %d\n", totalTreinos);
                printf("Minutos treinados  : %d\n", totalMinutos);
                printf("Calorias queimadas : %.1f kcal\n", totalCalorias);
                if (totalTreinos > 0) {
                    printf("Media por treino   : %.1f kcal\n", totalCalorias / totalTreinos);
                }
                printf("================================\n");
                break;

            case 0:
                printf("\nSaindo do sistema...\n");
                break;

            default:
                printf("\n[ERRO] Opcao invalida! Voce digitou um numero que nao esta no menu.\n");
                printf("Por favor, digite um numero de 0 a 4.\n");
        }
    } while (opcao != 0);

    
    printf("\n========================================\n");
    printf("        FITCONTROL ENCERRADO            \n");
    printf("========================================\n");
    printf("Resumo da sessao:\n");
    printf("Treinos registrados: %d\n", totalTreinos);
    printf("Minutos treinados  : %d\n", totalMinutos);
    printf("Calorias queimadas : %.1f kcal\n", totalCalorias);
    printf("----------------------------------------\n");
    printf("Obrigado por usar o FitControl.\n");
    printf("Continue se exercitando e ate a proxima!\n");
    printf("========================================\n");

    return 0;
}