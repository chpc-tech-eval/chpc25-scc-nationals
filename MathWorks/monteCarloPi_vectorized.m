function monteCarloPi_vectorized( N )
  tic;
  count = 0;

  xy = rand(N,2);
  count = sum( sum( xy.^2, 2 ) <= 1 );
  piEst = 4*count/N;
  timeTaken = toc;

%fprintf("Estimate for pi is %.8f after %f seconds using %f Bytes\n",piEst, timeTaken)
  fprintf("Absolute error is %8.3e\n",abs(piEst2-pi))
  fprintf("%.2f million samples per second\n", N/timeTaken/1e6)

end
