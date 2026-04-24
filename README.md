# InviKnight

A fast-paced 2D action-platformer where a brave knight must collect mystical invincibility potions to survive — and thrive. Built with **Godot 4.5** and exported for the web.

---

## 🎮 Gameplay

You control a knight navigating platformer levels filled with enemies and breakable walls. By default the knight is vulnerable — one touch from an enemy and it's over. But collect an **Invincibility Bottle** and everything changes:

- You become **temporarily invincible**
- Your speed, jump height, and dash distance all increase
- You can **smash through breakable walls**
- You can **defeat enemies** on contact — and each kill **extends your invincibility timer**
- Collecting additional bottles **stacks** onto your remaining invincibility time

When the invincibility wears off, the stat boosts disappear and you're vulnerable again. The final level (level 10) grants the player permanent invincibility for a climactic finish.

---

## ⭐ Scoring

Each level is rated with **1 to 3 stars** based on how many invincibility bottles you collect:

| Bottles Collected | Stars |
|-------------------|-------|
| 100%              | ⭐⭐⭐ |
| 60% – 99%         | ⭐⭐   |
| < 60%             | ⭐    |

Levels that contain no bottles automatically award 3 stars.

---

## ⏱️ Timer

Every level has a countdown timer. If it reaches zero before you complete the stage, it's **Game Over**. Complete the stage before time runs out to earn your stars.

---

## 🕹️ Controls

| Action      | Key              |
|-------------|------------------|
| Move Left   | ← Arrow          |
| Move Right  | → Arrow          |
| Jump        | ↑ Arrow          |
| Dash        | Space            |
| Pause       | Escape           |

> The dash can be used in the air and propels the knight in the direction they last moved.  
> While dashing with invincibility active, the knight can break walls and eliminate enemies.

---

## 🗺️ Levels

The game features **10 levels** of increasing challenge. Each level has:

- A **spawn point** for the player
- A **checkpoint** that triggers stage completion
- **Collectible bottles** scattered throughout
- **Enemies** (green and purple slimes) to avoid or eliminate
- A **level time limit**

---

## 📁 Project Structure

```
InviKnight/
├── characters/         # Player and Enemy scripts & scenes
├── collectible/        # Invincibility Bottle collectible
├── colliders/          # Damage emitter and receiver components
├── containers/         # Visual effects container
├── managers/           # SignalManager, MusicPlayer, SoundPlayer autoloads
├── stages/             # 10 level scenes + Stage/Checkpoint base scripts
├── ui/                 # All UI scenes (HUD, menus, stage complete/over)
├── vfx/                # Explosion visual effect
├── assets/             # Sprites, fonts, music, and sound effects
├── world.gd            # Core game loop: level loading, timer, star calculation
├── world.tscn          # Root game scene
├── main_menu.gd        # Main menu logic
└── main_menu.tscn      # Main menu scene
```

### Key Systems

- **SignalManager** — Global autoload that decouples all game systems using Godot signals (stage complete, retry, timer updates, etc.)
- **MusicPlayer / SoundPlayer** — Autoloaded audio managers for background music and sound effects
- **Player state machine** — States: `IDLE`, `WALK`, `JUMP`, `DASH`, `POWER_UP`, `POWER_DOWN`, `FROZEN`, `FALL`, `DEATH`
- **World** — Manages the level sequence, countdown timer, bottle tracking, and star calculation

---

## 🛠️ Built With

- **[Godot Engine 4.5](https://godotengine.org/)** — Game engine
- **GDScript** — Scripting language
- **GL Compatibility renderer** — Broad hardware/browser support
- **Viewport resolution**: 640 × 360 (integer-scaled)

---

## 🌐 Web Export

The project is configured for **HTML5 / Web export** (via Godot's Web platform preset), making it easy to host and play directly in a browser without any installation.

To export:
1. Open the project in Godot 4.5
2. Go to **Project → Export**
3. Select the **Web** preset
4. Click **Export Project** — output goes to `exports/web_v2/index.html`

To run the exported game locally, serve the `exports/web_v2/` folder with an HTTP server that sets the required cross-origin isolation headers (e.g. `npx serve` or a Python HTTP server with a custom header script).

---

## 🚀 Running Locally

1. Install [Godot 4.5](https://godotengine.org/download)
2. Clone this repository
3. Open Godot and import the `project.godot` file
4. Press **F5** (or the ▶ button) to run the game
