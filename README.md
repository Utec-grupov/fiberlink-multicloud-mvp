# FiberLink Multicloud MVP

## Proyecto

**Arquitectura Empresarial – Entregable 3**

Prototipo (MVP) de una solución multinube para FiberLink Andina Telecom, implementada sobre **Microsoft Azure** y **Google Cloud Platform (GCP)**, utilizando Infraestructura como Código (IaC) mediante **Terraform**.

---

# Objetivo

Implementar un MVP que demuestre la arquitectura objetivo (TO BE) propuesta para FiberLink, permitiendo automatizar procesos operacionales, correlacionar eventos de negocio y de red, identificar clientes afectados por incidentes y notificar proactivamente al cliente.

La solución debe cumplir con los lineamientos del Entregable 3:

- Despliegue sobre al menos dos nubes públicas.
- Infraestructura completamente definida mediante Terraform.
- Implementación de patrones de arquitectura.
- Uso de APIs Mock para simular sistemas corporativos.
- Automatización del despliegue mediante GitHub Actions (fase posterior).

---

# Objetivos Estratégicos Cubiertos

El MVP contribuye principalmente a los siguientes objetivos estratégicos del caso:

- Automatizar procesos operacionales.
- Incrementar la visibilidad operacional.
- Detectar clientes afectados casi en tiempo real.
- Mejorar la experiencia del cliente mediante notificaciones proactivas.
- Demostrar una arquitectura multinube moderna basada en eventos.

---

# Patrones de Arquitectura Implementados

El MVP implementa los siguientes patrones arquitectónicos:

| Patrón | Implementación |
|----------|----------------|
| Microservicios | Servicios independientes desplegados en Azure y GCP |
| Event Driven Architecture (EDA) | Azure Service Bus + Google Pub/Sub |
| Patrón de Resiliencia | Circuit Breaker ante degradación del NMS |

Patrones complementarios:

- Publisher–Subscriber
- Procesamiento Asíncrono
- Correlación de Eventos
- API Gateway

---

# Arquitectura Tecnológica

## Microsoft Azure

- Azure API Management
- Azure Container Apps
- Azure Service Bus
- Azure SQL Database
- Azure Key Vault
- Azure Log Analytics

## Google Cloud Platform

- Cloud Run
- Pub/Sub
- BigQuery
- Cloud Logging
- Cloud Monitoring

---

# Sistemas Mock

El MVP utiliza sistemas Mock para simular la integración con plataformas empresariales.

- OSS Mock
- NMS Mock

---

# Estructura del Repositorio

```text
fiberlink-multicloud-mvp/

├── docs/
├── terraform/
│   ├── azure/
│   ├── gcp/
│   ├── modules/
│   ├── environments/
│   └── shared/
│
├── microservices/
│   ├── ms-conectores-core/
│   ├── ms-eventos-negocio/
│   ├── ms-observabilidad-analitica/
│   └── ms-notificaciones/
│
├── .github/
│   └── workflows/
│
└── README.md
```

---

# Proceso de Ejecución del MVP

| Paso | Tipo | Ejecución | Resultado esperado |
|------|------|-----------|--------------------|
| **1** | Manual | El OSS Mock genera una orden de provisión y la envía mediante Azure API Management a **ms-conectores-core**. | Se registra la orden y se genera el evento **OrdenCreada**. |
| **2** | Automático | **ms-conectores-core** publica el evento en Azure Service Bus. **ms-eventos-negocio** consume el evento y lo replica hacia Google Pub/Sub. | Se demuestra la Arquitectura Dirigida por Eventos (EDA). |
| **3** | Manual | El NMS Mock simula una falla en un nodo de red y publica el evento **NodoSinServicio**. | La plataforma inicia el procesamiento del incidente. |
| **4** | Automático | Durante la consulta al NMS se simula alta latencia y se supera el timeout configurado. | Se producen errores de comunicación con el sistema externo. |
| **5** | Automático | El Circuit Breaker cambia al estado OPEN y evita nuevas llamadas al NMS. | El proceso continúa sin interrumpirse, demostrando el patrón de resiliencia. |
| **6** | Automático | **ms-observabilidad-analitica** correlaciona los eventos de negocio y de red utilizando eventos, logs y métricas. | Se genera un incidente correlacionado. |
| **7** | Automático | La plataforma identifica los clientes afectados y consolida la información analítica. | Se obtiene el listado de clientes impactados. |
| **8** | Automático | El Dashboard Operacional actualiza la información del incidente y muestra el estado del Circuit Breaker. | El equipo operativo visualiza el incidente en tiempo casi real. |
| **9** | Automático | El servicio de notificaciones informa al cliente sobre la incidencia detectada. | Finaliza el flujo del MVP. |

---

# Infraestructura como Código

Toda la infraestructura del MVP será desplegada utilizando Terraform.

El proyecto contempla recursos en:

- Microsoft Azure
- Google Cloud Platform

El despliegue será completamente reproducible mediante IaC.

---

# Automatización

=======
La ejecución del despliegue será orquestada mediante GitHub Actions y sera construida para el despliegue final del mvp.

El pipeline realizará:

- Terraform Init
- Terraform Validate
- Terraform Plan
- Terraform Apply
- Build de microservicios
- Publicación de imágenes Docker
- Despliegue de los microservicios
- Pruebas básicas del entorno

---

# Estado del Proyecto

**Versión:** MVP v1.0

Estado actual:

- [X] Infraestructura Terraform
- [X] Microservicios
- [X] APIs Mock
- [X] Pruebas Integradas
- [X] MVP Operativo

