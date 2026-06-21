% Function to implement Simpson's rule
function integral = simpsons_rule(x, y)
    n = length(x) - 1;
    h = (x(end) - x(1)) / n;
    integral = y(1) + y(end);
    for j = 2:2:n
        integral = integral + 4 * y(j);
    end
    for j = 3:2:(n-1)
        integral = integral + 2 * y(j);
    end
    integral = integral * h / 3;
end
