function monteCarloPi(N)
% N is number of samples

tic
count = 0;
for i=1:N
    x = rand();
    y = rand();
    r = sqrt(x^2 + y^2);
    if r<1
        count = count + 1;
    end
end
estimatePi = 4*count/N;
timeTaken = toc;

fprintf("Estimate for pi is %.8f after %f seconds\n", estimatePi, timeTaken)
fprintf("Absolute error is %8.3e\n", abs( estimatePi-pi ))
fprintf("%.2f million samples per second\n", N/timeTaken/1e6 )
end
