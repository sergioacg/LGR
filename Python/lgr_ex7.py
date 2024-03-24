import numpy as np
import matplotlib.pyplot as plt
from control.matlab import *

# Parámetros de la función de transferencia
z1 = 3
a = 0
b = 1
c = 2
d = 4

# Creación de la función de transferencia
A = np.polymul(np.polymul(np.polymul([1, a], [1, b]), [1, c]), [1, d])
B = [1, z1]
FTLA = tf(B, A)  # Función de transferencia de lazo abierto

# Cálculo del coeficiente de amortiguamiento para el sobrepaso máximo deseado
Mp = 5  # Sobrepaso máximo como porcentaje
zeta = np.sqrt((np.log(Mp/100))**2 / (np.pi**2 + (np.log(Mp/100))**2))
theta = np.degrees(np.arccos(zeta))  # Ángulo de la línea de amortiguamiento en grados

# Visualización del Lugar Geométrico de las Raíces (LGR)
plt.figure()
rlocus(FTLA, plot=True)
plt.grid(True)
plt.axis([-5, 1.5, -4, 4])  # Ajuste de los límites de los ejes para una mejor visualización
plt.show()

# Preasignación de la matriz de datos para almacenar los resultados
K_range = np.arange(0, 10.01, 0.01)
data = []

# Bucle para encontrar la ganancia K que se aproxima al ángulo deseado
for K in K_range:
    poles, _ = rlocus(FTLA, kvect=[K], plot=False)  # Calcula los polos para la ganancia K sin trazar la gráfica
    for polo in poles[-1]:  # Considerar los últimos polos calculados
        sigma = -np.real(polo)
        omega = np.abs(np.imag(polo))
        # Calcula la diferencia en ángulo con respecto a la línea de amortiguamiento
        if omega != 0:
            costo = np.abs(np.degrees(np.arctan(omega / sigma)) - theta)
            # Comprueba si el polo está lo suficientemente cerca de la línea de amortiguamiento
            if costo < 1:
                data.append([costo, K, polo])
                break  # Sale del bucle después de encontrar un polo que cumple el criterio

# Asegurarse de que se han encontrado datos válidos antes de proceder
if len(data) > 0:
    # Encuentra el conjunto de datos con el costo más bajo (mejor ajuste al ángulo deseado)
    data_sorted = sorted(data, key=lambda x: x[0])
    K_des, polo_des = data_sorted[0][1], data_sorted[0][2]
    print(f'Intersección en K = {K_des} con el polo {polo_des}')
else:
    raise Exception('No se encontraron polos que cumplan con el criterio especificado.')

# Análisis de la respuesta en lazo cerrado
Tss = 4 / abs(np.real(polo_des))  # Tiempo de estabilización
Tp = np.pi / np.abs(np.imag(polo_des))  # Tiempo de Pico
print(f'Tiempo de Estabilización = {Tss} con tiempo de pico en = {Tp}')

# Simulación de la respuesta en lazo cerrado con la ganancia K deseada
H = feedback(K_des * FTLA, 1)
plt.figure()
y, t = step(H)
plt.plot(t, y)
plt.title('Respuesta al escalón')
plt.show()
