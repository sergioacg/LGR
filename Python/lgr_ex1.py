# Sergio Andres Castaño Giraldo
# https://www.youtube.com/@SergioACGiraldo
# https://controlautomaticoeducacion.com/

import numpy as np
import matplotlib.pyplot as plt
from control.matlab import *

G = tf(1,[1, 3, 2, 0])
rlocus(G)
plt.show()
#Lazo cerrado
k = 6;  # 0 - 0.38 Respuesta no oscilatoria
         # 6 llego al eje imaginario
H = feedback(k*G,1);
plt.figure(1)
pzmap(H)
plt.show()
plt.figure(2)
y, t = step(H)
plt.plot(t, y)
plt.show()