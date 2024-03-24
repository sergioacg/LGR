%% Sergio Andres Castaño Giraldo
% https://www.youtube.com/@SergioACGiraldo
% https://controlautomaticoeducacion.com/

% Limpia el entorno de MATLAB, borrando todas las variables y cerrando todas las figuras
clc
clear all
close all

% Define la función de transferencia G utilizando la función de convolución para los polinomios del numerador y denominador
G = tf(conv([1 2],[1 3]),conv([1 -1+j],[1 -1-j]));
% Define la función de transferencia H como 1 (sistema de control de un solo lazo)
H = 1;

% Conecta en serie las funciones de transferencia G y H
FTLA = series(G,H);
% Crea una nueva figura
figure;
% Traza el mapa de polos y ceros de FTLA
pzmap(FTLA);
% Encuentra todos los objetos de tipo 'line' en los ejes actuales
r = findobj(gca,'type','line');
% Establece el tamaño de los marcadores y el grosor de las líneas para estos objetos
set(r,'markersize',15,'linewidth',4);

% Crea otra nueva figura
figure;
% Traza el lugar geométrico de las raíces de FTLA
rlocus(FTLA);
% Encuentra todos los objetos de tipo 'line' en los ejes actuales
r = findobj(gca,'type','line');
% Establece el tamaño de los marcadores y el grosor de las líneas para estos objetos
set(r,'markersize',15,'linewidth',4);
% Define una ganancia K
K=20;
% Calcula la función de transferencia del sistema en lazo cerrado con la ganancia K
LC1 = feedback(K*FTLA,1);

% Calcula la respuesta al escalón del sistema en lazo cerrado LC1
[y,t] = step(LC1);

% Crea otra nueva figura
figure
% Traza la línea de referencia del escalón y la respuesta al escalón del sistema
plot([t(1) t(end)],[1 1], '--k', t, y, 'b', 'linewidth', 2)
% Etiqueta el eje Y como 'Salida'
ylabel('Salida')
% Etiqueta el eje X como 'Tiempo'
xlabel('tiempo')
% Añade una leyenda al gráfico
legend('Escalón', 'Respuesta')

%% Polos Adyacentes
[B, A] = tfdata(FTLA,'v')
term1 = conv(B,polyder(A))
term2 = conv(A,polyder(B))

adyacente = term1 - term2

roots(adyacente)
