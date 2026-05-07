frutas = ["Limão", "Banana", "Morango"]
frutas.append("Abacaxi")
frutas.append("Abacate")

frutas2= []
for i in range(2):

    frutas.pop()
    frutas2.append(frutas[i])

print(frutas2)