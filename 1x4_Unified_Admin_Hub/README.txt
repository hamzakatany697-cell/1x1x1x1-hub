# 1x4 Unified Admin Hub

## Files

- `1x4_Unified_Admin_Server.server.lua` → put in `ServerScriptService`
- `1x4_Unified_Admin_Client.client.lua` → put in `StarterPlayer > StarterPlayerScripts`

## Admin

The server whitelist already contains UserId `3216839590`.

## Music

Set `MUSIC_ID` in the server script to the Roblox audio asset ID you are permitted to use.

## Why there are two scripts

Roblox separates client and server execution. The GUI and client-only controls run in a LocalScript, while server-wide effects run in the server Script. The RemoteEvent connects the two securely.

Do not try to make a client loadstring grant itself server authority. The server script must exist in the experience.
