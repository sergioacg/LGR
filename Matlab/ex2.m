%% Sergio Andres Castaño Giraldo
% https://www.youtube.com/@SergioACGiraldo
% https://controlautomaticoeducacion.com/

clc
close all
clear all
% Definición de los parámetros de la función de transferencia
Kp = -1;
z1 = -1;
z2 = -3;
a = 1;
b = 2;
c = 5;
d = 7;

% Creación de la función de transferencia de lazo abierto
B = 2* Kp * conv([1, z1], [1, z2]);
A = conv(conv(conv([1, a], [1, b]), [1, c]), [1, d]);
FTLA = tf(B, A);

% Generación del Lugar Geométrico de las Raíces (LGR)
figure;
rlocus(FTLA);
r = findobj(gca,'type','line');
set(r,'markersize',15,'linewidth',4);
axis([-10 10 -6 6])
title('Lugar Geométrico de las Raíces (LGR) de la Función de Transferencia');
xlabel('Parte Real');
ylabel('Parte Imaginaria');

%% Polos Adyacentes
term1 = conv(B,polyder(A))
term2 = conv(A,polyder(B))

adyacente = term1 - term2

roots(adyacente)

%% \cruce en el eje imaginario

% %incognitas = w,k
% % x = [w, k]
F = @(x) [x(1)^4 + (2*x(2)-73)*x(1)^2+70-6*x(2);  %Ecuación 1
          -15*x(1)^3 + (129+8*x(2))*x(1)]; % Ecuacion 2
      
x0 = [1;1]; %Condicion inicial
x = fsolve(F, x0);

% Mostrar la solución
disp('Solución encontrada 1:');
disp(['ω = ', num2str(x(1))]);
disp(['K = ', num2str(x(2))]);

x0 = [5;29]; %Condicion inicial 2
x = fsolve(F, x0);

% Mostrar la solución
disp('Solución encontrada 2:');
disp(['ω = ', num2str(x(1))]);
disp(['K = ', num2str(x(2))]);

%% Respuesta Dinámica
K = 12;
FTLC = feedback(K*FTLA, 1)
[y,t] = step(FTLC);
figure
plot([t(1) t(end)],[1 1], '-r', t, y, 'b', 'linewidth', 2)
ylabel('Salida')
xlabel('tiempo')
legend('Escalón', 'Respuesta')

figure
pzmap(FTLC)
r = findobj(gca,'type','line');
set(r,'markersize',15,'linewidth',4);

