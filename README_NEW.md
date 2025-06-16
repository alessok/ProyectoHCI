# 🎓 RankedYourProf UL - Professor Ranking App

Una aplicación móvil moderna desarrollada en **Flutter** para calificar y rankear profesores universitarios de la **Universidad de Lima**.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.32.4-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

</div>

## 📱 Características Principales

### ✨ **Funcionalidades**
- 🔐 **Autenticación** - Login con email institucional + Google Sign-In
- 🏠 **Pantalla Principal** - Vista optimizada con profesores favoritos y top rankings
- 🔍 **Búsqueda Avanzada** - Filtros por carrera y departamento
- ⭐ **Sistema de Calificación** - Rating con estrellas y comentarios
- 🏆 **Rankings** - Lista ordenada de mejores profesores
- 👤 **Perfiles de Profesores** - Información detallada y reseñas
- 📱 **Navegación Intuitiva** - Diseño centrado en la experiencia del usuario

### 🎨 **Diseño**
- **Colores Universidad de Lima** - Paleta naranja/dorado oficial
- **UI Moderna** - Material Design 3 con gradientes
- **Responsive** - Optimizado para diferentes tamaños de pantalla
- **Navegación Consistente** - Botones de retroceder uniformes
- **Animaciones Fluidas** - Transiciones suaves entre pantallas

## 🚀 Instalación y Ejecución

### **Prerrequisitos**
- [Flutter 3.32.4+](https://flutter.dev/docs/get-started/install)
- [Dart 3.0+](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) o [Xcode](https://developer.apple.com/xcode/) (para desarrollo móvil)
- [VS Code](https://code.visualstudio.com/) con extensión de Flutter (recomendado)

### **1. Clonar el Repositorio**
```bash
git clone https://github.com/alessok/ProyectoHCI.git
cd ProyectoHCI
```

### **2. Instalar Dependencias**
```bash
flutter pub get
```

### **3. Ejecutar la Aplicación**

#### **En un emulador/simulador:**
```bash
flutter run
```

#### **En un dispositivo específico:**
```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device-id>
```

#### **Para desarrollo web:**
```bash
flutter run -d chrome
```

### **4. Compilar para Producción**

#### **Android (APK):**
```bash
flutter build apk --release
```

#### **iOS (requiere macOS y Xcode):**
```bash
flutter build ios --release
```

## 📁 Estructura del Proyecto

```
lib/
├── constants/          # Colores y strings constantes
│   ├── colors.dart     # Paleta de colores UL
│   └── strings.dart    # Textos de la aplicación
├── models/             # Modelos de datos
│   ├── professor.dart  # Modelo de profesor
│   └── user.dart      # Modelo de usuario
├── screens/            # Pantallas de la aplicación
│   ├── login_screen.dart
│   ├── home_screen_new.dart
│   ├── search_screen.dart
│   ├── ranking_screen.dart
│   ├── professor_profile_screen.dart
│   └── ...
├── services/           # Servicios y lógica de negocio
│   ├── mock_data_service.dart
│   └── session_service.dart
├── widgets/            # Componentes reutilizables
│   ├── professor_card.dart
│   ├── custom_button.dart
│   ├── search_bar_widget.dart
│   └── ...
└── main.dart          # Punto de entrada de la aplicación
```

## 🛠️ Tecnologías Utilizadas

- **Framework:** Flutter 3.32.4
- **Lenguaje:** Dart 3.0+
- **Arquitectura:** Clean Architecture con separación de capas
- **Estado:** StatefulWidget con setState
- **Navegación:** Navigator 2.0
- **UI:** Material Design 3
- **Datos:** Mock Data Service (preparado para Firebase)

## 📋 Funcionalidades Implementadas

### 🔐 **Autenticación**
- [x] Pantalla de login con email institucional
- [x] Pantalla de registro
- [x] Integración con Google Sign-In (preparada)
- [x] Validación de formularios

### 🏠 **Pantalla Principal**
- [x] Header con gradiente UL
- [x] Búsqueda rápida
- [x] Filtros por categoría
- [x] Tarjetas de profesores favoritos
- [x] Lista de top profesores
- [x] Navegación optimizada

### 🔍 **Búsqueda y Filtros**
- [x] Búsqueda por nombre de profesor
- [x] Filtros por carrera/departamento
- [x] Resultados en tiempo real
- [x] Navegación a perfiles

### ⭐ **Sistema de Rating**
- [x] Calificación con estrellas (1-5)
- [x] Comentarios detallados
- [x] Pantalla de confirmación
- [x] Historial de reseñas

### 🏆 **Rankings**
- [x] Lista ordenada por rating
- [x] Ordenamiento por número de reseñas
- [x] Información completa de profesores
- [x] Navegación a perfiles

### 👤 **Perfiles**
- [x] Información detallada del profesor
- [x] Estadísticas de calificaciones
- [x] Lista de comentarios
- [x] Opción de favoritos
- [x] Botón para calificar

## 🎨 Guía de Diseño

### **Colores Universidad de Lima**
```dart
primaryOrange: Color(0xFFFF6B35)    // Naranja principal
primaryGold: Color(0xFFFFB800)      // Dorado secundario
textPrimary: Color(0xFF2C3E50)      // Texto principal
textSecondary: Color(0xFF7F8C8D)    // Texto secundario
backgroundColor: Color(0xFFF8F9FA)   // Fondo de aplicación
```

### **Tipografía**
- **Títulos:** Roboto Bold, 24px
- **Subtítulos:** Roboto Medium, 18px
- **Cuerpo:** Roboto Regular, 16px
- **Detalles:** Roboto Light, 14px

## 🧪 Testing

### **Ejecutar Tests**
```bash
# Tests unitarios
flutter test

# Tests de integración
flutter test integration_test/
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -m 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Autores

- **Alessandro Ledesma** - *Desarrollo principal* - [alessok](https://github.com/alessok)

## 🙏 Reconocimientos

- Universidad de Lima por la inspiración del diseño
- Comunidad Flutter por las excelentes herramientas
- Material Design para las guías de UI/UX

---

<div align="center">
  <p>Desarrollado con ❤️ para la Universidad de Lima</p>
  <p>🎓 <strong>RankedYourProf UL</strong> - Califica a tus profesores de manera anónima</p>
</div>
