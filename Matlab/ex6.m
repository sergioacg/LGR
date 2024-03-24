clc;
clear;
close all;

% Parámetros de la función de transferencia
a = 0;
b = 1;

% Amortiguamiento deseado
Mp = 3.5;
zeta =sqrt(((log(Mp/100))^2)/(pi^2+((log(Mp/100))^2))) 
theta = acosd(zeta); % Ángulo de la línea de amortiguamiento

% Crear función de transferencia
A = conv([1, a], [1, b]);
B = 1;
FTLA = tf(B, A);

% Visualización del Lugar Geométrico de las Raíces (LGR)
figure;
rlocus(FTLA);
grid on;
r = findobj(gca, 'type', 'line');
set(r, 'markersize', 15, 'linewidth', 4);

% Preasignación de la matriz de datos para almacenar los resultados
K_range = 0:0.01:10;
j = 1; %Indice de los datos encontrados
data = zeros(10, 3);

% Bucle para encontrar la ganancia K que se aproxima al ángulo deseado
for K = K_range
    [r, ~] = rlocus(FTLA, K); % Calcula los polos para la ganancia K
    for i = 1:length(r)
        polo = r(i);
        sigma = -real(polo);
        omega = abs(imag(polo));
        % Calcula la diferencia en ángulo con respecto a la línea de amortiguamiento
        costo = abs(atand(omega / sigma) - theta);
        % Comprueba si el polo está lo suficientemente cerca de la línea de amortiguamiento
        if omega ~= 0 && costo < 1e-1
            data(j,:) = [costo, K, polo];
            j = j + 1;
            break; % Sale del bucle después de encontrar un polo que cumple el criterio
        end
    end
end

% Eliminar filas donde todos los elementos son ceros
data = data(~all(data == 0, 2), :);

% Asegurarse de que se han encontrado datos válidos antes de proceder
if j > 1
    % Encuentra el conjunto de datos con el costo más bajo (mejor ajuste al ángulo deseado)
    [M, ind] = min(data(1:j-1,1)); % Solo considera las filas hasta j-1
    K_des = data(ind,2); % Ganancia K deseada
    polo_des = data(ind,3); % Polo correspondiente a la ganancia K deseada
    disp(['Intersección en K = ', num2str(K_des), ' con el polo ', num2str(polo_des)]);
else
    error('No se encontraron polos que cumplan con el criterio especificado.');
end

%% Análisis de la respuesta en lazo cerrado
% Tiempo de estabilización, Tss = 4 / (zeta * Wn)
% La parte real del polo (zeta * Wn) es negativa, por lo que se usa el valor absoluto
Tss = 4 / abs(real(polo_des)); 

%Tiempo de Pico, Tp = pi / (Wn * sqrt(1 - zeta^2))
%  (Wn * sqrt(1 - zeta^2)) ---> Es la parte imaginaria del polo
Tp = pi / imag(polo_des);
disp(['Tiempo de Estabilización = ', num2str(Tss), ' con tiempo de pico en = ', num2str(Tp)]);
                
% Simulación de la respuesta en lazo cerrado con la ganancia K deseada
H = feedback(K_des*FTLA,1);
figure;
step(H); % Visualización de la respuesta al escalón
