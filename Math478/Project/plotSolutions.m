function plotSolutions(g0, u_exact, u)
%Plot the input, output, exact solution of test case, and error for FACR Poisson solver

    subplot(2,2,1);
    s1 = surf(g0);
    s1.EdgeColor = 'none';
    title('a) Source Term, p', 'FontSize', 16)
    xlabel('X');
    ylabel('Y');
    
    subplot(2,2,2);
    s2 = surf(u_exact);
    s2.EdgeColor = 'none';
    title('b) Exact Solution to Laplace(u) = p, u', 'FontSize', 16)
    xlabel('X');
    ylabel('Y');
    
    subplot(2,2,3);
    s3 = surf(u);
    s3.EdgeColor = 'none';
    title('c) Numerical Solution to Laplace(u) = p, u', 'FontSize', 16)
    xlabel('X');
    ylabel('Y');
    
    subplot(2,2,4);
    s4 = surf(u-u_exact);
    s4.EdgeColor = 'none';
    title('d) Error From Exact Solution to Laplace(u) = p, u', 'FontSize', 16)
    xlabel('X');
    ylabel('Y');
end

