# 🏥 PACIENTE 360 – Solución Integral de Salud Digital

**Desarrollado por: CODE TITANS**

> "Transformando la atención hospitalaria en Nicaragua con tecnología accesible"

---

## 🎯 Reto: Portal Paciente – “Paciente App” (Nivel Avanzado)

**PACIENTE 360** es una solución digital integral diseñada para **automatizar el registro, seguimiento de pacientes y programación de citas médicas** en los hospitales públicos de Nicaragua.
Enfrentamos desafíos crónicos como **largas filas, sobrecarga administrativa y acceso limitado a historiales médicos**, proponiendo una app móvil y web que mejora la experiencia del paciente y optimiza la gestión hospitalaria.

---

## 📋 Descripción del Proyecto

**PACIENTE 360** integra funcionalidades clave para pacientes y personal médico, utilizando tecnologías modernas, escalables y de bajo costo, pensadas específicamente para el contexto nicaragüense.

El sistema permite:

- ✅ Registro digital de pacientes
- ✅ Programación de citas médicas desde casa
- ✅ Fila virtual para reducir aglomeraciones
- ✅ Acceso seguro al historial clínico
- ✅ Gestión centralizada de expedientes electrónicos
- ✅ Reportes en tiempo real para administradores

---

## 🎯 Objetivos

- ✅ Agilizar la atención médica en hospitales públicos.
- ✅ Eliminar filas físicas con un sistema de turnos virtuales.
- ✅ Reducir errores administrativos mediante digitalización.
- ✅ Mejorar la experiencia del paciente con notificaciones y acceso 24/7.
- ✅ Empoderar al personal médico con herramientas digitales eficientes.
- ✅ Generar reportes automatizados para toma de decisiones.

---


---


## 🗂️ Tabla de Contenidos

- [🏥 PACIENTE 360 – Solución Integral de Salud Digital](#-paciente-360--solución-integral-de-salud-digital)
  - [🎯 Reto: Portal Paciente – “Paciente App” (Nivel Avanzado)](#-reto-portal-paciente--paciente-app-nivel-avanzado)
  - [📋 Descripción del Proyecto](#-descripción-del-proyecto)
  - [🎯 Objetivos](#-objetivos)
  - [🗂️ Tabla de Contenidos](#️-tabla-de-contenidos)
  - [✨ Características](#-características)
  - [🧩 Arquitectura](#-arquitectura)
  - [⚡ Instalación](#-instalación)
    - [🖥️ Requisitos](#️-requisitos)
    - [📥 Clonar el repositorio](#-clonar-el-repositorio)
  - [🛠️ Backend (Django)](#️-backend-django)
    - [⚙️ Instalación](#️-instalación)
    - [🗄️ Migraciones y arranque](#️-migraciones-y-arranque)
    - [🏗️ Estructura de apps](#️-estructura-de-apps)
  - [📱 Mobile (Flutter)](#-mobile-flutter)
    - [⚙️ Instalación](#️-instalación-1)
    - [🛡️ Configuración](#️-configuración)
  - [🔑 Variables de Entorno](#-variables-de-entorno)
  - [🧪 Testing](#-testing)
  - [🚢 Despliegue](#-despliegue)
  - [🤝 Contribuir](#-contribuir)
  - [�️ Control de Versiones](#️-control-de-versiones)
  - [📄 Licencia](#-licencia)

---

## ✨ Características

- 👨‍⚕️ Gestión de pacientes, doctores, citas y expedientes médicos.
- 🔒 Autenticación y notificaciones.
- 🔗 API RESTful segura.
- 📲 App móvil multiplataforma (Android/iOS).
- ☁️ Integración con servicios externos (Firebase, Google).

---

## 🧩 Arquitectura

```diff
Paciente 360/
├── backend/        # Django REST API
├── mobile/         # Flutter App
├── assets/         # Recursos gráficos
└── nginx.conf      # Configuración de servidor
```

---

## ⚡ Instalación

### 🖥️ Requisitos

- 🐍 Python 3.10+
- 🟩 Node.js (opcional para frontend)
- 💙 Flutter 3.x
- 🐳 Docker (opcional)
- 🗃️ Git

### 📥 Clonar el repositorio

### 📥 Clonar el repositorio

```sh
git clone https://github.com/sterry-cyber/paciente-360-portal-app.git
cd PACIENTE_360
```

---

## 🛠️ Backend (Django)

### ⚙️ Instalación

```sh
cd backend
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

### 🗄️ Migraciones y arranque

```sh
python manage.py migrate
python manage.py runserver
```

### 🏗️ Estructura de apps

- 🗓️ `appointments/` - Gestión de citas
- 🔑 `authentication/` - Usuarios y login
- 👨‍⚕️ `doctors/` - Información de doctores
- 📋 `medical_records/` - Expedientes médicos
- 🔔 `notifications/` - Notificaciones push/email
- 🧑‍🤝‍🧑 `patients/` - Gestión de pacientes

---

## 📱 Mobile (Flutter)

### ⚙️ Instalación

```sh
cd mobile
flutter pub get
flutter run
```

### 🛡️ Configuración

- 🤖 Android: Coloca tu `google-services.json` en `android/app/`
- 🍏 iOS: Coloca tu `GoogleService-Info.plist` en `ios/Runner/`

---

## 🔑 Variables de Entorno

- 🛡️ Backend: Copia `env_template.txt` a `.env` y configura tus credenciales.
- 📲 Mobile: Configura las claves de Firebase en los archivos correspondientes.

---

## 🧪 Testing

- 🧑‍💻 Django: `python manage.py test`
- 🧑‍💻 Flutter: `flutter test`

---

## 🚢 Despliegue

- 🐳 Docker: Usa `Dockerfile` en `backend/` para contenedores.
- 🖥️ Nginx: Configura el proxy con `nginx.conf`.

---

## 🤝 Contribuir

1. 🍴 Haz un fork del repositorio.
2. 🌱 Crea una rama (`git checkout -b feature/nueva-funcionalidad`)
3. 💾 Haz commit de tus cambios.
4. 🚀 Haz push y abre un Pull Request.

---

##  Control de Versiones
•	Versión 1:
- meditrack
-https://github.com/sterry-cyber/meditrack-v2.git
- Versión 2:
- `hospital_app_nic
https://github.com/sterry-cyber/hospital_app_nic.git

•	- Versión 3:
paciente-360-portal
https://github.com/sterry-cyber/paciente-360-portal-app.git

---

- 📌 Rama principal: `main`
- 🏷️ Convención de ramas:
  - `feature/<nombre>` para nuevas funcionalidades
  - `fix/<nombre>` para correcciones de errores
  - `hotfix/<nombre>` para parches urgentes
  - `release/<versión>` para lanzamientos

- 📦 Commits recomendados:
  - `feat: descripción` para nuevas características
  - `fix: descripción` para correcciones
  - `docs: descripción` para documentación
  - `refactor: descripción` para mejoras internas
  - `test: descripción` para pruebas

- 🔄 Pull Requests:
  - Realiza PRs hacia `main`
  - Incluye descripción clara y referencia a issues si aplica
  - Espera revisión antes de merge

---

## 📄 Licencia

MIT © Sterry Cyber
