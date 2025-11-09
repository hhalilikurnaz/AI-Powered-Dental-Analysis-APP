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

# Architecture Documentation

## S&H Tech Labs – AI Dental Health Platform

### System Architecture Overview

This document outlines the comprehensive architecture of the S&H Tech Labs AI Dental Health Platform, including frontend architecture, component structure, and system design patterns.

### Frontend Architecture

#### Technology Stack
- **React 18**: Modern React with hooks and concurrent features
- **TypeScript**: Type-safe development
- **Vite**: Fast build tool and development server
- **Tailwind CSS**: Utility-first CSS framework
- **Zustand**: Lightweight state management
- **React Query**: Server state management
- **React Router**: Client-side routing

#### Project Structure
```
src/
├── app/                    # Application configuration and providers
├── modules/                # Feature-based modules
├── components/             # Reusable UI components
├── hooks/                  # Custom React hooks
├── store/                  # Global state management
└── utils/                  # Utility functions and helpers
```

#### Component Architecture

##### Component Hierarchy
- **App Components**: Root-level application setup
- **Module Components**: Feature-specific components
- **Shared Components**: Reusable UI components
- **Layout Components**: Page and section layouts

##### Component Design Principles
- **Single Responsibility**: Each component has one clear purpose
- **Composition over Inheritance**: Use component composition
- **Props Drilling Prevention**: Use context and state management
- **Performance Optimization**: Lazy loading and memoization

#### State Management Architecture

##### Global State (Zustand)
- **Authentication State**: User session and permissions
- **Application State**: Global application settings
- **UI State**: Modal visibility, notifications, etc.

##### Server State (React Query)
- **Data Fetching**: API calls and caching
- **Mutations**: Create, update, delete operations
- **Background Updates**: Automatic data refreshing

#### Routing Architecture

##### Route Structure
```
/                           # Dashboard
/auth/                      # Authentication routes
  ├── /login               # Login page
  └── /register            # Registration page
/patients/                  # Patient management
  ├── /list                # Patient list
  ├── /create              # Add new patient
  └── /:id                 # Patient details
/analysis/                  # AI Analysis
  ├── /upload              # Upload images
  ├── /results             # Analysis results
  └── /history             # Analysis history
/reports/                   # Reports and analytics
/settings/                  # Application settings
```

#### Module Architecture

##### Feature Modules
Each module contains:
- **Components**: Module-specific components
- **Hooks**: Module-specific custom hooks
- **Services**: API calls and business logic
- **Types**: TypeScript interfaces and types
- **Utils**: Module-specific utilities

##### Module Examples
- **Authentication Module**: Login, registration, password reset
- **Patient Module**: Patient CRUD operations
- **Analysis Module**: AI image analysis features
- **Dashboard Module**: Analytics and overview
- **Settings Module**: User and application settings

#### Security Architecture

##### Authentication Flow
1. **Login Process**: JWT token acquisition
2. **Token Storage**: Secure token storage
3. **Route Protection**: Private route guards
4. **Token Refresh**: Automatic token renewal

##### Data Security
- **Input Validation**: Client-side validation
- **XSS Prevention**: Content sanitization
- **CSRF Protection**: Request token validation
- **HTTPS Enforcement**: Secure communication

#### Performance Architecture

##### Optimization Strategies
- **Code Splitting**: Route-based lazy loading
- **Bundle Optimization**: Tree shaking and minification
- **Image Optimization**: Lazy loading and compression
- **Caching Strategy**: Browser and application caching

##### Monitoring and Analytics
- **Performance Metrics**: Core Web Vitals tracking
- **Error Tracking**: Runtime error monitoring
- **User Analytics**: Usage pattern analysis
- **Performance Budgets**: Bundle size monitoring

This architecture document serves as the foundation for development decisions and system design.
