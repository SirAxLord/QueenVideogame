# Queen (Godot 4.3)

Un minijuego de lógica estilo "Reinas" sobre un tablero 9x9. El objetivo es colocar exactamente 9 coronas cumpliendo tres restricciones:

- Una corona por fila.
- Una corona por columna.
- Una corona por región de color (no pueden existir dos coronas en la misma región).
- Además, las coronas no pueden estar adyacentes ni en diagonal (no pueden tocarse a distancia de 1 celda).

## Requisitos

- Godot 4.3 (Forward+). Puedes descargarlo desde https://godotengine.org.
- Windows (probado), aunque el proyecto debería abrir en otros sistemas compatibles con Godot.

## Ejecutar el proyecto

1. Abre Godot 4.3.
2. En la pantalla de inicio, selecciona "Import" y elige el archivo `project.godot` ubicado en la carpeta del proyecto.
3. Abre la escena principal `Main.tscn` si deseas editar, o simplemente pulsa "Play" para ejecutar.

## Cómo se juega

- El tablero es 9x9 y está dividido en 9 regiones (colores) según el mapa seleccionado.
- Cada celda es un botón con tres estados cíclicos:
  - Vacío → Corona → Bloqueado → Vacío.
  - Click izquierdo cambia de estado.
- Al colocar las 9 coronas, pulsa el botón de validar. El juego revisa:
  - Fila única, columna única, región única por corona.
  - No hay coronas adyacentes (incluye diagonales).
- Si la solución es válida, se muestra un mensaje con el tiempo empleado y el tablero queda bloqueado.
- Botón "Reset" limpia estados y permite seguir jugando. Si el juego estaba ganado, reinicia el temporizador.

## Controles y UI

- Temporizador: inicia automáticamente con tu primer clic en una celda.
- Selector de mapa: `OptionButton` para escoger entre 10 mapas predefinidos, cada uno con su paleta de colores.
- Popup de mensajes: muestra errores de validación o confirmación de éxito.

## Mapas

- Se incluyen 10 mapas predefinidos (`PREDEFINED_MAPS`) con:
  - `regions`: matriz 9x9 de IDs de región (0-8).
  - `colors`: paletas de 9 colores por mapa.
- Al cambiar el mapa, el tablero se reconstruye con los colores y regiones correspondientes.

## Estructura del código (resumen)

- `Main.gd` (Control):
  - Carga y reconstruye el tablero 9x9 instanciando `cellButton.tscn`.
  - Gestiona el temporizador, el selector de mapas y la validación del tablero.
  - Reglas de validación: una corona por fila/columna/región y sin adyacencias.
- `cell_button.gd` (Button):
  - Estados: `EMPTY`, `CROWN`, `BLOCKED`.
  - Señal `first_click_detected` para arrancar el temporizador.
  - Renderiza iconos de estado (`👑`, `❌`).
- `cellButton.tscn`: Escena del botón de celda (instanciado para cada posición del tablero).
- `Main.tscn`: Escena principal con el contenedor del tablero (`VBoxContainer/BoardGrid`), temporizador y UI.
- `Imagen/`: Recursos gráficos (texto/frames e importaciones).

## Personalización rápida

- Tamaño del tablero: cambiar `BOARD_SIZE` en `Main.gd` y adaptar las matrices `MAP_X_REGIONS` a NxN.
- Paletas de color: editar constantes `MAP_X_COLORS` en `Main.gd`.
- Reglas: ajustar `validate_board()` si quieres permitir adyacencias o modificar restricciones.

## Desarrollo

- Godot 4.3 con Forward+ (ver `project.godot`).
- El proyecto utiliza `StyleBoxFlat` dinámicos para colorear las celdas según la región.
- Los estilos se aplican en los estados `normal`, `hover`, `pressed` y `disabled` para consistencia visual.

## Próximas mejoras sugeridas

- Modo ayuda: resaltar conflictos al vuelo (fila/columna/región/adyacencia).
- Generador de mapas aleatorios y editor de regiones en runtime.
- Guardado/carga de partidas y mejores efectos visuales.
- Sonidos y animaciones al validar/colocar.

## Licencia

Este repositorio no especifica licencia. Si deseas abrirlo, añade un archivo `LICENSE`. 
