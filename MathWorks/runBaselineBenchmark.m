% runBaselineBenchmark(N, seed)
% Generates N customers, runs the serial decision function, times it, and reports throughput
function results = runBaselineBenchmark(N)
if nargin < 1
N = 1e5; % default 100k
end
fprintf('Generating %d customer records...\n', N);
customers = generateCustomers(N);
fprintf('Running baseline serial decision engine...\n');
tic;
[decisions, reasonCodes, riskScore] = decideLoanEligibility_serial(customers);
elapsed = toc;
throughput = N / elapsed;
numAccepted = sum(decisions);
fprintf('Elapsed: %.3f s, Throughput: %.1f decisions/s, Accepted: %d (%.2f%%)\n', ...
elapsed, throughput, numAccepted, 100 * numAccepted/N);

results.N = N;
results.elapsed = elapsed;
results.throughput = throughput;
results.decisions = decisions;
results.reasonCodes = reasonCodes;
results.riskScore = riskScore;
end