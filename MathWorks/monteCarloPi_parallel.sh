function monteCarloPi_parallel( N, M, numChunks )
  arguments
    % Configure default arguments
    N = 1e10;
    M = <MAX_WORKERS>;
    numChunks = 1e2;
  end

  tic;

  piEst = 0

  % Configure Parallel Computing environment
  % parpool can take on values of `local`, `Threads`, `Processes`
  % Experiment with these to determine the best results
  mpiSettings = parcluster('local');
  mpiSettings.NumWorkers = M;
  saveProfile(mpiSettings);
  parpool('local', M);

  xyStream = RandStream('Threefry');

  parfor( i=1:numChunks, M )
    count = 0;
    xy = rand(xyStream, N/numChunks, 2);
    count = sum( sum( xy.^2, 2 ) <=1 );
    piEst = piEst + 4*count/(N/numChunks);
  end

  timeTaken = toc;

  fprintf("Estimate for pi is %.8f after %f seconds using %f Bytes\n",piEst, timeTaken)
  fprintf("Absolute error is %8.3e\n",abs(piEst2-pi))
  fprintf("%.2f million samples per second\n", N/timeTaken/1e6)

  delete(parpoo)
end
