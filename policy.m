function a_ind = policy(values) %(phi, theta, s)
    % Output an action based on the approximated value function

    % n = 100;
    % as = rand(n,1);
    % % random sample some candidate actions
    % values = phi(s, as)' * theta;

    a_ind = randsample(1:length(values), 1, true, softmax(values, 1));
    % [~, a_ind] = max(values);