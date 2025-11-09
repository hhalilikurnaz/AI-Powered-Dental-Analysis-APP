# Development Guide

## S&H Tech Labs – AI Dental Health Platform

### Development Environment Setup

This guide provides comprehensive instructions for setting up and contributing to the S&H Tech Labs AI Dental Health Platform development environment.

### Prerequisites

#### Required Software
- **Node.js**: Version 18.x or higher
- **npm**: Version 8.x or higher (comes with Node.js)
- **Git**: Latest version
- **Docker**: Version 20.x or higher
- **Docker Compose**: Version 2.x or higher

#### Recommended Tools
- **VS Code**: With recommended extensions
- **Postman**: For API testing
- **GitHub Desktop**: For Git GUI (optional)
- **MongoDB Compass**: For database management
- **pgAdmin**: For PostgreSQL management

#### System Requirements
- **RAM**: Minimum 8GB, 16GB recommended
- **Storage**: At least 10GB free space
- **OS**: macOS 10.15+, Windows 10+, or Ubuntu 18.04+

### Project Setup

#### 1. Clone the Repository
```bash
# Clone the main repository
git clone https://github.com/shtechlabs/sh-tech-labs.git
cd sh-tech-labs

# Checkout the development branch
git checkout dev
```

#### 2. Environment Configuration
```bash
# Copy environment template
cp .env.example .env.local

# Edit environment variables
# Configure database connections, API keys, etc.
```

#### 3. Install Dependencies
```bash
# Install root dependencies
npm install

# Install frontend dependencies
cd frontend
npm install

# Install backend dependencies
cd ../backend
npm install

# Return to root directory
cd ..
```

#### 4. Database Setup
```bash
# Start local databases using Docker
docker-compose up -d postgres mongodb redis

# Run database migrations
npm run db:migrate

# Seed development data
npm run db:seed
```

#### 5. Start Development Servers
```bash
# Start all services in development mode
npm run dev

# Or start services individually:
npm run dev:frontend    # Frontend dev server
npm run dev:backend     # Backend API server
npm run dev:ai          # AI service
```

### Project Structure

```
sh-tech-labs/
├── frontend/                 # React frontend application
│   ├── src/
│   │   ├── components/      # Reusable UI components
│   │   ├── pages/          # Page components
│   │   ├── hooks/          # Custom React hooks
│   │   ├── services/       # API service functions
│   │   ├── utils/          # Utility functions
│   │   ├── types/          # TypeScript type definitions
│   │   └── styles/         # Global styles and themes
│   ├── public/             # Static assets
│   └── package.json
├── backend/                 # Node.js backend services
│   ├── src/
│   │   ├── controllers/    # Request handlers
│   │   ├── models/         # Database models
│   │   ├── middleware/     # Express middleware
│   │   ├── routes/         # API route definitions
│   │   ├── services/       # Business logic services
│   │   └── utils/          # Utility functions
│   ├── tests/              # Backend tests
│   └── package.json
├── ai-service/              # Python AI/ML service
│   ├── src/
│   │   ├── models/         # AI model definitions
│   │   ├── preprocessing/  # Image preprocessing
│   │   ├── inference/      # Model inference logic
│   │   └── utils/          # Utility functions
│   ├── tests/              # AI service tests
│   └── requirements.txt
├── shared/                  # Shared utilities and types
│   ├── types/              # Shared TypeScript types
│   └── utils/              # Shared utility functions
├── docs/                   # Documentation
├── docker/                 # Docker configurations
├── scripts/                # Build and deployment scripts
├── .github/                # GitHub Actions workflows
├── docker-compose.yml      # Local development environment
├── package.json            # Root package.json
└── README.md
```

### Development Workflow

#### Git Workflow

##### Branch Strategy
- **main**: Production-ready code
- **dev**: Development integration branch
- **feature/***: Feature development branches
- **hotfix/***: Critical bug fix branches
- **release/***: Release preparation branches

##### Feature Development Workflow
```bash
# 1. Create and switch to feature branch
git checkout dev
git pull origin dev
git checkout -b feature/patient-management-improvements

# 2. Make your changes and commit
git add .
git commit -m "feat: add patient search functionality"

# 3. Push branch and create pull request
git push origin feature/patient-management-improvements
# Create PR from feature branch to dev branch

# 4. After PR approval and merge, cleanup
git checkout dev
git pull origin dev
git branch -d feature/patient-management-improvements
```

##### Commit Message Convention
Follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

```bash
# Format: <type>[optional scope]: <description>

# Types:
feat:     # New feature
fix:      # Bug fix
docs:     # Documentation changes
style:    # Code formatting, missing semicolons, etc.
refactor: # Code refactoring
test:     # Adding or updating tests
chore:    # Maintenance tasks

# Examples:
git commit -m "feat(ai): add cavity detection algorithm"
git commit -m "fix(auth): resolve login token expiration issue"
git commit -m "docs: update API documentation"
git commit -m "test(patient): add patient creation tests"
```

#### Code Quality Standards

##### TypeScript Configuration
```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

##### ESLint Configuration
```json
// .eslintrc.json
{
  "extends": [
    "@typescript-eslint/recommended",
    "prettier"
  ],
  "rules": {
    "no-console": "warn",
    "@typescript-eslint/no-unused-vars": "error",
    "prefer-const": "error"
  }
}
```

##### Prettier Configuration
```json
// .prettierrc
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
```

#### Testing Strategy

##### Frontend Testing
```bash
# Run all frontend tests
cd frontend
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage

# Run specific test file
npm test -- PatientList.test.tsx
```

##### Backend Testing
```bash
# Run all backend tests
cd backend
npm test

# Run integration tests
npm run test:integration

# Run unit tests only
npm run test:unit

# Test with coverage report
npm run test:coverage
```

##### End-to-End Testing
```bash
# Run E2E tests
npm run test:e2e

# Run E2E tests in headless mode
npm run test:e2e:headless

# Run specific E2E test suite
npm run test:e2e -- --spec="patient-management.cy.ts"
```

### API Development

#### RESTful API Guidelines

##### Endpoint Naming
```javascript
// Good examples:
GET    /api/v1/patients          // Get all patients
GET    /api/v1/patients/:id      // Get specific patient
POST   /api/v1/patients          // Create new patient
PUT    /api/v1/patients/:id      // Update patient
DELETE /api/v1/patients/:id      // Delete patient

// Nested resources:
GET    /api/v1/patients/:id/analyses     // Get patient's analyses
POST   /api/v1/patients/:id/analyses     // Create analysis for patient
```

##### Request/Response Format
```javascript
// Request
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@example.com"
}

// Successful Response
{
  "success": true,
  "data": {
    "id": "patient123",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}

// Error Response
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

##### Controller Example
```typescript
// controllers/PatientController.ts
import { Request, Response } from 'express';
import { PatientService } from '../services/PatientService';

export class PatientController {
  private patientService: PatientService;

  constructor() {
    this.patientService = new PatientService();
  }

  async createPatient(req: Request, res: Response) {
    try {
      const patientData = req.body;
      const patient = await this.patientService.create(patientData);
      
      res.status(201).json({
        success: true,
        data: patient
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        error: {
          code: 'CREATION_FAILED',
          message: error.message
        }
      });
    }
  }
}
```

### Frontend Development

#### Component Structure
```typescript
// components/PatientList/PatientList.tsx
import React, { useState, useEffect } from 'react';
import { Patient } from '../../types/Patient';
import { PatientService } from '../../services/PatientService';
import styles from './PatientList.module.css';

interface PatientListProps {
  onPatientSelect: (patient: Patient) => void;
}

export const PatientList: React.FC<PatientListProps> = ({ onPatientSelect }) => {
  const [patients, setPatients] = useState<Patient[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadPatients();
  }, []);

  const loadPatients = async () => {
    try {
      setLoading(true);
      const data = await PatientService.getAll();
      setPatients(data);
    } catch (err) {
      setError('Failed to load patients');
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div>Loading patients...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div className={styles.patientList}>
      {patients.map(patient => (
        <div
          key={patient.id}
          className={styles.patientItem}
          onClick={() => onPatientSelect(patient)}
        >
          <h3>{patient.firstName} {patient.lastName}</h3>
          <p>{patient.email}</p>
        </div>
      ))}
    </div>
  );
};
```

#### Custom Hooks
```typescript
// hooks/usePatients.ts
import { useState, useEffect } from 'react';
import { Patient } from '../types/Patient';
import { PatientService } from '../services/PatientService';

export const usePatients = () => {
  const [patients, setPatients] = useState<Patient[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const loadPatients = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await PatientService.getAll();
      setPatients(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setLoading(false);
    }
  };

  const createPatient = async (patientData: Partial<Patient>) => {
    try {
      const newPatient = await PatientService.create(patientData);
      setPatients(prev => [...prev, newPatient]);
      return newPatient;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Creation failed');
      throw err;
    }
  };

  useEffect(() => {
    loadPatients();
  }, []);

  return {
    patients,
    loading,
    error,
    loadPatients,
    createPatient
  };
};
```

#### State Management
```typescript
// store/patientStore.ts (using Zustand)
import { create } from 'zustand';
import { Patient } from '../types/Patient';
import { PatientService } from '../services/PatientService';

interface PatientStore {
  patients: Patient[];
  selectedPatient: Patient | null;
  loading: boolean;
  error: string | null;
  
  loadPatients: () => Promise<void>;
  selectPatient: (patient: Patient) => void;
  createPatient: (data: Partial<Patient>) => Promise<Patient>;
  updatePatient: (id: string, data: Partial<Patient>) => Promise<void>;
  deletePatient: (id: string) => Promise<void>;
}

export const usePatientStore = create<PatientStore>((set, get) => ({
  patients: [],
  selectedPatient: null,
  loading: false,
  error: null,

  loadPatients: async () => {
    set({ loading: true, error: null });
    try {
      const patients = await PatientService.getAll();
      set({ patients, loading: false });
    } catch (error) {
      set({ error: error.message, loading: false });
    }
  },

  selectPatient: (patient) => {
    set({ selectedPatient: patient });
  },

  createPatient: async (data) => {
    const newPatient = await PatientService.create(data);
    set(state => ({
      patients: [...state.patients, newPatient]
    }));
    return newPatient;
  },

  updatePatient: async (id, data) => {
    const updatedPatient = await PatientService.update(id, data);
    set(state => ({
      patients: state.patients.map(p => 
        p.id === id ? updatedPatient : p
      )
    }));
  },

  deletePatient: async (id) => {
    await PatientService.delete(id);
    set(state => ({
      patients: state.patients.filter(p => p.id !== id),
      selectedPatient: state.selectedPatient?.id === id ? null : state.selectedPatient
    }));
  }
}));
```

### AI Service Development

#### Model Integration
```python
# ai-service/src/models/cavity_detector.py
import tensorflow as tf
import numpy as np
from PIL import Image
import cv2

class CavityDetector:
    def __init__(self, model_path: str):
        self.model = tf.keras.models.load_model(model_path)
        self.input_size = (224, 224)
        
    def preprocess_image(self, image_path: str) -> np.ndarray:
        """Preprocess image for model inference"""
        # Load and resize image
        image = Image.open(image_path)
        image = image.resize(self.input_size)
        
        # Convert to RGB if needed
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Normalize pixel values
        image_array = np.array(image) / 255.0
        
        # Add batch dimension
        return np.expand_dims(image_array, axis=0)
    
    def predict(self, image_path: str) -> dict:
        """Perform cavity detection on image"""
        try:
            # Preprocess image
            processed_image = self.preprocess_image(image_path)
            
            # Run inference
            predictions = self.model.predict(processed_image)
            
            # Process results
            confidence = float(predictions[0][0])
            has_cavity = confidence > 0.5
            
            return {
                'has_cavity': has_cavity,
                'confidence': confidence,
                'severity': self._determine_severity(confidence),
                'recommendations': self._generate_recommendations(has_cavity, confidence)
            }
            
        except Exception as e:
            raise Exception(f"Prediction failed: {str(e)}")
    
    def _determine_severity(self, confidence: float) -> str:
        """Determine cavity severity based on confidence"""
        if confidence < 0.3:
            return 'none'
        elif confidence < 0.6:
            return 'mild'
        elif confidence < 0.8:
            return 'moderate'
        else:
            return 'severe'
    
    def _generate_recommendations(self, has_cavity: bool, confidence: float) -> list:
        """Generate treatment recommendations"""
        if not has_cavity:
            return ['Continue regular dental hygiene', 'Schedule routine checkup']
        
        recommendations = ['Schedule dental appointment immediately']
        
        if confidence > 0.7:
            recommendations.append('Consider filling or crown treatment')
        
        if confidence > 0.9:
            recommendations.append('Urgent treatment required')
        
        return recommendations
```

#### API Service Integration
```python
# ai-service/src/api/analysis_api.py
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import os
import uuid
from models.cavity_detector import CavityDetector

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size

# Initialize AI models
cavity_detector = CavityDetector('models/cavity_detection_v2.h5')

@app.route('/analyze/cavity', methods=['POST'])
def analyze_cavity():
    try:
        # Validate request
        if 'image' not in request.files:
            return jsonify({'error': 'No image file provided'}), 400
        
        file = request.files['image']
        if file.filename == '':
            return jsonify({'error': 'No file selected'}), 400
        
        # Save uploaded file temporarily
        filename = secure_filename(file.filename)
        temp_id = str(uuid.uuid4())
        temp_path = f'/tmp/{temp_id}_{filename}'
        file.save(temp_path)
        
        try:
            # Perform analysis
            results = cavity_detector.predict(temp_path)
            
            # Clean up temporary file
            os.remove(temp_path)
            
            return jsonify({
                'success': True,
                'data': results
            })
            
        except Exception as e:
            # Clean up on error
            if os.path.exists(temp_path):
                os.remove(temp_path)
            raise e
            
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
```

### Database Management

#### Schema Migrations
```javascript
// migrations/001_create_patients_table.js
exports.up = function(knex) {
  return knex.schema.createTable('patients', function(table) {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.string('firstName').notNullable();
    table.string('lastName').notNullable();
    table.string('email').unique().notNullable();
    table.string('phone');
    table.date('dateOfBirth');
    table.enum('gender', ['male', 'female', 'other']);
    table.jsonb('address');
    table.jsonb('medicalHistory');
    table.timestamps(true, true);
    
    table.index(['email']);
    table.index(['lastName', 'firstName']);
  });
};

exports.down = function(knex) {
  return knex.schema.dropTable('patients');
};
```

#### Model Definitions
```typescript
// models/Patient.ts
import { Model } from 'objection';

export class Patient extends Model {
  static tableName = 'patients';

  id!: string;
  firstName!: string;
  lastName!: string;
  email!: string;
  phone?: string;
  dateOfBirth?: Date;
  gender?: 'male' | 'female' | 'other';
  address?: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
  };
  medicalHistory?: any;
  createdAt!: Date;
  updatedAt!: Date;

  static jsonSchema = {
    type: 'object',
    required: ['firstName', 'lastName', 'email'],
    properties: {
      id: { type: 'string' },
      firstName: { type: 'string', minLength: 1, maxLength: 50 },
      lastName: { type: 'string', minLength: 1, maxLength: 50 },
      email: { type: 'string', format: 'email' },
      phone: { type: 'string' },
      dateOfBirth: { type: 'string', format: 'date' },
      gender: { type: 'string', enum: ['male', 'female', 'other'] },
      address: {
        type: 'object',
        properties: {
          street: { type: 'string' },
          city: { type: 'string' },
          state: { type: 'string' },
          zipCode: { type: 'string' }
        }
      }
    }
  };

  static relationMappings = {
    analyses: {
      relation: Model.HasManyRelation,
      modelClass: 'Analysis',
      join: {
        from: 'patients.id',
        to: 'analyses.patientId'
      }
    },
    
    appointments: {
      relation: Model.HasManyRelation,
      modelClass: 'Appointment',
      join: {
        from: 'patients.id',
        to: 'appointments.patientId'
      }
    }
  };
}
```

### Performance Optimization

#### Frontend Optimization
```typescript
// Lazy loading components
const PatientList = React.lazy(() => import('./components/PatientList'));
const AIAnalysis = React.lazy(() => import('./components/AIAnalysis'));

// Memoization for expensive calculations
const PatientDashboard = React.memo(({ patients }) => {
  const patientStats = useMemo(() => {
    return calculatePatientStatistics(patients);
  }, [patients]);

  return <div>{/* dashboard content */}</div>;
});

// Virtual scrolling for large lists
import { FixedSizeList as List } from 'react-window';

const VirtualizedPatientList = ({ patients }) => (
  <List
    height={400}
    itemCount={patients.length}
    itemSize={60}
    itemData={patients}
  >
    {PatientRow}
  </List>
);
```

#### Backend Optimization
```typescript
// Database query optimization
class PatientService {
  async findPatientsWithAnalyses(filters: PatientFilters) {
    return Patient.query()
      .select('patients.*')
      .withGraphFetched('analyses(recent)')
      .modifyGraph('analyses', builder => {
        builder.orderBy('createdAt', 'desc').limit(5);
      })
      .where(builder => {
        if (filters.search) {
          builder.where('firstName', 'ilike', `%${filters.search}%`)
                 .orWhere('lastName', 'ilike', `%${filters.search}%`);
        }
      })
      .orderBy('lastName', 'asc')
      .page(filters.page || 0, filters.limit || 20);
  }
}

// Caching strategy
import Redis from 'ioredis';

class CacheService {
  private redis: Redis;

  constructor() {
    this.redis = new Redis(process.env.REDIS_URL);
  }

  async get<T>(key: string): Promise<T | null> {
    const value = await this.redis.get(key);
    return value ? JSON.parse(value) : null;
  }

  async set(key: string, value: any, ttl: number = 3600): Promise<void> {
    await this.redis.setex(key, ttl, JSON.stringify(value));
  }

  async invalidate(pattern: string): Promise<void> {
    const keys = await this.redis.keys(pattern);
    if (keys.length > 0) {
      await this.redis.del(...keys);
    }
  }
}
```

### Deployment and DevOps

#### Docker Configuration
```dockerfile
# frontend/Dockerfile
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

#### CI/CD Pipeline
```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, dev]
  pull_request:
    branches: [main, dev]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:13
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linting
      run: npm run lint
    
    - name: Run tests
      run: npm test
      env:
        CI: true
    
    - name: Build application
      run: npm run build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy to production
      run: |
        # Deployment scripts here
        echo "Deploying to production..."
```

This development guide provides a comprehensive foundation for contributing to the S&H Tech Labs AI Dental Health Platform. For additional information and updates, please refer to the project wiki and technical documentation.
