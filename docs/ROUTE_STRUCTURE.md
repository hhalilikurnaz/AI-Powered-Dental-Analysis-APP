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

# Route Structure Documentation

## S&H Tech Labs – AI Dental Health Platform

### Application Routing Overview

This document defines the complete routing structure for the S&H Tech Labs AI Dental Health Platform, including public and private routes, route guards, and navigation patterns.

### Route Hierarchy

#### Public Routes (No Authentication Required)

```
/                           # Landing page (redirects to /auth/login if not authenticated)
/auth/                      # Authentication routes
  ├── /login                # Login page
  ├── /register             # Registration page  
  ├── /forgot-password      # Password reset request
  ├── /reset-password       # Password reset form
  └── /verify-email         # Email verification page
/about                      # About the platform
/contact                    # Contact information
/privacy                    # Privacy policy
/terms                      # Terms of service
```

#### Private Routes (Authentication Required)

##### Dashboard Routes
```
/dashboard                  # Main dashboard (default authenticated route)
  ├── /overview            # Dashboard overview
  ├── /analytics           # Quick analytics view
  └── /recent             # Recent activity
```

##### Patient Management Routes
```
/patients                   # Patient management section
  ├── /                    # Patient list (default)
  ├── /list                # Patient list view
  ├── /grid                # Patient grid view
  ├── /create              # Add new patient form
  ├── /import              # Bulk patient import
  ├── /:patientId          # Individual patient routes
  │   ├── /                # Patient overview
  │   ├── /profile         # Patient profile details
  │   ├── /history         # Medical history
  │   ├── /analyses        # Analysis history
  │   ├── /appointments    # Patient appointments
  │   ├── /files           # Patient files
  │   ├── /reports         # Patient reports
  │   └── /edit            # Edit patient information
  └── /archived            # Archived patients
```

##### AI Analysis Routes
```
/analysis                   # AI analysis section
  ├── /                    # Analysis dashboard
  ├── /upload              # Upload images for analysis
  ├── /batch               # Batch analysis upload
  ├── /queue               # Analysis processing queue
  ├── /history             # Analysis history
  ├── /results             # Analysis results overview
  ├── /:analysisId         # Individual analysis routes
  │   ├── /                # Analysis overview
  │   ├── /details         # Detailed results
  │   ├── /images          # Analysis images
  │   ├── /report          # Analysis report
  │   └── /share           # Share analysis
  └── /settings            # Analysis preferences
```

##### Appointment Management Routes
```
/appointments               # Appointment management
  ├── /                    # Appointment calendar (default)
  ├── /calendar            # Calendar view
  ├── /list                # List view
  ├── /create              # Create new appointment
  ├── /recurring           # Recurring appointments
  ├── /:appointmentId      # Individual appointment routes
  │   ├── /                # Appointment details
  │   ├── /edit            # Edit appointment
  │   └── /reschedule      # Reschedule appointment
  └── /settings            # Appointment settings
```

##### Reports & Analytics Routes
```
/reports                    # Reports and analytics
  ├── /                    # Reports dashboard
  ├── /patient             # Patient reports
  ├── /practice            # Practice analytics
  ├── /financial          # Financial reports
  ├── /ai-performance      # AI accuracy reports
  ├── /custom              # Custom report builder
  ├── /templates           # Report templates
  ├── /scheduled           # Scheduled reports
  └── /:reportId           # Individual report routes
      ├── /                # Report view
      ├── /edit            # Edit report
      └── /share           # Share report
```

##### File Management Routes
```
/files                      # File management
  ├── /                    # File browser (default)
  ├── /images              # Image files
  ├── /documents           # Document files
  ├── /reports             # Generated reports
  ├── /upload              # File upload interface
  ├── /search              # File search
  └── /:fileId             # Individual file routes
      ├── /                # File preview
      ├── /edit            # Edit file metadata
      └── /share           # Share file
```

##### Settings Routes
```
/settings                   # Application settings
  ├── /                    # General settings (default)
  ├── /profile             # User profile settings
  ├── /practice            # Practice information
  ├── /users               # User management (admin only)
  ├── /integrations        # Third-party integrations
  ├── /notifications       # Notification preferences
  ├── /security            # Security settings
  ├── /billing             # Billing and subscription
  ├── /backup              # Backup settings
  └── /system              # System configuration (admin only)
```

##### Help & Support Routes
```
/help                       # Help and support
  ├── /                    # Help center (default)
  ├── /docs                # Documentation
  ├── /tutorials           # Video tutorials
  ├── /faq                 # Frequently asked questions
  ├── /contact             # Contact support
  ├── /tickets             # Support tickets
  └── /feedback            # Feedback form
```

### Route Parameters and Query Strings

#### Common Route Parameters
- `:patientId` - Patient identifier (UUID)
- `:analysisId` - Analysis identifier (UUID)
- `:appointmentId` - Appointment identifier (UUID)
- `:reportId` - Report identifier (UUID)
- `:fileId` - File identifier (UUID)
- `:userId` - User identifier (UUID)

#### Common Query Parameters
- `?page=` - Pagination page number
- `?limit=` - Items per page
- `?search=` - Search query string
- `?sort=` - Sort field
- `?order=` - Sort order (asc/desc)
- `?filter=` - Filter criteria
- `?view=` - View type (list/grid/calendar)
- `?tab=` - Active tab
- `?modal=` - Modal state

### Route Guards and Protection

#### Authentication Guard
- **Applies to**: All private routes
- **Function**: Redirects unauthenticated users to `/auth/login`
- **Storage**: Checks for valid JWT token in localStorage

#### Role-Based Guards
- **Admin Routes**: `/settings/users`, `/settings/system`
- **Dentist Routes**: All patient and analysis routes
- **Assistant Routes**: Limited patient data access
- **Patient Routes**: Personal data access only

#### Permission Guards
- **Patient Access**: Can only access own data
- **Data Modification**: Based on user role permissions
- **Feature Access**: Based on subscription plan
- **API Access**: Based on user permissions

### Navigation Patterns

#### Primary Navigation
- **Dashboard**: Main overview and analytics
- **Patients**: Patient management and records
- **Analysis**: AI analysis tools and results
- **Appointments**: Scheduling and calendar
- **Reports**: Analytics and reporting
- **Files**: File and document management
- **Settings**: Configuration and preferences

#### Secondary Navigation
- **Breadcrumbs**: Hierarchical navigation path
- **Tabs**: Section-specific navigation
- **Quick Actions**: Contextual action buttons
- **Search**: Global and section-specific search

#### Mobile Navigation
- **Bottom Tab Bar**: Primary navigation on mobile
- **Hamburger Menu**: Secondary navigation
- **Swipe Gestures**: Navigate between sections
- **Pull-to-Refresh**: Refresh current view

### URL Structure Conventions

#### Naming Conventions
- **Lowercase**: All URLs use lowercase
- **Kebab-case**: Multi-word segments use hyphens
- **Plural Nouns**: Collection routes use plural nouns
- **RESTful**: Follow REST conventions where applicable

#### Examples
- ✅ `/patients/create` - Correct
- ❌ `/Patients/Create` - Incorrect (capitalization)
- ✅ `/forgot-password` - Correct
- ❌ `/forgotPassword` - Incorrect (camelCase)

### Route Redirects and Aliases

#### Default Redirects
- `/` → `/dashboard` (authenticated users)
- `/` → `/auth/login` (unauthenticated users)
- `/patients` → `/patients/list`
- `/analysis` → `/analysis/upload`
- `/settings` → `/settings/profile`

#### Legacy Route Support
- `/patient/:id` → `/patients/:id` (backwards compatibility)
- `/analyze` → `/analysis/upload`
- `/schedule` → `/appointments/calendar`

### Error Routes

#### Error Pages
- `/404` - Page not found
- `/403` - Access forbidden
- `/500` - Server error
- `/offline` - Offline mode

#### Error Handling
- **Invalid Routes**: Redirect to 404
- **Unauthorized Access**: Redirect to 403
- **Network Errors**: Show offline page
- **Server Errors**: Show 500 page

### Progressive Enhancement

#### Route Lazy Loading
```typescript
// Example lazy loading implementation
const PatientList = lazy(() => import('../modules/patients/PatientList'));
const Analysis = lazy(() => import('../modules/analysis/Analysis'));
```

#### Route Preloading
- **Prefetch**: Likely next routes
- **Preload**: Critical route components
- **Background**: Non-critical route loading

This route structure documentation serves as the definitive guide for application navigation and URL structure.
