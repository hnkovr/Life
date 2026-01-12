# Incremental Frontend Feature Implementation Plan

## Overview

Transform the Obsidian-based Life vault into a full-stack web application by implementing frontend features incrementally from simplest to hardest, with backend support built first for each feature.

**Current State:**
- Pure Obsidian vault with 118+ markdown files
- Structured data: Tasks, Projects, Goals, Areas, Notes, Reviews, Daily
- Bash scripts for DOCX/PPTX/audio processing
- NO web frontend, NO backend API, NO database

**Target Architecture:**
- **Frontend:** Vue 3 + TypeScript + Vite + Pinia + Tailwind CSS
- **Backend:** Django 5.0 + Django REST Framework + JWT auth
- **Database:** PostgreSQL (production) / SQLite (development)
- **Infrastructure:** Docker + docker-compose + GitHub Actions + Railway

## Implementation Strategy

Build **6 features** incrementally, each with:
1. Backend implementation (models, API, tests) - **DO THIS FIRST**
2. Frontend implementation (components, tests) - **DO THIS SECOND**
3. Integration testing - **DO THIS THIRD**
4. Verification - **DO THIS LAST**

---

## FEATURE 1: TaskList with Authentication (Week 1-2)

**Complexity:** SIMPLE (6-8 days total)
**Goal:** Establish complete infrastructure foundation with working task management

### Backend Implementation (2-3 days)

**Models to create:**
```
apps/authentication/models.py:
- User (extends AbstractUser)
  - email (unique)
  - username
  - domain_preference (work/personal)

apps/tasks/models.py:
- Task
  - id (UUID primary key)
  - user (ForeignKey)
  - title (CharField)
  - description (TextField, nullable)
  - status (todo/doing/waiting/done/canceled)
  - domain (work/personal)
  - due_date, scheduled_date, start_date (DateField, nullable)
  - completed_date (DateTimeField, nullable)
  - created_at, updated_at (auto)
  - tags (JSONField)
  - markdown_content (TextField)
```

**API Endpoints:**
```
POST   /api/auth/register          - User registration
POST   /api/auth/login             - JWT token generation
POST   /api/auth/refresh           - Token refresh
POST   /api/auth/logout            - Token invalidation

GET    /api/tasks/                 - List tasks (filters: domain, status, due_date)
POST   /api/tasks/                 - Create task
GET    /api/tasks/{id}/            - Retrieve task
PUT    /api/tasks/{id}/            - Update task
PATCH  /api/tasks/{id}/            - Partial update
DELETE /api/tasks/{id}/            - Soft delete
POST   /api/tasks/{id}/complete/   - Mark complete
```

**Backend Tests:**
- User registration and authentication
- JWT token generation/validation/refresh
- Task CRUD with authentication
- Task filtering by domain/status/date
- Permissions (users access only their tasks)
- Coverage target: >80%

**Infrastructure Setup:**
- Initialize Django project: `backend/`
- Create `backend/Dockerfile` (Python 3.11-slim, multi-stage)
- Create `docker-compose.yml`:
  - PostgreSQL 16 container
  - Redis 7 container (for future Celery)
  - Backend service
- Django settings split: base.py, development.py, production.py
- CORS configuration for frontend
- pytest + pytest-django + factory_boy setup
- Coverage reporting (pytest-cov)
- OpenAPI spec with drf-spectacular

**Critical Files:**
- `backend/life_api/settings/base.py`
- `backend/apps/tasks/models.py`
- `backend/apps/authentication/views.py`
- `docker-compose.yml`

### Frontend Implementation (2-3 days)

**Project Setup:**
- Initialize Vue 3 + TypeScript project with Vite
- Configure Tailwind CSS + Headless UI
- Setup Pinia stores
- Configure Vue Router with auth guards
- Setup axios with interceptors

**Components to create:**
```
src/components/auth/
- LoginForm.vue           - Email/password login
- RegisterForm.vue        - User registration
- AuthLayout.vue          - Auth pages layout

src/components/tasks/
- TaskList.vue            - Main task list with filters
- TaskItem.vue            - Single task row/card
- TaskForm.vue            - Create/edit task modal
- TaskFilters.vue         - Domain/status/date filters
- TaskSearch.vue          - Search tasks

src/components/common/
- AppHeader.vue           - Navigation header
- AppSidebar.vue          - Sidebar navigation
- LoadingSpinner.vue      - Loading indicator
```

**Services & Stores:**
```
src/services/
- api.ts                  - Axios instance with interceptors
- auth.service.ts         - Auth API calls
- task.service.ts         - Task API calls

src/stores/
- auth.ts                 - Pinia auth store
- tasks.ts                - Pinia tasks store
```

**Key Features:**
- Login/Register pages with form validation (VeeValidate + Zod)
- JWT token storage in localStorage
- Auto-refresh token on 401
- Task list with filters (domain, status, date)
- Task search by title/description
- Task CRUD operations (create, edit, delete, complete)
- Responsive design (mobile-friendly)

**Frontend Tests:**
- Unit tests (Vitest): auth store, task store, components
- E2E tests (Playwright): registration, login, task CRUD flows
- Coverage target: >70%

**Critical Files:**
- `frontend/src/services/api.ts`
- `frontend/src/stores/auth.ts`
- `frontend/src/stores/tasks.ts`
- `frontend/src/components/tasks/TaskList.vue`
- `frontend/Dockerfile`

### Infrastructure (2 days)

**Docker Setup:**
- `frontend/Dockerfile` (Node 20-alpine, nginx for production)
- Update `docker-compose.yml` with frontend service
- nginx.conf for SPA routing

**CI/CD Pipeline:**
```
.github/workflows/ci.yml:
- Backend tests (pytest)
- Frontend tests (vitest + playwright)
- Linting (ruff, ESLint)
- Coverage reports

.github/workflows/cd.yml (for later):
- Deploy to Railway on main branch push
```

**Documentation:**
```
docs/SETUP.md              - Complete setup instructions
docs/ARCHITECTURE.md       - System architecture (C4 model)
docs/DATABASE.md           - Database schema
backend/README.md          - Backend setup
frontend/README.md         - Frontend setup
api/openapi.yaml           - OpenAPI specification
```

### Verification Checklist

- [ ] User can register new account
- [ ] User can login with credentials
- [ ] JWT tokens stored and auto-refreshed
- [ ] User can create task with domain/status/due_date
- [ ] User can view list of tasks
- [ ] User can filter tasks by domain/status/date
- [ ] User can search tasks
- [ ] User can edit task
- [ ] User can delete task
- [ ] User can mark task as complete
- [ ] Backend tests pass (>80% coverage)
- [ ] Frontend tests pass (>70% coverage)
- [ ] Docker compose starts all services
- [ ] OpenAPI docs accessible at /api/schema/swagger-ui/
- [ ] CI pipeline passes

---

## FEATURE 2: NoteEditor (Week 3)

**Complexity:** SIMPLE-MEDIUM (5 days total)
**Goal:** Add knowledge management with markdown editing

### Backend Implementation (2 days)

**Models to create:**
```
apps/notes/models.py:
- Note
  - id (UUID)
  - user (ForeignKey)
  - title (CharField)
  - content (TextField, markdown)
  - summary (TextField, nullable)
  - domain (work/personal)
  - tags (JSONField)
  - created_at, updated_at
  - markdown_source (TextField)
```

**API Endpoints:**
```
GET    /api/notes/                - List notes (filters: domain, tags)
POST   /api/notes/                - Create note
GET    /api/notes/{id}/           - Retrieve note
PUT    /api/notes/{id}/           - Update note
PATCH  /api/notes/{id}/           - Partial update
DELETE /api/notes/{id}/           - Soft delete
GET    /api/notes/search/         - Full-text search
```

**Backend Tests:**
- Note CRUD operations
- Full-text search functionality
- Markdown sanitization
- Permissions

### Frontend Implementation (2 days)

**Components:**
```
src/components/notes/
- NoteEditor.vue          - Split-pane editor (markdown + preview)
- NoteList.vue            - List of notes
- NoteItem.vue            - Single note card
- NotePreview.vue         - Rendered markdown preview
- NoteSearch.vue          - Search notes
```

**Key Features:**
- Split-pane editor (left: markdown, right: preview)
- Live markdown preview using `marked` + `highlight.js`
- Auto-save draft to localStorage
- Note search with highlighting
- Tag management
- Markdown toolbar (bold, italic, code, lists, etc.)

**Frontend Tests:**
- Component rendering
- Markdown preview accuracy
- Note CRUD operations
- Search functionality

### Integration Testing (1 day)

- Create note with markdown → verify preview rendering
- Edit note → verify auto-save
- Search notes → verify results accuracy
- Tag filtering

### Verification Checklist

- [ ] User can create note with markdown
- [ ] Live preview shows rendered markdown
- [ ] User can edit existing notes
- [ ] User can search notes by content
- [ ] User can add/remove tags
- [ ] Markdown renders correctly (headings, lists, code, images)
- [ ] All tests pass
- [ ] OpenAPI spec updated

---

## FEATURE 3: Dashboard (Week 4)

**Complexity:** MEDIUM (5 days total)
**Goal:** Provide overview of all data with statistics

### Backend Implementation (2 days)

**API Endpoints:**
```
GET /api/dashboard/stats/         - Aggregate statistics
  Response: {
    tasks: {total, by_status, by_domain, overdue, due_today, due_this_week},
    notes: {total, recent}
  }

GET /api/dashboard/recent/        - Recent activity
GET /api/dashboard/upcoming/      - Upcoming tasks (next 7 days)
```

**Backend Tests:**
- Aggregation queries correctness
- Performance with large datasets
- Redis caching for stats

### Frontend Implementation (2 days)

**Components:**
```
src/components/dashboard/
- Dashboard.vue              - Main dashboard layout
- StatsCard.vue              - Statistic card widget
- TasksOverview.vue          - Tasks summary
- NotesOverview.vue          - Notes summary
- UpcomingTasks.vue          - Upcoming tasks list
- RecentActivity.vue         - Recent activity feed
- QuickActions.vue           - Quick action buttons
```

**Key Features:**
- Summary cards:
  - Total tasks by status (with doughnut chart)
  - Overdue tasks (highlighted red)
  - Due today / this week
  - Total notes count
- Upcoming tasks (next 7 days)
- Recent notes (last 5)
- Quick actions (Create task, Create note)
- Domain toggle (Work/Personal/Both)
- Simple charts using Chart.js

**Frontend Tests:**
- Dashboard rendering
- Stats calculation
- Chart rendering
- Quick actions

### Integration Testing (1 day)

- Dashboard loads correct aggregated data
- Creating task from dashboard updates stats in real-time
- Charts render with accurate data
- Domain toggle filters correctly

### Verification Checklist

- [ ] Dashboard displays correct task counts
- [ ] Overdue tasks prominently highlighted
- [ ] Upcoming tasks shown
- [ ] Recent notes displayed
- [ ] Charts render correctly
- [ ] Quick actions work
- [ ] Dashboard updates when data changes
- [ ] All tests pass

---

## FEATURE 4: GoalTracker with Projects (Week 5-6)

**Complexity:** MEDIUM-HARD (8 days total)
**Goal:** Introduce entity relationships and progress tracking

### Backend Implementation (3 days)

**Models to create:**
```
apps/goals/models.py:
- Goal
  - id, user, title, description
  - horizon (3mo/6mo/1yr/2yr/5yr)
  - metric (success criteria)
  - status (active/paused/done/canceled)
  - domain, tags
  - progress (IntegerField 0-100%)
  - created_at, updated_at

apps/projects/models.py:
- Project
  - id, user, title, outcome
  - status (active/paused/done/canceled)
  - domain, area, tags
  - goal (ForeignKey to Goal, nullable)
  - created_at, updated_at

# Update apps/tasks/models.py:
- Task
  + project (ForeignKey to Project, nullable)
  + goal (ForeignKey to Goal, nullable)
```

**API Endpoints:**
```
# Goals
GET    /api/goals/                - List goals
POST   /api/goals/                - Create goal
GET    /api/goals/{id}/           - Retrieve goal
PUT    /api/goals/{id}/           - Update goal
DELETE /api/goals/{id}/           - Delete goal
GET    /api/goals/{id}/projects/  - Projects for goal
GET    /api/goals/{id}/tasks/     - Tasks for goal
GET    /api/goals/{id}/progress/  - Progress calculation

# Projects
GET    /api/projects/             - List projects
POST   /api/projects/             - Create project
GET    /api/projects/{id}/        - Retrieve project
PUT    /api/projects/{id}/        - Update project
DELETE /api/projects/{id}/        - Delete project
GET    /api/projects/{id}/tasks/  - Tasks for project
```

**Business Logic:**
- Goal progress calculation:
  ```python
  progress = (completed_items / total_items) * 100
  # Where items = linked projects + linked tasks
  ```

**Backend Tests:**
- Goal/Project model relationships
- Progress calculation algorithm
- Cascading queries (goal → projects → tasks)
- Permissions (users can only link their own entities)

### Frontend Implementation (3 days)

**Components:**
```
src/components/goals/
- GoalTracker.vue           - Main goal tracking view
- GoalList.vue              - List of goals
- GoalCard.vue              - Goal card with progress bar
- GoalDetail.vue            - Goal detail with linked items
- GoalForm.vue              - Create/edit goal
- ProjectList.vue           - List of projects
- ProjectCard.vue           - Project card
- ProjectDetail.vue         - Project detail with tasks
- ProjectForm.vue           - Create/edit project
- ProgressBar.vue           - Visual progress indicator
```

**Key Features:**
- Goal tracker page:
  - Goals grouped by horizon (3mo, 6mo, 1yr, etc.)
  - Visual progress bars
  - Filter by domain/status
- Goal detail page:
  - Goal info (title, description, metric, horizon)
  - Linked projects with progress
  - Linked tasks grouped by project
  - Edit/delete actions
- Project detail page:
  - Project info (title, outcome, status)
  - Linked goal
  - Task list with completion summary
- Entity linking:
  - When creating task, can link to project/goal
  - When creating project, can link to goal
  - Dropdown selectors with search

**Frontend Tests:**
- Goal/project rendering
- Progress calculation display
- Entity linking workflows
- CRUD operations

### Integration Testing (2 days)

- Create goal → create project linked to goal → create tasks linked to project → verify progress calculates correctly
- Complete tasks → verify project progress updates → verify goal progress updates
- Unlink task from project → verify progress recalculates
- Delete project → verify tasks remain (just unlinked)

### Verification Checklist

- [ ] User can create goals with metrics and horizons
- [ ] User can create projects linked to goals
- [ ] User can create tasks linked to projects/goals
- [ ] Progress bars show correct percentages
- [ ] Goal detail shows all linked projects
- [ ] Project detail shows all linked tasks
- [ ] Progress auto-updates when tasks complete
- [ ] All tests pass
- [ ] OpenAPI spec updated

---

## FEATURE 5: ProjectBoard (Kanban) (Week 6-7)

**Complexity:** MEDIUM-HARD (7 days total)
**Goal:** Add interactive drag-and-drop task management

### Backend Implementation (2 days)

**Models update:**
```
apps/tasks/models.py:
- Task
  + board_order (IntegerField, for ordering within status)
```

**API Endpoints:**
```
PATCH /api/tasks/{id}/move/        - Move task to new status/order
  Request: {status: "doing", order: 2}

POST  /api/tasks/bulk-update/      - Bulk update task orders
  Request: [{id: "uuid", order: 1}, {id: "uuid", order: 2}]
```

**Backend Tests:**
- Task ordering within status column
- Bulk update operations
- Concurrent move operations (race condition handling)

### Frontend Implementation (3 days)

**Components:**
```
src/components/board/
- ProjectBoard.vue          - Kanban board layout
- BoardColumn.vue           - Single status column
- BoardCard.vue             - Task card (draggable)
- BoardFilters.vue          - Filter tasks on board
```

**Key Features:**
- Kanban board with columns:
  - Todo | Doing | Waiting | Done
- Drag-and-drop functionality:
  - Drag task between columns → updates status
  - Drag task within column → updates order
  - Library: `@vueuse/core` useDraggable or `vue-draggable-plus`
- Board views:
  - Filter by project
  - Filter by domain (Work/Personal)
  - Show/hide completed tasks
- Task quick actions on card:
  - Edit (modal)
  - Delete
  - View details

**Frontend Tests:**
- Board rendering with columns
- Drag-and-drop functionality
- Status update on move
- Order preservation after refresh

### Integration Testing (2 days)

- Drag task between columns → verify status update in database
- Drag task within column → verify order persists
- Multiple concurrent moves → verify no data loss
- Refresh page → verify order maintained

### Verification Checklist

- [ ] Board displays tasks in correct columns
- [ ] User can drag task between columns
- [ ] Task status updates when moved
- [ ] User can reorder tasks within column
- [ ] Board filters work correctly
- [ ] Changes persist after page refresh
- [ ] All tests pass

---

## FEATURE 6: ImportWizard (Todoist + Notion) (Week 8-9)

**Complexity:** HARD (12 days total)
**Goal:** External integrations with OAuth and data sync

### Backend Implementation (5 days)

**Models to create:**
```
apps/integrations/models.py:
- Integration
  - id, user
  - service (todoist/notion)
  - access_token (encrypted)
  - refresh_token (encrypted, nullable)
  - token_expires_at (nullable)
  - last_sync_at
  - sync_settings (JSONField)
  - is_active
  - created_at, updated_at

- SyncLog
  - id, integration
  - sync_type (full/incremental)
  - status (pending/running/success/failed)
  - started_at, completed_at
  - items_synced
  - errors (JSONField)
```

**API Endpoints:**
```
# Todoist
GET   /api/integrations/todoist/authorize/      - Start OAuth flow
GET   /api/integrations/todoist/callback/       - OAuth callback
POST  /api/integrations/todoist/sync/           - Trigger sync
POST  /api/integrations/todoist/disconnect/     - Disconnect

# Notion
GET   /api/integrations/notion/authorize/
GET   /api/integrations/notion/callback/
POST  /api/integrations/notion/sync/
POST  /api/integrations/notion/disconnect/

# Generic
GET   /api/integrations/                        - List active integrations
GET   /api/integrations/sync-logs/              - Sync history
```

**Implementation Details:**

**Todoist Integration:**
- OAuth 2.0 flow (store encrypted tokens)
- Fetch tasks from Todoist API
- Mapping:
  - content → title
  - description → description
  - due.date → due_date
  - priority → priority
  - labels → tags
  - project_id → project (if mapped)
- Incremental sync (only changed since last_sync_at)
- Celery task for background sync

**Notion Integration:**
- OAuth 2.0 flow
- Fetch pages and databases
- Parse Notion blocks → Markdown:
  - Paragraph → markdown paragraph
  - Heading → # Heading
  - Bulleted list → - Item
  - Code → ```language\ncode```
  - Image → download to S3/MinIO
- Convert page properties → frontmatter
- Celery task for background sync

**Celery Setup:**
```python
# apps/integrations/tasks.py
@shared_task
def sync_todoist(integration_id: str):
    """Background task for Todoist sync"""

@shared_task
def sync_notion(integration_id: str):
    """Background task for Notion sync"""
```

**Backend Tests:**
- OAuth flow (mocked responses)
- Token encryption/decryption
- Todoist task mapping
- Notion block parsing (all types)
- Sync logic (full + incremental)
- Error handling (rate limits, network errors)
- Celery task execution

**Infrastructure:**
- Add Celery worker container to docker-compose
- Redis as Celery broker
- Environment variables for OAuth credentials

### Frontend Implementation (4 days)

**Components:**
```
src/components/import/
- ImportWizard.vue             - Multi-step wizard
- ImportSteps.vue              - Step indicator
- ImportSelectService.vue      - Step 1: Choose service
- ImportAuthorize.vue          - Step 2: OAuth authorization
- ImportConfigure.vue          - Step 3: Sync settings
- ImportProgress.vue           - Step 4: Sync progress
- ImportResults.vue            - Step 5: Results summary
- IntegrationCard.vue          - Active integration card
```

**Wizard Steps:**

1. **Select Service:** Choose Todoist or Notion
2. **Authorization:** OAuth redirect flow
3. **Configure Sync:**
   - Choose domain (Work/Personal)
   - Select projects/databases to sync
   - Set sync schedule (manual/daily/hourly)
4. **Sync Progress:** Real-time progress (polling)
5. **Results:** Summary with success/error counts

**Active Integrations Page:**
- List connected services
- Last sync time
- Sync now button
- Disconnect button
- View sync logs

**Frontend Tests:**
- Wizard navigation
- OAuth flow (mocked)
- Configuration options
- Results display

### Integration Testing (3 days)

**Todoist:**
- Mock Todoist API
- Full sync: fetch tasks → create in database → verify
- Incremental sync: fetch only new/changed → update
- Disconnect: remove integration → verify tasks remain

**Notion:**
- Mock Notion API
- Fetch pages → parse blocks → convert to markdown → create notes
- Download images → store in S3 → link in notes
- Handle various block types

### Security Considerations

- Encrypt OAuth tokens with `django-cryptography`
- Store secrets in environment variables
- Use HTTPS for OAuth callbacks
- Implement rate limiting
- Validate OAuth state parameter (CSRF protection)

### Verification Checklist

- [ ] User can connect Todoist via OAuth
- [ ] User can sync Todoist tasks
- [ ] Todoist tasks appear in TaskList
- [ ] User can configure sync settings
- [ ] User can manually trigger sync
- [ ] User can view sync logs
- [ ] User can disconnect Todoist
- [ ] User can connect Notion via OAuth
- [ ] User can sync Notion pages to notes
- [ ] Notion pages convert to markdown correctly
- [ ] Notion images download and link correctly
- [ ] Background sync works via Celery
- [ ] All tests pass
- [ ] Error handling works (API failures, rate limits)

---

## Cross-Cutting Concerns

### OpenAPI Specification Evolution

Build incrementally after each feature:
- **Feature 1:** Auth + Task endpoints
- **Feature 2:** Note endpoints
- **Feature 3:** Dashboard endpoints
- **Feature 4:** Goal + Project endpoints
- **Feature 6:** Integration endpoints

Use `drf-spectacular` to auto-generate from Django, then customize.

### Database Migrations

Run migrations after each feature:
```bash
python manage.py makemigrations
python manage.py migrate
```

Test migrations in both directions (forward and rollback).

### CI/CD Pipeline Evolution

- **Feature 1:** Setup CI (tests, linting)
- **Feature 3:** Add caching (Redis)
- **Feature 6:** Add Celery worker, deploy to Railway

### Testing Strategy

**Unit Tests:**
- Backend: >80% coverage (pytest)
- Frontend: >70% coverage (Vitest)

**API Tests:**
- All endpoints with authentication
- All error cases (400, 401, 403, 404, 500)

**Integration Tests:**
- Multi-step user workflows
- Data consistency across features

**E2E Tests:**
- Critical user journeys (Playwright)
- Happy paths + error cases

### Documentation Updates

After each feature, update:
- `docs/ARCHITECTURE.md` - Add new components
- `docs/DATABASE.md` - Add new models/relationships
- `api/openapi.yaml` - Add new endpoints
- `README.md` - Add new features to overview
- Backend/Frontend READMEs - Add new setup steps

---

## Timeline Summary

| Week | Feature | Backend | Frontend | Tests | Total |
|------|---------|---------|----------|-------|-------|
| 1-2  | TaskList + Auth | 3d | 3d | 2d | 8d |
| 3    | NoteEditor | 2d | 2d | 1d | 5d |
| 4    | Dashboard | 2d | 2d | 1d | 5d |
| 5-6  | GoalTracker | 3d | 3d | 2d | 8d |
| 6-7  | ProjectBoard | 2d | 3d | 2d | 7d |
| 8-9  | ImportWizard | 5d | 4d | 3d | 12d |
| **Total** | | | | | **45 days (9 weeks)** |

---

## Critical Files to Create

### Backend
1. `backend/life_api/settings/base.py` - Core Django config
2. `backend/apps/tasks/models.py` - Task model with relationships
3. `backend/apps/authentication/views.py` - JWT auth endpoints
4. `backend/apps/integrations/todoist/sync.py` - Todoist sync logic
5. `backend/apps/integrations/notion/parser.py` - Notion block parser

### Frontend
1. `frontend/src/services/api.ts` - Centralized axios client
2. `frontend/src/stores/auth.ts` - Auth state management
3. `frontend/src/stores/tasks.ts` - Task state management
4. `frontend/src/components/tasks/TaskList.vue` - Main task interface
5. `frontend/src/components/import/ImportWizard.vue` - Integration wizard

### Infrastructure
1. `docker-compose.yml` - All services orchestration
2. `.github/workflows/ci.yml` - CI pipeline
3. `api/openapi.yaml` - API contract
4. `docs/ARCHITECTURE.md` - System architecture

---

## Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| OAuth complexity | High | Use well-tested libraries, mock in tests |
| State management | Medium | Use Pinia with clear modules, TypeScript |
| Performance | Medium | Pagination, caching, indexes, lazy loading |
| Time overrun | High | MVP-first, use AI assistants, strict time-boxing |

---

## Success Criteria (AI Dev Zoomcamp)

After all features, verify:
- [x] Problem description clear (README.md)
- [x] AI development logged with MCP usage
- [x] Architecture fully documented
- [x] OpenAPI spec complete and accurate
- [x] Frontend functional with >70% test coverage
- [x] Backend functional with >80% test coverage
- [x] Database supports multiple environments
- [x] Docker runs entire system
- [x] Integration tests cover key workflows
- [x] Deployed to Railway with working URL
- [x] CI/CD pipeline runs tests and deploys
- [x] Reproducibility documented (SETUP.md)

---

## Next Steps

1. **Confirm approach** with user
2. **Start Feature 1:** Create initial project structure
3. **Setup Docker** environment
4. **Implement backend** (models, API, tests)
5. **Implement frontend** (components, tests)
6. **Verify** end-to-end
7. **Move to Feature 2**

Each feature is independently deployable and testable before moving to the next.
