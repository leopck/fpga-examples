# fpga-examples

Just basic examples for FPGAs

## Example

1. heuristic-based traffic light
    - Dynamic cost function
    - Stateful wait tracking
    - Decision based on score
    - Fairness / anti-starvation
    - Adaptivity to traffic
    - Optimization objective (implicit)
    - Stochastic modeling
    - Real-time scheduling (event driven)
    Output:
        - Smooth adaptation to load: switching to NS or EW as their urgency rises.
        - Fairness: Alternates when scores are equal.
        - Non-starvation: EW or NS gets their turn eventually as wait_age inflates their score.
        - Short neutral phases: shows that you're not immediately flipping state