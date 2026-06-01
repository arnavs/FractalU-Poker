# FractalU: Build a Poker AI Bot

I'm teaching a class on building a Poker AI bot. Details are below; to signup send an email to [`arnavs@alumni.cmu.edu`](mailto:arnavs@alumni.cmu.edu).

My bio: [Arnav Sood](https://arnavsood.com). I'm a 5th year Econ PhD student at [Carnegie Mellon](https://www.cmu.edu), a data scientist intern at [Revelio Labs](https://reveliolabs.com), and a former open-source econ developer at [QuantEcon](https://quantecon.org). My thesis is on learning and deception involving "behavioral" (not strictly rational) economic agents.

tl/dr
  - **Time**: Sundays 2:00-4:00PM. 
  - **Class**: Build a Poker AI Bot. 
  - **Duration**: 6 weeks, from 7.5.26 to 8.9.26.
  - **Location**: 99 Hudson St., Jersey City (right across from WTC on PATH), **or remote, if you need**
    - you can use the building amenities (coworking space, gym, pool, etc.) as long as I'm around
  - **Cost**: $140 (scholarship), $230 (standard), $320 (supporter). Send me an email at [`arnavs@alumni.cmu.edu`](mailto:arnavs@alumni.cmu.edu) if none of these work.

### Summary 

Over 6 weeks, we're going to build a bot to play a variant of poker. By the end, you'll have learned the underlying theory and have a functioning bot. After the class I'll test the bots against each other and give a prize to the top bots.

Our variant is heads-up (1v1) with a reduced deck (27 cards, A-9 for 3 suits, where A can be either high or low). See the full rules [here](https://github.com/cmu-dsc/poker-engine-2026/blob/main/docs/rules.md). The twist is that instead of normal poker, each player gets **five** cards preflop, at which point they discard 3 and show it to the other person. You can use whatever approach you want (i.e., game theory, reinforcement learning, etc.)

If none of that makes sense: it's okay! I'm not assuming any poker knowledge. The first class is going to be about the basics of the game, but you can already see the basic strategic decisions (I discard cards to make my best hand, but what I discard tells my opponent about what I have, etc.)

What makes poker different from chess is the role of "higher order beliefs." Unlike chess, there's private information. And what matters is what I have, what I think about you have, what you think about what I have, what I think about what you think I have, etc. And the signaling about these things is the heart of the game. 

### Requirements

You should have **some familiarity** with Python coding (but you don't need to work as a software engineer or have majored in CS, for example.) Experience with math/stats/econ and git/commandline is a plus, but not a requirement. **No prior poker experience is required**. 

You should be willing to learn and work hard. The course is fast-paced, and you'll get out what you put in. 

### Class Format 

Each class will be 1.5 hours of new material, followed by at least 0.5 hours of coworking and "office hours." (There's no hard stop after 0.5 hours.) 

Office hours are a good time to get help from me (and other students) on your individual projects. 

There will be homework, but no grades. 

Once everyone is registered, I'll add you all to this repo and make it private. The GitHub will be our main digital space/sandbox. 

After the class is over, anyone who wants to can remove their material or interim products, and I'll make it public again. 

### Syllabus 

Exact topics and order subject to change. **Don't worry if stuff in links seems too advanced**; it's just a reference.

| Class | Topic | References |
| -------- | ------- | ------- | 
| Week 1 (7.5.26) | Rules of Poker, setup and tooling | N/A |
| Week 2 (7.12.26) | Game Theory and Nash Equilibrium | Osborne & Rubinstein, *A Course in Game Theory* (Ch. 1–4); Zinkevich et al. (2007), "Regret Minimization in Games with Incomplete Information"; Shoham & Leyton-Brown, *Multiagent Systems* (Ch. 3–4) |
| Week 3 (7.19.26) | Human Poker Strategies | Sklansky, *The Theory of Poker* (Ch. 1–5); Chen & Ankenman, *The Mathematics of Poker*; Negreanu, *Hold'em Wisdom for All Players* |
| Week 4 (7.26.26) | Statistics and Bayesian Learning | Billings et al. (2002), "The Challenge of Poker"; Gelman et al., *Bayesian Data Analysis* (relevant chapters) |
| Remote: Week 5 (8.2.26) | ML Approaches | Nielsen, *Neural Networks and Deep Learning* (Ch. 1–2); Brown & Sandholm (2019), "Deep Counterfactual Regret Minimization" |
| Remote: Week 6 (8.9.26) | Frontier ML Approaches | Brown & Sandholm (2018), "Superhuman AI for heads-up no-limit poker: Libratus"; Brown & Sandholm (2019), "Superhuman AI for multiplayer poker: Pluribus"; Heinrich & Silver (2016), "Deep Reinforcement Learning from Self-Play in Imperfect-Information Games"; Schmid et al. (2023), "Student of Games" |
| Offline | Tournament | N/A |

<!-- [^1]: A bit on [what this means](https://paulromer.net/jupyter-mathematica-and-the-future-of-the-research-paper/), and an [example](https://github.com/QuantEcon/notebook-gallery/blob/main/ipynb/john_stachurski-coase.ipynb). -->