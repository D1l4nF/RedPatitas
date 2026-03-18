# 🐾 RedPatitas

**Plataforma Web Comunitaria para la Gestión Integral de Mascotas y Adopciones**

[![.NET Framework](https://img.shields.io/badge/.NET%20Framework-4.8-purple)](https://dotnet.microsoft.com/)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-red)](https://www.microsoft.com/sql-server)
[![License](https://img.shields.io/badge/License-Academic-blue)]()
[![Status](https://img.shields.io/badge/Status-Estable-green)]()

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
│   ├── CN_MascotaService.cs      # Gestión de catálogo
│   └── CN_CampaniaService.cs     # Módulo de eventos
│
├── 📂 RedPatitas/                # Interfaz Web Forms
│   ├── Public/                   # Home, Adopta, Reportar
│   ├── Admin/                    # Panel SuperAdmin
│   ├── AdminRefugio/             # Panel Gestión de Refugio
│   ├── Adoptante/                # Panel Adoptante
│   └── Images/                   # Assets y Fotos
│
└── 📄 BD_RedPatitas.sql          # Script UNIFICADO de base de datos
```

---

## 👥 Roles del Sistema

| Rol | ID | Nivel | Descripción |
|-----|:--:|:-----:|-------------|
| 👑 **SuperAdmin** | 1 | 100 | Control total del sistema |
| 🏥 **AdminRefugio** | 2 | 50 | Administra un refugio específico |
| 🐕 **Refugio** | 3 | 30 | Usuario operativo de refugio |
| 🐾 **Adoptante** | 4 | 10 | Solicita adopciones, reporta mascotas |

---

## 🗄️ Base de Datos

### Módulos Consolidados en `BD_RedPatitas.sql`

| Módulo | Tablas | Descripción |
|--------|:------:|-------------|
| 🔐 Seguridad | 5 | Usuarios, Roles, Tokens, Auditoría |
| 🐾 Catálogo | 5 | Mascotas, Especies, Razas, Fotos, Favoritos |
| 📝 Adopción | 4 | Solicitudes, Criterios, Evaluación, FotosVivienda |
| 📍 Seguimiento| 1 | Hitos post-adopción con ubicación GPS |
| 📜 Docs | 2 | Certificados digitales y Notificaciones |
| 🚨 Comunidad | 3 | Reportes extravío, Avistamientos, Fotos |
| 📢 Campañas | 1 | Gestión de eventos y campañas |

**Total: 21 tablas unificadas en un solo script.**

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

---

## 🚀 Instalación y Despliegue

### Prerrequisitos

- Visual Studio 2022
- SQL Server Instance (Local o Cloud)
- .NET Framework 4.8

### Pasos Rápidos

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/D1l4nF/RedPatitas.git
   ```

2. **Base de Datos Única**
   - Abrir SQL Server Management Studio.
   - Crear base de datos `RedPatitas`.
   - Ejecutar el script `BD_RedPatitas.sql` (incluye Tablas, Vistas, SPs y SuperAdmin inicial).

3. **Configuración de Conexión**
   - Actualizar el `Web.config` de la aplicación con sus credenciales de SQL local.
   - Ajustar el `App.config` en `CapaDatos` para el asistente de LINQ.

4. **Credenciales Iniciales**
   - **Usuario:** `admin@test.com`
   - **Clave:** `admin123`

---

## 📅 Roadmap (Status Actual)

- [x] Módulo de Seguridad y Autenticación con Hashing
- [x] Protección de páginas por rol y Master Pages
- [x] Sistema de registro (Adoptante y Refugio)
- [x] Panel SuperAdmin completo (Estadísticas Reales)
- [x] Gestión de Mascotas por Refugio
- [x] Sistema de Favoritos y Búsqueda Avanzada
- [x] **MATRIZ DE EVALUACIÓN** de solicitudes (Criterios Automáticos)
- [x] **SEGUIMIENTO POST-ADOPCIÓN** (Hitos con evidencia GPS)
- [x] **MODULO DE CAMPAÑAS** (Mapa interactivo y Verificación)
- [x] **CERTIFICADOS DIGITALES** (Generación en PDF/Print)
- [x] Mapa de extravíos interactivo (Leaflet.js)
- [ ] Integración de Notificaciones Push (Roadmap Futuro)
- [ ] App Móvil PWA (Roadmap Futuro)

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

Desarrollado para el **Proyecto Integrador de Tercer Nivel** - Periodo 2025-2026.

<p align="center">
  <strong>🐾 Porque cada mascota merece un hogar 🏠</strong>
</p>
