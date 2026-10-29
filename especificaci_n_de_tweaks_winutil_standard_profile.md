# Especificación de Implementación para Agente de IA: Tweaks de Optimización en Perfil `Standard` (WinUtil)

## 1. Contexto de Arquitectura (WinUtil)
Este documento contiene las instrucciones técnicas extraídas de la guía de optimización de Windows sin programas (referencia: *Guía de Optimización sin Programas - RickyEdit*) adaptadas a la estructura del repositorio `christitustech/winutil`.

### Reglas para el Agente de IA:
1. **Archivo Principal de Configuración:** `config/tweaks.json`
2. **Selector del Perfil Estándar:** En WinUtil, los botones de preajuste (*Standard*, *Minimal*, *Clear*) leen o activan entradas dentro de `config/tweaks.json` o `config/preset.json` (dependiendo de la rama de tu fork). Asegúrate de que cada entrada listada a continuación exista en `config/tweaks.json` y que su identificador (`WPFTweaks...`) esté incluido dentro del array correspondiente a **`Standard`**.
3. **Idempotencia y Reversibilidad:** Cada tweak debe contar con su estado `OriginalValue` o script `UndoScript` para que el botón *Undo Selected Tweaks* de WinUtil funcione sin romper el sistema.
4. **Seguridad de Hardware:** Se han filtrado o parametrizado configuraciones antiguas del video (como `bootmenupolicy` o el límite manual de procesadores en `msconfig`) que causan cuellos de botella en CPUs modernos, manteniendo únicamente las optimizaciones reales de registro, energía, servicios y limpieza.

---

## 2. Configuraciones del Sistema, Interfaz y Juegos (Windows Settings)

### 2.1. Desactivar Xbox Game Bar y Game DVR
En el video se desactiva el *Xbox Game Bar*, las capturas en segundo plano y el audio grabado para evitar pérdida de FPS y *input lag*.

* **ID sugerido / existente en WinUtil:** `WPFTweaksDVR`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON (`config/tweaks.json`):**

```json
"WPFTweaksDVR": {
  "Content": "Disable GameDVR and Xbox Game Bar",
  "Description": "Disables Xbox Game Bar, background recording, and Game DVR overlays to reduce input lag and resource usage.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a005_",
  "registry": [
    {
      "Path": "HKCU:\\System\\GameConfigStore",
      "Name": "GameDVR_FSEBehavior",
      "Type": "DWord",
      "Value": "2",
      "OriginalValue": "0"
    },
    {
      "Path": "HKCU:\\System\\GameConfigStore",
      "Name": "GameDVR_Enabled",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\GameDVR",
      "Name": "AppCaptureEnabled",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\GameDVR",
      "Name": "AllowGameDVR",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "<RemoveEntry>"
    }
  ]
}
```

---

### 2.2. Activar Modo Juego (Game Mode) y Aceleración de GPU por Hardware (HAGS)
El video recomienda mantener activado el **Modo Juego** y la **Programación de GPU acelerada por hardware** para reducir la latencia y priorizar el proceso del juego.

* **ID sugerido:** `WPFTweaksGameModeAndHAGS`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksGameModeAndHAGS": {
  "Content": "Enable Game Mode and Hardware Accelerated GPU Scheduling",
  "Description": "Enables Windows Game Mode and HAGS (Hardware-Accelerated GPU Scheduling) to improve frame times and reduce latency.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a006_",
  "registry": [
    {
      "Path": "HKCU:\\Software\\Microsoft\\GameBar",
      "Name": "AllowAutoGameMode",
      "Type": "DWord",
      "Value": "1",
      "OriginalValue": "1"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\GameBar",
      "Name": "AutoGameModeEnabled",
      "Type": "DWord",
      "Value": "1",
      "OriginalValue": "1"
    },
    {
      "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\GraphicsDrivers",
      "Name": "HwSchMode",
      "Type": "DWord",
      "Value": "2",
      "OriginalValue": "1"
    }
  ]
}
```

---

### 2.3. Desactivar Notificaciones, Sugerencias de Windows y Asistente de Concentración
En el video se desactivan las notificaciones emergentes, sugerencias de uso de Windows, trucos y el Asistente de Concentración automático para evitar interrupciones y procesos en segundo plano.

* **ID sugerido:** `WPFTweaksDisableNotificationsAndTips`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksDisableNotificationsAndTips": {
  "Content": "Disable Windows Tips, Tricks, and Notification Popups",
  "Description": "Disables Windows suggestions, lock screen tips, welcome experiences, and promotional notifications.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a007_",
  "registry": [
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
      "Name": "SubscribedContent-338389Enabled",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
      "Name": "SubscribedContent-310093Enabled",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
      "Name": "SubscribedContent-338388Enabled",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
      "Name": "SoftLandingEnabled",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
      "Name": "ShowSyncProviderNotifications",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    }
  ]
}
```

---

### 2.4. Desactivar Transparencias y Animaciones Innecesarias
En la sección de *Personalización > Colores* del video se desactivan los efectos de transparencia para liberar recursos de la GPU y DWM (`dwm.exe`).

* **ID sugerido:** `WPFTweaksDisableTransparency`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksDisableTransparency": {
  "Content": "Disable Windows Transparency Effects",
  "Description": "Disables acrylic and transparency effects in the Windows shell to reduce DWM GPU usage.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a008_",
  "registry": [
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
      "Name": "EnableTransparency",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    }
  ]
}
```

---

## 3. Privacidad y Permisos en Segundo Plano (A partir del min 10:00 - `t=600s`)

En el minuto `10:00` del video se recorre todo el panel de **Privacidad** de Windows, desactivando la telemetría, el seguimiento de lanzamientos de aplicaciones, diagnósticos, historial de actividades y las **Aplicaciones en segundo plano**.

### 3.1. Desactivar Aplicaciones en Segundo Plano (Background Apps)
* **ID sugerido / existente en WinUtil:** `WPFTweaksConsumerFeatures` / `WPFTweaksBackgroundApps`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksBackgroundApps": {
  "Content": "Disable Background Apps",
  "Description": "Prevents Universal Windows Platform (UWP) apps from running, receiving info, or sending notifications in the background.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a009_",
  "registry": [
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\BackgroundAccessApplications",
      "Name": "GlobalUserDisabled",
      "Type": "DWord",
      "Value": "1",
      "OriginalValue": "0"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search",
      "Name": "BackgroundAppGlobalToggle",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\AppPrivacy",
      "Name": "LetAppsRunInBackground",
      "Type": "DWord",
      "Value": "2",
      "OriginalValue": "<RemoveEntry>"
    }
  ]
}
```

### 3.2. Privacidad General, Telemetría, Historial de Actividad y Diagnóstico
* **ID existente en WinUtil:** `WPFTweaksTele` y `WPFTweaksActivity` (Asegurarse de que ambos estén en `Standard` y contengan las claves del video).
* **Implementación JSON consolidada:**

```json
"WPFTweaksPrivacySuite": {
  "Content": "Disable Telemetry, Activity History, App Launch Tracking & Advertising ID",
  "Description": "Applies privacy settings from Windows Settings -> Privacy: disables Advertising ID, App Launch Tracking, Ink & Typing personalization, Diagnostic Data, and Activity History.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a010_",
  "registry": [
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\AdvertisingInfo",
      "Name": "Enabled",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
      "Name": "Start_TrackProgs",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
      "Name": "AllowTelemetry",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "<RemoveEntry>"
    },
    {
      "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\DataCollection",
      "Name": "AllowTelemetry",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System",
      "Name": "EnableActivityFeed",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "<RemoveEntry>"
    },
    {
      "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System",
      "Name": "PublishUserActivities",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "<RemoveEntry>"
    },
    {
      "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System",
      "Name": "UploadUserActivities",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "<RemoveEntry>"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\InputPersonalization",
      "Name": "RestrictImplicitInkCollection",
      "Type": "DWord",
      "Value": "1",
      "OriginalValue": "0"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\InputPersonalization",
      "Name": "RestrictImplicitTextCollection",
      "Type": "DWord",
      "Value": "1",
      "OriginalValue": "0"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Siuf\\Rules",
      "Name": "NumberOfSIUFInPeriod",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "<RemoveEntry>"
    }
  ]
}
```

### 3.3. Desactivar Optimización de Distribución P2P (Windows Update Delivery Optimization)
En el video se desactiva permitir descargas de otros equipos en red/Internet para evitar picos de ping y consumo de ancho de banda en segundo plano.

* **ID sugerido:** `WPFTweaksDeliveryOptimization`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksDeliveryOptimization": {
  "Content": "Disable Windows Update P2P Delivery Optimization",
  "Description": "Prevents Windows from using your bandwidth to upload updates to other PCs over the Internet.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a011_",
  "registry": [
    {
      "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\DeliveryOptimization\\Config",
      "Name": "DODownloadMode",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\DeliveryOptimization",
      "Name": "DODownloadMode",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "<RemoveEntry>"
    }
  ]
}
```

---

## 4. Rendimiento Visual, Ratón y Energía (`sysdm.cpl`, `main.cpl`, `powercfg`)

### 4.1. Ajustar Efectos Visuales para Mejor Rendimiento (Conservando Fuentes Suaves y Miniaturas)
El video muestra abrir `sysdm.cpl` -> *Opciones avanzadas* -> *Rendimiento* -> *Ajustar para obtener el mejor rendimiento*, marcando únicamente:
1. **Mostrar vistas en miniatura en lugar de iconos** (`IconsOnly = 0`)
2. **Suavizar bordes para las fuentes de pantalla** (`FontSmoothing = 2`)

* **ID sugerido:** `WPFTweaksVisualFXPerformance`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksVisualFXPerformance": {
  "Content": "Set Visual Effects for Best Performance (Keep Font Smoothing & Thumbnails)",
  "Description": "Configures Windows Visual Effects for maximum performance while preserving smooth fonts and image thumbnails.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a012_",
  "registry": [
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\VisualEffects",
      "Name": "VisualFXSetting",
      "Type": "DWord",
      "Value": "3",
      "OriginalValue": "0"
    },
    {
      "Path": "HKCU:\\Control Panel\\Desktop",
      "Name": "UserPreferencesMask",
      "Type": "Binary",
      "Value": "9012038010000000",
      "OriginalValue": "9E1E078012000000"
    },
    {
      "Path": "HKCU:\\Control Panel\\Desktop",
      "Name": "FontSmoothing",
      "Type": "String",
      "Value": "2",
      "OriginalValue": "2"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
      "Name": "IconsOnly",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "0"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
      "Name": "ListviewAlphaSelect",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
      "Name": "ListviewShadow",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
      "Name": "TaskbarAnimations",
      "Type": "DWord",
      "Value": "0",
      "OriginalValue": "1"
    }
  ]
}
```

---

### 4.2. Desactivar Aceleración del Ratón ("Mejorar la precisión del puntero")
En el video se abre la configuración adicional del mouse (`main.cpl`) -> *Opciones de puntero* y se desmarca **"Mejorar la precisión del puntero"** (aceleración de Windows) asegurando velocidad `6/11`.

* **ID existente en WinUtil:** `WPFTweaksMouseAcceleration`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksMouseAcceleration": {
  "Content": "Disable Mouse Acceleration (Raw Input 1:1)",
  "Description": "Unchecks 'Enhance pointer precision' and sets pointer speed to 6/11 for 1:1 raw mouse movement.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a013_",
  "registry": [
    {
      "Path": "HKCU:\\Control Panel\\Mouse",
      "Name": "MouseSpeed",
      "Type": "String",
      "Value": "0",
      "OriginalValue": "1"
    },
    {
      "Path": "HKCU:\\Control Panel\\Mouse",
      "Name": "MouseThreshold1",
      "Type": "String",
      "Value": "0",
      "OriginalValue": "6"
    },
    {
      "Path": "HKCU:\\Control Panel\\Mouse",
      "Name": "MouseThreshold2",
      "Type": "String",
      "Value": "0",
      "OriginalValue": "10"
    },
    {
      "Path": "HKCU:\\Control Panel\\Mouse",
      "Name": "MouseSensitivity",
      "Type": "String",
      "Value": "10",
      "OriginalValue": "10"
    }
  ]
}
```

---

### 4.3. Activar Plan de Energía "Máximo Rendimiento" (Ultimate Performance)
En el video se ejecuta `powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61` y se selecciona en el Panel de Control.

* **ID existente en WinUtil:** `WPFTweaksUltimatePerformance`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksUltimatePerformance": {
  "Content": "Enable and Activate Ultimate Performance Power Plan",
  "Description": "Unlocks and activates the hidden Windows Ultimate Performance power scheme.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a014_",
  "InvokeScript": [
    "$ultimateGuid = 'e9a42b02-d5df-448d-aa00-03f14749eb61'",
    "$existing = powercfg -list | Select-String -Pattern $ultimateGuid",
    "if (-not $existing) {",
    "    $output = powercfg -duplicatescheme $ultimateGuid",
    "    if ($output -match '([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})') {",
    "        powercfg -setactive $matches[1]",
    "    }",
    "} else {",
    "    if ($existing -match '([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})') {",
    "        powercfg -setactive $matches[1]",
    "    }",
    "}"
  ],
  "UndoScript": [
    "powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e"
  ]
}
```

---

## 5. Optimización de Arranque, Almacenamiento y Limpieza (`msconfig`, Sensor de Almacenamiento y `%temp%`)

### 5.1. Reducir Tiempo de Espera de Arranque (`msconfig` Timeout = 3s) y Cierre de Servicios
En el video (para lograr el arranque rápido) se abre `msconfig` -> *Arranque*, se marca *"Sin arranque de GUI"* (opcional) y se cambia el **Tiempo de espera de 30 segundos a 3 segundos**.
> **Nota crítica para el Agente de IA:** En el video original de 2020 se menciona marcar "Número de procesadores" en `msconfig`. **NO implementes** `bcdedit /set numproc` porque es un mito conocido que en Windows 10/11 puede limitar hilos lógicos en actualizaciones de CPU. Implementa únicamente el `timeout` de arranque y la reducción del `WaitToKillServiceTimeout`.

* **ID sugerido:** `WPFTweaksFastBootTime`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksFastBootTime": {
  "Content": "Optimize Boot Timeout and Shutdown Speed",
  "Description": "Sets boot menu timeout to 3 seconds (msconfig standard) and reduces service/app kill timeout during shutdown/reboot.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a015_",
  "registry": [
    {
      "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control",
      "Name": "WaitToKillServiceTimeout",
      "Type": "String",
      "Value": "2000",
      "OriginalValue": "5000"
    },
    {
      "Path": "HKCU:\\Control Panel\\Desktop",
      "Name": "AutoEndTasks",
      "Type": "String",
      "Value": "1",
      "OriginalValue": "0"
    },
    {
      "Path": "HKCU:\\Control Panel\\Desktop",
      "Name": "WaitToKillAppTimeout",
      "Type": "String",
      "Value": "2000",
      "OriginalValue": "20000"
    },
    {
      "Path": "HKCU:\\Control Panel\\Desktop",
      "Name": "HungAppTimeout",
      "Type": "String",
      "Value": "1000",
      "OriginalValue": "5000"
    }
  ],
  "InvokeScript": [
    "bcdedit /timeout 3 | Out-Null"
  ],
  "UndoScript": [
    "bcdedit /timeout 30 | Out-Null"
  ]
}
```

---

### 5.2. Activar el Sensor de Almacenamiento (Storage Sense) y Limpieza de Archivos Temporales (`temp`, `%temp%`, `prefetch`)
En el video se activa el **Sensor de almacenamiento** en *Configuración > Sistema > Almacenamiento* y se vacían manualmente las carpetas `temp` y `%temp%`.

* **ID existente en WinUtil:** `WPFTweaksStorage` y `WPFTweaksDeleteTempFiles`
* **Categoría:** `Essential Tweaks`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksStorageAndTempCleanup": {
  "Content": "Enable Storage Sense and Clean Temporary Files",
  "Description": "Enables Windows Storage Sense automatic cleanup and removes residual files in Temp and %Temp%.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a016_",
  "registry": [
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\StorageSense\\Parameters\\StoragePolicy",
      "Name": "01",
      "Type": "DWord",
      "Value": "1",
      "OriginalValue": "0"
    },
    {
      "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\StorageSense\\Parameters\\StoragePolicy",
      "Name": "04",
      "Type": "DWord",
      "Value": "1",
      "OriginalValue": "0"
    }
  ],
  "InvokeScript": [
    "$tempFolders = @(\"$env:TEMP\\*\", \"$env:windir\\Temp\\*\")",
    "Remove-Item -Path $tempFolders -Recurse -Force -ErrorAction SilentlyContinue"
  ]
}
```

---

## 6. Servicios y Tareas Programadas en Segundo Plano

En el video se desactivan servicios de telemetría, búsqueda indexada pesada (o SysMain según disco) y servicios de Xbox/impresión/fax si no se utilizan. Para el perfil **`Standard`** de WinUtil, mantenemos los servicios seguros que no rompen funciones cotidianas (como Wi-Fi o Bluetooth):

* **ID existente en WinUtil:** `WPFTweaksServices`
* **Incluir en Preset:** `Standard`
* **Implementación JSON:**

```json
"WPFTweaksServices": {
  "Content": "Set Background Services to Manual (Safe Standard Profile)",
  "Description": "Sets non-essential telemetry, diagnostic, and rare background services to Manual or Disabled so they only run when explicitly needed.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a017_",
  "service": [
    {
      "Name": "DiagTrack",
      "StartupType": "Disabled",
      "OriginalType": "Automatic"
    },
    {
      "Name": "dmwappushservice",
      "StartupType": "Disabled",
      "OriginalType": "Manual"
    },
    {
      "Name": "MapsBroker",
      "StartupType": "Disabled",
      "OriginalType": "AutomaticDelayedStart"
    },
    {
      "Name": "Fax",
      "StartupType": "Manual",
      "OriginalType": "Manual"
    },
    {
      "Name": "XblAuthManager",
      "StartupType": "Manual",
      "OriginalType": "Manual"
    },
    {
      "Name": "XblGameSave",
      "StartupType": "Manual",
      "OriginalType": "Manual"
    },
    {
      "Name": "XboxNetApiSvc",
      "StartupType": "Manual",
      "OriginalType": "Manual"
    },
    {
      "Name": "XboxGipSvc",
      "StartupType": "Manual",
      "OriginalType": "Manual"
    },
    {
      "Name": "RetailDemo",
      "StartupType": "Disabled",
      "OriginalType": "Manual"
    },
    {
      "Name": "WerSvc",
      "StartupType": "Manual",
      "OriginalType": "Manual"
    }
  ]
}
```

---

## 7. Instrucciones de Integración en el Preset `Standard` (`config/preset.json` / `scripts/main.ps1`)

Para que el agente de IA conecte todas estas configuraciones al botón **"Standard"** en la pestaña *Tweaks* de WinUtil:

1. Abre `config/preset.json` (o la sección de presets dentro del script compilador si usas la arquitectura modular de WinUtil).
2. Localiza la clave `"Standard"`.
3. Asegúrate de que el array `"Standard"` incluya todos los identificadores definidos en este documento:

```json
{
  "Standard": [
    "WPFTweaksDVR",
    "WPFTweaksGameModeAndHAGS",
    "WPFTweaksDisableNotificationsAndTips",
    "WPFTweaksDisableTransparency",
    "WPFTweaksBackgroundApps",
    "WPFTweaksPrivacySuite",
    "WPFTweaksDeliveryOptimization",
    "WPFTweaksVisualFXPerformance",
    "WPFTweaksMouseAcceleration",
    "WPFTweaksUltimatePerformance",
    "WPFTweaksFastBootTime",
    "WPFTweaksStorageAndTempCleanup",
    "WPFTweaksServices",
    "WPFTweaksTele",
    "WPFTweaksActivity",
    "WPFTweaksLocation",
    "WPFTweaksDiskCleanup",
    "WPFTweaksDeleteTempFiles"
  ]
}
```

4. **Verificación de Compilación en WinUtil:**
   Ejecuta el script de compilación de tu fork (`./Compile.ps1`) para regenerar `winutil.ps1` e verifica en la interfaz WPF que al hacer clic en el botón **Standard** se marquen automáticamente los *CheckBoxes* correspondientes a estos Tweaks.