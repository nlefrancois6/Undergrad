function plotSolutions(g0, u_exact, u)
%Plot the input, output, exact solution of test case, and error for FACR
%Poisson solver

    subplot(2,2,1);
    s1 = surf(g0);
    s1.EdgeColor = 'none';
    title('Source Term, g')
    xlabel('X');
    ylabel('Y');
    
    subplot(2,2,2);
    s2 = surf(u_exact);
    s2.EdgeColor = 'none';
    title('Exact Solution to Laplace(u) = g, u')
    xlabel('X');
    ylabel('Y');
    
    subplot(2,2,3);
    s3 = surf(u);
    s3.EdgeColor = 'none';
    title('Numerical Solution to Laplace(u) = g, u')
    xlabel('X');
    ylabel('Y');
    
    subplot(2,2,4);
    s4 = surf(u-u_exact);
    s4.EdgeColor = 'none';
    title('Error From Exact Solution to Laplace(u) = g, u')
    xlabel('X');
    ylabel('Y');
end

