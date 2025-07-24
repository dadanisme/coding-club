import { body, param, query, validationResult } from 'express-validator';
import { Request, Response, NextFunction } from 'express';
import { 
  LIGHTSABER_COLORS, 
  CRYSTAL_TYPES, 
  HILT_MATERIALS 
} from '../models/lightsaber';
import { sendError } from '../utils/responses';

export const handleValidationErrors = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const errorMessages = errors.array().map(error => error.msg);
    return sendError(res, `Validation failed: ${errorMessages.join(', ')}`, 400);
  }
  next();
};

export const validateCreateLightsaber = [
  body('name')
    .notEmpty()
    .withMessage('Name is required')
    .isLength({ min: 1, max: 100 })
    .withMessage('Name must be between 1 and 100 characters'),
  
  body('color')
    .notEmpty()
    .withMessage('Color is required')
    .isIn(LIGHTSABER_COLORS)
    .withMessage(`Color must be one of: ${LIGHTSABER_COLORS.join(', ')}`),
  
  body('creator')
    .notEmpty()
    .withMessage('Creator is required')
    .isLength({ min: 1, max: 100 })
    .withMessage('Creator must be between 1 and 100 characters'),
  
  body('crystalType')
    .notEmpty()
    .withMessage('Crystal type is required')
    .isIn(CRYSTAL_TYPES)
    .withMessage(`Crystal type must be one of: ${CRYSTAL_TYPES.join(', ')}`),
  
  body('hiltMaterial')
    .notEmpty()
    .withMessage('Hilt material is required')
    .isIn(HILT_MATERIALS)
    .withMessage(`Hilt material must be one of: ${HILT_MATERIALS.join(', ')}`),
  
  body('isActive')
    .optional()
    .isBoolean()
    .withMessage('isActive must be a boolean'),
  
  handleValidationErrors
];

export const validateUpdateLightsaber = [
  body('name')
    .optional()
    .isLength({ min: 1, max: 100 })
    .withMessage('Name must be between 1 and 100 characters'),
  
  body('color')
    .optional()
    .isIn(LIGHTSABER_COLORS)
    .withMessage(`Color must be one of: ${LIGHTSABER_COLORS.join(', ')}`),
  
  body('creator')
    .optional()
    .isLength({ min: 1, max: 100 })
    .withMessage('Creator must be between 1 and 100 characters'),
  
  body('crystalType')
    .optional()
    .isIn(CRYSTAL_TYPES)
    .withMessage(`Crystal type must be one of: ${CRYSTAL_TYPES.join(', ')}`),
  
  body('hiltMaterial')
    .optional()
    .isIn(HILT_MATERIALS)
    .withMessage(`Hilt material must be one of: ${HILT_MATERIALS.join(', ')}`),
  
  body('isActive')
    .optional()
    .isBoolean()
    .withMessage('isActive must be a boolean'),
  
  handleValidationErrors
];

export const validateLightsaberId = [
  param('id')
    .notEmpty()
    .withMessage('Lightsaber ID is required')
    .isUUID()
    .withMessage('Invalid lightsaber ID format'),
  
  handleValidationErrors
];

export const validateQueryParams = [
  query('color')
    .optional()
    .isIn(LIGHTSABER_COLORS)
    .withMessage(`Color must be one of: ${LIGHTSABER_COLORS.join(', ')}`),
  
  query('creator')
    .optional()
    .isLength({ min: 1, max: 100 })
    .withMessage('Creator must be between 1 and 100 characters'),
  
  query('active')
    .optional()
    .isIn(['true', 'false'])
    .withMessage('Active must be "true" or "false"'),
  
  handleValidationErrors
];