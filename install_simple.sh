#!/bin/bash

# Script de instalación simplificado para Paciente 360
# Este script configura el entorno de desarrollo sin Docker

echo "🏥 Configurando Paciente 360 - Instalación Simplificada"
echo "========================================================"

# Verificar si Python está instalado
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 no está instalado. Por favor instala Python 3 primero."
    echo "   Visita: https://www.python.org/downloads/"
    exit 1
fi

echo "✅ Python 3 está instalado"

# Verificar si pip está instalado
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 no está instalado. Por favor instala pip3 primero."
    exit 1
fi

echo "✅ pip3 está instalado"

# Crear entorno virtual
echo "📦 Creando entorno virtual..."
cd backend
python3 -m venv venv

# Activar entorno virtual
echo "🔧 Activando entorno virtual..."
source venv/bin/activate

# Instalar dependencias
echo "📥 Instalando dependencias de Python..."
pip install --upgrade pip
pip install -r requirements.txt

# Crear archivo .env si no existe
if [ ! -f .env ]; then
    echo "📝 Creando archivo de configuración .env..."
    cp env_template.txt .env
    echo "✅ Archivo .env creado. Por favor revisa y ajusta las configuraciones."
fi

# Crear directorios necesarios
echo "📁 Creando directorios necesarios..."
mkdir -p logs
mkdir -p media
mkdir -p staticfiles

# Configurar base de datos SQLite para desarrollo
echo "🗄️ Configurando base de datos SQLite..."
python manage.py migrate

# Crear superusuario
echo "👤 Creando superusuario..."
echo "Por favor ingresa los datos del administrador:"
python manage.py createsuperuser

# Crear usuarios STERRY y WAYMARA
echo "👥 Creando usuarios STERRY y WAYMARA..."
python manage.py create_stery_waymara

# Recopilar archivos estáticos
echo "📦 Recopilando archivos estáticos..."
python manage.py collectstatic --noinput

echo ""
echo "🎉 ¡Instalación completada!"
echo ""
echo "📋 Para iniciar el servidor:"
echo "   cd backend"
echo "   source venv/bin/activate"
echo "   python manage.py runserver"
echo ""
echo "📱 Para ejecutar la aplicación móvil:"
echo "   cd mobile"
echo "   flutter pub get"
echo "   flutter run"
echo ""
echo "🧪 Para probar el login:"
echo "   python3 test_login.py"
echo ""
echo "📚 Para más información, consulta el README.md"
echo ""
echo "¡Bienvenido a Paciente 360! 🏥"
