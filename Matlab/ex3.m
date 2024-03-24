clc
clear all
close all

%polos
p1 = -0.5+0.5j;
p2 = -0.5-0.5j;
p3 = -3;
p4 = -5;

%ceros
z1 = -1;
z2 = -2;

%funcion de transferencia feedforward
ng = 1;
dg = poly([p1 p2]);
G = tf(ng, dg);

%funcion de transferencia feedback
nh = poly([z1 z2]);
dh = poly([p3 p4]);
H = tf(nh, dh);


%funcion de transferencia de lazo abierto
FTLA = series(G, H);

% Grafica del LGR
figure
rlocus(FTLA)
title('Lugar Geométrico de las Raíces')
r = findobj(gca,'type','line');
set(r,'markersize',13,'linewidth',4);

%% Polos Adyacentes
[B, A] = tfdata(FTLA,'v');
term1 = conv(B,polyder(A))
term2 = conv(A,polyder(B))

% Asegurarse de que los polinomios tengan la misma longitud
max_length = max(length(term1), length(term2))
term1 = [zeros(1, max_length - length(term1)), term1]
term2 = [zeros(1, max_length - length(term2)), term2]

adyacente = term1 - term2

roots(adyacente)

%% Comparación de lazo cerrado con el LGR
k = 20;
LC1 = feedback(k*G,H); %Lazo cerrado del ejemplo
zpk(LC1)
figure
subplot(1,2,1)
pzmap(LC1)
title('Plano de polos y ceros SIN realimentación unitaria')
r = findobj(gca,'type','line');
set(r,'markersize',13,'linewidth',4);

%Lazo Cerrado 2
LC2 = feedback(k*FTLA, 1); %Lazo cerrado hipotetico si estubiera en lazo convencional
zpk(LC2)
subplot(1,2,2)
pzmap(LC2)
title('Plano de polos y ceros CON realimentación unitaria')
r = findobj(gca,'type','line');
set(r,'markersize',13,'linewidth',4);

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
