import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import minimize
from control import tf, feedback, step_response, rlocus, pzmap

def overshoot_cost(K, FTLA, PO_desired):
    H = feedback(K * FTLA, 1)
    T, y = step_response(H)
    valor_final = y[-1]
    valor_maximo = np.max(y)
    PO_actual = (valor_maximo - valor_final) / valor_final * 100

    if PO_actual < PO_desired:
        cost = (PO_actual - PO_desired)**2 * 10
    else:
        cost = (PO_actual - PO_desired)**2
    return cost

def tuneOvershootLGR(FTLA, PO_desired, plotFlag=False):
    K_initial_guess = 0.1
    for i in range(10):
        result = minimize(overshoot_cost, K_initial_guess, args=(FTLA, PO_desired),
                          method='Nelder-Mead', options={'xatol': 1e-4, 'fatol': 1e-4, 'maxfev': 6000, 'maxiter': 6000})
        K_optimal = result.x[0]
        if result.fun < 0.1:
            break
        K_initial_guess *= 5

    print(f'Optimal gain K for an overshoot of {PO_desired}% is: {K_optimal}')

    if plotFlag:
        plt.figure()
        rlocus(FTLA)
        plt.grid(True)

        H = feedback(K_optimal * FTLA, 1)
        plt.figure()
        T, y = step_response(H)
        plt.plot(T, y)
        plt.title('Step Response of the Closed-loop System')

        plt.figure()
        pzmap(H, plot=True)  # Updated to use 'plot' instead of 'Plot'
        plt.title('Pole-Zero Map of the Closed-loop System')

        plt.show()

    return K_optimal

if __name__ == '__main__':
    z1 = 1.5
    a = 0
    b = 1
    c = 10

    A = np.polymul(np.polymul([1, a], [1, b]), [1, c])
    B = [1, z1]
    FTLA = tf(B, A)

    Mp = 10  # Desired percentage overshoot

    K_optimal = tuneOvershootLGR(FTLA, Mp, True)
