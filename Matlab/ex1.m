% Ejemplo 1
clc
close all
clear all

G = tf(1,[1 3 2 0]);
rlocus(G)
a = findobj(gca,'type','line');
set(a,'markersize',15,'linewidth',4);

%Lazo cerrado
k = 6; % 0 - 0.38 Respuesta no oscilatoria
         % 6 llego al eje imaginario
H = feedback(k*G,1);
figure
pzmap(H)
a = findobj(gca,'type','line');
set(a,'markersize',15,'linewidth',4);
figure
step(H)