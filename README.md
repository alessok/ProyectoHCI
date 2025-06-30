# Professor Ranking App - Universidad de Lima

Aplicación móvil y web para calificar y reseñar profesores de la Universidad de Lima.

## Descripción

Esta aplicación permite a los estudiantes de la Universidad de Lima:
- Ver la lista completa de profesores por departamento
- Calificar y reseñar profesores
- Buscar profesores por nombre o curso
- Ver estadísticas de calificaciones
- Gestionar favoritos

## Tecnologías

- Flutter (Framework de desarrollo)
- Firebase (Backend y autenticación)
- Firestore (Base de datos)
- Firebase Hosting (Despliegue web)

## Características

- Sistema de autenticación con email y Google
- Datos reales de profesores de la ULima
- Sistema híbrido (datos mock + Firebase)
- Interfaz responsive para móvil y web
- Búsqueda y filtros avanzados
- Gestión de reseñas y calificaciones

## Instalación

1. Clonar el repositorio:
```
git clone https://github.com/alessok/ProyectoHCI.git
```

2. Entrar al directorio:
```
cd ProyectoHCI
```

3. Instalar dependencias:
```
flutter pub get
```

4. Ejecutar la aplicación:
```
flutter run
```

## Despliegue

La aplicación está desplegada en Firebase Hosting:
https://professor-ranking-app-ulima.web.app

## Estructura del Proyecto

```
lib/
├── core/           # Lógica de negocio
├── models/         # Modelos de datos
├── screens/        # Pantallas de la aplicación
├── services/       # Servicios y APIs
├── widgets/        # Componentes reutilizables
└── constants/      # Constantes y configuración
```

## Arquitectura

El proyecto utiliza un sistema híbrido que combina:
- Datos mock para información de profesores (datos reales de la ULima)
- Firebase para autenticación y reseñas dinámicas
- Patrón Repository para separación de capas
- Provider para gestión de estado

## Autores

- Grupo 5
- Universidad de Lima
- Proyecto de HCI

## Licencia

Este proyecto es parte del curso de Interacción Humano-Computadora de la Universidad de Lima. 
