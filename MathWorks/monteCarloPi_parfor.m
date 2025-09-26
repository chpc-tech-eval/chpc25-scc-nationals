function monteCarloPi_parfor( N, M )
  tic
  ticBytes(gcp)
  % Maximum number of workers (threads) running in parallel
  % Use M=0 for serial, single core run
  M = <NUM_CORES>
  count = 0;
  parfor( i=1:N, M )
    x = rand();
    y = rand();
    r = sqrt(x^2 + y^2);
    if r < 1
      count = count + 1;
    end
  end
  estimatePi = 4*count/N;
  timeTaken = toc;
  dataTransfered = tocBytes(gcp);

  fprintf("Estimate for pi is %.8f after %f seconds\n" with %f Bytes transfered between worker nodes, estimatePi, timeTaken, dataTransfered)
  fprintf("Absolute error is %8.3e\n", abs( estimatePi-pi ))
end
