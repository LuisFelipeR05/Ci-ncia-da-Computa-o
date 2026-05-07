sexo =""
idade = 0
qdtMulheres = 0
qdtHomens = 0

for i in range(0,5):
    sexo = input("Digite o sexo (M ou H)")
    idade = int(input("Digite a idade"))

    if(sexo=="M" or sexo=="m"):
        qdtMulheres=+1
    elif(sexo=="H" or sexo=="h"):
        qdtHomens=+1



print("A quantidade de mulheres é: ",qdtMulheres)
print("A quantidade de homens é: ",qdtHomens)