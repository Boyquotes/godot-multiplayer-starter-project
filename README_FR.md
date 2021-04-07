 # Godot Multiplayer Starter Project

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0)
![Godot Version](https://img.shields.io/badge/Godot%20Version-3.2.3-blue?style=for-the-badge)
![Ask for help](https://img.shields.io/badge/Demandez%20de-l%E2%80%99aide%20!-blue?style=for-the-badge)

![Last commit](https://img.shields.io/github/last-commit/clement-or/godot-multiplayer-starter-project/master?style=for-the-badge)

**Get the README in your language**
*Or contribute by translating it !*

:fr: [Français](./README_FR.md)

## Résumé

Ce dépôt est un **projet de démarrage** (ou **boilerplate**) pour **le multijoueur en réseau** dans Godot. Il utilise une structure séparée Serveur/Client qui est différente de ce que la doc de Godot propose.

**Pourquoi ?** Parce que pour certains projets, une structure Serveur/Client délimitée est très utile, et que je préfère travailler comme ça. De cette façon, vous pouvez contrôler qui a accès à quelles données et faire de la logique spécifique au serveur quand vous en avez besoin.

## Contribuer et demander de l'aide

N'importe qui peut contribuer à ce dépôt, n'hésitez pas à faire une **pull request** ou **poster une issue** si vous rencontrez un bug. Vous pouvez également demander de l'aide concernant le réseau sur Godot et ce projet.

Le projet permet d'exécuter un **serveur headless** personnalisé sur un PC distant comme un VPS et de s'y connecter.

*Note : Le mode headless pour Godot ne fonctionne pas encore dans la version 3.2.3. Il est prévu pour la 3.2.4. J'essaierai de mettre à jour ce dépôt si il a de l'intérêt. Veuillez poster une issue si vous avez besoin de ce projet dans une version qui n'est pas encore supportée.

## Arguments CLI

La scène principale de ce projet est **Start.tscn**. Elle lance soit le serveur soit le client en fonction des arguments CLI.
`--server` lance un serveur headless et `--client` lance le client. Vous pouvez ensuite créer votre propre scène principale à partir de là.

Si vous voulez que les joueurs se connectent directement les uns aux autres, vous pouvez permettre à un joueur d'héberger un serveur en démarrant une autre instance du jeu. Pour que cela fonctionne, l'un des joueurs devra configurer la **redirection de port** sur son routeur, ou utiliser un **VPN** tel que *Tunngle* ou *LogMeIn Hamachi* (je préfère ce dernier).

## Comment ça marche ?

Il y a deux autoloads : `Server.tscn` et `Client.tscn`. Chaque scène client (comme l'exemple `World.tscn`) peut avoir un script côté serveur qui va gérer la logique spécifique au serveur. Chaque **scène racine** côté client **doit** avoir un script côté serveur qui instanciera la scène sur le serveur, car **l'arbre de scène doit être le même sur le client et le serveur**.

### Usage 

### Projet

Importez ce projet dans **Godot 3.2.3** et exécutez-le.

### Scripts

Les scripts situés dans le dossier `scripts/` vous permettent de démarrer plusieurs instances du projet sans avoir à lancer l'éditeur plusieurs fois. Ils fonctionnent pour Windows et Linux (bash)

**Prérequis :** Vous devez avoir `godot` comme commande dans la variable `PATH` de votre système.
