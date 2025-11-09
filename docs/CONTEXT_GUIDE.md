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

# Context Guide Documentation

## S&H Tech Labs – AI Dental Health Platform

### Context Architecture Overview

This document provides a comprehensive guide to the React Context implementation for the S&H Tech Labs AI Dental Health Platform, including context providers, consumers, and state management patterns.

### Context Structure

#### Application Context Hierarchy

```
App
├── ThemeProvider          # Theme and styling context
├── AuthProvider           # Authentication and user context
├── ConfigProvider         # Application configuration
├── NotificationProvider   # Notifications and alerts
├── ModalProvider          # Modal and dialog management
└── QueryProvider          # React Query client provider
    └── Router
        └── Protected Routes
            ├── PatientProvider      # Patient data context
            ├── AnalysisProvider     # AI analysis context
            ├── AppointmentProvider  # Appointment context
            └── FileProvider         # File management context
```

### Core Context Providers

#### Authentication Context

```typescript
interface AuthContextType {
  // User State
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  
  // Authentication Methods
  login: (credentials: LoginCredentials) => Promise<void>;
  logout: () => void;
  register: (userData: RegisterData) => Promise<void>;
  refreshToken: () => Promise<void>;
  
  // Password Management
  forgotPassword: (email: string) => Promise<void>;
  resetPassword: (token: string, password: string) => Promise<void>;
  changePassword: (oldPassword: string, newPassword: string) => Promise<void>;
  
  // Profile Management
  updateProfile: (profileData: Partial<User>) => Promise<void>;
  uploadAvatar: (file: File) => Promise<string>;
  
  // Permissions
  hasPermission: (permission: Permission) => boolean;
  hasRole: (role: UserRole) => boolean;
}

// Implementation
const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  
  // Initialize authentication state
  useEffect(() => {
    initializeAuth();
  }, []);
  
  const initializeAuth = async () => {
    try {
      const token = localStorage.getItem('authToken');
      if (token && !isTokenExpired(token)) {
        const userData = await validateToken(token);
        setUser(userData);
      }
    } catch (error) {
      console.error('Auth initialization failed:', error);
      localStorage.removeItem('authToken');
    } finally {
      setIsLoading(false);
    }
  };
  
  const login = async (credentials: LoginCredentials) => {
    setIsLoading(true);
    try {
      const { user, token, refreshToken } = await authAPI.login(credentials);
      localStorage.setItem('authToken', token);
      localStorage.setItem('refreshToken', refreshToken);
      setUser(user);
    } catch (error) {
      throw error;
    } finally {
      setIsLoading(false);
    }
  };
  
  const logout = () => {
    localStorage.removeItem('authToken');
    localStorage.removeItem('refreshToken');
    setUser(null);
  };
  
  const value = {
    user,
    isAuthenticated: !!user,
    isLoading,
    login,
    logout,
    // ... other methods
  };
  
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

// Hook
export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
```

#### Theme Context

```typescript
interface ThemeContextType {
  // Theme State
  theme: ThemeMode;
  colors: ThemeColors;
  
  // Theme Methods
  setTheme: (theme: ThemeMode) => void;
  toggleTheme: () => void;
  
  // Customization
  setCustomColors: (colors: Partial<ThemeColors>) => void;
  resetTheme: () => void;
  
  // Preferences
  fontSize: FontSize;
  setFontSize: (size: FontSize) => void;
  
  // Accessibility
  highContrast: boolean;
  setHighContrast: (enabled: boolean) => void;
  reduceMotion: boolean;
  setReduceMotion: (enabled: boolean) => void;
}

enum ThemeMode {
  LIGHT = 'light',
  DARK = 'dark',
  SYSTEM = 'system'
}

enum FontSize {
  SMALL = 'small',
  MEDIUM = 'medium',
  LARGE = 'large',
  EXTRA_LARGE = 'extra_large'
}

interface ThemeColors {
  primary: string;
  secondary: string;
  accent: string;
  background: string;
  surface: string;
  text: string;
  textSecondary: string;
  border: string;
  error: string;
  warning: string;
  success: string;
  info: string;
}
```

#### Notification Context

```typescript
interface NotificationContextType {
  // Notification State
  notifications: Notification[];
  
  // Notification Methods
  addNotification: (notification: Omit<Notification, 'id' | 'timestamp'>) => string;
  removeNotification: (id: string) => void;
  clearNotifications: () => void;
  
  // Convenience Methods
  showSuccess: (message: string, options?: NotificationOptions) => string;
  showError: (message: string, options?: NotificationOptions) => string;
  showWarning: (message: string, options?: NotificationOptions) => string;
  showInfo: (message: string, options?: NotificationOptions) => string;
  
  // Settings
  maxNotifications: number;
  defaultDuration: number;
  position: NotificationPosition;
  setPosition: (position: NotificationPosition) => void;
}

interface Notification {
  id: string;
  type: NotificationType;
  title?: string;
  message: string;
  duration?: number;
  persistent?: boolean;
  actions?: NotificationAction[];
  timestamp: Date;
}

enum NotificationType {
  SUCCESS = 'success',
  ERROR = 'error',
  WARNING = 'warning',
  INFO = 'info'
}

enum NotificationPosition {
  TOP_RIGHT = 'top-right',
  TOP_LEFT = 'top-left',
  BOTTOM_RIGHT = 'bottom-right',
  BOTTOM_LEFT = 'bottom-left',
  TOP_CENTER = 'top-center',
  BOTTOM_CENTER = 'bottom-center'
}
```

#### Modal Context

```typescript
interface ModalContextType {
  // Modal State
  modals: Modal[];
  isOpen: (modalId: string) => boolean;
  
  // Modal Methods
  openModal: (modal: ModalConfig) => string;
  closeModal: (modalId: string) => void;
  closeAllModals: () => void;
  
  // Modal Stack Management
  getTopModal: () => Modal | null;
  bringToFront: (modalId: string) => void;
  
  // Convenience Methods
  showConfirm: (config: ConfirmConfig) => Promise<boolean>;
  showAlert: (config: AlertConfig) => Promise<void>;
  showDialog: (config: DialogConfig) => Promise<any>;
}

interface Modal {
  id: string;
  component: React.ComponentType<any>;
  props?: any;
  options: ModalOptions;
  zIndex: number;
  timestamp: Date;
}

interface ModalOptions {
  size?: ModalSize;
  position?: ModalPosition;
  backdrop?: boolean;
  closeOnBackdrop?: boolean;
  closeOnEsc?: boolean;
  persistent?: boolean;
  className?: string;
  animation?: ModalAnimation;
}

enum ModalSize {
  SMALL = 'small',
  MEDIUM = 'medium',
  LARGE = 'large',
  EXTRA_LARGE = 'extra_large',
  FULL_SCREEN = 'full_screen'
}
```

### Feature-Specific Contexts

#### Patient Context

```typescript
interface PatientContextType {
  // Patient State
  patients: Patient[];
  selectedPatient: Patient | null;
  isLoading: boolean;
  error: string | null;
  
  // Patient Methods
  loadPatients: (filters?: PatientFilters) => Promise<void>;
  createPatient: (patientData: CreatePatientData) => Promise<Patient>;
  updatePatient: (patientId: string, updates: Partial<Patient>) => Promise<Patient>;
  deletePatient: (patientId: string) => Promise<void>;
  
  // Selection
  selectPatient: (patientId: string) => void;
  clearSelection: () => void;
  
  // Search and Filter
  searchPatients: (query: string) => void;
  setFilters: (filters: PatientFilters) => void;
  clearFilters: () => void;
  
  // Pagination
  pagination: PaginationState;
  loadMore: () => Promise<void>;
  goToPage: (page: number) => Promise<void>;
  
  // Cache Management
  refreshPatients: () => Promise<void>;
  invalidateCache: () => void;
}

interface PatientFilters {
  status?: PatientStatus[];
  ageRange?: { min: number; max: number };
  gender?: Gender[];
  lastVisit?: DateRange;
  search?: string;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

interface PaginationState {
  page: number;
  limit: number;
  total: number;
  hasMore: boolean;
}
```

#### Analysis Context

```typescript
interface AnalysisContextType {
  // Analysis State
  analyses: Analysis[];
  currentAnalysis: Analysis | null;
  isProcessing: boolean;
  isLoading: boolean;
  error: string | null;
  
  // Analysis Methods
  startAnalysis: (config: AnalysisConfig) => Promise<string>;
  getAnalysis: (analysisId: string) => Promise<Analysis>;
  cancelAnalysis: (analysisId: string) => Promise<void>;
  retryAnalysis: (analysisId: string) => Promise<void>;
  
  // Results Management
  getResults: (analysisId: string) => Promise<AnalysisResults>;
  exportResults: (analysisId: string, format: ExportFormat) => Promise<string>;
  shareResults: (analysisId: string, shareConfig: ShareConfig) => Promise<string>;
  
  // History and Search
  loadAnalysisHistory: (patientId?: string) => Promise<void>;
  searchAnalyses: (criteria: AnalysisSearchCriteria) => Promise<Analysis[]>;
  
  // Real-time Updates
  subscribeToAnalysis: (analysisId: string) => () => void;
  
  // Settings
  analysisSettings: AnalysisSettings;
  updateSettings: (settings: Partial<AnalysisSettings>) => void;
}

interface AnalysisConfig {
  patientId: string;
  analysisType: AnalysisType;
  images: File[];
  metadata?: AnalysisMetadata;
  settings?: AnalysisSettings;
}

interface AnalysisSettings {
  confidenceThreshold: number;
  enableAutoReview: boolean;
  notifyOnCompletion: boolean;
  saveToPatientRecord: boolean;
  defaultAnalysisType: AnalysisType;
}
```

### Context Best Practices

#### Performance Optimization

```typescript
// Context Splitting for Performance
const PatientDataContext = createContext<PatientData>();
const PatientActionsContext = createContext<PatientActions>();

// Memoized Context Values
const PatientProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [patients, setPatients] = useState<Patient[]>([]);
  
  // Memoize actions to prevent unnecessary re-renders
  const actions = useMemo(() => ({
    createPatient,
    updatePatient,
    deletePatient,
  }), []);
  
  // Memoize data to prevent unnecessary re-renders
  const data = useMemo(() => ({
    patients,
    selectedPatient,
    isLoading,
  }), [patients, selectedPatient, isLoading]);
  
  return (
    <PatientDataContext.Provider value={data}>
      <PatientActionsContext.Provider value={actions}>
        {children}
      </PatientActionsContext.Provider>
    </PatientDataContext.Provider>
  );
};
```

#### Error Boundaries with Context

```typescript
interface ErrorContextType {
  error: Error | null;
  clearError: () => void;
  reportError: (error: Error, errorInfo?: any) => void;
}

class ErrorBoundary extends React.Component<
  { children: React.ReactNode },
  { hasError: boolean; error: Error | null }
> {
  constructor(props: any) {
    super(props);
    this.state = { hasError: false, error: null };
  }
  
  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error };
  }
  
  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
    // Report to error tracking service
    this.reportError(error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      return <ErrorFallback error={this.state.error} />;
    }
    
    return this.props.children;
  }
}
```

#### Context Testing Utilities

```typescript
// Test Provider Wrapper
export const createTestWrapper = (initialValues: Partial<AppContextType> = {}) => {
  return ({ children }: { children: React.ReactNode }) => (
    <TestProvider initialValues={initialValues}>
      {children}
    </TestProvider>
  );
};

// Mock Context Hook
export const mockUseAuth = (overrides: Partial<AuthContextType> = {}) => {
  return {
    user: null,
    isAuthenticated: false,
    isLoading: false,
    login: jest.fn(),
    logout: jest.fn(),
    ...overrides,
  };
};

// Context Testing Helper
export const renderWithContext = (
  component: React.ReactElement,
  contextValues: Partial<AppContextType> = {}
) => {
  const Wrapper = createTestWrapper(contextValues);
  return render(component, { wrapper: Wrapper });
};
```

### Context Hook Patterns

#### Conditional Context Usage

```typescript
// Optional Context Hook
export const useOptionalAuth = () => {
  return useContext(AuthContext);
};

// Required Context Hook
export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
```

#### Selector Pattern for Context

```typescript
// Context Selector Hook
export const useAuthSelector = <T>(selector: (auth: AuthContextType) => T): T => {
  const auth = useAuth();
  return useMemo(() => selector(auth), [auth, selector]);
};

// Usage
const user = useAuthSelector(auth => auth.user);
const isAuthenticated = useAuthSelector(auth => auth.isAuthenticated);
```

#### Context State Persistence

```typescript
// Persistent Context State
const usePersistedState = <T>(key: string, defaultValue: T) => {
  const [state, setState] = useState<T>(() => {
    try {
      const persistedValue = localStorage.getItem(key);
      return persistedValue ? JSON.parse(persistedValue) : defaultValue;
    } catch {
      return defaultValue;
    }
  });
  
  useEffect(() => {
    try {
      localStorage.setItem(key, JSON.stringify(state));
    } catch (error) {
      console.error('Failed to persist state:', error);
    }
  }, [key, state]);
  
  return [state, setState] as const;
};
```

This context guide provides a comprehensive framework for managing application state and cross-component communication in the S&H Tech Labs platform.
