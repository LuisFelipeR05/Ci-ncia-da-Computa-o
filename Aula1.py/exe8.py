# percorrer de 1 a N

numero = int(input("Digite um número: "))

resultado = 1
for i in range(1, numero + 1):
    resultado = resultado * i

print("Resultado: ", resultado)