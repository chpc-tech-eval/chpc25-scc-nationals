function monteCarloPi_visualize(N)
% Comments in MATLAB are denoted using '%'
% N is the number of samples above where function monteCarloPiVis(N) is declared
% D is the canvas for the plot
D = 1000;

% points are the ones we mark for plotting purposes
% points is initialized to D x D array or "grid"" of zeroes
points = zeros(D);

% Initialize the number of points which satisfy the "within circle radius" check
count = 0;

% Plotting utilities
fig = gcf;
figure(gcf);

% Monte Carlo "for loop", iterating over N samples
% Simplified version without plotting utilities described in the next section.
for i = 1:N
    if mod(i, 5E3) == 0
        colormap([1 1 1; 1 0 0; 0 1 0; 0 0 1]);
        image(points);
        title(sprintf( 'pi=%f', 4*(count/i)));
        pause(0.02)
    end
    x = rand();
    y = rand();
    r = sqrt(x^2 + y^2);
    if r <= 1.0
        points(round(x*(D-1))+1, round(y*(D-1)+1)) = 2;
        count = count + 1;
    else
        points(round(x*(D-1))+1, round(y*(D-1)+1)) = 4;
    end
end
