import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import path from "path";
import dotenv from "dotenv";

import apiRoutes from "./routes/api";
import docsRoutes from "./routes/docs";
import { errorHandler, notFoundHandler } from "./middleware/errorHandler";
import { seedDatabase } from "./utils/seedData";

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(
  helmet({
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        scriptSrc: ["'self'"],
        imgSrc: ["'self'", "data:", "https:"],
        connectSrc: ["'self'"],
      },
    },
  })
);

// CORS configuration
app.use(
  cors({
    origin:
      process.env.NODE_ENV === "production"
        ? ["https://yourdomain.com"]
        : ["http://localhost:3000", "http://127.0.0.1:3000"],
    credentials: true,
  })
);

// Body parsing middleware
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true }));

// Logging middleware
app.use(morgan(process.env.NODE_ENV === "production" ? "combined" : "dev"));

// Serve static files (CSS, JS, images)
app.use("/static", express.static(path.join(__dirname, "public")));

// Routes
app.use("/", docsRoutes);
app.use("/api", apiRoutes);

// Error handling middleware
app.use(notFoundHandler);
app.use(errorHandler);

// Start server
if (require.main === module) {
  app.listen(PORT, async () => {
    console.log(`🚀 Lightsaber API Server running on port ${PORT}`);
    console.log(`📖 Documentation: http://localhost:${PORT}/`);
    console.log(`🔌 API Base URL: http://localhost:${PORT}/api`);

    // Seed database with sample data (only if Firebase is configured)
    if (process.env.FIREBASE_PROJECT_ID) {
      try {
        // await seedDatabase();
      } catch (error) {
        console.log(
          "⚠️  Database seeding skipped - Firebase not configured or accessible"
        );
      }
    } else {
      console.log("⚠️  Firebase not configured - sample data seeding skipped");
      console.log(
        "💡 Configure Firebase credentials in .env to enable database features"
      );
    }
  });
}

export default app;
