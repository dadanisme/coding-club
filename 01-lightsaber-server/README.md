# ⚔️ Lightsaber Collection API

An educational REST API built with Express.js, TypeScript, and Firebase for teaching HTTP methods to Swift/iOS students through a fun Star Wars lightsaber collection theme.

## 🎯 Purpose

This API serves as a practical learning tool for students developing iOS apps. It provides all major HTTP methods (GET, POST, PUT, PATCH, DELETE) with comprehensive documentation and interactive testing capabilities.

## ✨ Features

- **📖 Interactive Documentation** - Web-based API explorer at `/`
- **🔍 Complete CRUD Operations** - All HTTP methods demonstrated  
- **🛡️ Input Validation** - Comprehensive request validation
- **🎨 Swift Examples** - Ready-to-use URLSession code snippets
- **🌟 Sample Data** - Pre-seeded lightsaber collection for testing
- **📱 Mobile-Friendly** - Responsive documentation design

## 🚀 Quick Start

### Prerequisites
- Node.js (v18+)
- Firebase project with Firestore enabled
- npm or yarn

### Installation

1. **Clone and setup**
   ```bash
   cd lightsaber-server
   npm install
   ```

2. **Configure Firebase**
   ```bash
   cp .env.example .env
   # Edit .env with your Firebase credentials
   ```

3. **Start development server**
   ```bash
   npm run dev
   ```

4. **Visit the documentation**
   Open http://localhost:3000 in your browser

## 🔧 Configuration

### Environment Variables

Create a `.env` file with your Firebase credentials:

```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nyour-private-key-here\n-----END PRIVATE KEY-----"
FIREBASE_CLIENT_EMAIL=your-service-account@your-project-id.iam.gserviceaccount.com
PORT=3000
NODE_ENV=development
```

### Firebase Setup

1. Create a Firebase project at https://console.firebase.google.com
2. Enable Firestore Database
3. Generate a service account key:
   - Go to Project Settings → Service Accounts
   - Click "Generate new private key"
   - Save the JSON file and extract the required fields for `.env`

## 📡 API Endpoints

### Base URL: `http://localhost:3000/api`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/lightsabers` | Get all lightsabers (with optional filtering) |
| GET | `/lightsabers/:id` | Get single lightsaber by ID |
| POST | `/lightsabers` | Create new lightsaber |
| PUT | `/lightsabers/:id` | Replace entire lightsaber |
| PATCH | `/lightsabers/:id` | Partial update lightsaber |
| DELETE | `/lightsabers/:id` | Delete lightsaber |

### Query Parameters (GET /lightsabers)
- `color` - Filter by color (blue, green, red, purple, yellow, orange, white, black, silver)
- `creator` - Filter by creator name
- `active` - Filter by active status (true/false)

### Example Requests

**Get all blue lightsabers:**
```
GET /api/lightsabers?color=blue
```

**Create a new lightsaber:**
```json
POST /api/lightsabers
{
  "name": "Mace Windu's Lightsaber",
  "color": "purple",
  "creator": "Mace Windu",
  "crystalType": "Kyber",
  "hiltMaterial": "Electrum",
  "isActive": true
}
```

## 🏗️ Data Model

```typescript
interface Lightsaber {
  id: string;              // Auto-generated UUID
  name: string;            // "Luke's Lightsaber"
  color: string;           // "blue", "green", "red", etc.
  creator: string;         // "Luke Skywalker"
  crystalType: string;     // "Kyber", "Synthetic", etc.
  hiltMaterial: string;    // "Durasteel", "Phrik", etc.
  createdAt: Date;         // Timestamp
  isActive: boolean;       // Currently active/owned
}
```

### Valid Values

**Colors:** blue, green, red, purple, yellow, orange, white, black, silver

**Crystal Types:** Kyber, Synthetic, Adegan, Ilum, Hurrikaine, Krayt Dragon Pearl, Solari, Mantle of the Force

**Hilt Materials:** Durasteel, Phrik, Cortosis, Beskar, Electrum, Chromium, Bronzium, Aurodium

## 🍎 Swift Integration

### Basic Setup

```swift
import Foundation

class LightsaberAPI {
    private let baseURL = "http://localhost:3000/api"
    private let session = URLSession.shared
    
    func getAllLightsabers() async throws -> [Lightsaber] {
        let url = URL(string: "\\(baseURL)/lightsabers")!
        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(APIResponse<[Lightsaber]>.self, from: data)
        return response.data ?? []
    }
}
```

### Data Models

```swift
struct Lightsaber: Codable, Identifiable {
    let id: String
    let name: String
    let color: String
    let creator: String
    let crystalType: String
    let hiltMaterial: String
    let createdAt: Date
    let isActive: Bool
}

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
    let error: String?
}
```

## 🛠️ Development

### Scripts

```bash
npm run dev      # Start development server with hot reload
npm run build    # Build TypeScript to JavaScript
npm run start    # Start production server
npm run clean    # Clean build directory
```

### Project Structure

```
lightsaber-server/
├── src/
│   ├── controllers/     # Request handlers
│   ├── models/          # TypeScript interfaces
│   ├── routes/          # API routes
│   ├── middleware/      # Validation & error handling
│   ├── config/          # Firebase configuration
│   ├── views/           # HTML documentation
│   ├── utils/           # Utilities & sample data
│   └── app.ts           # Main application
├── public/              # Static assets (CSS, JS)
├── docs/               # Project documentation
└── dist/               # Built JavaScript (generated)
```

## 🎓 Educational Use

### For Students Learning iOS Development

This API provides hands-on experience with:

1. **HTTP Methods** - Understanding REST conventions
2. **JSON Parsing** - Working with Codable protocols
3. **Error Handling** - Managing network failures
4. **Async/Await** - Modern Swift concurrency
5. **URL Construction** - Query parameters and endpoints

### Learning Progression

1. **Start with GET** - Fetch and display data
2. **Add POST** - Create new resources
3. **Implement PUT/PATCH** - Update existing data
4. **Handle DELETE** - Remove resources
5. **Add Filtering** - Query parameters and search

## 🔒 Security Notes

- CORS enabled for local development
- Input validation on all endpoints  
- Helmet security headers applied
- No authentication required (educational use)

## 🐛 Troubleshooting

### Common Issues

**Firebase Connection Error:**
- Verify `.env` credentials are correct
- Ensure Firestore is enabled in Firebase console
- Check service account permissions

**CORS Issues:**
- Ensure your client URL is in the CORS whitelist
- Check for typos in localhost URLs

**Validation Errors:**
- Review the interactive documentation for valid field values
- Check that all required fields are provided

## 📄 License

MIT License - Feel free to use for educational purposes.

## 🤝 Contributing

This is an educational project. Suggestions and improvements welcome!

---

**Happy coding! May the Force be with you.** ⚔️✨