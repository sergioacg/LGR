import numpy as np
import matplotlib.pyplot as plt
from control.matlab import *

# Definición de los parámetros de la función de transferencia
K = -2
z1 = -1
z2 = -3
a = 1
b = 2
c = 5
d = 7

# Creación de la función de transferencia de lazo abierto
B = K * np.polymul([1, z1], [1, z2])
A = np.polymul(np.polymul(np.polymul([1, a], [1, b]), [1, c]), [1, d])
FTLA = tf(B, A)

# Generación del Lugar Geométrico de las Raíces (LGR)
plt.figure()
rlocus(FTLA)
plt.gca().set_title('Lugar Geométrico de las Raíces (LGR) de la Función de Transferencia')
plt.xlabel('Parte Real')
plt.ylabel('Parte Imaginaria')
plt.axis([-10, 10, -6, 6])
plt.show()

# Polos Adyacentes
term1 = np.polymul(B, np.polyder(A))
term2 = np.polymul(A, np.polyder(B))

adyacente = np.polysub(term1, term2)

print('Raíces del polinomio adyacente:', np.roots(adyacente))

# Cruce en el eje imaginario
from scipy.optimize import fsolve

def F(x):
    return [x[0]**4 + (2*x[1]-73)*x[0]**2 + 70 - 6*x[1],  # Ecuación 1
            -15*x[0]**3 + (129+8*x[1])*x[0]]  # Ecuación 2

x0 = [5, 29]  # Condición inicial
x = fsolve(F, x0)

# Mostrar la solución
print('Solución encontrada:')
print('ω =', x[0])
print('K =', x[1])
