syms K w

% Definición de los parámetros de la función de transferencia
z1 = -1;
z2 = -3;
a = 1;
b = 2;
c = 5;
d = 7;

% Sustitución de s por jw en la ecuación característica
s = j*w;

% Ecuación característica
characteristic_eq = K * (s - z1) * (s - z2) - (s + a) * (s + b) * (s + c) * (s + d);

% Separar parte real e imaginaria
real_part = real(characteristic_eq);
imag_part = imag(characteristic_eq);

% Resolver el sistema de ecuaciones no lineales
solutions = solve([real_part == 0, imag_part == 0], [w, K]);

% Mostrar soluciones
disp(solutions)
