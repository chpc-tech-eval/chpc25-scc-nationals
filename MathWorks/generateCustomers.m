% generateCustomers(N, seed)
% Returns a table with N synthetic customer records.
% Fields: ID, Age, CreditScore, AnnualIncome, EmploymentYears,
% ExistingDebt, NumOpenLoans, NumDefaults, RequestedLoanAmount, LoanTermMonths
function customers = generateCustomers(N)
% ID
ID = (1:N)';

% Age: 21-75 (use skewed distribution)
Age = round(max(18, min(80, 35 + 12*randn(N,1))));
Age = max(18, min(80, Age));

% CreditScore: 300-850 (skewed)
CreditScore = round(300 + 550*betarnd(2,3,N,1)); % more mass at lower scores
CreditScore = min(850, max(300, CreditScore));

% AnnualIncome: log-normal to cover wide range
AnnualIncome = round(exp(10 + 0.8*randn(N,1))); % realistic distribution
AnnualIncome = max(5000, AnnualIncome); % floor

% Employment years
EmploymentYears = max(0, round(abs(8 + 5*randn(N,1))));
EmploymentYears = min(50, EmploymentYears);

% ExistingDebt (annual equivalent)
ExistingDebt = round( max(0, 0.2*AnnualIncome .* randn(N,1) + 0.2*AnnualIncome) );
ExistingDebt = max(0, ExistingDebt);

% NumOpenLoans
NumOpenLoans = poissrnd(1, N, 1);
NumOpenLoans = min(20, NumOpenLoans);

% NumDefaults (0 or 1-3)
NumDefaults = binornd(1, 0.05, N,1); % 5% have defaults

% RequestedLoanAmount: 0.1 * income to 5x income
RequestedLoanAmount = round( max(500, AnnualIncome .* (0.1 + 5*rand(N,1))) );
RequestedLoanAmount = min(RequestedLoanAmount, 10*AnnualIncome);

% LoanTermMonths
LoanTermMonths = randi([12, 84], N, 1);

customers = table(ID, Age, CreditScore, AnnualIncome, EmploymentYears, ...
ExistingDebt, NumOpenLoans, NumDefaults, RequestedLoanAmount, LoanTermMonths);
end