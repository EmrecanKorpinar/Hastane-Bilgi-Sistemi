# HBS Domain-Driven Design - Context Map

```
┌─────────────────────────────────────────────────────────────────────┐
│                          API GATEWAY                                 │
│  - Routing, Rate Limiting, Authentication, CORS                     │
└─────────────────────────────────────────────────────────────────────┘
                                  │
        ┌─────────────────────────┴────────────────────────┐
        │                                                   │
┌───────▼──────────┐                              ┌────────▼─────────┐
│  PATIENT CONTEXT │                              │   IAM CONTEXT    │
├──────────────────┤                              ├──────────────────┤
│ Aggregate:       │                              │ Aggregate:       │
│  - Patient       │◄─────────────────────────────┤  - User          │
│                  │     User creates Patient     │  - Role          │
│ Events:          │                              │  - Permission    │
│  patient.        │                              │                  │
│  registered      │                              │ Events:          │
│                  │                              │  user.created    │
│ Database:        │                              │                  │
│  PostgreSQL      │                              │ Database:        │
└────────┬─────────┘                              │  PostgreSQL      │
         │                                        └──────────────────┘
         │ patient.registered
         │
    ┌────▼──────────────┐
    │  KAFKA (Event Bus)│
    └────┬──────────┬───┘
         │          │
         │          └──────────────────────────┐
         │                                     │
┌────────▼─────────┐              ┌────────────▼──────────┐
│ APPOINTMENT      │              │   NOTIFICATION         │
│ CONTEXT          │              │   CONTEXT              │
├──────────────────┤              ├───────────────────────┤
│ Aggregate:       │              │ Aggregate:             │
│  - Appointment   │              │  - Notification        │
│                  │              │                        │
│ Subscribes:      │              │ Subscribes:            │
│  patient.        │              │  patient.registered    │
│  registered      │              │  appointment.created   │
│                  │              │  prescription.created  │
│ Events:          │              │                        │
│  appointment.    │              │ Events:                │
│  created         │              │  notification.sent     │
│                  │              │                        │
│ Database:        │              │ Database:              │
│  PostgreSQL      │              │  PostgreSQL            │
└────────┬─────────┘              └────────────────────────┘
         │
         │ appointment.created
         │
    ┌────▼──────────────┐
    │  KAFKA            │
    └────┬──────────────┘
         │
┌────────▼─────────┐
│ CLINICAL CONTEXT │
├──────────────────┤
│ Aggregate:       │
│  - Encounter     │
│  - Diagnosis     │
│  - Treatment     │
│                  │
│ Subscribes:      │
│  appointment.    │
│  created         │
│                  │
│ Events:          │
│  encounter.      │
│  completed       │
│  diagnosis.added │
│                  │
│ Database:        │
│  PostgreSQL      │
└────────┬─────────┘
         │
         │ encounter.completed
         │
    ┌────▼──────────────┐
    │  KAFKA            │
    └────┬──────┬───────┘
         │      │
         │      └─────────────────────────┐
         │                                │
┌────────▼─────────┐          ┌───────────▼────────┐
│ PHARMACY CONTEXT │          │  BILLING CONTEXT   │
├──────────────────┤          ├────────────────────┤
│ Aggregate:       │          │ Aggregate:         │
│  - Prescription  │          │  - Invoice         │
│  - Drug          │          │  - Payment         │
│                  │          │                    │
│ Subscribes:      │          │ Subscribes:        │
│  encounter.      │          │  encounter.        │
│  completed       │          │  completed         │
│                  │          │  prescription.     │
│ Events:          │          │  created           │
│  prescription.   │          │  stock.decremented │
│  created         │          │                    │
│                  │          │ Events:            │
│ Database:        │          │  invoice.created   │
│  PostgreSQL      │          │  payment.received  │
└────────┬─────────┘          │                    │
         │                    │ Integrations:      │
         │                    │  - SUT             │
         │                    │  - Medula (SGK)    │
         │                    │                    │
         │                    │ Database:          │
         │                    │  PostgreSQL        │
         │                    └────────────────────┘
         │ prescription.created
         │
    ┌────▼──────────────┐
    │  KAFKA            │
    └────┬──────────────┘
         │
┌────────▼─────────┐
│ INVENTORY        │
│ CONTEXT          │
├──────────────────┤
│ Aggregate:       │
│  - Stock         │
│  - Warehouse     │
│                  │
│ Subscribes:      │
│  prescription.   │
│  created         │
│                  │
│ Events:          │
│  stock.          │
│  decremented     │
│  reorder.        │
│  triggered       │
│                  │
│ Integrations:    │
│  - ÜTS           │
│                  │
│ Database:        │
│  PostgreSQL      │
└──────────────────┘

┌──────────────────┐
│ LAB CONTEXT      │
├──────────────────┤
│ Aggregate:       │
│  - LabOrder      │
│  - LabResult     │
│                  │
│ Events:          │
│  lab.ordered     │
│  result.ready    │
│                  │
│ Integrations:    │
│  - LIS devices   │
│                  │
│ Database:        │
│  PostgreSQL      │
│  + MongoDB (logs)│
└──────────────────┘

┌──────────────────┐
│ IMAGING CONTEXT  │
├──────────────────┤
│ Aggregate:       │
│  - ImagingStudy  │
│  - DicomImage    │
│                  │
│ Events:          │
│  study.created   │
│  dicom.uploaded  │
│                  │
│ Integrations:    │
│  - PACS          │
│  - RIS           │
│                  │
│ Database:        │
│  PostgreSQL      │
│  + MinIO (DICOM) │
└──────────────────┘
```

## Bounded Context Relationships

### Patient Context (Core Domain)
- **Type**: Core Domain
- **Upstream**: IAM Context
- **Downstream**: Appointment, Clinical, Notification
- **Integration**: Published events
- **Database**: PostgreSQL (patients table)

### Appointment Context
- **Type**: Supporting Domain
- **Upstream**: Patient Context
- **Downstream**: Clinical Context
- **Integration**: Event-driven (patient.registered → create appointment slot)
- **Database**: PostgreSQL (appointments table)

### Clinical Context
- **Type**: Core Domain
- **Upstream**: Appointment, Patient
- **Downstream**: Pharmacy, Billing, Lab, Imaging
- **Integration**: Event-driven (encounter.completed triggers downstream)
- **Database**: PostgreSQL (encounters, diagnoses, treatments)

### Pharmacy Context
- **Type**: Supporting Domain
- **Upstream**: Clinical Context
- **Downstream**: Inventory, Billing
- **Integration**: Saga (prescription → stock decrement → billing)
- **Database**: PostgreSQL (prescriptions, drugs)

### Billing Context (Core Domain)
- **Type**: Core Domain
- **Upstream**: Clinical, Pharmacy, Lab, Imaging
- **Downstream**: None (end of chain)
- **Integration**: Saga orchestration, External API (Medula/SUT)
- **Database**: PostgreSQL (invoices, payments)

### Inventory Context
- **Type**: Supporting Domain
- **Upstream**: Pharmacy Context
- **Downstream**: None
- **Integration**: Event-driven (stock.decremented compensation)
- **Database**: PostgreSQL (stock, warehouses)

### IAM Context
- **Type**: Generic Subdomain
- **Upstream**: Keycloak (OAuth2/OpenID)
- **Downstream**: All contexts (authentication/authorization)
- **Integration**: JWT token validation
- **Database**: PostgreSQL (users, roles, permissions)

### Notification Context
- **Type**: Generic Subdomain
- **Upstream**: All contexts
- **Downstream**: External (SMS, Email, Push providers)
- **Integration**: Event-driven (consume all domain events)
- **Database**: PostgreSQL (notification logs)

## Anti-Corruption Layers (ACL)

### Medula Integration (Billing Context)
- **Purpose**: SGK billing integration
- **Pattern**: ACL to translate HBS domain to Medula API
- **Implementation**: Adapter pattern

### ÜTS Integration (Inventory Context)
- **Purpose**: Medical device tracking
- **Pattern**: ACL to comply with Turkish regulation
- **Implementation**: External service adapter

### PACS/DICOM (Imaging Context)
- **Purpose**: Medical imaging storage
- **Pattern**: ACL to handle DICOM protocol
- **Implementation**: DICOM server adapter + MinIO

