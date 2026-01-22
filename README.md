# 🐾 RedPatitas

**Plataforma Web Comunitaria para la Gestión Integral de Mascotas y Adopciones**

[![.NET Framework](https://img.shields.io/badge/.NET%20Framework-4.8-purple)](https://dotnet.microsoft.com/)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-red)](https://www.microsoft.com/sql-server)
[![License](https://img.shields.io/badge/License-Academic-blue)]()
[![Status](https://img.shields.io/badge/Status-En%20Desarrollo-yellow)]()

---

## 📋 Descripción

RedPatitas es una plataforma web que centraliza y digitaliza el proceso de adopción de mascotas, permitiendo que refugios, adoptantes y la comunidad interactúen en un entorno seguro y confiable.

### 🎯 Objetivos

- Reducir el tiempo promedio de adopción de **45 a 21 días** (53%)
- Aumentar la tasa de adopción de **40% a 65%**
- Facilitar la reunificación de mascotas perdidas con sus dueños
- Crear una comunidad de apoyo para el bienestar animal

---

## 🛠️ Stack Tecnológico

| Capa | Tecnología |
|------|------------|
| **Frontend** | HTML5, CSS3, JavaScript |
| **Backend** | C# (.NET Framework 4.8) |
| **Arquitectura** | ASP.NET Web Forms - 3 Capas |
| **Base de Datos** | SQL Server 2019+ |
| **ORM** | LINQ to SQL |
| **Mapas** | Leaflet.js + OpenStreetMap + Nominatim API |
| **Persistencia Config** | JSON (Server-side) |

---

## 📁 Estructura del Proyecto

```
RedPatitas/
│
├── 📂 CapaDatos/                 # Capa de acceso a datos (LINQ to SQL)
│   └── DataClasses1.dbml         # Modelo de datos
│
├── 📂 CapaNegocios/              # Capa de lógica de negocio
│   ├── CN_UsuarioService.cs      # Servicios de usuario
│   ├── CN_LoginResultado.cs      # Resultado de login
│   └── CN_RegistroResultado.cs   # Resultado de registro
│
├── 📂 RedPatitas/                # Interfaz Web Forms
│   ├── Login/                    # Login, Registro
│   ├── Admin/                    # Panel SuperAdmin
│   ├── AdminRefugio/             # Panel Admin de Refugio
│   ├── Refugio/                  # Panel Usuario Refugio
│   ├── Adoptante/                # Panel Adoptante
│   └── Style/                    # CSS (dashboard.css, forms.css)
│
└── 📄 BD_RedPatitas.sql          # Script de base de datos
```

---

## 👥 Roles del Sistema

| Rol | ID | Nivel | Descripción |
|-----|:--:|:-----:|-------------|
| 👑 **SuperAdmin** | 1 | 100 | Control total del sistema |
| 🏥 **AdminRefugio** | 2 | 50 | Administra un refugio específico |
| 🐕 **Refugio** | 3 | 30 | Usuario operativo de refugio |
| 🐾 **Adoptante** | 4 | 10 | Solicita adopciones, reporta mascotas |

### Permisos por Rol

| Funcionalidad | SuperAdmin | AdminRefugio | Refugio | Adoptante |
|---------------|:----------:|:------------:|:-------:|:---------:|
| Gestión global de usuarios | ✅ | ❌ | ❌ | ❌ |
| Aprobar refugios | ✅ | ❌ | ❌ | ❌ |
| Gestionar mascotas del refugio | ❌ | ✅* | ✅ | ❌ |
| Gestionar campañas | ❌ | ✅* | ❌ | ❌ |
| Ver solicitudes de adopción | ❌ | ✅* | ✅ | ❌ |
| Buscar mascotas | ❌ | ❌ | ❌ | ✅ |
| Solicitar adopción | ❌ | ❌ | ❌ | ✅ |
| Reportar mascota perdida | ❌ | ❌ | ❌ | ✅ |
| Favoritos | ❌ | ❌ | ❌ | ✅ |

**\* = Bloqueado si el refugio no está verificado**

---

## 🗄️ Base de Datos

### Módulos Implementados

| Módulo | Tablas | Descripción |
|--------|:------:|-------------|
| 🔐 Seguridad | 4 | Usuarios, Roles, Tokens, Auditoría |
| 🏠 Refugios | 1 | Gestión de organizaciones |
| 🐾 Mascotas | 4 | Mascotas, Especies, Razas, Fotos |
| ⭐ Favoritos | 1 | Mascotas favoritas de adoptantes |
| 📝 Adopciones | 3 | Solicitudes, Criterios, Evaluación |
| 🚨 Reportes | 3 | Mascotas perdidas/encontradas, Avistamientos, Fotos |
| 🔔 Notificaciones | 1 | Alertas in-app |
| 📢 Campañas | 1 | Eventos de refugios |

**Total: 18 tablas**

---

## 🔐 Características de Seguridad

- ✅ Protección de páginas por rol (Master Pages)
- ✅ Sesiones de usuario (UsuarioId, RolId, RefugioId)
- ✅ Verificación de refugios pendientes de aprobación
- ✅ Bloqueo de funciones para refugios no verificados
- ✅ Recuperación de contraseña por token
- ✅ Auditoría de acciones del sistema
- ✅ Protección contra SQL Injection (LINQ to SQL)
- ✅ Hashing de contraseñas (SHA-256 + Salt)
- ✅ Configuración de políticas de seguridad (JSON)

---

## 📊 Sistema de Evaluación de Adoptantes

El sistema utiliza una **matriz de evaluación ponderada** para calcular la aptitud de cada solicitante:

| Criterio | Peso |
|----------|------|
| Tipo de Vivienda | 15% |
| Experiencia con Mascotas | 15% |
| Tiempo Disponible | 15% |
| Espacio Exterior | 15% |
| Compatibilidad Familiar | 10% |
| Estabilidad Económica | 15% |
| Motivación | 15% |

**Resultado:**
- ≥ 70 puntos: ✅ APTO PARA ADOPCIÓN
- 50-69 puntos: ⚠️ REQUIERE EVALUACIÓN ADICIONAL
- < 50 puntos: ❌ NO APTO

---

## 🚀 Instalación

### Prerrequisitos

- Visual Studio 2022
- SQL Server 2019 o superior
- .NET Framework 4.8

### Pasos

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/D1l4nF/RedPatitas.git
   ```

2. **Crear la base de datos**
   ```sql
   CREATE DATABASE RedPatitas;
   GO
   USE RedPatitas;
   GO
   -- Ejecutar el script BD_RedPatitas.sql
   ```

3. **Configurar conexión** en `CapaDatos/App.config`

4. **Ejecutar el proyecto**
   - Abrir `RedPatitas.sln` en Visual Studio
   - Presionar F5 para ejecutar

---

## 📅 Roadmap

- [x] Módulo de Seguridad y Autenticación
- [x] Protección de páginas por rol
- [x] Sistema de registro (Adoptante y Refugio)
- [x] Verificación de refugios
- [x] Verificación automática de adoptantes (perfil completo)
- [x] Perfil de usuario
- [x] Estructura de Master Pages con menús dinámicos
- [x] Panel SuperAdmin completo (Dashboard, Usuarios, Refugios, Reportes, Configuración, Auditoría, Notificaciones, MascotasPerdidas)
- [x] CRUD de Mascotas (Adoptante)
- [x] Sistema de Solicitudes de Adopción
- [x] Reportar Mascotas Perdidas/Encontradas
- [x] Sistema de Favoritos
- [x] Mapa interactivo de extravíos con Leaflet.js
- [ ] CRUD de Mascotas (Refugio - Panel completo)
- [ ] Evaluación de Adopciones (UI de matriz de criterios)

---

## 👨‍💻 Autores

| Nombre | Rol |
|--------|-----|
| **Dayana Ordoñez** | Desarrolladora |
| **Jaime Peralvo** | Desarrollador |
| **Dilan Pérez** | Desarrollador |

**Tutora:** Jessica Reyes

---

## 📝 Licencia

Este proyecto fue desarrollado con fines académicos como parte del **Proyecto Integrador de Tercer Nivel** (Periodo 2025-2026).

---

<p align="center">
  <strong>🐾 Porque cada mascota merece un hogar 🏠</strong>
</p>
