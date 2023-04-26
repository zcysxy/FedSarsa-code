function a_ind = policy(values, L) %(phi, theta, s)
    % Output an action based on the approximated value function
    
    %% Softmax
    % n = 100;
    % as = rand(n,1);
    % % random sample some candidate actions
    % values = phi(s, as)' * theta;

    % a_ind = randsample(1:length(values), 1, true, softmax(values, 1));
    % [~, a_ind] = max(values);

    %% Plain
    mean_value = mean(values);
    normed_values = values - mean_value;
    min_value = -min(normed_values) * L;
    if min_value > 1
        new_values = (1 + normed_values / min_value) / length(values);
    else
        new_values = (1 + L * normed_values) / length(values);
    end
    a_ind = find(cumsum(new_values) > rand(1), 1);