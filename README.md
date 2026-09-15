# 🏰 Medieval Castle Platformer — Godot 4 2D Game Project

[![Engine](https://img.shields.io/badge/Engine-Godot%204.x-blue?style=for-the-badge&logo=godotengine&logoColor=white)](https://godotengine.org/)
[![Genre](https://img.shields.io/badge/Genre-2D%20Action%20Platformer-red?style=for-the-badge)](#)
[![Style](https://img.shields.io/badge/Art-Pixel%20Art%20%7C%20Medieval-goldenrod?style=for-the-badge)](#)
[![Status](https://img.shields.io/badge/Project-UAS%20Game%20Development-green?style=for-the-badge)](#)

> **Proyek Akhir Semester (UAS) Game Development** Sebuah game 2D Action Platformer bertema abad pertengahan (*Medieval Fantasy*) yang dibangun menggunakan **Godot Engine 4**. Game ini menampilkan pergerakan karakter yang dinamis, mekanisme pertempuran dasar, sistem *healthbar*, musuh (*enemy AI*), latar belakang *Parallax Scrolling*, serta transisi level berbasis gerbang (*gate*).

---

## 📸 Demo & Gameplay Preview

![Game Preview GIF](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHp1OHM2NzBybzRqZTFzODFvd3Eyd3U1OHJndXNqdWhvYmZtY2c3eSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3oKIPnAiaMCws8nOsE/giphy.gif)

---

## 🌟 Fitur Utama Game

1. **🏰 Medieval Castle Environment & Pixel Art**
   - Menggunakan aset visual *Pixel Art* bertema kastil abad pertengahan (`Castle.png`).
   - Font khusus bertema *Medieval Fantasy* (`SlightlyItalicMedievalFantasyFont`).

2. **🌅 Multi-Layered Parallax Scrolling Background**
   - Efek kedalaman latar belakang 5 lapis (`parallax-00` hingga `parallax-04`) yang digerakkan oleh skrip `Cloudparallax.gd`.

3. **⚔️ Character Mechanics & Health System**
   - Pergerakan ksatria/karakter utama (`character.gd`) yang responsif (berlari, melompat, interaksi).
   - Sistem *Healthbar* dinamis (`healtbar.tscn` & `healtbar.gd`) untuk mengukur sisa nyawa pemain.

4. **👾 Enemy Patrol & Collision System**
   - Musuh (`enemy.tscn` & `Enemy.gd`) dengan deteksi area dan interaksi damage saat menabrak pemain.

5. **🚪 Scene & Level Transitions**
   - **Main Menu UI**: Tampilan menu utama yang estetik (`main_menu.tscn`).
   - **Gate / Portal**: Area penyelesaian stage (`gate.tscn` & `gate.gd`) yang memicu transisi ke stage/map berikutnya.
   - **Try Again / Game Over**: Layar mengulang permainan saat darah pemain habis (`try_again.tscn`).

---

## 📁 Struktur Direktori Proyek

```text
Project_Uas_Game/
├── .godot/                             # File cache internal Godot Engine 4
├── .editorconfig                       # Konfigurasi format kode editor
├── .gitignore                          # Rule ignore untuk repository Git
├── Assets/
│   ├── Fonts/
│   │   └── SlightlyItalicMedievalFantasyFont/ # Custom Medieval Font & Textures
│   ├── Parallax/
│   │   ├── parallax-00.png ~ parallax-04.png  # Asset gambar latar belakang 5 layer
│   │   └── *.import
│   ├── Scenes/                          # Node Adegan (Game Scenes)
│   │   ├── main_menu.tscn              # Scene Menu Utama
│   │   ├── game.tscn                   # Main Game Container
│   │   ├── map_1.tscn                  # Level / Stage 1
│   │   ├── maps.tscn                   # Tilemap & Level Layout
│   │   ├── character.tscn               # Node Player Character
│   │   ├── enemy.tscn                   # Node Enemy AI
│   │   ├── healtbar.tscn                # Node UI Health Bar
│   │   ├── gate.tscn                    # Node Finish Gate / Portal
│   │   └── try_again.tscn               # Scene Game Over / Game Restart
│   ├── Scripts/                         # Logika Kode GDScript
│   │   ├── main_menu.gd                # Logika Navigasi Menu
│   │   ├── game.gd                      # Game Loop Manager
│   │   ├── map_1.gd                     # Level Manager Stage 1
│   │   ├── character.gd                 # Logika Kontrol & Fisika Player
│   │   ├── Enemy.gd                     # Logika Perilaku & AI Musuh
│   │   ├── healtbar.gd                  # Update Tampilan UI Darah
│   │   ├── gate.gd                      # Logika Pemicu Pindah Level
│   │   ├── Cloudparallax.gd             # Efek Animasi Parallax Awan
│   │   └── try_again.gd                 # Logika Restart Game
│   └── Sprites/
│       └── Castle/
│           └── Castle.png              # Tilemap & Sprite Kastil Abad Pertengahan
└── project.godot                       # File konfigurasi utama proyek Godot
