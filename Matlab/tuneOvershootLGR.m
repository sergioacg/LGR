function K_optimal = tuneOvershootLGR(FTLA, PO_desired, plotFlag)
    % TUNE OVERSHOOT LGR
    %
    % Function to set a desired percentage overshoot in a closed-loop system using root locus.
    %
    % Syntax: K_optimal = tuneOvershootLGR(FTLA, PO_desired, plotFlag)
    %
    % Inputs:
    %    FTLA - Open loop transfer function of the system
    %    PO_desired - Desired percentage overshoot
    %    plotFlag - Boolean flag to control plotting (true for plotting, false otherwise)
    %
    % Outputs:
    %    K_optimal - Optimal gain to achieve the desired percentage overshoot
    %
    % Example:
    %    K_optimal = tuneOvershoot(FTLA, 10, true)
    %
    % Author: Sergio Andres Castaño Giraldo
    % Website: https://www.youtube.com/@SergioACGiraldo
    %          https://controlautomaticoeducacion.com/
    % Date: 27/03/2024

    % Check if plotFlag is provided, otherwise set to false
    
    if nargin < 3
        plotFlag = false;
    end

    % Plot Root Locus if plotFlag is true
    if plotFlag
        figure;
        rlocus(FTLA);
        grid on;
        r = findobj(gca,'type','line');
        set(r,'markersize',15,'linewidth',4);
    end

    % Optimization to find the gain K that minimizes the cost function
    options = optimset('TolX',1e-4,'TolFun',1e-4, 'MaxFunEvals', 6000, 'MaxIter', 6000);
    K_initial_guess = 0.1; % Initial guess for the gain K

    % Iterate up to 10 times to find the optimal K
    for i = 1:10
        % Perform optimization to find K that minimizes the overshoot cost
        [K_optimal, fval] = fminsearch(@(K) overshoot_cost(K, FTLA, PO_desired), K_initial_guess, options);

        % Check if the absolute value of the function value (fval) is greater than 0.1
        % If so, it suggests that the current guess is far from optimal, and we increase it
        if abs(fval) > 0.1
            K_initial_guess = K_initial_guess * 5;  % Increase the initial guess to expedite convergence
        else
            break; % Exit the loop if the cost function is close enough to the desired value
        end
    end


    % Display optimal gain K
    disp(['Optimal gain K for an overshoot of ', num2str(PO_desired), '% is: ', num2str(K_optimal)]);

    % Plot step response and pole-zero map if plotFlag is true
    if plotFlag
        figure
        H = feedback(K_optimal*FTLA,1);
        step(H);
        title('Step Response of the Closed-loop System');

        figure
        pzmap(H);
        title('Pole-Zero Map of the Closed-loop System');
        r = findobj(gca,'type','line');
        set(r,'markersize',15,'linewidth',4);
    end

    function cost = overshoot_cost(K, FTLA, PO_desired)
    % Local function to calculate the cost based on the percentage overshoot
    % for a given gain K in the feedback system defined by FTLA.
    
        % Create closed-loop system with gain K
        H = feedback(K*FTLA, 1);

        % Simulate step response of the closed-loop system
        y = step(H);

        % Determine the final value and maximum value of the step response
        valor_final = y(end);
        valor_maximo = max(y);

        % Calculate the actual percentage overshoot
        PO_actual = (valor_maximo - valor_final) / valor_final * 100;

        % Calculate cost based on the difference between actual and desired overshoot
        % Include a penalty factor if actual overshoot is less than the desired overshoot
        if PO_actual < PO_desired
            % The penalty is applied by multiplying the squared difference by 10
            % This makes the cost significantly higher for overshoots below the desired level,
            % encouraging the optimizer to avoid solutions with too little overshoot.
            cost = (PO_actual - PO_desired)^2 * 10;
        else
            % For overshoots equal to or greater than the desired level, use the squared difference
            % as the cost, which naturally guides the optimizer towards the desired overshoot.
            cost = (PO_actual - PO_desired)^2;
        end
    end

end
