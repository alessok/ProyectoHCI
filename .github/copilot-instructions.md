# Copilot Instructions para Professor Ranking App

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Contexto del Proyecto
Esta es una aplicación móvil Flutter para rankear profesores universitarios, desarrollada para iOS y Android.

## Especificaciones de Diseño
- **Colores**: Usar paleta de colores de la Universidad de Lima (naranja/dorado y colores neutros)
- **UI**: Diseño limpio y moderno con formularios centrados
- **Navegación**: Flujo intuitivo para estudiantes universitarios

## Funcionalidades Principales
- Autenticación de usuarios (email institucional + contraseña)
- Login con Google
- Sistema de ranking de profesores
- Perfiles de profesores
- Comentarios y reseñas

## Estructura de Pantallas
1. **Login/Registro**: Autenticación con email institucional
2. **Home**: Lista de profesores y rankings
3. **Perfil de Profesor**: Detalles, calificaciones y comentarios
4. **Ranking**: Lista ordenada de profesores

## Tecnologías
- **Framework**: Flutter 3.32.4
- **Lenguaje**: Dart
- **Base de datos**: Por definir (Firebase/SQLite)
- **Autenticación**: Firebase Auth + Google Sign-In

## Patrones de Código
- Usar widgets reutilizables
- Implementar arquitectura limpia (separación de capas)
- Nombrar archivos en snake_case
- Comentarios en español para mayor claridad del equipo
