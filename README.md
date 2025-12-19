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
| **Frontend** | HTML5, CSS3, JavaScript, Bootstrap 5.3 |
| **Backend** | C# (.NET Framework 4.8) |
| **Arquitectura** | ASP.NET Web Forms - 3 Capas (DAL, BLL, UI) |
| **Base de Datos** | SQL Server 2019+ |
| **ORM** | Linq to SQL |
| **Mapas** | Leaflet.js + OpenStreetMap |

---

## 📁 Estructura del Proyecto

```
RedPatitas.Solution/
│
├── 📂 RedPatitas.Entities/      # Clases de entidades
├── 📂 RedPatitas.DAL/           # Capa de acceso a datos
├── 📂 RedPatitas.BLL/           # Capa de lógica de negocio
├── 📂 RedPatitas.Web/           # Interfaz Web Forms
│   ├── Account/                  # Login, Registro
│   ├── Mascotas/                 # CRUD de mascotas
│   ├── Adopciones/               # Solicitudes y evaluación
│   ├── Reportes/                 # Mascotas perdidas/encontradas
│   ├── Admin/                    # Panel de administración
│   └── Comunidad/                # Foro y campañas
│
└── 📄 BD_RedPatitas.sql         # Script de base de datos
```

---

## 👥 Roles del Sistema

| Rol | Nivel | Descripción |
|-----|-------|-------------|
| 👑 **SuperAdmin** | 100 | Control total del sistema |
| 🏥 **AdminRefugio** | 50 | Administra un refugio específico |
| 🐕 **Refugio** | 30 | Registra mascotas, responde solicitudes |
| 🐾 **Adoptante** | 10 | Solicita adopciones, reporta mascotas |

---

## 🗄️ Base de Datos

### Resumen

| Elemento | Cantidad |
|----------|----------|
| Tablas | 23 |
| Vistas | 5 |
| Procedimientos Almacenados | 7 |
| Índices | 14 |

### Módulos

- 🔐 **Seguridad**: Usuarios, Roles, Tokens, Auditoría, Bloqueo de cuentas
- 🏠 **Refugios**: Gestión de organizaciones con múltiples usuarios
- 🐾 **Mascotas**: Especies, Razas, Galería de fotos
- 📝 **Adopciones**: Solicitudes, Evaluación con matriz ponderada
- 🚨 **Reportes**: Mascotas perdidas/encontradas con geolocalización
- 🔔 **Notificaciones**: Alertas in-app y campañas
- 💬 **Comunidad**: Foro con categorías, comentarios y likes

---

## 🔐 Características de Seguridad

- ✅ Contraseñas hasheadas con SHA-256 + Salt
- ✅ Bloqueo automático después de 3 intentos fallidos
- ✅ Desbloqueo automático después de 30 minutos
- ✅ Recuperación de contraseña por token
- ✅ Auditoría de todas las acciones del sistema
- ✅ Protección contra SQL Injection (Linq to SQL)
- ✅ Validación de entradas con Data Annotations

---

## 📊 Sistema de Evaluación de Adoptantes

El sistema utiliza una **matriz de evaluación ponderada** con cursores para calcular la aptitud de cada solicitante:

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
   -- Ejecutar en SQL Server Management Studio
   CREATE DATABASE RedPatitas;
   GO
   USE RedPatitas;
   GO
   -- Ejecutar el script BD_RedPatitas.sql
   ```

3. **Configurar conexión**
   ```xml
   <!-- Web.config -->
   <connectionStrings>
     <add name="RedPatitasConnection" 
          connectionString="Data Source=.;Initial Catalog=RedPatitas;Integrated Security=True" />
   </connectionStrings>
   ```

4. **Ejecutar el proyecto**
   - Abrir `RedPatitas.sln` en Visual Studio
   - Presionar F5 para ejecutar

---

## 📸 Capturas de Pantalla

*Próximamente...*

---

## 📅 Roadmap

- [x] Sprint 1: Módulo de Seguridad y Autenticación *(En progreso)*
- [x] Sprint 1: CRUD de Mascotas *(En progreso)*
- [ ] Sprint 2: Módulo de Adopciones y Evaluación
- [ ] Sprint 3: Geolocalización y Reportes
- [ ] Sprint 4: Panel Admin y Comunidad

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
