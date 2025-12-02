% decideLoanEligibility_serial(customers)
% Input: customers table (as generated above)
% Output: decisions (Nx1 logical), reasonCodes (Nx1 cellstr), riskScore (Nx1 double)
% Reason codes examples: 'AGE', 'CREDIT', 'DEFAULT', 'EMPLOYMENT', 'INCOME', 'DTI', 'REQUEST_SIZE', 'RISK_OK'
function [decisions, reasonCodes, riskScore] = decideLoanEligibility_serial(customers)
N = height(customers);
decisions = false(N,1);
reasonCodes = repmat({''}, N, 1);
riskScore = zeros(N,1);
% Parameters
minAge = 21; maxAge = 75;
minCredit = 650;
minIncome = 20000;
maxDTI = 0.40;
maxRequestedToIncome = 4; % requested <= 4 * annual income
riskThreshold = 0.5;

for i = 1:N
    a = customers.Age(i);
    cs = customers.CreditScore(i);
    nd = customers.NumDefaults(i);
    ey = customers.EmploymentYears(i);
    inc = customers.AnnualIncome(i);
    debt = customers.ExistingDebt(i);
    req = customers.RequestedLoanAmount(i);
    % Rule checks
    if (a < minAge) || (a > maxAge)
        reasonCodes{i} = 'AGE';
        decisions(i) = false; continue;
    end
    if cs < minCredit
        reasonCodes{i} = 'CREDIT';
        decisions(i) = false; continue;
    end
    if nd > 0
        reasonCodes{i} = 'DEFAULT';
        decisions(i) = false; continue;
    end
    if ey < 1
        reasonCodes{i} = 'EMPLOYMENT';
        decisions(i) = false; continue;
    end
    if inc < minIncome
        reasonCodes{i} = 'INCOME';
        decisions(i) = false; continue;
    end
    dti = debt / max(1, inc); % prevent divide by zero
    if dti > maxDTI
        reasonCodes{i} = 'DTI';
        decisions(i) = false; continue;
    end
    if req > maxRequestedToIncome * inc
        reasonCodes{i} = 'REQUEST_SIZE';
        decisions(i) = false; continue;
    end
    % compute simple normalized risk score
    % normalize features to [0,1] using presumed ranges
    f_credit = 1 - (cs - 300) / (850 - 300); % lower credit => higher risk
    f_income = 1 - min(1, inc / 200000); % lower income => higher risk
    f_dti = min(1, dti / 1.0); % higher dti => higher risk
    f_age = 1 - abs(a - 40) / 40; % age far from 40 -> slightly higher risk
    f_age = max(0, min(1, 1 - f_age)); % convert so bigger -> riskier
    % weights
    w = [0.4, 0.25, 0.25, 0.10];
    riskScore(i) = w(1)*f_credit + w(2)*f_income + w(3)*f_dti + w(4)*f_age;
    if riskScore(i) > riskThreshold
        reasonCodes{i} = 'RISK_HIGH';
        decisions(i) = false;
    else
        reasonCodes{i} = 'APPROVED';
        decisions(i) = true;
    end
end
end