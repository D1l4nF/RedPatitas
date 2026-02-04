# 📚 Guía de Componentes UI - RedPatitas

Esta guía te ayudará a reutilizar los componentes visuales del proyecto sin necesidad de conocer a fondo HTML, CSS o JavaScript.

---

## 📋 Índice

1. [Cómo Usar Esta Guía](#cómo-usar-esta-guía)
2. [Componentes de Layout](#componentes-de-layout)
3. [Componentes de Navegación](#componentes-de-navegación)
4. [Tarjetas y Contenedores](#tarjetas-y-contenedores)
5. [Formularios](#formularios)
6. [Botones](#botones)
7. [Tablas](#tablas)
8. [Notificaciones y Alertas](#notificaciones-y-alertas)
9. [Estados Vacíos](#estados-vacíos)
10. [Componentes de Mascota](#componentes-de-mascota)

---

## 🎯 Cómo Usar Esta Guía

### Paso 1: Crear una Nueva Página

```aspx
<%@ Page Title="Mi Página" Language="C#" MasterPageFile="~/Adoptante/Adoptante.Master" 
    AutoEventWireup="true" CodeBehind="MiPagina.aspx.cs" Inherits="RedPatitas.Adoptante.MiPagina" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Mi Página | RedPatitas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeader" runat="server">
    <!-- Encabezado de página aquí -->
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Tu contenido aquí -->
</asp:Content>
```

### Paso 2: Copiar y Pegar Componentes

Copia el código HTML del componente que necesites y pégalo dentro de `MainContent`.

---

## 🏗️ Componentes de Layout

### Encabezado de Página

Muestra título y descripción de la página actual.

```html
<div class="page-header">
    <h1 class="page-title">🏠 Mi Título</h1>
    <div class="breadcrumb">Descripción breve de esta página</div>
</div>
```

### Grid de Estadísticas (4 columnas)

Ideal para dashboards con métricas.

```html
<div class="stats-grid">
    <!-- Tarjeta Naranja -->
    <div class="stat-card">
        <div class="stat-icon orange">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="24" height="24">
                <path d="M..." />
            </svg>
        </div>
        <div class="stat-info">
            <h3>156</h3>
            <p>Mascotas Adoptadas</p>
        </div>
    </div>
    
    <!-- Tarjeta Azul -->
    <div class="stat-card">
        <div class="stat-icon blue">
            <!-- icono -->
        </div>
        <div class="stat-info">
            <h3>42</h3>
            <p>Solicitudes Pendientes</p>
        </div>
    </div>
    
    <!-- Colores disponibles: orange, blue, green, purple -->
</div>
```

---

## 🧭 Componentes de Navegación

### Breadcrumb Simple

```html
<div class="breadcrumb">Inicio > Mascotas > Detalle</div>
```

### Enlace de Acción

```html
<a href="pagina.aspx" class="btn-link">
    Ver todos →
</a>
```

---

## 🃏 Tarjetas y Contenedores

### Contenedor de Sección

```html
<div class="recent-section">
    <div class="section-header">
        <h2 class="section-title">Título de Sección</h2>
        <a href="#" class="btn-link">Ver más →</a>
    </div>
    <!-- contenido -->
</div>
```

### Tarjeta de Información

```html
<div class="info-card">
    <div class="icon-container">
        <svg><!-- icono --></svg>
    </div>
    <div>
        <h4>Título</h4>
        <p>Descripción del contenido</p>
    </div>
</div>
```

---

## 📝 Formularios

### Campo de Texto

```html
<div class="form-group">
    <label>Nombre <span class="required">*</span></label>
    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ingresa el nombre" />
    <span class="input-hint">Ejemplo: Max, Luna, Rocky</span>
</div>
```

### Campo con Error

```html
<div class="form-group error">
    <label>Email</label>
    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
    <span class="validation-message error">
        <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
            <circle cx="12" cy="12" r="10"/>
            <line x1="12" y1="8" x2="12" y2="12" stroke="white" stroke-width="2"/>
            <circle cx="12" cy="16" r="1" fill="white"/>
        </svg>
        Este campo es obligatorio
    </span>
</div>
```

### Campo con Éxito

```html
<div class="form-group success">
    <label>Email</label>
    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
    <span class="validation-message success">
        ✓ Email válido
    </span>
</div>
```

### Select / Dropdown

```html
<div class="form-group">
    <label>Especie</label>
    <asp:DropDownList ID="ddlEspecie" runat="server" CssClass="form-control">
        <asp:ListItem Value="">Seleccionar...</asp:ListItem>
        <asp:ListItem Value="perro">Perro 🐕</asp:ListItem>
        <asp:ListItem Value="gato">Gato 🐱</asp:ListItem>
    </asp:DropDownList>
</div>
```

### Área de Texto

```html
<div class="form-group">
    <label>Descripción</label>
    <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" 
        Rows="4" CssClass="form-control" placeholder="Describe la mascota..." />
</div>
```

### Grid de 2 Columnas

```html
<div class="form-grid">
    <div class="form-group">
        <label>Campo 1</label>
        <asp:TextBox ID="txt1" runat="server" CssClass="form-control" />
    </div>
    <div class="form-group">
        <label>Campo 2</label>
        <asp:TextBox ID="txt2" runat="server" CssClass="form-control" />
    </div>
</div>
```

---

## 🔘 Botones

### Botón Primario (Naranja)

```html
<asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn-primary" OnClick="btnGuardar_Click" />
```

### Botón Secundario

```html
<asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-secondary" />
```

### Botón de Enlace

```html
<a href="pagina.aspx" class="btn-view-pet">Ver Perfil</a>
```

### Botón con Icono

```html
<asp:LinkButton ID="btnAccion" runat="server" CssClass="action-btn" ToolTip="Acción">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20">
        <path d="..."/>
    </svg>
</asp:LinkButton>
```

### Botón de Filtro

```html
<button type="button" class="btn-filter">
    <svg><!-- icono filtro --></svg>
    Filtrar
</button>
```

---

## 📊 Tablas

### Tabla Básica

```html
<div class="table-container">
    <table>
        <thead>
            <tr>
                <th>Nombre</th>
                <th>Estado</th>
                <th>Fecha</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <div class="pet-cell">
                        <img src="foto.jpg" alt="" class="pet-img" />
                        <span>Max</span>
                    </div>
                </td>
                <td>
                    <span class="status-badge approved">Aprobado</span>
                </td>
                <td>15/01/2025</td>
                <td>
                    <a href="#" class="btn-link">Ver</a>
                </td>
            </tr>
        </tbody>
    </table>
</div>
```

### Badges de Estado

```html
<!-- Estados disponibles -->
<span class="status-badge pending">Pendiente</span>
<span class="status-badge approved">Aprobado</span>
<span class="status-badge rejected">Rechazado</span>
<span class="status-badge active">Activo</span>
```

---

## 🔔 Notificaciones y Alertas

### Toast con SweetAlert2

> ⚠️ SweetAlert2 ya está incluido en Adoptante.Master

```javascript
// Toast de éxito
const Toast = Swal.mixin({
    toast: true,
    position: 'top-end',
    showConfirmButton: false,
    timer: 2000,
    timerProgressBar: true
});

Toast.fire({
    icon: 'success',  // success, error, warning, info
    title: '✅ Guardado correctamente'
});
```

### Alerta Modal

```javascript
Swal.fire({
    icon: 'warning',
    title: '¿Estás seguro?',
    text: 'Esta acción no se puede deshacer',
    showCancelButton: true,
    confirmButtonText: 'Sí, eliminar',
    cancelButtonText: 'Cancelar',
    confirmButtonColor: '#FF8C42'
});
```

### Banner de Verificación

```html
<div class="verification-banner warning">
    <div class="verification-content">
        <svg><!-- icono --></svg>
        <div class="verification-text">
            <strong>¡Atención!</strong>
            <span>Mensaje de advertencia aquí.</span>
        </div>
    </div>
    <a href="#" class="btn-complete-profile">Acción</a>
</div>
```

---

## 📭 Estados Vacíos

### Estado Vacío Básico

```html
<div class="empty-state">
    <div class="empty-state-icon">🐾</div>
    <h3 class="empty-state-title">No hay resultados</h3>
    <p class="empty-state-desc">No encontramos lo que buscas. Intenta con otros filtros.</p>
    <a href="mascotas.aspx" class="empty-state-action">Buscar Mascotas</a>
</div>
```

### Variaciones de Iconos

```html
<!-- Favoritos vacíos -->
<div class="empty-state-icon">💔</div>

<!-- Sin mascotas -->
<div class="empty-state-icon">🐾</div>

<!-- Búsqueda sin resultados -->
<div class="empty-state-icon">🔍</div>

<!-- Sin notificaciones -->
<div class="empty-state-icon">🔔</div>
```

---

## 🐕 Componentes de Mascota

### Tarjeta de Mascota Completa

```html
<div class="pet-card-adopta">
    <div class="pet-card-image">
        <!-- Con foto -->
        <img src="~/Uploads/mascota.jpg" alt="Max" />
        
        <!-- O sin foto (emoji) -->
        <div class="pet-card-emoji">
            <div class="pet-emoji">🐕</div>
        </div>
        
        <!-- Badge -->
        <span class="pet-badge nuevo">Nuevo</span>
        
        <!-- Botón favorito -->
        <a href="javascript:void(0);" class="pet-favorite" onclick="toggleFavorito(this, 123)">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
            </svg>
        </a>
    </div>
    
    <div class="pet-card-body">
        <div class="pet-card-header">
            <h3>Max</h3>
            <span class="pet-age">2 años</span>
        </div>
        <p class="pet-breed">Labrador • Macho</p>
        <div class="pet-tags">
            <span class="pet-tag">Vacunado</span>
            <span class="pet-tag">Esterilizado</span>
        </div>
        <div class="pet-location">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                <circle cx="12" cy="10" r="3"/>
            </svg>
            Quito
        </div>
        <a href="PerfilMascota.aspx?id=123" class="btn-ver-perfil">Ver Perfil</a>
    </div>
</div>
```

### Grid de Mascotas

```html
<div class="pets-grid">
    <!-- Repite pet-card-adopta aquí -->
</div>
```

### Badges de Mascota

```html
<span class="pet-badge nuevo">Nuevo</span>
<span class="pet-badge disponible">Disponible</span>
<span class="pet-badge urgente">Urgente</span>
```

### Corazón de Favorito (activo)

```html
<a href="javascript:void(0);" class="pet-favorite active">
    <svg viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2" width="20" height="20">
        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
    </svg>
</a>
```

---

## ⏳ Spinners y Loading

### Spinner Básico

```html
<div class="spinner"></div>

<!-- Tamaños -->
<div class="spinner small"></div>
<div class="spinner large"></div>
```

### Overlay de Carga

```html
<div class="loading-overlay active">
    <div class="spinner large"></div>
    <p class="loading-text">Cargando...</p>
</div>
```

---

## 🎨 Variables de Colores

Los colores están definidos en `estilos-base.css`:

| Variable | Color | Uso |
|----------|-------|-----|
| `--primary-color` | #FF8C42 | Naranja principal |
| `--primary-hover` | #E67A30 | Hover del naranja |
| `--secondary-color` | #4A3B32 | Café oscuro (texto) |
| `--success` | #27AE60 | Verde éxito |
| `--error` | #E74C3C | Rojo error |
| `--warning` | #F39C12 | Amarillo advertencia |
| `--info` | #3498DB | Azul información |

---

## 📱 Master Pages Disponibles

| Master Page | Uso |
|-------------|-----|
| `~/Adoptante/Adoptante.Master` | Panel de adoptante |
| `~/Admin/Admin.Master` | Panel de administrador |
| `~/Refugio/Refugio.Master` | Panel de refugio |
| `~/Public/Public.Master` | Páginas públicas |
| `~/Login/Login.Master` | Páginas de autenticación |

---

## ✅ Checklist para Nueva Página

1. [ ] Crear archivo `.aspx` y `.aspx.cs`
2. [ ] Elegir el `MasterPageFile` correcto
3. [ ] Agregar `PageHeader` con título
4. [ ] Agregar contenido en `MainContent`
5. [ ] Copiar componentes de esta guía
6. [ ] Probar en el navegador

---

*Última actualización: Febrero 2025*
