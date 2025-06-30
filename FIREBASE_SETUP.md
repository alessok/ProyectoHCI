# Configuración de Firebase para Professor Ranking App

## 📋 Pasos para configurar Firebase

### 1. Crear proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en "Crear un proyecto"
3. Nombra tu proyecto (ej: "professor-ranking-app")
4. Sigue los pasos del asistente

### 2. Habilitar servicios necesarios

#### Authentication
1. En Firebase Console, ve a "Authentication" > "Sign-in method"
2. Habilita "Email/Password"
3. Opcional: Habilita "Google" para login con Google

#### Firestore Database
1. Ve a "Firestore Database"
2. Haz clic en "Crear base de datos"
3. Selecciona "Comenzar en modo de prueba" (para desarrollo)
4. Elige la ubicación más cercana (ej: "us-central1")

### 3. Configurar reglas de seguridad de Firestore

Ve a "Firestore Database" > "Reglas" y configura las siguientes reglas:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuarios pueden leer/escribir sus propios datos
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Cualquiera puede leer profesores
    match /professors/{professorId} {
      allow read: if true;
      allow write: if false; // Solo admin puede escribir
    }
    
    // Cualquiera puede leer departamentos
    match /departments/{departmentId} {
      allow read: if true;
      allow write: if false; // Solo admin puede escribir
    }
    
    // Usuarios autenticados pueden crear reseñas
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Usuarios pueden gestionar sus favoritos
    match /userFavorites/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 4. Obtener credenciales de configuración

#### Para Android:
1. Ve a "Configuración del proyecto" > "General"
2. En "Tus apps", haz clic en el ícono de Android
3. Registra la app con el package name: `com.example.professor_ranking_app`
4. Descarga el archivo `google-services.json`
5. Colócalo en `android/app/google-services.json`

#### Para iOS:
1. En "Tus apps", haz clic en el ícono de iOS
2. Registra la app con el Bundle ID: `com.example.professorRankingApp`
3. Descarga el archivo `GoogleService-Info.plist`
4. Colócalo en `ios/Runner/GoogleService-Info.plist`

#### Para Web:
1. En "Tus apps", haz clic en el ícono de Web
2. Registra la app con el nombre que desees
3. Copia la configuración que aparece

### 5. Actualizar archivo de configuración

Edita `lib/firebase_options.dart` y reemplaza los valores con tus credenciales reales:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'TU-API-KEY-REAL',
  appId: 'TU-APP-ID-REAL',
  messagingSenderId: 'TU-SENDER-ID-REAL',
  projectId: 'TU-PROJECT-ID-REAL',
  authDomain: 'TU-PROJECT-ID-REAL.firebaseapp.com',
  storageBucket: 'TU-PROJECT-ID-REAL.appspot.com',
);
```

### 6. Configurar archivos de build

#### Android (`android/app/build.gradle.kts`):
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Agregar esta línea
}
```

#### Android (`android/build.gradle.kts`):
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0") // Agregar esta línea
    }
}
```

#### iOS (`ios/Podfile`):
```ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end
```

### 7. Poblar la base de datos con datos iniciales

Una vez configurado Firebase, puedes poblar la base de datos ejecutando:

```dart
// En tu app, temporalmente:
import 'services/database_seeder.dart';

// En algún lugar de tu código:
await DatabaseSeeder.seedDatabase();
```

### 8. Verificar la configuración

1. Ejecuta `flutter clean`
2. Ejecuta `flutter pub get`
3. Ejecuta `flutter run`

## 🔧 Solución de problemas comunes

### Error: "No Firebase App '[DEFAULT]' has been created"
- Verifica que Firebase esté inicializado en `main.dart`
- Asegúrate de que las credenciales sean correctas

### Error: "Permission denied"
- Verifica las reglas de seguridad de Firestore
- Asegúrate de que el usuario esté autenticado

### Error: "Network error"
- Verifica tu conexión a internet
- Asegúrate de que Firebase esté habilitado en tu proyecto

## 📱 Próximos pasos

1. **Configurar autenticación avanzada**: Google Sign-In, Facebook, etc.
2. **Implementar notificaciones push**: Firebase Cloud Messaging
3. **Configurar Analytics**: Firebase Analytics
4. **Implementar Storage**: Para fotos de perfil
5. **Configurar Functions**: Para lógica del servidor

## 🔒 Seguridad

- Nunca subas las credenciales de Firebase a un repositorio público
- Usa variables de entorno para las credenciales en producción
- Revisa regularmente las reglas de seguridad
- Implementa rate limiting para prevenir spam

## 📞 Soporte

Si tienes problemas con la configuración:
1. Revisa la [documentación oficial de Firebase](https://firebase.google.com/docs)
2. Consulta la [documentación de FlutterFire](https://firebase.flutter.dev/)
3. Verifica los logs de Firebase Console 