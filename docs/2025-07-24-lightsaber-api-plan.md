# Lightsaber Collection API - Project Plan

**Date:** July 24, 2025  
**Project:** Educational HTTP API for Swift/iOS students  
**Backend:** Express.js + TypeScript + Firebase

## Project Overview

Building a fun and educational REST API that demonstrates all major HTTP methods through a Star Wars lightsaber collection theme. This backend will serve as a learning tool for students to understand HTTP requests before building iOS apps that consume APIs.

## Route Structure

- **Documentation:** `GET /` - Interactive HTML documentation page
- **API Base:** `/api` - All API endpoints under this prefix

## Learning Objectives

Students will learn:
- GET requests (retrieve data)  
- POST requests (create new resources)
- PUT requests (replace entire resources)
- PATCH requests (partial updates)
- DELETE requests (remove resources)
- HTTP status codes and error handling
- JSON request/response formats

## Tech Stack

- **Runtime:** Node.js
- **Framework:** Express.js
- **Language:** TypeScript
- **Database:** Firebase Firestore
- **Authentication:** Firebase Admin SDK
- **Validation:** Express-validator middleware
- **Documentation:** Interactive HTML page at root

## Data Model

### Lightsaber Interface
```typescript
interface Lightsaber {
  id: string;              // Auto-generated UUID
  name: string;            // "Anakin's Lightsaber"
  color: string;           // "blue", "red", "green", "purple", etc.
  creator: string;         // "Anakin Skywalker"
  crystalType: string;     // "Kyber", "Synthetic", "Adegan"
  hiltMaterial: string;    // "Durasteel", "Phrik", "Cortosis"
  createdAt: Date;         // Timestamp
  isActive: boolean;       // Is lightsaber currently active/owned
}
```

## API Endpoints

### Base URL
```
http://localhost:3000/api
```

### Endpoints Overview

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/lightsabers` | Get all lightsabers |
| GET | `/api/lightsabers/:id` | Get single lightsaber |
| POST | `/api/lightsabers` | Create new lightsaber |
| PUT | `/api/lightsabers/:id` | Replace entire lightsaber |
| PATCH | `/api/lightsabers/:id` | Partial update lightsaber |
| DELETE | `/api/lightsabers/:id` | Delete lightsaber |

## Documentation Features

### Interactive Documentation at `/`
- Live API explorer with request/response examples
- Code samples for Swift/iOS URLSession
- Interactive forms to test endpoints
- Real-time response display
- HTTP status code explanations
- Styled with Star Wars theme

### Key Features
- **Try It Out:** Interactive request forms
- **Code Examples:** Swift URLSession snippets
- **Response Viewer:** Pretty-printed JSON
- **Error Handling:** Status code explanations
- **Mobile Friendly:** Responsive design for iPad/iPhone

## Project Structure

```
lightsaber-api/
├── src/
│   ├── controllers/
│   │   └── lightsaberController.ts
│   ├── models/
│   │   └── lightsaber.ts
│   ├── routes/
│   │   ├── api.ts
│   │   └── docs.ts
│   ├── middleware/
│   │   ├── validation.ts
│   │   └── errorHandler.ts
│   ├── config/
│   │   └── firebase.ts
│   ├── views/
│   │   └── documentation.html
│   ├── utils/
│   │   └── responses.ts
│   └── app.ts
├── public/
│   ├── styles.css
│   └── script.js
├── docs/
│   └── 2025-07-24-lightsaber-api-plan.md
├── package.json
├── tsconfig.json
├── .env.example
└── README.md
```

## Implementation Phases

### Phase 1: Setup & Configuration
- [ ] Project structure setup
- [ ] TypeScript configuration
- [ ] Express.js setup with static files
- [ ] Firebase Admin SDK integration
- [ ] Environment configuration

### Phase 2: Documentation Route
- [ ] HTML documentation page at `/`
- [ ] Interactive API explorer
- [ ] Swift code examples
- [ ] Responsive CSS styling

### Phase 3: Core API Development
- [ ] Lightsaber data model
- [ ] All API endpoints under `/api`
- [ ] Input validation
- [ ] Error handling

### Phase 4: Testing & Polish
- [ ] Sample data seeding
- [ ] Documentation testing
- [ ] API endpoint verification

## Success Criteria

1. ✅ Interactive documentation at `/`
2. ✅ All API endpoints under `/api`
3. ✅ Working examples in documentation
4. ✅ Mobile-friendly documentation
5. ✅ Swift code samples included
6. ✅ Real-time API testing capability

---

**Next Steps:** Begin implementation with project setup and documentation route.