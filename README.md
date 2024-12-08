# README

## Algorithms

- `fedsarsa.m` FedSARSA for three methods
- `basic_TD.m` TD learning for a single agent
    - includes mean-path, iid, and Markovian
- `fedTD.m` FedTD for three methods


## Utils

- `mdp_gen.m` generates heterogeneous MDP models
    - `batch_mdp_perturb.m` and `markov_pertub.m` are for the same purpose, but should be deprecated
- `feature_gen.m` generates feature vectors for each state-action pair.
- `feature_map.m` maps the feature space to the state-action space.
- `policy.m` is the policy operator, e.g., softmax.

## Misc

- `plot_err.m` plots the error with confidence region (depending on `varplot.m`) of the learning process
