from flask import Flask, request, jsonify
from flask_cors import CORS
from qiskit import QuantumCircuit, transpile
from qiskit_aer import AerSimulator

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# --- Quantum move generator using Qiskit AerSimulator ---
def get_quantum_move():
    qc = QuantumCircuit(2, 2)
    qc.h(0)
    qc.h(1)
    qc.measure([0, 1], [0, 1])

    simulator = AerSimulator()
    transpiled_qc = transpile(qc, simulator)

    job = simulator.run(transpiled_qc, shots=1)
    result = job.result().get_counts()

    quantum_output = int(list(result.keys())[0], 2) % 3
    return quantum_output

# --- Flask route to play the game ---
@app.route("/play", methods=["POST"])
def play_game():
    data = request.get_json()
    print("Received data:", data)  # Debug logging

    player_choice = data.get("player_choice") if data else None
    if player_choice not in [0, 1, 2]:
        print("Invalid choice:", player_choice)  # Debug logging
        return jsonify({"error": "Invalid choice. Must be 0 (Rock), 1 (Paper), or 2 (Scissors)."}), 400

    quantum_choice = get_quantum_move()
    moves = ["Rock 🪨", "Paper 📄", "Scissors ✂️"]

    if player_choice == quantum_choice:
        result = "tie"
        message = "⚖️ It's a tie — the universe is balanced!"
    elif (player_choice - quantum_choice) % 3 == 1:
        result = "win"
        message = "🎉 You win! Quantum collapse favored you this time."
    else:
        result = "lose"
        message = "🤖 Quantum computer wins! Reality collapsed against you."

    response = {
        "player_move": moves[player_choice],
        "quantum_move": moves[quantum_choice],
        "result": result,
        "message": message
    }

    print("Response:", response)  # Debug logging
    return jsonify(response)

# --- Run the Flask app ---
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
