# README

- `main.m` is the main file; all experiment results are generated from this file.
- `fedsarsa.m` is the main algorithm file. It recovers the FedTD algorithm when using a degenerate `policy.m`, and recovers (on-policy) Q-learning when using an argmax `policy.m`. See also branches `fedtd` and `ql` for implementations of different `policy.m`.
- Utils
    - `mdp_gen.m` generates heterogeneous MDP models
    - `feature_gen.m` generates feature vectors for each state-action pair.
    - `feature_map.m` maps the feature space to the state-action space.
    - `policy.m` is the policy operator, e.g., softmax.
- Misc
    - `plot_err.m` plots the error with confidence region (depending on `varplot.m`) of the learning process
    - `basic_TD.m`, `fedTD.m`, `fedTD_batch.m` and `fedTD_test.m` should be deprecated as `fedsarsa.m` recovers all of them.
    - `batch_mdp_perturb.m` and `markov_pertub.m` are for the same purpose as `mdp_gen.m`, and should be deprecated
