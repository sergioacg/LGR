# Grafica de LGR con polos y ceros

# importar librerias
import numpy as np
import matplotlib.pyplot as plt
from control.matlab import *

#polos 
p1 = -0.5+0.5j
p2 = -0.5-0.5j
p3 = -3
p4 = -5

#ceros
z1 = -1
z2 = -2

#funcion de transferencia feedforward
ng = 1
dg = np.poly([p1, p2])
G = tf(ng, dg)

#funcion de transferencia feedback
nf = np.poly([z1, z2])
df = np.poly([p3, p4])
H = tf(nf, df)

#funcion de transferencia de lazo abierto
FTLA = series(G, H)

#grafica de polos y ceros
plt.figure()
pzmap(FTLA)

#grafica de LGR
plt.figure()
rlocus(FTLA)

# Polos Adyacentes
B, A = FTLA.num[0][0], FTLA.den[0][0]
term1 = np.convolve(B, np.polyder(A))
term2 = np.convolve(A, np.polyder(B))

# Asegurarse de que los polinomios tengan la misma longitud
max_length = max(len(term1), len(term2))
term1 = np.pad(term1, (max_length - len(term1), 0), 'constant')
term2 = np.pad(term2, (max_length - len(term2), 0), 'constant')

adyacente = term1 - term2

print(np.roots(adyacente))

#calculo de lazo cerrado con ganancia constante
K = 1
LC1 = feedback(K*G, H)    
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



