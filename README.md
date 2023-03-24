# README

- `markov_gen.m` generates a MDP model
    - input: $|\mathcal{S}|$, $\gamma$, $d$
    - output: ~~fixed point~~, $P$, $r$, $\mu$, $\phi$
- `markov_pertub.m` generates a hetereogenious MDP models based on the given model
    - input: $(P,r,\gamma)$, $(\epsilon, \epsilon_1)$
    - output: 3d layers with each layer the same as markov_gen output
- `basic_TD.m`