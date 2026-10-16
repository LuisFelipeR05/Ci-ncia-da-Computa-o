#include <stdio.h>

#define DIAS_MAX 31
#define DIAS_MIN 2
#define TEMP_MIN -50
#define TEMP_MAX 60
#define ALTURA   10

int main(void)
{
    float temperatura[DIAS_MAX];
    char  grafico[ALTURA][DIAS_MAX];
    int   dias;
    int   i, j;
    int   diaMaior, diaMenor;
    int   linha;
    float soma, media, maior, menor;

    printf("Quantos dias tem o mes (%d a %d)? ", DIAS_MIN, DIAS_MAX);
    scanf("%d", &dias);
    while (dias < DIAS_MIN || dias > DIAS_MAX) {
        printf("Valor invalido. Digite um valor entre %d e %d: ",
               DIAS_MIN, DIAS_MAX);
        scanf("%d", &dias);
    }

    for (i = 0; i < dias; i++) {
        printf("Temperatura maxima do dia %d: ", i + 1);
        scanf("%f", &temperatura[i]);

        while (temperatura[i] < TEMP_MIN || temperatura[i] > TEMP_MAX) {
            printf("Valor fora do intervalo (%d a %d). Digite novamente: ",
                   TEMP_MIN, TEMP_MAX);
            scanf("%f", &temperatura[i]);
        }
    }

    soma = 0;
    maior = menor = temperatura[0];
    diaMaior = diaMenor = 1;

    for (i = 0; i < dias; i++) {
        soma += temperatura[i];

        if (temperatura[i] > maior) {
            maior = temperatura[i];
            diaMaior = i + 1;
        }
        if (temperatura[i] < menor) {
            menor = temperatura[i];
            diaMenor = i + 1;
        }
    }
    media = soma / dias;

    printf("\n===== TEMPERATURAS DO MES =====\n");
    printf("Dia | Temperatura (C)\n");
    printf("----+----------------\n");
    for (i = 0; i < dias; i++) {
        printf("%3d | %10.1f\n", i + 1, temperatura[i]);
    }

    printf("\nMedia do mes : %.1f C\n", media);
    printf("Maior        : %.1f C (dia %d)\n", maior, diaMaior);
    printf("Menor        : %.1f C (dia %d)\n", menor, diaMenor);

    for (i = 0; i < ALTURA; i++) {
        for (j = 0; j < dias; j++) {
            grafico[i][j] = ' ';
        }
    }

    for (j = 0; j < dias; j++) {
        if (maior == menor) {
            linha = ALTURA / 2;
        } else {
            linha = (int)((temperatura[j] - menor) / (maior - menor)
                          * (ALTURA - 1) + 0.5f);
            linha = (ALTURA - 1) - linha;
        }
        grafico[linha][j] = '*';
    }

    printf("\n===== GRAFICO DE TEMPERATURA (dia 1 a %d) =====\n", dias);
    for (i = 0; i < ALTURA; i++) {
        float valorFaixa;
        if (maior == menor) {
            valorFaixa = maior;
        } else {
            valorFaixa = maior - (maior - menor) * i / (ALTURA - 1);
        }
        printf("%6.1f |", valorFaixa);
        for (j = 0; j < dias; j++) {
            printf("%c", grafico[i][j]);
        }
        printf("\n");
    }

    printf("       +");
    for (j = 0; j < dias; j++) {
        printf("-");
    }
    printf("\n        ");
    for (j = 0; j < dias; j++) {
        printf("%d", (j + 1) % 10);
    }
    printf("\n");

    return 0;
}