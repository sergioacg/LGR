from control.matlab import *
from scipy.optimize import fsolve
import matplotlib.pyplot as plt
import numpy as np

# Definición de los parámetros de la función de transferencia

z1 = -3+3j
z2 = -3-3j
p1 = -1+1j
p2 = -1-1j
p3 = 0

# Creación de la función de transferencia de lazo abierto
B = np.poly([z1, z2])
A = np.poly([p1, p2, p3])
FTLA = tf(B, A)

# Generación del Lugar Geométrico de las Raíces (LGR)
plt.figure()
rlocus(FTLA)
plt.title('Lugar Geométrico de las Raíces (LGR) de la Función de Transferencia')
plt.xlabel('Parte Real')
plt.ylabel('Parte Imaginaria')
plt.axis([-5, 1, -5, 5])

# Feedback
k = 1
LC1 = feedback(k*FTLA, 1)

# Calcula la respuesta al escalón del sistema en lazo cerrado LC1
y, t = step(LC1)

# Crea otra nueva figura
plt.figure()
plt.plot(t, y, label='Respuesta')
plt.plot([t[0], t[-1]], [1, 1], '--k', label='Escalón')
plt.ylabel('Salida')
plt.xlabel('Tiempo')
plt.legend()

# incognitas = w,k
# x = [w, k]
def equations(x):
    return [-x[0]**2*(2+x[1])+18*x[1], x[0]*(-x[0]**2+1+6*x[1])]

x0 = [1, 1]  # Condicion inicial
x = fsolve(equations, x0)
print(x)

plt.show()