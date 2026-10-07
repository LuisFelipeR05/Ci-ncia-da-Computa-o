#include <stdio.h>
#include <string.h>

#define QUANTIDADE_PRODUTOS 3

typedef struct {
    char nome[50];
    float precoAnterior;
    float precoAtual;
    float variacao;
    float variacaoPercentual;
    char situacao[20];
} Produto;

int main(void) {
    Produto cestaBasica[QUANTIDADE_PRODUTOS];
    int i;

    printf("=====================================\n");
    printf(" ANALISE DE PRECOS DA CESTA BASICA\n");
    printf("=====================================\n");


for (i = 0; i < QUANTIDADE_PRODUTOS; i++) {

    printf("\n--- Produto %d ---\n", i + 1);

    printf("Digite o nome do produto: ");
    fgets(cestaBasica[i].nome,
          sizeof(cestaBasica[i].nome),
          stdin);

    cestaBasica[i].nome[
        strcspn(cestaBasica[i].nome, "\n")
    ] = '\0';

    printf("Digite o preco do mes anterior: ");
    scanf("%f", &cestaBasica[i].precoAnterior);
    getchar();

    printf("Digite o preco do mes atual: ");
    scanf("%f", &cestaBasica[i].precoAtual);
    getchar();
        // Cálculo da variação
        
        cestaBasica[i].variacao =
            cestaBasica[i].precoAtual -
            cestaBasica[i].precoAnterior;

        // Proteção contra divisão por zero
        if (cestaBasica[i].precoAnterior != 0) {
            cestaBasica[i].variacaoPercentual =
                (cestaBasica[i].variacao /
                 cestaBasica[i].precoAnterior) * 100;
        } else {
            cestaBasica[i].variacaoPercentual = 0;
        }

        // Verificação da situação
        if (cestaBasica[i].precoAtual > cestaBasica[i].precoAnterior) {
            strcpy(cestaBasica[i].situacao, "Aumentou");
        } else if (cestaBasica[i].precoAtual < cestaBasica[i].precoAnterior) {
            strcpy(cestaBasica[i].situacao, "Diminuiu");
        } else {
            strcpy(cestaBasica[i].situacao, "Manteve");
        }
    }

    // Exibição dos resultados
    printf("\n\n=====================================\n");
    printf(" RESULTADO DA ANALISE\n");
    printf("=====================================\n");

    for (i = 0; i < QUANTIDADE_PRODUTOS; i++) {
        printf("\nProduto: %s\n", cestaBasica[i].nome);
        printf("Preco anterior: R$ %.2f\n", cestaBasica[i].precoAnterior);
        printf("Preco atual: R$ %.2f\n", cestaBasica[i].precoAtual);
        printf("Variacao: R$ %.2f\n", cestaBasica[i].variacao);
        printf("Variacao percentual: %.2f%%\n", cestaBasica[i].variacaoPercentual);
        printf("Situacao: %s\n", cestaBasica[i].situacao);

        printf("-------------------------------------\n");
    }

    printf("\nFim da analise.\n");

    return 0;
}