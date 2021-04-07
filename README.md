# Godot Multiplayer Starter Project

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0)
![Last commit](https://img.shields.io/github/last-commit/clement-or/godot-multiplayer-starter-project/master?style=for-the-badge)
![Godot Version](https://img.shields.io/badge/Godot%20Version-3.2.3-blue?style=for-the-badge)
![Ask for help](https://img.shields.io/badge/Ask%20for-help%20!-blue?style=for-the-badge)

**Get the README in your language**

Or contribute by translating this README !

:fr: [Français](./README_FR.md)

## Summary

This repo is a **starter project** (or **boilerplate**) for **multiplayer networking** in Godot. It uses a separated Server/Client structure which is different from what the Godot docs proposes.

**Why ?** Because for some projects, a confined Server/Client structure is really helpful, and I prefer to work that way. This way, you can control who gets access to what data and do server specific logic when you need to.

## Contributing and asking for help

I'd be glad for anyone to contribute to this repository, don't hesitate to do a **pull request** or **file an issue** if you encounter any bug. You may also ask for help about Godot networking and this project.

It allows to run a custom **headless server** on a remote PC like a VPS and connecting to it.

*Note: The headless mode for Godot doesn't work yet in 3.2.3. It's scheduled for 3.2.4. I'll try to update this repo if it gets interest. Please post an issue if you need this project in a version that isn't supported yet.*

## CLI Arguments

The main scene of this project is **Start.tscn**. It launches either the server or the client depending on CLI arguments.
`--server` starts a headless server and `--client` starts the client. You can then create your own main scene from there.

If you want players to connect directly to one another, you can allow one player to host a server in-game by starting another instance of the game. For this to work, one of the players will have to configure **port forwarding** on their router, or use a **VPN** such as *Tunngle* or *LogMeIn Hamachi* (I prefer the latter).

## How this works ? 

There are two autoloads : `Server.tscn` and `Client.tscn`. Each client scene (like the `World.tscn` example) may have a server-side script that will handle server-specific logic. Every client-side **root scene** should have a server-side script that will instantiate the scene on the server, as the **scene tree must be the same on Client and Server**.

## Usage 

### Project

Import this project in **Godot 3.2.3** and run it.

### Scripts

The scripts located in `scripts/` folder allow you to start multiple instances of the project without having to run the editor multiple times. They work for Windows and Linux (bash)

**Prerequisite :** You need to have `godot` as a command in your system's `PATH` variable.
