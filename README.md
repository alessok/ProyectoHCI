# Professor Ranking App 📚⭐

Una aplicación móvil Flutter para rankear profesores universitarios, desarrollada específicamente para la Universidad de Lima.

## 🎯 Características

- **Autenticación segura** con email institucional y Google Sign-In
- **Ranking de profesores** con sistema de calificaciones
- **Reseñas y comentarios** de estudiantes
- **Búsqueda avanzada** de profesores por departamento y curso
- **Interfaz moderna** con los colores institucionales de la Universidad de Lima

## 🚀 Tecnologías

- **Flutter 3.32.4** - Framework multiplataforma
- **Dart 3.8.1** - Lenguaje de programación
- **Firebase** - Backend y autenticación
- **Material Design 3** - Sistema de diseño

## 🎨 Diseño

La aplicación utiliza la paleta de colores oficial de la Universidad de Lima:
- **Naranja primario** (#FF8C00)
- **Dorado** (#FFD700)
- **Colores neutros** para mejor legibilidad

## 🏗️ Estructura del Proyecto

```
lib/
├── constants/          # Colores, strings y constantes
├── models/            # Modelos de datos (User, Professor, etc.)
├── screens/           # Pantallas de la aplicación
├── widgets/           # Widgets reutilizables
├── services/          # Servicios (auth, API, etc.)
└── utils/             # Utilidades y helpers
```

## 🛠️ Instalación y Configuración

### Prerrequisitos

1. **Flutter SDK** (versión 3.32.4 o superior)
2. **Dart SDK** (versión 3.8.1 o superior)
3. **Android Studio** / **Xcode** para emuladores
4. **VS Code** con extensiones de Flutter

### Pasos de instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd professor-ranking-app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Verificar configuración**
   ```bash
   flutter doctor
   ```

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 📱 Pantallas Implementadas

### ✅ Pantalla de Login
- Formulario de autenticación con email y contraseña
- Integración con Google Sign-In
- Validación de campos
- Diseño responsivo con colores institucionales

### 🚧 En Desarrollo
- [ ] Pantalla de Registro
- [ ] Pantalla Principal (Home)
- [ ] Perfil de Profesor
- [ ] Sistema de Ranking
- [ ] Búsqueda de Profesores

## 🎯 Funcionalidades Planificadas

- [ ] **Autenticación completa** (registro, recuperación de contraseña)
- [ ] **Sistema de calificaciones** con estrellas y comentarios
- [ ] **Filtros avanzados** (departamento, curso, calificación)
- [ ] **Notificaciones push** para nuevas reseñas
- [ ] **Modo offline** para consultas básicas

## 🧪 Testing

```bash
# Ejecutar tests unitarios
flutter test

# Ejecutar tests de integración
flutter drive --target=test_driver/app.dart
```

## 📦 Build

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Equipo de Desarrollo

Desarrollado con ❤️ para la comunidad de la Universidad de Lima

---

**Nota**: Esta aplicación está en desarrollo activo. Las funcionalidades pueden cambiar durante el proceso de desarrollo.
