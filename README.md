# Professor Ranking App - Universidad de Lima

Aplicación Flutter para rankear profesores de la Universidad de Lima con sistema híbrido (datos reales + Firebase).

## 🚀 Características

### ✅ Implementado
- **Sistema Híbrido**: Combina datos reales de la ULima con Firebase
- **Datos Completos**: 100+ profesores reales de Ingeniería de Sistemas
- **Autenticación completa** con Firebase Auth
- **Base de datos en tiempo real** con Firestore
- **Sistema de reseñas** persistente y híbrido
- **Gestión de favoritos** por usuario
- **Búsqueda avanzada** de profesores
- **Filtros por departamento**
- **Ranking de profesores** por calificación
- **Perfiles de profesores** detallados
- **Interfaz moderna** con Material Design 3

### 🔄 En desarrollo
- Notificaciones push
- Modo offline completo
- Analytics y métricas
- Exportación de datos

## 🛠️ Tecnologías

- **Frontend**: Flutter 3.32.4
- **Backend**: Sistema Híbrido
  - **Datos Mock**: Profesores reales de la ULima
  - **Firebase**: Authentication, Firestore, Hosting
- **Estado**: Provider
- **UI**: Material Design 3

## 📊 Datos de la Universidad de Lima

La aplicación incluye datos reales de profesores de **Ingeniería de Sistemas** de la Universidad de Lima:

- **100+ profesores** con información completa
- **Cursos reales** impartidos por cada profesor
- **Biografías** y especializaciones
- **Departamentos** de la facultad
- **Reseñas existentes** para pruebas

### Ejemplos de Profesores Incluidos:
- Dr. Carlos Alberto Mendoza Torres (Programación I, Algoritmos)
- Mg. Ana María Rodríguez López (Desarrollo Web, Interfaces)
- Dr. Luis Fernando Silva Vargas (Investigación de Operaciones)
- Y muchos más...

## 📱 Capturas de pantalla

*[Aquí irían las capturas de pantalla de la app]*

## 🚀 Instalación

### Prerrequisitos
- Flutter SDK 3.8.1 o superior
- Dart SDK 3.8.1 o superior
- Android Studio / VS Code
- Cuenta de Firebase (opcional para funcionalidades avanzadas)

### Pasos de instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/professor-ranking-app.git
   cd professor-ranking-app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase (Opcional)**
   - Sigue las instrucciones en [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
   - Obtén las credenciales de Firebase Console
   - Actualiza `lib/firebase_options.dart`
   - **Nota**: La app funciona sin Firebase usando solo datos mock

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 🏗️ Arquitectura del proyecto

```
lib/
├── constants/          # Constantes de la app
├── core/              # Lógica de negocio
│   ├── providers/     # Providers de estado
│   └── repositories/  # Repositorios de datos
├── models/            # Modelos de datos
├── screens/           # Pantallas de la UI
├── services/          # Servicios (Híbrido, Firebase, Auth, etc.)
├── widgets/           # Widgets reutilizables
└── main.dart          # Punto de entrada
```

## 🔧 Sistema Híbrido

### ¿Qué es?
El sistema híbrido combina:
- **Datos Mock**: Profesores reales de la ULima (siempre disponibles)
- **Firebase**: Autenticación y reseñas nuevas (requiere conexión)

### Ventajas
- ✅ **Funciona offline** con datos mock
- ✅ **Datos reales** de tu universidad
- ✅ **Escalable** con Firebase
- ✅ **Migración gradual** opcional

### Más información
Consulta [HYBRID_SYSTEM.md](HYBRID_SYSTEM.md) para detalles completos.

## 🔧 Configuración de Firebase

### Servicios utilizados
- **Firebase Authentication**: Login/registro de usuarios
- **Cloud Firestore**: Base de datos NoSQL
- **Firebase Security Rules**: Reglas de seguridad

### Estructura de la base de datos

```
firestore/
├── users/                    # Datos de usuarios
│   └── {userId}/
│       ├── name
│       ├── email
│       ├── createdAt
│       └── isVerified
├── professors/               # Datos de profesores (migrados)
│   └── {professorId}/
│       ├── name
│       ├── department
│       ├── courses[]
│       ├── averageRating
│       ├── totalReviews
│       ├── bio
│       └── searchKeywords[]
├── reviews/                  # Reseñas de profesores
│   └── {reviewId}/
│       ├── userId
│       ├── userName
│       ├── professorId
│       ├── rating
│       ├── comment
│       └── date
├── departments/              # Departamentos
│   └── {departmentId}/
│       └── name
└── userFavorites/            # Favoritos por usuario
    └── {userId}/
        └── favorites[]
```

## 📊 Funcionalidades principales

### 🔐 Autenticación
- Registro con email y contraseña
- Login con email y contraseña
- Recuperación de contraseña
- Verificación de email
- Cerrar sesión

### 👨‍🏫 Gestión de profesores
- Lista de todos los profesores de la ULima
- Búsqueda por nombre o curso
- Filtrado por departamento
- Ranking por calificación
- Perfiles detallados con biografías

### ⭐ Sistema de reseñas
- Calificar profesores (1-5 estrellas)
- Comentar reseñas
- Ver historial de reseñas
- Estadísticas de calificaciones
- Prevención de reseñas duplicadas
- **Híbrido**: Reseñas existentes + nuevas

### ❤️ Favoritos
- Marcar/desmarcar profesores favoritos
- Lista de profesores favoritos
- Sincronización en tiempo real
- Fallback a favoritos mock

## 🧪 Testing

```bash
# Ejecutar tests unitarios
flutter test

# Ejecutar tests de widgets
flutter test test/widget_test.dart

# Ejecutar tests con coverage
flutter test --coverage
```

## 📦 Build y deploy

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🔒 Seguridad

- Autenticación requerida para operaciones sensibles
- Reglas de Firestore configuradas
- Validación de datos en frontend y backend
- Prevención de spam en reseñas
- Datos mock protegidos (solo información pública)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👥 Autores

- **Tu Nombre** - *Desarrollo inicial* - [TuUsuario](https://github.com/TuUsuario)

## 🙏 Agradecimientos

- Flutter team por el framework
- Firebase team por el backend
- Universidad de Lima por los datos y la inspiración
- Profesores de Ingeniería de Sistemas por su dedicación

## 📞 Soporte

Si tienes problemas o preguntas:
- Abre un issue en GitHub
- Revisa la documentación de Firebase
- Consulta la documentación de Flutter
- Lee [HYBRID_SYSTEM.md](HYBRID_SYSTEM.md) para problemas del sistema híbrido

## 🔄 Roadmap

- [ ] Notificaciones push
- [ ] Modo offline completo
- [ ] Analytics y métricas
- [ ] Exportación de datos
- [ ] Integración con sistemas universitarios
- [ ] API REST pública
- [ ] Dashboard de administración
- [ ] Moderación de contenido
- [ ] Búsqueda avanzada con filtros
- [ ] Temas personalizables
- [ ] Migración completa a Firebase (opcional)
