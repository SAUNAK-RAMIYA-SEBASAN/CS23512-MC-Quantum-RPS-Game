# Quantum Rock-Paper-Scissors Game

## 🎮 Project Overview

**Quantum Rock-Paper-Scissors** is an interactive web-based game that combines classical game mechanics with quantum computing technology. Instead of playing against a predictable computer opponent, you face decisions made by a **real quantum computer simulator** using quantum superposition and measurement principles.

### How Quantum Technology is Used

The game leverages **IBM Qiskit** quantum computing framework to generate truly random moves:

1. **Quantum Circuit Creation**: A 2-qubit quantum circuit is initialized, where each qubit represents a binary state
2. **Hadamard Gates**: Hadamard gates are applied to both qubits, putting them into quantum superposition—a state where they exist in all possible outcomes simultaneously (0 and 1 at the same time)
3. **Measurement**: When you make your move, the quantum circuit "collapses" through measurement, producing a random binary output (00, 01, 10, or 11)
4. **Move Selection**: This quantum measurement result is converted to a base-10 number and mapped to Rock (0), Paper (1), or Scissors (2) using modulo 3 arithmetic

This means **every move is generated using genuine quantum randomness principles**, not pseudo-random classical algorithms—making the game unpredictable and demonstrating real quantum computing concepts in action.

### Key Features

- **Quantum-Powered Gameplay**: Uses Qiskit's AerSimulator for authentic quantum random number generation
- **Cyberpunk UI**: Sleek, minimalistic interface with neon cyan aesthetics, smooth animations, and floating particles
- **Smooth Animations**: Elastic scaling, screen shake effects, confetti celebrations, and continuous background gradients
- **Easter Eggs**: Special streak indicators for consecutive wins with glowing badges
- **Haptic Feedback**: Tactile response on mobile devices for button presses and game outcomes
- **Full-Stack Architecture**: Flask REST API backend + Flutter cross-platform frontend

---

## 📋 Prerequisites

Before you start, ensure you have the following software installed:

- **Python 3.10+** ([Download Python](https://www.python.org/))
- **Flutter SDK** ([Download Flutter](https://docs.flutter.dev/get-started/install))
- **Git** ([Download Git](https://git-scm.com/))
- **Android Studio** or **VS Code** (for Flutter development)
- **UV Package Manager** ([UV Documentation & Install Guide](https://docs.astral.sh/uv/))

### UV Installation

UV is a fast Python package and environment manager that makes setup easy and reproducible.

**Windows (PowerShell):**
```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Verify installation:**
```bash
uv --version
```

***

## 🚀 Project Setup Steps

### 1. Clone the Repository

```bash
git clone https://github.com/SAUNAK-RAMIYA-SEBASAN/CS23512-MC-Quantum-RPS-Game.git
```

***

## 🔧 Backend Setup (Flask + Qiskit)

### 1. Navigate to Backend Folder

```bash
cd backend
```

### 2. Create and Activate Virtual Environment

```bash
uv venv --python 3.10
```

**Activate on Windows:**
```bash
.venv\Scripts\activate
```

**Activate on macOS/Linux:**
```bash
source .venv/bin/activate
```

**Confirm Python version:**
```bash
python --version
# Output should be: Python 3.10.x
```

### 3. Install Dependencies

```bash
uv pip install -r requirements.txt
```

### 4. Run the Flask Backend

```bash
python backend.py
```

The backend will run on `http://localhost:5000`

**Expected Output:**
```
* Running on http://0.0.0.0:5000
* Debug mode: on
```

***

## 📱 Frontend Setup (Flutter)

### 1. Navigate to Frontend Folder

```bash
cd ../frontend
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Verify Flutter Installation

```bash
flutter doctor
```

Resolve any issues reported (accept Android licenses if needed):
```bash
flutter doctor --android-licenses
```

### 4. Run the Flutter App

**Option A: Run on Chrome (Web)**
```bash
flutter run -d chrome
```

**Option B: Run on Android Emulator**
1. Start your Android emulator from Android Studio's Device Manager
2. Run:
```bash
flutter run
```

**Option C: Run on Physical Android Device**
1. Enable USB Debugging on your phone
2. Connect via USB
3. Run:
```bash
flutter run
```

***

## 🎯 Usage

1. **Start the Flask backend** (must be running first)
2. **Launch the Flutter app** on your preferred platform
3. **Click Rock, Paper, or Scissors** to play against the quantum computer
4. **Watch the quantum processing animation** as the circuit is measured
5. **See your result** with confetti for wins, screen shake for losses, and detailed citations

**First Query Note:** The first time you play, models may take 10-15 seconds to initialize. Subsequent games are instant.

***

## 📦 Project Structure

```
quantum-rps-game/
├── backend/
│   ├── app.py              # Flask API with quantum circuit logic
│   ├── requirements.txt    # Python dependencies
│   └── .gitignore         # Python-specific ignore rules
├── frontend/
│   ├── lib/
│   │   └── main.dart      # Flutter UI with animations
│   ├── pubspec.yaml       # Flutter dependencies
│   └── .gitignore         # Flutter-specific ignore rules
└── README.md              # This file
```

***

## 🔬 Technology Stack

### Backend
- **Flask 3.0.3**: Lightweight Python web framework
- **Flask-CORS 5.0.0**: Cross-origin resource sharing support
- **Qiskit 1.2.4**: Quantum computing framework
- **Qiskit-Aer 0.15.1**: Quantum circuit simulator

### Frontend
- **Flutter 3.32.4**: Cross-platform UI framework
- **Dart**: Programming language for Flutter
- **HTTP Package**: For API communication

***

## 🌐 API Endpoints

### POST `/play`

**Request Body:**
```json
{
  "player_choice": 0  // 0=Rock, 1=Paper, 2=Scissors
}
```

**Response:**
```json
{
  "player_move": "Rock 🪨",
  "quantum_move": "Paper 📄",
  "result": "lose",
  "message": "🤖 Quantum computer wins! Reality collapsed against you."
}
```

***

## 🎨 Features Breakdown

- **Quantum Randomness**: True quantum superposition-based move generation
- **Cyberpunk Aesthetics**: Neon cyan colors, dark gradients, glowing borders
- **Smooth Animations**: 800ms elastic transitions, continuous gradient morphing
- **Floating Particles**: 40 animated particles in cyan and purple
- **Victory Effects**: Confetti burst with color particles
- **Defeat Effects**: Screen shake with haptic vibration
- **Win Streak Tracking**: Easter egg badge appears at 3+ consecutive wins
- **Haptic Feedback**: Tactile response on mobile devices

***

## 🔒 Security & Privacy

- All quantum computations run **locally** via Qiskit's simulator
- No data is sent to external quantum cloud services
- Flask backend runs on localhost only (suitable for private use)
- CORS enabled for local frontend-backend communication

***

**Enjoy playing against quantum randomness! 🎲⚛️**

***