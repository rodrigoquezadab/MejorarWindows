<div align="center">

# 🚀 MejorarWindows
### The Ultimate Windows Toolbox (WinUtil Fork con Perfil Standard Optimizado)

[![Latest Release](https://img.shields.io/github/v/release/rodrigoquezadab/MejorarWindows?color=%230567ff&label=Latest%20Release&style=for-the-badge)](https://github.com/rodrigoquezadab/MejorarWindows/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D6.svg?style=for-the-badge&logo=windows)](https://www.microsoft.com/windows)

Una compilación completa basada íntegramente en la herramienta oficial **[WinUtil de Chris Titus Tech](https://github.com/ChrisTitusTech/winutil)**, que automatiza **instalaciones de software** en lote, optimiza el sistema con **tweaks**, soluciona problemas con **config**, gestiona **actualizaciones de Windows** y añade la especificación de **optimizaciones del Perfil Estándar (Standard Profile)** tanto en el preset de un clic como en una pestaña dedicada.

![Title Screen](docs/src/assets/branding/title-screen.png)

</div>

---

## ⚡ Inicio Rápido (Quick Start)

> [!IMPORTANT]
> **MejorarWindows debe ejecutarse como Administrador** debido a que realiza modificaciones globales en el sistema operativo (servicios, registro, paquetes AppX y directivas).

Abre **PowerShell** o **Windows Terminal** como Administrador (clic derecho en el botón de Inicio > *Terminal (Administrador)* o *Windows PowerShell (Administrador)*) y ejecuta:

```powershell
irm https://raw.githubusercontent.com/rodrigoquezadab/MejorarWindows/main/winutil.ps1 | iex
```

### Ejecución Local / Offline

Si has clonado este repositorio:

```powershell
git clone https://github.com/rodrigoquezadab/MejorarWindows.git
cd MejorarWindows
.\run.bat
```

*O compila los cambios tras editar cualquier archivo en `config/`, `functions/` o `xaml/`:*
```powershell
.\Compile.ps1 -Run
```

---

## 🎯 Mejoras Integradas del Perfil Estándar (Standard Profile)

En esta versión se han implementado íntegramente las optimizaciones de la guía técnica de optimización (referencia: *Guía de Optimización sin Programas - RickyEdit*) bajo dos modalidades:

### 1. En la Selección Estándar (`Standard Preset`)
Al pulsar el botón **"Standard"** en la pestaña *Tweaks* (o al ejecutar por línea de comandos con `-Preset Standard`), se marcan y aplican automáticamente los siguientes 15 ajustes (el primero crea un punto de restauración antes de tocar nada):

| Identificador | Descripción Técnica | Categoría |
| :--- | :--- | :--- |
| `WPFTweaksRestorePoint` | Crea un punto de restauración del sistema antes de aplicar el resto de los ajustes. | Essential Tweaks |
| `WPFTweaksDVR` | Desactiva Game DVR, Xbox Game Bar y capturas en segundo plano (elimina input lag y pérdida de FPS). | Essential Tweaks |
| `WPFTweaksGameModeAndHAGS` | Activa el Modo Juego de Windows y la Programación de GPU acelerada por hardware (HAGS). | Essential Tweaks |
| `WPFTweaksMouseAcceleration` | Desmarca *"Mejorar la precisión del puntero"* y fija velocidad en 6/11 para respuesta 1:1 real (*Raw Input*). | Essential Tweaks |
| `WPFTweaksPrivacySuite` | Desactiva ID de publicidad, seguimiento de inicio de apps, telemetría y recolección de escritura/tinta. | Essential Tweaks |
| `WPFTweaksBackgroundApps` | Impide que aplicaciones UWP se ejecuten silenciosamente en segundo plano. | Essential Tweaks |
| `WPFTweaksDeliveryOptimization`| Desactiva la optimización de distribución P2P de Windows Update para evitar picos de ping y consumo de ancho de banda. | Essential Tweaks |
| `WPFTweaksDisableNotificationsAndTips` | Desactiva sugerencias de Windows, trucos de pantalla de bloqueo y notificaciones emergentes. | Essential Tweaks |
| `WPFTweaksDisableTransparency`| Desactiva transparencias y efectos acrílicos en el shell, reduciendo el consumo de GPU por DWM. | Essential Tweaks |
| `WPFTweaksVisualFXPerformance` | Efectos visuales de rendimiento manteniendo fuentes de pantalla suaves y vistas en miniatura. | Essential Tweaks |
| `WPFTweaksFastBootTime` | Reduce el timeout de arranque a 3 segundos (`msconfig standard`) y acelera el cierre de tareas colgadas al apagar. | Essential Tweaks |
| `WPFTweaksStorageAndTempCleanup` | Habilita Sensor de Almacenamiento (Storage Sense) y purga de archivos temporales. | Essential Tweaks |
| `WPFTweaksServices` | Deshabilita servicios no esenciales de telemetría, mapas y modo demo (`DiagTrack`, `dmwappushservice`, `MapsBroker`, `RetailDemo`). | Essential Tweaks |
| `WPFTweaksTele` | Deshabilita servicios y tareas programadas de telemetría adicionales. | Essential Tweaks |
| `WPFTweaksLocation` | Desactiva el seguimiento de ubicación y sensores. | Essential Tweaks |

### 2. En la Nueva Pestaña Dedicada: `Standard Tweaks`
En la barra superior de pestañas se ha agregado una nueva sección **`Standard Tweaks`** (accesible mediante el atajo de teclado `S` o el botón en el panel de Tweaks) que incluye:
- Panel exclusivo con la suite completa de optimizaciones del perfil estándar. Incluye el plan de energía **Máximo Rendimiento**, que el preset Standard no marca porque en notebooks gasta más batería.
- Botones de **Select All** y **Clear Selection**.
- Botón **Run Standard Tweaks** para aplicar únicamente esta suite (lo marcado en otras pestañas y el DNS no se tocan).
- Botón **Undo Selected** para restaurar los valores de fábrica originales en cualquier momento con total reversibilidad.

---

## 🛠️ Pestañas y Módulos de la Suite

- 📦 **Install**: Catálogo con cientos de programas populares organizados por categorías (Navegadores, Comunicaciones, Desarrollo, Multimedia, Juegos, Utilidades) con instalación, actualización y desinstalación desatendida mediante **Winget** y **Chocolatey**.
- ⚙️ **Tweaks**: Optimización de privacidad, servicios, personalización de la barra de tareas, eliminación de Copilot/Recall y desinstalador profundo de AppX.
- 🔧 **Config**: Instalación rápida de características de Windows (**WSL**, **Hyper-V**, **Windows Sandbox**, **.NET 3.5**), cambio de proveedores de DNS de alta velocidad (Cloudflare, Google, Quad9) y utilidades de reparación.
- 🔄 **Updates**: Control de Windows Update (retrasar actualizaciones de características inestables, aplicar únicamente parches de seguridad recomendados o restablecer el servicio a valores predeterminados).
- 💿 **Win11 Creator (MicroWin)**: Herramienta avanzada para generar imágenes ISO limpias, ligeras y personalizadas de Windows 11.

---

## 🤖 Automatización por Línea de Comandos (CLI Presets)

Puedes ejecutar el script aplicando un perfil predefinido sin interactuar con los menús gráficos:

```powershell
& ([ScriptBlock]::Create((irm https://raw.githubusercontent.com/rodrigoquezadab/MejorarWindows/main/winutil.ps1))) -Preset Standard
```

Presets disponibles:
* **Office**: Perfil de máxima ligereza para equipos de oficina, trabajo y computadoras antiguas/de bajos recursos. Desactiva todas las animaciones de ventanas y menús, todas las notificaciones y sugerencias, transparencias acrílicas de GPU, telemetría, servicios innecesarios, búsqueda web de Bing en menú inicio, widgets, Copilot y servicios de juegos (Xbox), maximizando la fluidez y respuesta del sistema para ofimática y trabajo.
* **Standard**: Perfil equilibrado con las optimizaciones completas de rendimiento y privacidad recomendadas.
* **Minimal**: Modificaciones básicas esenciales.
* **Advanced**: Modificaciones profundas orientadas a usuarios avanzados.

---

## 🏗️ Compilación y Desarrollo

Para compilar el proyecto tras realizar cambios en el código modular:

```powershell
.\Compile.ps1
```

Para compilar y lanzar inmediatamente la interfaz:

```powershell
.\Compile.ps1 -Run
```

Para correr los tests (PowerShell 7 y Pester 5.8.0):

```powershell
Invoke-Pester -Path 'pester/*.Tests.ps1' -Output Detailed
```

### Publicación automática

Cada push y pull request ejecuta el workflow **Build and test** (`.github/workflows/build.yaml`) en Windows: compila `winutil.ps1` y corre todos los tests. Si un push a `main` pasa los tests, el workflow sube el `winutil.ps1` compilado a `main`, que es el que descarga `irm ... | iex`.

Por eso **no subas tu `winutil.ps1` compilado localmente**: es solo para probar. `hacer_push.bat` lo descarta y trae primero lo que publicó GitHub Actions antes de hacer push.

---

## 🤝 Reconocimientos

- Basado íntegramente en el proyecto open-source **[WinUtil](https://github.com/ChrisTitusTech/winutil)** de **Chris Titus Tech** y su comunidad de colaboradores.
- Guía y optimizaciones basadas en la *Guía de Optimización sin Programas - RickyEdit*.
- Licenciado bajo la **[Licencia MIT](LICENSE)**.
