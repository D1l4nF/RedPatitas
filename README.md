# 🐾 RedPatitas

**Plataforma Web Comunitaria para la Gestión Integral de Mascotas y Adopciones**

[![.NET Framework](https://img.shields.io/badge/.NET%20Framework-4.8.1-purple)](https://dotnet.microsoft.com/)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-red)](https://www.microsoft.com/sql-server)
[![ASP.NET Web Forms](https://img.shields.io/badge/ASP.NET-Web%20Forms-blue)](https://learn.microsoft.com/aspnet/web-forms/)
[![License](https://img.shields.io/badge/License-Academic-orange)]()
[![Status](https://img.shields.io/badge/Status-MVP%20Funcional-brightgreen)]()

---

## 📋 Descripción

RedPatitas es una plataforma web que centraliza y digitaliza el proceso de adopción de mascotas, permitiendo que refugios, adoptantes y la comunidad interactúen en un entorno seguro y confiable. El sistema abarca desde el registro y catálogo de mascotas, hasta el seguimiento post-adopción con evidencia GPS, certificados digitales y un mapa comunitario de mascotas perdidas.

### 🎯 Objetivos

- Reducir el tiempo promedio de adopción de **45 a 21 días** (53%)
- Aumentar la tasa de adopción de **40% a 65%**
- Facilitar la reunificación de mascotas perdidas con sus dueños
- Crear una comunidad de apoyo para el bienestar animal

---

## 🛠️ Stack Tecnológico

| Capa | Tecnología |
|------|------------|
| **Frontend** | HTML5, CSS3, JavaScript, SweetAlert2 |
| **Backend** | C# (.NET Framework 4.8.1) |
| **Arquitectura** | ASP.NET Web Forms - 3 Capas (Presentación, Negocios, Datos) |
| **Base de Datos** | SQL Server 2019+ |
| **ORM** | LINQ to SQL |
| **Mapas** | Leaflet.js + OpenStreetMap + Nominatim API |
| **Notificaciones UI** | SweetAlert2 (Toasts y Modales) |
| **Email** | SMTP (Gmail) |
| **Almacenamiento** | Server-side (Uploads/) |

---

## 📁 Estructura del Proyecto

```
RedPatitas/
│
├── 📂 CapaDatos/                   # Capa de acceso a datos (LINQ to SQL)
│   ├── DataClasses1.dbml           # Modelo de datos (21 tablas mapeadas)
│   └── app.config                  # Config de conexión para el diseñador
│
├── 📂 CapaNegocios/                # Capa de lógica de negocio (16 servicios)
│   ├── CN_UsuarioService.cs        # Auth, registro, gestión de usuarios
│   ├── CN_MascotaService.cs        # CRUD mascotas, fotos, búsqueda avanzada
│   ├── CN_AdopcionService.cs       # Solicitudes, evaluación, aprobación/rechazo
│   ├── CN_SeguimientoService.cs    # Hitos post-adopción con GPS
│   ├── CN_CertificadoService.cs    # Generación de certificados digitales
│   ├── CN_CampaniaService.cs       # Gestión de campañas y eventos
│   ├── CN_NotificacionService.cs   # Sistema de notificaciones in-app
│   ├── CN_DashboardService.cs      # Estadísticas, tendencias, gráficos
│   ├── CN_AdminRefugioService.cs   # Operaciones admin de refugio
│   ├── CN_AdminUsuarioService.cs   # Gestión avanzada de usuarios (SuperAdmin)
│   ├── CN_AuditoriaService.cs      # Log de acciones del sistema
│   ├── CN_RefugioService.cs        # Perfil y datos del refugio
│   ├── CN_EmailService.cs          # Envío de correos (SMTP Gmail)
│   ├── CN_CryptoService.cs         # Hashing SHA-256 + Salt
│   ├── CN_LoginResultado.cs        # DTO de resultado de login
│   └── CN_RegistroResultado.cs     # DTO de resultado de registro
│
├── 📂 RedPatitas/                  # Capa de Presentación (Web Forms)
│   ├── 📂 Public/                  # Páginas públicas (sin login)
│   │   ├── Home.aspx               # Landing page con impacto social
│   │   ├── Adopta.aspx             # Catálogo público de mascotas
│   │   ├── PerfilMascota.aspx      # Detalle público de mascota
│   │   ├── MapaExtravios.aspx      # Mapa interactivo de extravíos (Leaflet.js)
│   │   ├── Reportar.aspx           # Reportar mascota perdida/encontrada
│   │   ├── DetalleReporte.aspx     # Ver detalle de un reporte
│   │   ├── RegistrarAvistamiento.aspx # Registrar avistamiento comunitario
│   │   ├── 404.aspx                # Página de error personalizada
│   │   └── Public.Master           # Master page pública
│   │
│   ├── 📂 Login/                   # Autenticación
│   │   ├── Login.aspx              # Inicio de sesión con alertas contextuales
│   │   ├── Registro.aspx           # Registro (Adoptante y Refugio)
│   │   ├── RecuperarContrasena.aspx # Solicitar recuperación por email
│   │   └── CambiarContrasena.aspx  # Cambio con token temporal
│   │
│   ├── 📂 Admin/                   # Panel SuperAdmin (11 páginas)
│   │   ├── Dashboard.aspx          # Estadísticas globales con tendencias
│   │   ├── Usuarios.aspx           # CRUD de usuarios, bloqueo/desbloqueo
│   │   ├── Refugios.aspx           # Verificación y gestión de refugios
│   │   ├── Reportes.aspx           # Supervisión de reportes
│   │   ├── MascotasPerdidas.aspx   # Gestión de mascotas perdidas
│   │   ├── Configuracion.aspx      # Config del sistema
│   │   ├── Auditoria.aspx          # Log de auditoría del sistema
│   │   ├── Notificaciones.aspx     # Centro de notificaciones
│   │   ├── Perfil.aspx             # Perfil del admin
│   │   ├── DetalleReporte.aspx     # Vista detallada de reporte
│   │   └── Admin.Master            # Master page admin
│   │
│   ├── 📂 AdminRefugio/            # Panel Admin de Refugio (15 páginas)
│   │   ├── Dashboard.aspx          # KPIs del refugio con tendencias
│   │   ├── Estadisticas.aspx       # Gráficos avanzados del refugio
│   │   ├── Mascotas.aspx           # CRUD de mascotas (fotos múltiples)
│   │   ├── Solicitudes.aspx        # Listado filtrable de solicitudes
│   │   ├── RevisarSolicitud.aspx   # Revisión con matriz de evaluación
│   │   ├── HistorialSolicitudes.aspx # Historial de solicitudes procesadas
│   │   ├── Campanias.aspx          # CRUD de campañas con mapa
│   │   ├── VerSeguimiento.aspx     # Revisión de seguimientos post-adopción
│   │   ├── AuditoriaSeguimientos.aspx # Auditoría de seguimientos
│   │   ├── Certificados.aspx       # Listado de certificados emitidos
│   │   ├── Usuarios.aspx           # Gestión de personal del refugio
│   │   ├── Actividad.aspx          # Registro de actividad
│   │   ├── Notificaciones.aspx     # Centro de notificaciones
│   │   ├── Perfil.aspx             # Perfil y datos del refugio
│   │   └── AdminRefugio.Master     # Master page con sidebar
│   │
│   ├── 📂 Adoptante/               # Panel Adoptante (20 páginas)
│   │   ├── Dashboard.aspx          # Resumen personal
│   │   ├── Mascotas.aspx           # Catálogo con filtros avanzados
│   │   ├── MascotasDisponible.aspx # Explorar mascotas disponibles
│   │   ├── PerfilMascota.aspx      # Detalle con galería de fotos
│   │   ├── SolicitudAdopcion.aspx  # Formulario completo de solicitud
│   │   ├── MisSolicitudes.aspx     # Mis solicitudes enviadas
│   │   ├── Solicitudes.aspx        # Estado de solicitudes
│   │   ├── Favoritos.aspx          # Mascotas favoritas (❤️ toggle)
│   │   ├── MisSeguimientos.aspx    # Etapas de seguimiento post-adopción
│   │   ├── CompletarSeguimiento.aspx # Formulario con GPS y foto en vivo
│   │   ├── MiCertificado.aspx      # Ver/descargar certificado de adopción
│   │   ├── ReportarMascota.aspx    # Reportar mascota perdida
│   │   ├── MisReportes.aspx        # Mis reportes activos
│   │   ├── DetalleReporte.aspx     # Ver reporte con mapa
│   │   ├── Notificaciones.aspx     # Centro de notificaciones
│   │   ├── Perfil.aspx             # Perfil personal completo
│   │   └── Adoptante.Master        # Master page adoptante
│   │
│   ├── 📂 Refugio/                 # Panel Personal de Refugio (8 páginas)
│   │   ├── Dashboard.aspx          # Vista operativa
│   │   ├── Mascotas.aspx           # Gestión de mascotas
│   │   ├── Solicitudes.aspx        # Ver solicitudes
│   │   ├── RevisarSolicitud.aspx   # Evaluar solicitudes
│   │   ├── Certificados.aspx       # Certificados emitidos
│   │   ├── Notificaciones.aspx     # Notificaciones
│   │   ├── Perfil.aspx             # Perfil personal
│   │   └── Refugio.Master          # Master page refugio
│   │
│   ├── 📂 Style/                   # Hojas de estilo
│   │   ├── estilos-base.css        # Variables CSS y estilos globales
│   │   ├── estilos-paneles.css     # Estilos de dashboards y paneles
│   │   ├── estilos-publicos.css    # Estilos de páginas públicas
│   │   ├── auth.css                # Estilos de login/registro
│   │   └── Mascotas_disponibles.css # Estilos del catálogo
│   │
│   ├── 📂 Js/                      # JavaScript
│   │   ├── ux-components.js        # Componentes UX reutilizables
│   │   └── mapas-reportes.js       # Lógica de mapas Leaflet
│   │
│   ├── 📂 Images/                  # Assets y fotos de perfil
│   │   ├── 📂 Campanias/           # Imágenes de campañas
│   │   ├── 📂 Mascotas/            # Fotos de mascotas
│   │   └── 📂 Default/             # Imágenes por defecto
│   │
│   ├── 📂 Uploads/                 # Archivos subidos por usuarios
│   │   ├── 📂 Reportes/            # Fotos de reportes de extravío
│   │   ├── 📂 Seguimientos/        # Fotos de seguimiento post-adopción
│   │   └── 📂 Solicitudes/         # Fotos de vivienda (solicitudes)
│   │
│   ├── VerCertificado.aspx         # Vista pública de certificado (Print/PDF)
│   └── Web.config                  # Configuración (conexión, límites 20MB)
│
├── 📄 BD_RedPatitas.sql            # Script UNIFICADO de base de datos
├── 📄 COMPONENTES.md               # Guía de componentes UI reutilizables
└── 📄 README.md                    # Este archivo
```

---

## 👥 Roles del Sistema

| Rol | ID | Nivel | Páginas | Descripción |
|-----|:--:|:-----:|:-------:|-------------|
| 👑 **SuperAdmin** | 1 | 100 | 11 | Control total: usuarios, refugios, reportes, auditoría |
| 🏥 **AdminRefugio** | 2 | 50 | 15 | Gestiona su refugio: mascotas, solicitudes, campañas, certificados |
| 🐕 **Refugio** (Staff) | 3 | 30 | 8 | Operativo de refugio: mascotas, solicitudes, certificados |
| 🐾 **Adoptante** | 4 | 10 | 20 | Adopta, reporta, favoritos, seguimiento, certificados |

---

## 🗄️ Base de Datos

### Script Unificado: `BD_RedPatitas.sql`

| Módulo | Tablas | Componentes |
|--------|:------:|-------------|
| 🔐 **Seguridad** | 5 | `tbl_Roles`, `tbl_Refugios`, `tbl_Usuarios`, `tbl_TokensRecuperacion`, `tbl_Auditoria` |
| 🐾 **Catálogo** | 2 | `tbl_Especies`, `tbl_Razas` |
| 🐕 **Mascotas** | 3 | `tbl_Mascotas`, `tbl_FotosMascotas`, `tbl_Favoritos` |
| 📝 **Adopción** | 4 | `tbl_CriteriosEvaluacion`, `tbl_SolicitudesAdopcion`, `tbl_DetalleEvaluacion`, `tbl_FotosSolicitud` |
| 📍 **Seguimiento** | 1 | `tbl_SeguimientosAdopcion` (4 etapas con GPS) |
| 📜 **Documentos** | 2 | `tbl_CertificadosAdopcion`, `tbl_Notificaciones` |
| 🚨 **Comunidad** | 3 | `tbl_ReportesMascotas`, `tbl_FotosReportes`, `tbl_Avistamientos` |
| 📢 **Campañas** | 1 | `tbl_Campanias` |

**Total: 21 tablas + 2 vistas + 7 stored procedures + 3 índices**

### Objetos DB Incluidos

| Tipo | Nombre | Función |
|------|--------|---------|
| Vista | `vw_EstadisticasGenerales` | Contadores globales del sistema |
| Vista | `vw_MascotasCompleta` | Mascotas con especie, raza y refugio |
| SP | `sp_ValidarLogin` | Login con bloqueo por intentos |
| SP | `sp_CalcularEvaluacionAdopcion` | Cálculo ponderado de aptitud |
| SP | `sp_ProgramarSeguimientosAdopcion` | Crea 4 hitos automáticos |
| SP | `sp_RevisarSeguimiento` | Aprueba/rechaza seguimiento |
| SP | `sp_SolicitarDevolucion` | Inicia proceso de devolución |
| SP | `sp_ConfirmarDevolucionRetorno` | Confirma devolución/maltrato |
| SP | `sp_GenerarCertificadoAdopcion` | Genera certificado con código único |

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
| Motivación y Compromiso | 15% |

---

## 🔐 Seguridad Implementada

| Característica | Detalle |
|----------------|---------|
| **Hashing** | SHA-256 + Salt aleatorio de 32 chars |
| **Bloqueo de cuenta** | Automático tras 3 intentos fallidos |
| **Protección de páginas** | Validación de sesión y rol en cada Master Page |
| **Tokens temporales** | Para recuperación de contraseña con expiración 24h |
| **Auditoría** | Log de acciones con IP, usuario, tabla y valores |
| **Archivos** | Límite de 20MB configurado en Web.config e IIS |

---

## 🚀 Instalación y Despliegue

### Prerrequisitos

- Visual Studio 2022
- SQL Server 2019+ (LocalDB, Express o instancia completa)
- .NET Framework 4.8.1
- IIS (para despliegue en producción)

### Pasos Rápidos

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/D1l4nF/RedPatitas.git
   ```

2. **Base de Datos**
   - Abrir SQL Server Management Studio.
   - Crear base de datos `RedPatitas`.
   - Ejecutar el script `BD_RedPatitas.sql` (incluye Tablas, Vistas, SPs, Datos iniciales y SuperAdmin).

3. **Configuración de Conexión**
   - Actualizar el `Web.config` con la cadena de conexión correcta:
     ```xml
     <add name="CapaDatos.Properties.Settings.RedPatitasConnectionString" 
          connectionString="Data Source=.;Initial Catalog=RedPatitas;Integrated Security=True" />
     ```
   - Ajustar el `app.config` en `CapaDatos` si se usa una instancia diferente.

4. **Credenciales Iniciales**
   - **Usuario:** `admin@test.com`
   - **Clave:** `admin123`

5. **Ejecutar**
   - Abrir `RedPatitas.slnx` en Visual Studio 2022.
   - Establecer `RedPatitas` como proyecto de inicio.
   - Ejecutar con `F5` (IIS Express) o publicar en IIS.

---

## 📅 Roadmap (Status Actual)

### ✅ Implementado y Funcional

- [x] Módulo de Seguridad y Autenticación (SHA-256 + Salt)
- [x] Bloqueo de cuentas por intentos fallidos
- [x] Protección de páginas por rol con Master Pages
- [x] Recuperación de contraseña por email (SMTP)
- [x] Sistema de registro (Adoptante y Refugio con geolocalización)
- [x] Panel SuperAdmin completo (Dashboard con Estadísticas Reales)
- [x] Panel AdminRefugio completo (15 páginas)
- [x] Panel Refugio operativo (8 páginas)
- [x] Panel Adoptante completo (20 páginas)
- [x] CRUD de Mascotas con fotos múltiples
- [x] Sistema de Favoritos (❤️ toggle con AJAX)
- [x] Búsqueda y filtros avanzados de mascotas
- [x] **Matriz de Evaluación** de solicitudes (7 criterios ponderados)
- [x] **Seguimiento Post-Adopción** (4 hitos con GPS y foto en vivo)
- [x] **Módulo de Campañas** (CRUD con mapa interactivo)
- [x] **Certificados Digitales** (código único RP-YYYY-NNNNN, vista Print/PDF)
- [x] **Mapa de Extravíos** interactivo (Leaflet.js + OpenStreetMap)
- [x] **Reportes de mascotas** perdidas/encontradas con fotos
- [x] **Avistamientos comunitarios** con geolocalización
- [x] Sistema de Notificaciones in-app (con conteo de no leídas)
- [x] Dashboard con gráficos de tendencia mensual
- [x] Auditoría del sistema (acciones, IP, timestamps)
- [x] Gestión y verificación de refugios
- [x] Proceso de devolución de mascotas (con detección de maltrato)
- [x] Página 404 personalizada
- [x] Guía de componentes UI (`COMPONENTES.md`)

### 🔮 Futuro (Post-MVP)

- [ ] Notificaciones Push (Web Push API)
- [ ] App Móvil PWA (Service Workers, Manifest)
- [ ] Chat en tiempo real entre adoptante y refugio
- [ ] Integración con redes sociales para compartir mascotas
- [ ] Reportes PDF exportables del sistema
- [ ] Paginación server-side para grandes volúmenes de datos
- [ ] Tests unitarios y de integración
- [ ] CI/CD con GitHub Actions

---

## 📈 Métricas del Proyecto

| Métrica | Valor |
|---------|-------|
| **Páginas Web Forms** | 54+ (`.aspx`) |
| **Servicios de Negocio** | 16 archivos (`CN_*.cs`) |
| **Master Pages** | 5 (Public, Login, Admin, AdminRefugio, Adoptante, Refugio) |
| **Hojas de Estilo** | 5 archivos CSS |
| **Tablas en BD** | 21 |
| **Stored Procedures** | 7 |
| **Vistas SQL** | 2 |
| **Líneas de SQL** | ~480 |

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
