---
title: Migración Arch + Hyprland
status: en-progreso
updated: 2026-09-16
---

# Migración Arch + Hyprland

## Objetivo

Reconstruir el escritorio personal sobre Arch + Hyprland, sin dependencia de
Omarchy, con Black Ember como tema predeterminado.

## Fase 1 — Base de sesión

- [x] `hyprland.lua` autónomo con layout Spiral.
- [x] Walker como launcher principal.
- [x] Menú de sistema propio: lock, suspend, logout, restart y shutdown.
- [x] Scripts propios de volumen, DDC, float y orientación de monitor.
- [x] Servicio propio de Elephant.
- [x] Eliminadas las rutas y comandos operativos de Omarchy del nuevo Lua.

## Fase 2 — Capa visual y temas

- [x] Tema Black Ember creado sin modificar Mechanoonna.
- [x] Wallpapers originales horizontal y vertical, con variantes de acuarela.
- [x] Selector Walker/Elephant con preview de wallpaper.
- [x] Paletas válidas para Walker y SwayOSD.
- [x] Walker, SwayOSD y Ghostty incluidos en el repositorio.
- [x] Waybar, Walker y SwayOSD reciben su paleta desde el tema seleccionado.
- [ ] Migrar variantes activas de Waybar y retirar módulos/rutas personales no deseados.
- [ ] Migrar los demás temas personales si se quiere conservarlos.

## Pendiente antes de una instalación limpia

- [ ] Separar perfiles de hardware: desktop, laptop y monitores.
- [ ] Reemplazar el instalador de copia por uno idempotente con backup.
- [ ] Retirar el `hyprland.conf` legado y Rofi del repositorio.
- [ ] Retirar Linear del greeting y de la documentación.
- [ ] Corregir o decidir el uso de `cliphist`.
- [ ] Probar en VM o usuario temporal de Arch antes de aplicarlo al sistema principal.

## Estado de validación

Los scripts Bash y archivos Lua añadidos pasan validación sintáctica. Falta la
prueba funcional completa en una sesión Arch limpia.

## Próximo paso

Migrar y simplificar Waybar, después crear perfiles de hardware.
