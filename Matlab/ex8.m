clc;
clear all;
close all

% Parámetros de la función de transferencia
z1 = 1.5;
a = 0;
b = 1;
c = 10;

% Crear función de transferencia
A = conv(conv(conv([1, a], [1, b]), [1, c]), 1);
B = [1, z1];
FTLA = tf(B, A);

Mp = 10; % Sobrepaso máximo como porcentaje

K_optimal = tuneOvershootLGR(FTLA, Mp, 1)