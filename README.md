# Roblox TCG Card Shop Simulator

This repository contains a simple Roblox Studio-ready starter project for a 2D TCG card shop simulator with:

- Level progression and XP
- In-game money and wallet tracking
- Card packs with rarity tiers
- Inventory and sell system with Select All
- Coinflip doubling minigame
- Global leaderboard support using DataStore ordered values
- Tutorial flow
- Loading screen
- Sound effects and background music hooks
- Save progression via DataStore

## Project layout

- `roblox/ReplicatedStorage/Shared/Config.lua` - Game balance and settings
- `roblox/ReplicatedStorage/Shared/CardData.lua` - Card definitions and pack pools
- `roblox/ServerScriptService/GameServer.server.lua` - Main server logic
- `roblox/StarterPlayer/StarterPlayerScripts/GameClient.client.lua` - UI, tutorial, loading screen, sound, interactions

## How to use in Roblox Studio

1. Create a new place in Roblox Studio.
2. Copy the folders from this repo into the Studio hierarchy:
   - `ReplicatedStorage/Shared/Config.lua`
   - `ReplicatedStorage/Shared/CardData.lua`
   - `ServerScriptService/GameServer.server.lua`
   - `StarterPlayer/StarterPlayerScripts/GameClient.client.lua`
3. Make sure `ReplicatedStorage/Shared` exists and contains both Lua modules.
4. Press Play.
5. Replace the placeholder sound asset IDs in `Config.lua` with your own audio IDs.

## Notes

- This is a clean foundation for a 2D card shop simulator.
- The code is designed to be simple enough to expand into a more advanced Roblox game.
- Leaderboards use DataStore APIs and work best in a live Roblox experience with proper permissions and data privacy rules.

## Suggested next upgrades

- More card rarity layers and unique art styles
- Seasonal packs and limited cards
- Inventory rarity filtering
- Better card drag/drop UI
- Trade system or card duplicate exchange
- More minigames and shop upgrades
