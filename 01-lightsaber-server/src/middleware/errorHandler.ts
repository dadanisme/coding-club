import { Request, Response, NextFunction } from 'express';
import { sendServerError } from '../utils/responses';

export const errorHandler = (
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  console.error('Unhandled error:', error);
  
  if (res.headersSent) {
    return next(error);
  }

  sendServerError(res, 'An unexpected error occurred');
};

export const notFoundHandler = (req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    error: `Route ${req.method} ${req.path} not found`
  });
};