import { Response } from 'express';

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
  error?: string;
}

export const sendSuccess = <T>(res: Response, data: T, message?: string, statusCode = 200) => {
  const response: ApiResponse<T> = {
    success: true,
    data,
    message
  };
  res.status(statusCode).json(response);
};

export const sendError = (res: Response, error: string, statusCode = 400) => {
  const response: ApiResponse = {
    success: false,
    error
  };
  res.status(statusCode).json(response);
};

export const sendNotFound = (res: Response, resource = 'Resource') => {
  sendError(res, `${resource} not found`, 404);
};

export const sendServerError = (res: Response, error: string = 'Internal server error') => {
  sendError(res, error, 500);
};