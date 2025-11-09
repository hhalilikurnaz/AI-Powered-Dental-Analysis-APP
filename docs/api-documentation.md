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

# API Documentation

## S&H Tech Labs – AI Dental Health Platform API

### API Overview

The S&H Tech Labs API provides comprehensive access to the AI Dental Health Platform's functionality through a RESTful interface. The API is designed with security, scalability, and ease of use in mind, following industry best practices for healthcare data handling.

### Base Information

- **Base URL**: `https://api.shtechlabs.com/v1`
- **Authentication**: JWT Bearer Token
- **Content Type**: `application/json`
- **Rate Limiting**: 1000 requests per hour per user
- **API Version**: v1.0.0

### Authentication

#### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "user123",
      "email": "user@example.com",
      "role": "dentist",
      "name": "Dr. John Smith"
    }
  }
}
```

#### Refresh Token
```http
POST /auth/refresh
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### Logout
```http
POST /auth/logout
Authorization: Bearer <token>
```

### Patient Management

#### Get All Patients
```http
GET /patients
Authorization: Bearer <token>
```

**Query Parameters:**
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 20)
- `search` (string): Search by name or ID
- `sortBy` (string): Sort field (name, createdAt, etc.)
- `sortOrder` (string): asc or desc

**Response:**
```json
{
  "success": true,
  "data": {
    "patients": [...],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "pages": 8
    }
  }
}
```

#### Get Patient by ID
```http
GET /patients/{patientId}
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "patient123",
    "firstName": "Jane",
    "lastName": "Doe",
    "email": "jane.doe@email.com",
    "phone": "+1234567890",
    "dateOfBirth": "1985-06-15",
    "gender": "female",
    "address": {
      "street": "123 Main St",
      "city": "Anytown",
      "state": "CA",
      "zipCode": "12345"
    },
    "medicalHistory": [...],
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-20T14:45:00Z"
  }
}
```

#### Create Patient
```http
POST /patients
Authorization: Bearer <token>
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Smith",
  "email": "john.smith@email.com",
  "phone": "+1234567890",
  "dateOfBirth": "1990-03-20",
  "gender": "male",
  "address": {
    "street": "456 Oak Ave",
    "city": "Somewhere",
    "state": "NY",
    "zipCode": "54321"
  }
}
```

#### Update Patient
```http
PUT /patients/{patientId}
Authorization: Bearer <token>
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Smith Updated",
  "phone": "+1234567891"
}
```

#### Delete Patient
```http
DELETE /patients/{patientId}
Authorization: Bearer <token>
```

### AI Analysis

#### Upload Image for Analysis
```http
POST /ai/analyze
Authorization: Bearer <token>
Content-Type: multipart/form-data

{
  "image": <file>,
  "patientId": "patient123",
  "analysisType": "cavity_detection",
  "metadata": {
    "toothRegion": "upper_molars",
    "captureDate": "2024-01-20"
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "analysisId": "analysis123",
    "status": "completed",
    "results": {
      "confidence": 0.94,
      "detections": [
        {
          "type": "cavity",
          "location": {
            "tooth": "upper_right_molar_1",
            "coordinates": {
              "x": 120,
              "y": 340,
              "width": 45,
              "height": 30
            }
          },
          "severity": "moderate",
          "confidence": 0.89
        }
      ],
      "recommendations": [
        "Schedule dental filling appointment",
        "Consider fluoride treatment"
      ]
    },
    "processedAt": "2024-01-20T15:30:00Z"
  }
}
```

#### Get Analysis Results
```http
GET /ai/analysis/{analysisId}
Authorization: Bearer <token>
```

#### Get Patient's Analysis History
```http
GET /patients/{patientId}/analyses
Authorization: Bearer <token>
```

**Query Parameters:**
- `startDate` (string): Start date filter (ISO 8601)
- `endDate` (string): End date filter (ISO 8601)
- `analysisType` (string): Filter by analysis type
- `page` (number): Page number
- `limit` (number): Items per page

### File Management

#### Upload File
```http
POST /files/upload
Authorization: Bearer <token>
Content-Type: multipart/form-data

{
  "file": <file>,
  "category": "dental_image",
  "patientId": "patient123",
  "description": "Post-treatment X-ray"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "fileId": "file123",
    "filename": "xray_20240120.jpg",
    "url": "https://cdn.shtechlabs.com/files/file123",
    "size": 2048576,
    "mimeType": "image/jpeg",
    "uploadedAt": "2024-01-20T16:00:00Z"
  }
}
```

#### Get File
```http
GET /files/{fileId}
Authorization: Bearer <token>
```

#### Delete File
```http
DELETE /files/{fileId}
Authorization: Bearer <token>
```

### Reports

#### Generate Report
```http
POST /reports/generate
Authorization: Bearer <token>
Content-Type: application/json

{
  "patientId": "patient123",
  "reportType": "comprehensive_analysis",
  "dateRange": {
    "startDate": "2024-01-01",
    "endDate": "2024-01-31"
  },
  "includeImages": true,
  "format": "pdf"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "reportId": "report123",
    "status": "generating",
    "estimatedCompletion": "2024-01-20T16:05:00Z"
  }
}
```

#### Get Report Status
```http
GET /reports/{reportId}/status
Authorization: Bearer <token>
```

#### Download Report
```http
GET /reports/{reportId}/download
Authorization: Bearer <token>
```

### Appointments

#### Get Appointments
```http
GET /appointments
Authorization: Bearer <token>
```

**Query Parameters:**
- `patientId` (string): Filter by patient
- `startDate` (string): Start date filter
- `endDate` (string): End date filter
- `status` (string): Filter by status

#### Create Appointment
```http
POST /appointments
Authorization: Bearer <token>
Content-Type: application/json

{
  "patientId": "patient123",
  "scheduledAt": "2024-01-25T10:00:00Z",
  "duration": 60,
  "type": "consultation",
  "notes": "Follow-up after AI analysis"
}
```

#### Update Appointment
```http
PUT /appointments/{appointmentId}
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "completed",
  "notes": "Treatment completed successfully"
}
```

### Analytics

#### Get Dashboard Data
```http
GET /analytics/dashboard
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "totalPatients": 150,
    "analysesThisMonth": 45,
    "accuracyRate": 0.96,
    "trendsData": {
      "patientGrowth": [...],
      "analysisVolume": [...],
      "detectionTypes": [...]
    }
  }
}
```

#### Get Usage Statistics
```http
GET /analytics/usage
Authorization: Bearer <token>
```

**Query Parameters:**
- `period` (string): day, week, month, year
- `startDate` (string): Start date
- `endDate` (string): End date

### Notifications

#### Get Notifications
```http
GET /notifications
Authorization: Bearer <token>
```

#### Mark Notification as Read
```http
PUT /notifications/{notificationId}/read
Authorization: Bearer <token>
```

#### Get Notification Preferences
```http
GET /notifications/preferences
Authorization: Bearer <token>
```

#### Update Notification Preferences
```http
PUT /notifications/preferences
Authorization: Bearer <token>
Content-Type: application/json

{
  "email": {
    "analysisComplete": true,
    "appointments": true,
    "systemUpdates": false
  },
  "push": {
    "analysisComplete": true,
    "appointments": true,
    "systemUpdates": true
  }
}
```

### Error Handling

#### Error Response Format
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "email",
        "message": "Email is required"
      }
    ]
  }
}
```

#### Common Error Codes
- `UNAUTHORIZED` (401): Invalid or missing authentication token
- `FORBIDDEN` (403): Insufficient permissions
- `NOT_FOUND` (404): Resource not found
- `VALIDATION_ERROR` (400): Request validation failed
- `RATE_LIMIT_EXCEEDED` (429): Too many requests
- `INTERNAL_ERROR` (500): Server error

### Rate Limiting

#### Headers
- `X-RateLimit-Limit`: Maximum requests per hour
- `X-RateLimit-Remaining`: Remaining requests in current window
- `X-RateLimit-Reset`: Time when rate limit resets

### Webhooks

#### Webhook Events
- `analysis.completed`: AI analysis finished
- `patient.created`: New patient registered
- `appointment.scheduled`: New appointment created
- `report.generated`: Report generation completed

#### Webhook Payload Example
```json
{
  "event": "analysis.completed",
  "timestamp": "2024-01-20T16:30:00Z",
  "data": {
    "analysisId": "analysis123",
    "patientId": "patient123",
    "results": {...}
  }
}
```

### SDK and Libraries

#### JavaScript/Node.js
```javascript
npm install @shtechlabs/api-client

import { SHTechLabsClient } from '@shtechlabs/api-client';

const client = new SHTechLabsClient({
  apiKey: 'your-api-key',
  baseURL: 'https://api.shtechlabs.com/v1'
});

const patients = await client.patients.list();
```

#### Python
```python
pip install shtechlabs-python

from shtechlabs import Client

client = Client(api_key='your-api-key')
patients = client.patients.list()
```

### Testing

#### Postman Collection
A comprehensive Postman collection is available for testing all API endpoints:
- **Collection URL**: `https://api.shtechlabs.com/postman/collection.json`
- **Environment Variables**: Available for different environments (dev, staging, prod)

#### Example Requests
Complete example requests and responses are available in our interactive API documentation at `https://docs.shtechlabs.com/api`

This API documentation is continuously updated and versioned. For the latest information, please refer to our online documentation portal.
