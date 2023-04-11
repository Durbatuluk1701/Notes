# Coding AlphaZero

## Introduction

There are two main parts, **self-play** and **training**. The self-play part will generate data that can be used by the training part, to generate a new model for more self-play. 
This cyclic format can go on infinitely to continuously improve the model.

$f_{\theta}(s) = (p,v)$

The input state $s$ is applied to a function, that will yield a policy $p$ and value $v$.


## Monte Carlo Tree Search

Here are the steps for one whole iteration of the Monte Carlo Tree Search Process
1. Selection \(Walk down until a leaf node, **NOTE**, leafs are slightly different here, as leaf means that we have the possibility of creating another child node\)
2. Expansion \(Create a new node, as a child of the previously mentioned leaf node\)
3. Simulation \(Play randomly: starting at your new node, play until the "game" ends. These actions should be completely random, and they do not have to follow a "path" in the search tree\)
4. Backpropagation \(Propagate back the win or loss information, as well as visits \)


The tree is setup where possible states are Nodes, and actions are connections between nodes.
Each node has a visit count, and a win count. The higher the ratio of $win/visit$, the better the algorithm's performance

We have a function **UCB** defined as $UCB = \frac{w_i}{n_i} + C \sqrt{\frac{\ln N_i}{n_i}}$ 
where $w_i = $ win count for node $i$, and $n_i = $ the visit count for node $i$. $N_i$ is the visit count for all nodes, and $C$ is a tuning variable \(or possibly the number of possible branches\).

**Notes:**
- When in step 1. to decide how to walk down the tree you need to calculate the $UCB$ scores for each child to decide which step to immediately take next


### AlphaZero Monte Carlos Tree Search

**Primary Differences**
- The UBC formula is updated, $UBC = \frac{w_i}{n_i} + p_i \cdot C \cdot \frac{\sqrt{N_i}}{1 + n}$, where $p_i$ is the policy value that is associated with each node now
- We now longer play simulations randomly to the end of a game
- The policy is a tuple with different values for each possible action moving forward. If a Node has $n$ possible children, it will have $n$ actions, and policy will be a $n$ -tuple
- The backpropagation step will update the winning values based upon the value $v$ output of $f_{\theta}(s)$

### Self-Play

1. Perform a MCTS \( Monte Carlo Tree Search \)
2. Act based upon MCTS
3. Switch sides, and repeat
4. Finish once game ends or timeout

After self-play is completed, we want to add the \(state, MCTS-distribution, reward \) tuple to our Training Data \( so we do not have to repeat again \)

### Training

- $s, \pi, z = $ Sample \( take a sample from our training data \)
- $f_{\theta}(s) = (p,v)$, \( get output from our model $f_{\theta}$ \)
- $l = (z - v)^2 - \pi^T \cdot \log\ p + c \cdot || \theta ||^2$ \( minimize our losses via back-propagation \)