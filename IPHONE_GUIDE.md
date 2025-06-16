# 📱 Guía para Ejecutar en iPhone 15 Físico

## 🎯 Opción RECOMENDADA: Acceso Web (AHORA MISMO)

### ✅ Pasos Inmediatos:

1. **Asegúrate de que tu iPhone 15 y Mac están en la misma red WiFi**
2. **Abre Safari en tu iPhone 15** 
3. **Ve a:** `http://192.168.18.91:8080`
4. **¡Disfruta de la app en tu iPhone!** 📱✨

### 🌟 Ventajas del acceso web:
- ✅ Funciona INMEDIATAMENTE
- ✅ Todos los gestos táctiles funcionan
- ✅ Responsive design optimizado para móvil
- ✅ Hot reload funciona perfectamente
- ✅ No necesitas certificados ni configuración

---

## 🔧 Opción Avanzada: Despliegue Nativo iOS

Si quieres la app nativa en tu iPhone 15 físico:

### 📋 Requisitos:
1. **Xcode** instalado en tu Mac
2. **Apple Developer Account** (gratis o de pago)
3. **iPhone 15 conectado via USB-C**
4. **Certificados de desarrollo configurados**

### 🚀 Pasos para despliegue nativo:

```bash
# 1. Verificar configuración
flutter doctor

# 2. Conectar iPhone 15 via USB-C
# 3. Confiar en el dispositivo desde iPhone

# 4. Verificar que aparece
flutter devices

# 5. Ejecutar en iPhone físico
flutter run -d ios

# 6. Si hay problemas de signing:
open ios/Runner.xcworkspace
# Configurar Team y Bundle ID en Xcode
```

### ⚠️ Posibles Issues:
- Certificados de desarrollo
- Bundle identifier único
- Permisos de desarrollador en iPhone
- Configuración de Xcode signing

---

## 🎯 RECOMENDACIÓN

**Para testing inmediato:** Usa la opción web (`http://192.168.18.91:8080`)

**Para desarrollo avanzado:** Configura Xcode + certificados para despliegue nativo

La aplicación Flutter está diseñada para funcionar perfectamente en ambos casos, con todos los gestos táctiles y navegación optimizada para móvil.

---

## 📱 URLs de Acceso:

- **iPhone (WiFi):** http://192.168.18.91:8080
- **Local (Mac):** http://localhost:8080
- **DevTools:** Consulta terminal para URL específica

¡Tu app se ve increíble en iPhone 15! 🎉
