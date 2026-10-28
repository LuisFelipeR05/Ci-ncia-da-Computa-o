#include <stdio.h>

int main() {
    int tempos[10] = {35, 12, 48, 25, 60, 18, 42, 30, 55, 22};
    int temp;

    printf("=== Tempo de deslocamento (em minutos) ===\n\n");

    printf("Dados originais:\n");
    for (int i = 0; i < 10; i++) {
        printf("Posicao %d: %2d min\n", i, tempos[i]);
    }

    /* Bubble Sort crescente */
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9 - i; j++) {
            if (tempos[j] > tempos[j + 1]) {
                temp = tempos[j];
                tempos[j] = tempos[j + 1];
                tempos[j + 1] = temp;
            }
        }
    }

    printf("\nDados em ordem crescente:\n");
    for (int i = 0; i < 10; i++) {
        printf("Posicao %d: %2d min\n", i, tempos[i]);
    }

    /* Bubble Sort decrescente */
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9 - i; j++) {
            if (tempos[j] < tempos[j + 1]) {
                temp = tempos[j];
                tempos[j] = tempos[j + 1];
                tempos[j + 1] = temp;
            }
        }
    }

    printf("\nDados em ordem decrescente:\n");
    for (int i = 0; i < 10; i++) {
        printf("Posicao %d: %2d min\n", i, tempos[i]);
    }

    return 0;
}