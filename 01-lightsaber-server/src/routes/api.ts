import { Router } from 'express';
import {
  getAllLightsabers,
  getLightsaberById,
  createLightsaber,
  updateLightsaber,
  replaceLightsaber,
  deleteLightsaber
} from '../controllers/lightsaberController';
import {
  validateCreateLightsaber,
  validateUpdateLightsaber,
  validateLightsaberId,
  validateQueryParams
} from '../middleware/validation';

const router = Router();

// GET /api/lightsabers - Get all lightsabers with optional filtering
router.get('/lightsabers', validateQueryParams, getAllLightsabers);

// GET /api/lightsabers/:id - Get single lightsaber by ID
router.get('/lightsabers/:id', validateLightsaberId, getLightsaberById);

// POST /api/lightsabers - Create new lightsaber
router.post('/lightsabers', validateCreateLightsaber, createLightsaber);

// PUT /api/lightsabers/:id - Replace entire lightsaber
router.put('/lightsabers/:id', validateLightsaberId, validateCreateLightsaber, replaceLightsaber);

// PATCH /api/lightsabers/:id - Partial update lightsaber
router.patch('/lightsabers/:id', validateLightsaberId, validateUpdateLightsaber, updateLightsaber);

// DELETE /api/lightsabers/:id - Delete lightsaber
router.delete('/lightsabers/:id', validateLightsaberId, deleteLightsaber);

export default router;