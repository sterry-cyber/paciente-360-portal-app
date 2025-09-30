#!/bin/bash

# Script de instalación para Paciente 360
# Este script configura el entorno de desarrollo completo

echo "🏥 Configurando Paciente 360 - Plataforma de Gestión Hospitalaria"
echo "================================================================"

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Por favor instala Docker primero."
    echo "   Visita: https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar si Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado. Por favor instala Docker Compose primero."
    echo "   Visita: https://docs.docker.com/compose/install/"
    exit 1
fi

# Verificar si Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado. Por favor instala Flutter primero."
    echo "   Visita: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Todas las dependencias están instaladas"

# Crear archivo .env si no existe
if [ ! -f backend/.env ]; then
    echo "📝 Creando archivo de configuración .env..."
    cp backend/env_template.txt backend/.env
    echo "✅ Archivo .env creado. Por favor revisa y ajusta las configuraciones."
fi

# Crear directorios necesarios
echo "📁 Creando directorios necesarios..."
mkdir -p backend/logs
mkdir -p backend/media
mkdir -p backend/staticfiles

# Construir y levantar servicios con Docker
echo "🐳 Construyendo y levantando servicios con Docker..."
docker-compose build

echo "🚀 Iniciando servicios..."
docker-compose up -d

# Esperar a que los servicios estén listos
echo "⏳ Esperando a que los servicios estén listos..."
sleep 30

# Ejecutar migraciones de Django
echo "🗄️ Ejecutando migraciones de base de datos..."
docker-compose exec backend python manage.py migrate

# Crear superusuario
echo "👤 Creando superusuario..."
echo "Por favor ingresa los datos del administrador:"
docker-compose exec backend python manage.py createsuperuser

# Recopilar archivos estáticos
echo "📦 Recopilando archivos estáticos..."
docker-compose exec backend python manage.py collectstatic --noinput

# Instalar dependencias de Flutter
echo "📱 Instalando dependencias de Flutter..."
cd mobile
flutter pub get
cd ..

echo ""
echo "🎉 ¡Instalación completada!"
echo ""
echo "📋 Servicios disponibles:"
echo "   • Backend API: http://localhost:8000"
echo "   • Documentación API: http://localhost:8000/api/docs/"
echo "   • Admin Django: http://localhost:8000/admin/"
echo ""
echo "📱 Para ejecutar la aplicación móvil:"
echo "   cd mobile"
echo "   flutter run"
echo ""
echo "🛠️ Para detener los servicios:"
echo "   docker-compose down"
echo ""
echo "📚 Para más información, consulta el README.md"
echo ""
echo "¡Bienvenido a Paciente 360! 🏥"
