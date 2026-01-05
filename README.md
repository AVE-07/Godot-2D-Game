# Godot 2D Game – Learning Project

🚀 This repository is a **learning-focused Godot 2D project**, built as part of my journey into game development.

The main goal of this project is to deeply understand **core game programming concepts**, especially:
- Finite State Machine (FSM)
- Player movement & animation handling
- Clean code structure in Godot (Node-based architecture)

This is **not a finished game**, but a growing sandbox where features are added incrementally as I progress through learning materials.

---

## 🎯 Project Focus
- Modular **Finite State Machine (FSM)** architecture
- Separated states (Idle, Run, etc.) for scalability
- Clear responsibility split between:
  - Player (core data & movement)
  - StateMachine (logic controller)
  - States (behavior units)

This setup is designed to be **reusable and extensible** for future projects.

---

## 🧠 What I’ve Learned So Far
- How FSM works in Godot using Nodes
- State transitions via return-based logic
- Handling input, process, and physics per state
- Direction-based animation handling (4-directional)
- Defensive initialization patterns
- Making a tilemap and collision system
- Adding a new layer of effect on character attack (4-directional)
- Using a key frame in AnimatedPlayer2D for making a smooth animation with different position
- Adding a sound on attack animation
- Using monitoring and monitorable in inspector Area2D
- Making a hitbox, hurtbox and attackable object
- Debugging about diagonal direction
- Updating a boundaries for Camera2D

---

## 📦 Assets & Credits
- All visual assets used in this repository are **free assets**
- Assets are **not created by me**
- Credits and download links are provided below
- Asset Artist: https://xzany.itch.io/top-down-adventurer-character
- Asset Artist (Map): https://michaelgames.itch.io/2d-action-adventure-rpg-assets

> This repository does **not** include paid assets to respect the original creators.

---

## 📚 Learning Resources
This project is inspired by a YouTube tutorial series.

- Tutorial Author: https://www.youtube.com/watch?v=QPeycNt29tY&list=PLfcCiyd_V9GH8M9xd_QKlyU8jryGcy3Xa)
- Platform: YouTube
- Core logic has been **modified and adapted**, not copied 1:1

Key differences from the tutorial:
- 4-directional movement instead of 3-direction
- Custom animation handling
- Removed sprite scaling logic (left/right handled via animations)
- Code comments rewritten for personal understanding

---

## 🛠 Tech Stack
- Engine: **Godot 4.5.1**
- Language: **GDScript**
- Version Control: **Git + GitHub**

---

## 📈 Progress Policy
- This repository will be updated **incrementally**
- Commits represent learning milestones, not final features
- Code quality will evolve alongside my understanding

---

## ⚠️ Disclaimer
This project is purely for **educational purposes**.
If you’re learning Godot too, feel free to explore — but always support original asset creators ❤️

---

## ✨ Future Plans
- Add more FSM states (Attack, Roll, Hurt, Death)
- TileMap & world interaction
- Basic enemy AI
- Original assets (later phase)

---

> Learning in public. Shipping progress, not perfection.
