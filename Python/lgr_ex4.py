import numpy as np
import matplotlib.pyplot as plt
from control.matlab import *

# Definición del sistema
G = tf(np.convolve([1, 2], [1, 3]), np.convolve([1, -1+1j], [1, -1-1j]))
H = 1

# Sistema en lazo abierto
FTLA = series(G, H)

# Gráfico del mapa de polos y ceros
plt.figure()
pzmap(FTLA)
# Ajuste de las propiedades gráficas
for line in plt.gca().get_lines():
    line.set_markersize(15)
    line.set_linewidth(4)

# Gráfico del lugar de las raíces
plt.figure()
rlocus(FTLA)
plt.grid(False)
# Ajuste de las propiedades gráficas
for line in plt.gca().get_lines():
    line.set_markersize(15)
    line.set_linewidth(4)

# Cálculo del sistema en lazo cerrado con una ganancia constante
K = 20
LC1 = feedback(K*FTLA,1)
# Simulación de la respuesta al escalón
y, t = step(LC1)

# Gráfico de la respuesta al escalón
plt.figure()
plt.plot([t[0], t[-1]], [1, 1], '--k', linewidth=2)  # Línea de referencia del escalón
plt.plot(t, y, 'b', linewidth=2)                     # Respuesta al escalón
plt.ylabel('Salida')
plt.xlabel('Tiempo')
plt.legend(['Escalón', 'Respuesta'])
plt.show()

