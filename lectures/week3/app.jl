using Genie, Genie.Router, Genie.Renderer.Html, Statistics

Genie.config.run_as_server = true

# --------------# --------------------
# Game configuration
# --------------------

const PLAYERS = [
    (:p1, "Samira"),
    (:p2, "Alex"),
    (:p3, "Matt"),
    (:p4, "Kruti"),
    (:p5, "Denis")
]

scores = Dict(id => 0 for (id, _) in PLAYERS)
eliminated_players = Set{Symbol}()  # Track eliminated players

duplicate_rule_active = Ref(false)

# --------------------
# Routes
# --------------------

route("/") do
    html("""
    <html>
    <head>
        <title>King of Diamonds</title>
        <style>
            body {
                background: radial-gradient(circle at top, #1b1b1b, #000);
                color: #e0e0e0;
                font-family: 'Segoe UI', Arial, sans-serif;
                margin: 0;
                padding: 40px;
            }

            h1 {
                color: #c62828;
                letter-spacing: 3px;
                text-transform: uppercase;
            }

            h2 {
                border-bottom: 1px solid #333;
                padding-bottom: 5px;
            }

            .arena {
                max-width: 600px;
                margin: auto;
                padding: 30px;
                background: rgba(10,10,10,0.85);
                border: 1px solid #222;
                box-shadow: 0 0 30px rgba(198,40,40,0.2);
            }

            label {
                display: flex;
                justify-content: space-between;
                margin: 10px 0;
            }

            input {
                width: 80px;
                background: #111;
                border: 1px solid #333;
                color: #fff;
                padding: 4px;
            }

            button {
                background: #c62828;
                color: white;
                border: none;
                padding: 10px 16px;
                font-weight: bold;
                letter-spacing: 1px;
                cursor: pointer;
                margin-top: 15px;
            }

            button:hover {
                background: #b71c1c;
            }

            .twist button {
                background: $(duplicate_rule_active[] ? "#6a1b1b" : "#333");
                width: 100%;
            }

            .rule-status {
                margin-bottom: 20px;
                padding: 10px;
                text-align: center;
                border: 1px solid #333;
                background: $(duplicate_rule_active[] ?
                    "rgba(198,40,40,0.15)" :
                    "rgba(255,255,255,0.03)"
                );
            }

            ul {
                list-style: none;
                padding-left: 0;
            }

            li {
                padding: 4px 0;
            }

            .negative {
                color: #ef5350;
            }

            .positive {
                color: #66bb6a;
            }

            .eliminated {
                text-decoration: line-through;
                color: #9e9e9e;
            }
        </style>
    </head>
    <body>
        <div class="arena">
            <h1>♠ King of Diamonds ♠</h1>

            <div class="rule-status">
                Duplicate Guess Rule:
                <strong>
                    $(duplicate_rule_active[] ? "ACTIVE ☠️" : "INACTIVE")
                </strong>
            </div>

            <div class="twist">
                <form method="POST" action="/toggle">
                    <button type="submit">
                        $(duplicate_rule_active[] ?
                            "Deactivate Duplicate Rule" :
                            "Activate Duplicate Rule")
                    </button>
                </form>
            </div>

            <form method="POST" action="/play">
                $(join([
                    "<label>
                        <span>$name</span>
                        <input type='number' name='$id' min='0' max='100' required $(id in eliminated_players ? "disabled" : "")>
                     </label>"
                    for (id, name) in PLAYERS
                    if !(id in eliminated_players)  # Skip eliminated players
                ], "\n"))

                <button type="submit">Submit Guesses</button>
            </form>

            <h2>Scores</h2>
            <ul>
                $(join([
                    "<li class='$(id in eliminated_players ? "eliminated" : "")'>$name:
                        <span class='$(scores[id] >= 0 ? "positive" : "negative")'>
                            $(scores[id])
                        </span>
                     </li>"
                    for (id, name) in PLAYERS
                ], "\n"))
            </ul>
        </div>
    </body>
    </html>
    """)
end


route("/toggle", method = POST) do
    duplicate_rule_active[] = !duplicate_rule_active[]
    redirect("/")
end


route("/play", method = POST) do
    guesses = Dict{Symbol, Float64}()

    for (id, _) in PLAYERS
        guesses[id] = parse(Float64, params(id))
    end

    invalid_players = Set{Symbol}()
    valid_guesses = copy(guesses)

    if duplicate_rule_active[]
        by_value = Dict{Float64, Vector{Symbol}}()

        for (id, value) in guesses
            push!(get!(by_value, value, Symbol[]), id)
        end

        for (_, ids) in by_value
            if length(ids) > 1
                for id in ids
                    scores[id] -= 1
                    delete!(valid_guesses, id)
                    push!(invalid_players, id)
                end
            end
        end
    end

    avg = isempty(valid_guesses) ? nothing : mean(values(valid_guesses))
    X = avg === nothing ? nothing : avg * 0.8

    winner = nothing

    if X !== nothing
        distances = Dict(
            id => abs(valid_guesses[id] - X)
            for id in keys(valid_guesses)
        )

        winner = argmin(distances)

        for (id, _) in PLAYERS
            if id == winner
                scores[id] += 0
            elseif !(id in invalid_players)
                scores[id] -= 1
            end

            # Eliminate player if score is ≤ -5
            if scores[id] <= -5
                push!(eliminated_players, id)
            end
        end
    end

    winner_name = winner === nothing ?
        "No winner — all invalidated" :
        first(name for (id, name) in PLAYERS if id == winner)

    html("""
    <html>
    <head>
        <title>Round Result</title>
        <style>
            body {
                background: #000;
                color: #e0e0e0;
                font-family: Arial;
                padding: 40px;
            }
            h1 { color: #c62828; }
            .invalid { color: #ef5350; }
        </style>
    </head>
    <body>
        <h1>Round Result</h1>

        <p>Duplicate Rule:
            <strong>$(duplicate_rule_active[] ? "ACTIVE ☠️" : "Inactive")</strong>
        </p>

        $(avg === nothing ?
            "<p>Average: —<br>X: —</p>" :
            "<p>Average (valid): $(round(avg, digits=2))<br>
             X = $(round(X, digits=2))</p>"
        )

        <h2>Guesses</h2>
        <ul>
            $(join([
                "<li class='$(id in invalid_players ? "invalid" : "")'>
                    $name: $(guesses[id]) $(id in invalid_players ? "❌" : "")
                 </li>"
                for (id, name) in PLAYERS
            ], "\n"))
        </ul>

        <h2>👑 Winner: $winner_name</h2>

        <a href="/">Return to Arena</a>
    </body>
    </html>
    """)
end

up(8000)
