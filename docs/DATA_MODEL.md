<!--
MIT License

Copyright (c) 2025 S&H Tech Labs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->

# Data Model Documentation

## S&H Tech Labs – AI Dental Health Platform

### Data Model Overview

This document defines the comprehensive data models, entities, and relationships for the S&H Tech Labs AI Dental Health Platform, including TypeScript interfaces and database schemas.

### Core Entities

#### User Entity

```typescript
interface User {
  id: string;                     // UUID primary key
  email: string;                  // Unique email address
  password: string;               // Hashed password
  firstName: string;              // User's first name
  lastName: string;               // User's last name
  role: UserRole;                 // User role enum
  status: UserStatus;             // Account status
  avatar?: string;                // Profile image URL
  phone?: string;                 // Phone number
  dateOfBirth?: Date;             // Date of birth
  gender?: Gender;                // Gender enum
  
  // Professional Information
  licenseNumber?: string;         // Dental license number
  specialization?: string[];      // Areas of specialization
  practiceAddress?: Address;      // Practice location
  
  // System Fields
  createdAt: Date;                // Account creation date
  updatedAt: Date;                // Last update date
  lastLoginAt?: Date;             // Last login timestamp
  emailVerifiedAt?: Date;         // Email verification date
  
  // Preferences
  preferences: UserPreferences;   // User settings
  notifications: NotificationSettings; // Notification preferences
}

enum UserRole {
  ADMIN = 'admin',
  DENTIST = 'dentist',
  ASSISTANT = 'assistant',
  PATIENT = 'patient'
}

enum UserStatus {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  SUSPENDED = 'suspended',
  PENDING = 'pending'
}

enum Gender {
  MALE = 'male',
  FEMALE = 'female',
  OTHER = 'other',
  PREFER_NOT_TO_SAY = 'prefer_not_to_say'
}
```

#### Patient Entity

```typescript
interface Patient {
  id: string;                     // UUID primary key
  patientNumber: string;          // Unique patient identifier
  
  // Personal Information
  firstName: string;              // Patient's first name
  lastName: string;               // Patient's last name
  email?: string;                 // Email address
  phone?: string;                 // Phone number
  dateOfBirth?: Date;             // Date of birth
  gender?: Gender;                // Gender enum
  avatar?: string;                // Profile photo URL
  
  // Contact Information
  address?: Address;              // Primary address
  emergencyContact?: EmergencyContact; // Emergency contact info
  
  // Medical Information
  medicalHistory: MedicalHistory; // Medical history data
  insuranceInfo?: InsuranceInfo;  // Insurance information
  allergies: string[];            // Known allergies
  medications: string[];          // Current medications
  
  // Dental Information
  dentalHistory: DentalHistory;   // Dental treatment history
  currentTreatments: Treatment[]; // Ongoing treatments
  
  // System Fields
  createdAt: Date;                // Record creation date
  updatedAt: Date;                // Last update date
  createdBy: string;              // User ID who created record
  lastVisitAt?: Date;             // Last appointment date
  
  // Status
  status: PatientStatus;          // Patient status
  isActive: boolean;              // Active status flag
  
  // Relationships
  practiceId: string;             // Associated practice
  primaryDentistId?: string;      // Primary dentist
}

enum PatientStatus {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  ARCHIVED = 'archived',
  TRANSFERRED = 'transferred'
}

interface Address {
  street: string;
  city: string;
  state: string;
  zipCode: string;
  country: string;
}

interface EmergencyContact {
  name: string;
  relationship: string;
  phone: string;
  email?: string;
}
```

#### Analysis Entity

```typescript
interface Analysis {
  id: string;                     // UUID primary key
  analysisNumber: string;         // Unique analysis identifier
  
  // Basic Information
  patientId: string;              // Associated patient
  performedBy: string;            // User who performed analysis
  analysisType: AnalysisType;     // Type of analysis
  status: AnalysisStatus;         // Processing status
  
  // Input Data
  images: AnalysisImage[];        // Input images
  metadata: AnalysisMetadata;     // Additional metadata
  
  // Results
  results?: AnalysisResults;      // AI analysis results
  confidence: number;             // Overall confidence score
  findings: Finding[];            // Detailed findings
  recommendations: Recommendation[]; // Treatment recommendations
  
  // Processing Information
  modelVersion: string;           // AI model version used
  processingTime: number;         // Processing time in seconds
  
  // Review and Approval
  reviewedBy?: string;            // Reviewing dentist
  reviewedAt?: Date;              // Review date
  reviewNotes?: string;           // Review comments
  approved: boolean;              // Approval status
  
  // System Fields
  createdAt: Date;                // Analysis creation date
  updatedAt: Date;                // Last update date
  processedAt?: Date;             // Processing completion date
}

enum AnalysisType {
  CAVITY_DETECTION = 'cavity_detection',
  GUM_DISEASE = 'gum_disease',
  ORTHODONTIC = 'orthodontic',
  ORAL_CANCER = 'oral_cancer',
  COMPREHENSIVE = 'comprehensive'
}

enum AnalysisStatus {
  PENDING = 'pending',
  PROCESSING = 'processing',
  COMPLETED = 'completed',
  FAILED = 'failed',
  CANCELLED = 'cancelled'
}

interface AnalysisImage {
  id: string;
  filename: string;
  url: string;
  size: number;
  mimeType: string;
  width: number;
  height: number;
  captureDate?: Date;
  deviceInfo?: string;
}

interface Finding {
  id: string;
  type: FindingType;
  location: Location;
  severity: Severity;
  confidence: number;
  description: string;
  boundingBox?: BoundingBox;
}

enum FindingType {
  CAVITY = 'cavity',
  CRACK = 'crack',
  GINGIVITIS = 'gingivitis',
  PERIODONTITIS = 'periodontitis',
  PLAQUE = 'plaque',
  TARTAR = 'tartar',
  LESION = 'lesion'
}

enum Severity {
  MILD = 'mild',
  MODERATE = 'moderate',
  SEVERE = 'severe'
}

interface Location {
  tooth?: string;                 // Tooth identifier
  quadrant?: Quadrant;            // Dental quadrant
  surface?: Surface;              // Tooth surface
  region?: string;                // General region description
}

interface BoundingBox {
  x: number;
  y: number;
  width: number;
  height: number;
}
```

#### Appointment Entity

```typescript
interface Appointment {
  id: string;                     // UUID primary key
  appointmentNumber: string;      // Unique appointment identifier
  
  // Basic Information
  patientId: string;              // Associated patient
  dentistId: string;              // Assigned dentist
  assistantId?: string;           // Assigned assistant
  
  // Scheduling
  scheduledAt: Date;              // Appointment date and time
  duration: number;               // Duration in minutes
  type: AppointmentType;          // Appointment type
  status: AppointmentStatus;      // Current status
  
  // Details
  title: string;                  // Appointment title
  description?: string;           // Additional details
  notes?: string;                 // Internal notes
  
  // Treatment Information
  plannedTreatments: string[];    // Planned treatments
  completedTreatments: string[];  // Completed treatments
  treatmentNotes?: string;        // Treatment notes
  
  // Billing
  estimatedCost?: number;         // Estimated cost
  actualCost?: number;            // Actual cost
  insuranceClaim?: string;        // Insurance claim number
  
  // System Fields
  createdAt: Date;                // Creation date
  updatedAt: Date;                // Last update date
  createdBy: string;              // User who created
  
  // Reminders
  reminderSent: boolean;          // Reminder sent flag
  reminderSentAt?: Date;          // Reminder sent date
  
  // Follow-up
  followUpRequired: boolean;      // Follow-up needed
  followUpDate?: Date;            // Scheduled follow-up
}

enum AppointmentType {
  CONSULTATION = 'consultation',
  CLEANING = 'cleaning',
  EXAMINATION = 'examination',
  TREATMENT = 'treatment',
  EMERGENCY = 'emergency',
  FOLLOW_UP = 'follow_up',
  AI_ANALYSIS = 'ai_analysis'
}

enum AppointmentStatus {
  SCHEDULED = 'scheduled',
  CONFIRMED = 'confirmed',
  CHECKED_IN = 'checked_in',
  IN_PROGRESS = 'in_progress',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
  NO_SHOW = 'no_show',
  RESCHEDULED = 'rescheduled'
}
```

#### File Entity

```typescript
interface File {
  id: string;                     // UUID primary key
  filename: string;               // Original filename
  displayName?: string;           // Display name
  
  // File Information
  size: number;                   // File size in bytes
  mimeType: string;               // MIME type
  extension: string;              // File extension
  checksum: string;               // File checksum
  
  // Storage
  url: string;                    // File URL
  storageProvider: StorageProvider; // Storage provider
  storagePath: string;            // Storage path
  
  // Metadata
  metadata: FileMetadata;         // Additional metadata
  tags: string[];                 // File tags
  description?: string;           // File description
  
  // Associations
  patientId?: string;             // Associated patient
  analysisId?: string;            // Associated analysis
  appointmentId?: string;         // Associated appointment
  category: FileCategory;         // File category
  
  // Security
  isEncrypted: boolean;           // Encryption status
  accessLevel: AccessLevel;       // Access level
  
  // System Fields
  createdAt: Date;                // Upload date
  updatedAt: Date;                // Last update date
  uploadedBy: string;             // User who uploaded
  lastAccessedAt?: Date;          // Last access date
}

enum StorageProvider {
  LOCAL = 'local',
  AWS_S3 = 'aws_s3',
  AZURE_BLOB = 'azure_blob',
  GOOGLE_CLOUD = 'google_cloud'
}

enum FileCategory {
  DENTAL_IMAGE = 'dental_image',
  X_RAY = 'x_ray',
  REPORT = 'report',
  DOCUMENT = 'document',
  TREATMENT_PLAN = 'treatment_plan',
  INSURANCE = 'insurance',
  CONSENT_FORM = 'consent_form'
}

enum AccessLevel {
  PUBLIC = 'public',
  PRIVATE = 'private',
  RESTRICTED = 'restricted',
  CONFIDENTIAL = 'confidential'
}
```

#### Report Entity

```typescript
interface Report {
  id: string;                     // UUID primary key
  reportNumber: string;           // Unique report identifier
  
  // Basic Information
  title: string;                  // Report title
  type: ReportType;               // Report type
  template: string;               // Report template
  
  // Content
  data: ReportData;               // Report data
  parameters: ReportParameters;   // Generation parameters
  filters: ReportFilters;         // Applied filters
  
  // Generation
  status: ReportStatus;           // Generation status
  format: ReportFormat;           // Output format
  generatedBy: string;            // User who generated
  generatedAt?: Date;             // Generation date
  
  // Output
  fileId?: string;                // Generated file ID
  url?: string;                   // Report URL
  size?: number;                  // File size
  
  // Scheduling
  isScheduled: boolean;           // Scheduled report
  schedule?: ReportSchedule;      // Schedule configuration
  
  // Sharing
  isShared: boolean;              // Shared status
  sharedWith: string[];           // Shared user IDs
  shareExpiration?: Date;         // Share expiration
  
  // System Fields
  createdAt: Date;                // Creation date
  updatedAt: Date;                // Last update date
}

enum ReportType {
  PATIENT_SUMMARY = 'patient_summary',
  ANALYSIS_REPORT = 'analysis_report',
  PRACTICE_ANALYTICS = 'practice_analytics',
  FINANCIAL_REPORT = 'financial_report',
  PERFORMANCE_REPORT = 'performance_report',
  CUSTOM_REPORT = 'custom_report'
}

enum ReportStatus {
  PENDING = 'pending',
  GENERATING = 'generating',
  COMPLETED = 'completed',
  FAILED = 'failed'
}

enum ReportFormat {
  PDF = 'pdf',
  EXCEL = 'excel',
  CSV = 'csv',
  HTML = 'html',
  JSON = 'json'
}
```

### Relationship Definitions

#### Entity Relationships

```typescript
// User to Patient (One-to-Many)
interface UserPatients {
  userId: string;                 // Dentist/Assistant ID
  patientIds: string[];           // Associated patients
}

// Patient to Analysis (One-to-Many)
interface PatientAnalyses {
  patientId: string;              // Patient ID
  analysisIds: string[];          // Patient's analyses
}

// Patient to Appointment (One-to-Many)
interface PatientAppointments {
  patientId: string;              // Patient ID
  appointmentIds: string[];       // Patient's appointments
}

// Analysis to File (One-to-Many)
interface AnalysisFiles {
  analysisId: string;             // Analysis ID
  fileIds: string[];              // Associated files
}
```

### Data Validation Rules

#### Validation Schemas

```typescript
// Patient validation
const PatientValidation = {
  firstName: {
    required: true,
    minLength: 2,
    maxLength: 50,
    pattern: /^[a-zA-Z\s]+$/
  },
  lastName: {
    required: true,
    minLength: 2,
    maxLength: 50,
    pattern: /^[a-zA-Z\s]+$/
  },
  email: {
    required: false,
    format: 'email'
  },
  phone: {
    required: false,
    pattern: /^\+?[\d\s\-\(\)]+$/
  },
  dateOfBirth: {
    required: false,
    type: 'date',
    maxDate: new Date()
  }
};

// Analysis validation
const AnalysisValidation = {
  patientId: {
    required: true,
    format: 'uuid'
  },
  analysisType: {
    required: true,
    enum: Object.values(AnalysisType)
  },
  images: {
    required: true,
    minItems: 1,
    maxItems: 10
  }
};
```

### Data Migration Strategies

#### Migration Scripts
- **Version Control**: Database schema versioning
- **Rollback Support**: Reversible migrations
- **Data Integrity**: Foreign key constraints
- **Performance**: Indexed migrations

This data model documentation serves as the foundation for database design and TypeScript type definitions throughout the application.
