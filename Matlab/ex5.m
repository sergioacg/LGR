clc
clear all
close all

% Definición de los parámetros de la función de transferencia

z1 = 3+3j;
z2 = 3-3j;
p1 = 1+j;
p2 = 1-j;
p3 = 0;


% Creación de la función de transferencia de lazo abierto
B = conv([1, z1], [1, z2]);
A = conv(conv([1, p1], [1, p2]), [1, p3]);
FTLA = tf(B, A);

% Generación del Lugar Geométrico de las Raíces (LGR)
figure;
rlocus(FTLA);
r = findobj(gca,'type','line');
set(r,'markersize',15,'linewidth',4);
% axis([-10 10 -6 6])
title('Lugar Geométrico de las Raíces (LGR) de la Función de Transferencia');
xlabel('Parte Real');
ylabel('Parte Imaginaria');

%% Feedback
k = 20;
LC1 = feedback(k*FTLA, 1);
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



%% incognitas = w,k
% % x = [w, k]
F = @(x) [-x(1)^2*(2+x(2))+18*x(2);  %Ecuación 1
          -x(1)^3+2*x(1)+6*x(1)*x(2)]; % Ecuacion 2
      
x0 = [25;25]; %Condicion inicial
x = fsolve(F, x0)


