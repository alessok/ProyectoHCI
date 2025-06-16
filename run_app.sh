#!/bin/bash

# 🚀 Script de Desarrollo - RankedYourProf ULima
# Universidad de Lima - Professor Ranking App

echo "🏫 RankedYourProf ULima - Universidad de Lima"
echo "=============================================="
echo ""

# Verificar que Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado. Por favor instala Flutter desde https://flutter.dev"
    exit 1
fi

echo "✅ Flutter encontrado: $(flutter --version | head -n 1)"
echo ""

# Verificar dependencias
echo "📦 Verificando dependencias..."
flutter pub get

echo ""
echo "🚀 Opciones de ejecución:"
echo "1. Chrome (Web) - Recomendado para desarrollo"
echo "2. Android Emulator"
echo "3. iOS Simulator (solo macOS)"
echo "4. Verificar dispositivos disponibles"
echo ""

read -p "Selecciona una opción (1-4): " option

case $option in
    1)
        echo "🌐 Iniciando en Chrome..."
        flutter run -d chrome --web-port=8080
        ;;
    2)
        echo "📱 Iniciando en Android..."
        flutter run -d android
        ;;
    3)
        echo "📱 Iniciando en iOS..."
        flutter run -d ios
        ;;
    4)
        echo "📋 Dispositivos disponibles:"
        flutter devices
        ;;
    *)
        echo "❌ Opción inválida"
        exit 1
        ;;
esac

echo ""
echo "🎯 URLs útiles cuando la app esté ejecutándose:"
echo "- App Web: http://localhost:8080"
echo "- DevTools: Consulta la terminal para URL específica"
echo ""
echo "⌨️  Comandos durante ejecución:"
echo "- r: Hot reload"
echo "- R: Hot restart"
echo "- q: Salir"
echo ""
echo "📖 Testing Guide: Consulta TESTING_GUIDE.md para scenarios específicos"
echo "📋 Release Notes: Consulta RELEASE_NOTES.md para características completas"
