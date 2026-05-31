using Genie, Genie.Router, Genie.Renderer.Html, Genie.Requests, Statistics

# -----------------------------
# Global state
# -----------------------------
const player_guesses = Dict{String,Int}()
const player_scores = Dict{String,Int}()

# -----------------------------
# Common CSS for intimidation
# -----------------------------
const CSS = """
<style>
body {
    background-color: #111;
    color: #f00;
    font-family: 'Courier New', monospace;
    text-align: center;
}
h1, h2 {
    color: #ff0000;
    text-shadow: 2px 2px #000;
}
form {
    margin: 20px auto;
    padding: 20px;
    background-color: #222;
    border: 2px solid #f00;
    width: 300px;
    border-radius: 10px;
}
input[type='submit'] {
    background-color: #f00;
    color: #000;
    font-weight: bold;
    border: none;
    padding: 8px 16px;
    margin-top: 10px;
    cursor: pointer;
}
input[type='number'], input[name='player'] {
    width: 80%;
    padding: 5px;
    margin-top: 5px;
}
.card {
    background-color: #222;
    border: 2px solid #f00;
    padding: 10px;
    margin: 10px auto;
    width: 200px;
    border-radius: 8px;
}
.alert {
    color: yellow;
    font-weight: bold;
}
</style>
"""

# -----------------------------
# Helpers
# -----------------------------
function get_player()
    pname = getcookie("player")
    return pname == "" ? nothing : pname
end

# -----------------------------
# Homepage / Login
# -----------------------------
route("/") do
    player = get_player()
    if player != nothing
        redirect("/guess")
    else
        html(CSS * """
        <h1>King of Diamonds</h1>
        <form action="/login" method="POST">
            Name: <input name="player" required>
            <input type="submit" value="Enter">
        </form>
        """)
    end
end

route("/login", method="POST") do
    pname = params("player")
    setcookie("player", pname)
    if !haskey(player_scores, pname)
        player_scores[pname] = 0
    end
    redirect("/guess")
end

# -----------------------------
# Guess submission
# -----------------------------
route("/guess") do
    pname = get_player()
    if pname == nothing
        redirect("/")
    end
    current_guess = get(player_guesses, pname, "")
    html(CSS * """
    <h2>Welcome, $pname</h2>
    <div class="card">
        <p>Current guess: $(current_guess)</p>
        <form action="/submit_guess" method="POST">
            Guess (0-100): <input name="guess" type="number" min="0" max="100" required>
            <input type="submit" value="Submit">
        </form>
        <p>Your score: $(player_scores[pname])</p>
    </div>
    """)
end

route("/submit_guess", method="POST") do
    pname = get_player()
    if pname != nothing
        guess = parse(Int, params("guess"))
        player_guesses[pname] = guess
    end
    redirect("/guess")
end

# -----------------------------
# Admin page
# -----------------------------
route("/admin") do
    # Get all guesses
    guesses = [v for v in values(player_guesses) if v !== nothing]

    # Count duplicates
    counts = Dict{Int,Int}()
    for g in guesses
        counts[g] = get(counts,g,0) + 1
    end

    # Identify valid guesses
    valid_guesses = [g for g in guesses if counts[g] == 1]
    duplicates = [p for (p,g) in player_guesses if g !== nothing && counts[g] > 1]

    # Compute X
    x = isempty(valid_guesses) ? 0.0 : mean(valid_guesses) * 0.8

    # Update scores
    distances = Dict{String,Float64}()
    for (p,g) in player_guesses
        if g !== nothing && counts[g] == 1
            distances[p] = abs(g - x)
        else
            player_scores[p] -= 1  # Duplicate or missing guess loses point
        end
    end

    winner_name = "No valid winner"
    if !isempty(distances)
        winner_idx = findmin(collect(values(distances)))[2]
        winner_name = collect(keys(distances))[winner_idx]
        player_scores[winner_name] += 1
    end

    # Show scores and duplicates
    duplicate_msg = isempty(duplicates) ? "" : "<p class='alert'>Duplicate guesses invalidated: $(join(duplicates, ", "))</p>"

    html(CSS * """
    <h1>Round Result</h1>
    <p>X = $x</p>
    <p>Winner: $winner_name</p>
    $duplicate_msg
    <h2>Scores:</h2>
    $(join(["<div class='card'>$p: $(player_scores[p])</div>" for p in keys(player_scores)], "\n"))
    <form action="/reset" method="POST">
        <input type="submit" value="Next Round">
    </form>
    """)
end

# -----------------------------
# Reset for next round
# -----------------------------
route("/reset", method="POST") do
    empty!(player_guesses)
    redirect("/guess")
end

# -----------------------------
# Start Genie
# -----------------------------
up(8000; listen_ip="0.0.0.0")
