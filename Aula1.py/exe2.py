import math
raiz = math.sqrt(16) #4.0
seno = math.sin(math.pi/2) #1.0
valor_pi = math.pi  #3.141592653589793

''''''''''''''
import random
numero = random.randint(1, 10) #gera um número inteiro aleatório entre 1 e 10
opcao = random.choice(['a', 'b', 'c']) #gera uma opção aleatória entre 'a', 'b' e 'c'

''''''''''''''
from datetime import datetime
agora = datetime.now() #obtém a data e hora atual
data_str = agora.strftime("%Y-%m-%d %H:%M:%S") #formata a data e hora como uma string no formato "YYYY-MM-DD HH:MM:SS"