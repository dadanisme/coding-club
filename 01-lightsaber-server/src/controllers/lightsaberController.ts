import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { db } from '../config/firebase';
import { 
  Lightsaber, 
  CreateLightsaberRequest, 
  UpdateLightsaberRequest 
} from '../models/lightsaber';
import { 
  sendSuccess, 
  sendError, 
  sendNotFound, 
  sendServerError 
} from '../utils/responses';

const COLLECTION_NAME = 'lightsabers';

export const getAllLightsabers = async (req: Request, res: Response) => {
  try {
    const { color, creator, active } = req.query;
    let query: FirebaseFirestore.Query<FirebaseFirestore.DocumentData> = db.collection(COLLECTION_NAME);

    if (color && typeof color === 'string') {
      query = query.where('color', '==', color);
    }
    if (creator && typeof creator === 'string') {
      query = query.where('creator', '==', creator);
    }
    if (active !== undefined) {
      const isActive = active === 'true';
      query = query.where('isActive', '==', isActive);
    }

    const snapshot = await query.get();
    const lightsabers: Lightsaber[] = [];

    snapshot.forEach(doc => {
      const data = doc.data();
      lightsabers.push({
        id: doc.id,
        name: data.name,
        color: data.color,
        creator: data.creator,
        crystalType: data.crystalType,
        hiltMaterial: data.hiltMaterial,
        createdAt: data.createdAt.toDate(),
        isActive: data.isActive
      });
    });

    sendSuccess(res, lightsabers, `Found ${lightsabers.length} lightsabers`);
  } catch (error) {
    console.error('Error getting lightsabers:', error);
    sendServerError(res, 'Failed to retrieve lightsabers');
  }
};

export const getLightsaberById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const doc = await db.collection(COLLECTION_NAME).doc(id).get();

    if (!doc.exists) {
      return sendNotFound(res, 'Lightsaber');
    }

    const data = doc.data()!;
    const lightsaber: Lightsaber = {
      id: doc.id,
      name: data.name,
      color: data.color,
      creator: data.creator,
      crystalType: data.crystalType,
      hiltMaterial: data.hiltMaterial,
      createdAt: data.createdAt.toDate(),
      isActive: data.isActive
    };

    sendSuccess(res, lightsaber);
  } catch (error) {
    console.error('Error getting lightsaber:', error);
    sendServerError(res, 'Failed to retrieve lightsaber');
  }
};

export const createLightsaber = async (req: Request, res: Response) => {
  try {
    const lightsaberData: CreateLightsaberRequest = req.body;
    const id = uuidv4();

    const newLightsaber = {
      name: lightsaberData.name,
      color: lightsaberData.color,
      creator: lightsaberData.creator,
      crystalType: lightsaberData.crystalType,
      hiltMaterial: lightsaberData.hiltMaterial,
      createdAt: new Date(),
      isActive: lightsaberData.isActive ?? true
    };

    await db.collection(COLLECTION_NAME).doc(id).set(newLightsaber);

    const createdLightsaber: Lightsaber = {
      id,
      ...newLightsaber
    };

    sendSuccess(res, createdLightsaber, 'Lightsaber created successfully', 201);
  } catch (error) {
    console.error('Error creating lightsaber:', error);
    sendServerError(res, 'Failed to create lightsaber');
  }
};

export const updateLightsaber = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const updateData: UpdateLightsaberRequest = req.body;

    const doc = await db.collection(COLLECTION_NAME).doc(id).get();
    if (!doc.exists) {
      return sendNotFound(res, 'Lightsaber');
    }

    const updatedData = {
      name: updateData.name,
      color: updateData.color,
      creator: updateData.creator,
      crystalType: updateData.crystalType,
      hiltMaterial: updateData.hiltMaterial,
      isActive: updateData.isActive
    };

    Object.keys(updatedData).forEach(key => {
      if (updatedData[key as keyof typeof updatedData] === undefined) {
        delete updatedData[key as keyof typeof updatedData];
      }
    });

    await db.collection(COLLECTION_NAME).doc(id).update(updatedData);

    const updatedDoc = await db.collection(COLLECTION_NAME).doc(id).get();
    const data = updatedDoc.data()!;
    
    const lightsaber: Lightsaber = {
      id: updatedDoc.id,
      name: data.name,
      color: data.color,
      creator: data.creator,
      crystalType: data.crystalType,
      hiltMaterial: data.hiltMaterial,
      createdAt: data.createdAt.toDate(),
      isActive: data.isActive
    };

    sendSuccess(res, lightsaber, 'Lightsaber updated successfully');
  } catch (error) {
    console.error('Error updating lightsaber:', error);
    sendServerError(res, 'Failed to update lightsaber');
  }
};

export const replaceLightsaber = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const lightsaberData: CreateLightsaberRequest = req.body;

    const doc = await db.collection(COLLECTION_NAME).doc(id).get();
    if (!doc.exists) {
      return sendNotFound(res, 'Lightsaber');
    }

    const originalData = doc.data()!;
    const replacementData = {
      name: lightsaberData.name,
      color: lightsaberData.color,
      creator: lightsaberData.creator,
      crystalType: lightsaberData.crystalType,
      hiltMaterial: lightsaberData.hiltMaterial,
      createdAt: originalData.createdAt,
      isActive: lightsaberData.isActive ?? true
    };

    await db.collection(COLLECTION_NAME).doc(id).set(replacementData);

    const lightsaber: Lightsaber = {
      id,
      ...replacementData,
      createdAt: originalData.createdAt.toDate()
    };

    sendSuccess(res, lightsaber, 'Lightsaber replaced successfully');
  } catch (error) {
    console.error('Error replacing lightsaber:', error);
    sendServerError(res, 'Failed to replace lightsaber');
  }
};

export const deleteLightsaber = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const doc = await db.collection(COLLECTION_NAME).doc(id).get();
    if (!doc.exists) {
      return sendNotFound(res, 'Lightsaber');
    }

    await db.collection(COLLECTION_NAME).doc(id).delete();
    res.status(204).send();
  } catch (error) {
    console.error('Error deleting lightsaber:', error);
    sendServerError(res, 'Failed to delete lightsaber');
  }
};