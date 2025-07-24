import { Router, Request, Response } from 'express';
import path from 'path';

const router = Router();

// GET / - Serve documentation page
router.get('/', (req: Request, res: Response) => {
  res.sendFile(path.join(__dirname, '../views/documentation.html'));
});

export default router;