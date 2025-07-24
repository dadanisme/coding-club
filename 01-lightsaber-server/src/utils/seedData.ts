import { db } from '../config/firebase';
import { v4 as uuidv4 } from 'uuid';

const COLLECTION_NAME = 'lightsabers';

const sampleLightsabers = [
  {
    id: uuidv4(),
    name: "Luke's First Lightsaber",
    color: "blue",
    creator: "Anakin Skywalker",
    crystalType: "Kyber",
    hiltMaterial: "Durasteel",
    createdAt: new Date('2023-01-15T10:00:00Z'),
    isActive: false
  },
  {
    id: uuidv4(),
    name: "Luke's Second Lightsaber",
    color: "green",
    creator: "Luke Skywalker",
    crystalType: "Kyber",
    hiltMaterial: "Durasteel",
    createdAt: new Date('2023-02-20T14:30:00Z'),
    isActive: true
  },
  {
    id: uuidv4(),
    name: "Darth Vader's Lightsaber",
    color: "red",
    creator: "Anakin Skywalker",
    crystalType: "Synthetic",
    hiltMaterial: "Durasteel",
    createdAt: new Date('2023-01-10T09:00:00Z'),
    isActive: true
  },
  {
    id: uuidv4(),
    name: "Mace Windu's Lightsaber",
    color: "purple",
    creator: "Mace Windu",
    crystalType: "Kyber",
    hiltMaterial: "Electrum",
    createdAt: new Date('2023-03-05T16:45:00Z'),
    isActive: true
  },
  {
    id: uuidv4(),
    name: "Yoda's Lightsaber",
    color: "green",
    creator: "Yoda",
    crystalType: "Kyber",
    hiltMaterial: "Durasteel",
    createdAt: new Date('2023-01-01T08:00:00Z'),
    isActive: false
  },
  {
    id: uuidv4(),
    name: "Obi-Wan's First Lightsaber",
    color: "blue",
    creator: "Obi-Wan Kenobi",
    crystalType: "Kyber",
    hiltMaterial: "Durasteel",
    createdAt: new Date('2023-02-10T11:20:00Z'),
    isActive: false
  },
  {
    id: uuidv4(),
    name: "Obi-Wan's Second Lightsaber",
    color: "blue",
    creator: "Obi-Wan Kenobi",
    crystalType: "Kyber",
    hiltMaterial: "Durasteel",
    createdAt: new Date('2023-02-15T13:15:00Z'),
    isActive: true
  },
  {
    id: uuidv4(),
    name: "Qui-Gon's Lightsaber",
    color: "green",
    creator: "Qui-Gon Jinn",
    crystalType: "Kyber",
    hiltMaterial: "Durasteel",
    createdAt: new Date('2023-01-25T15:30:00Z'),
    isActive: false
  },
  {
    id: uuidv4(),
    name: "Darth Maul's Lightsaber",
    color: "red",
    creator: "Darth Maul",
    crystalType: "Synthetic",
    hiltMaterial: "Phrik",
    createdAt: new Date('2023-03-01T12:00:00Z'),
    isActive: true
  },
  {
    id: uuidv4(),
    name: "Count Dooku's Lightsaber",
    color: "red",
    creator: "Count Dooku",
    crystalType: "Synthetic",
    hiltMaterial: "Durasteel",
    createdAt: new Date('2023-02-28T17:20:00Z'),
    isActive: false
  },
  {
    id: uuidv4(),
    name: "Ahsoka's White Lightsaber",
    color: "white",
    creator: "Ahsoka Tano",
    crystalType: "Kyber",
    hiltMaterial: "Durasteel",
    createdAt: new Date('2023-03-10T09:45:00Z'),
    isActive: true
  },
  {
    id: uuidv4(),
    name: "Rey's Yellow Lightsaber",
    color: "yellow",
    creator: "Rey Skywalker",
    crystalType: "Kyber",
    hiltMaterial: "Durasteel",
    createdAt: new Date('2023-03-15T14:10:00Z'),
    isActive: true
  }
];

export const seedDatabase = async () => {
  try {
    console.log('🌱 Starting database seeding...');
    
    // Check if data already exists
    const existingData = await db.collection(COLLECTION_NAME).limit(1).get();
    if (!existingData.empty) {
      console.log('📋 Database already contains data. Skipping seeding.');
      return;
    }
    
    // Add sample data
    const batch = db.batch();
    
    sampleLightsabers.forEach((lightsaber) => {
      const docRef = db.collection(COLLECTION_NAME).doc(lightsaber.id);
      batch.set(docRef, lightsaber);
    });
    
    await batch.commit();
    
    console.log(`✅ Successfully seeded ${sampleLightsabers.length} lightsabers to the database!`);
    console.log('🔍 Sample lightsabers include:');
    sampleLightsabers.forEach(ls => {
      console.log(`   - ${ls.name} (${ls.color}, ${ls.creator})`);
    });
    
  } catch (error) {
    console.error('❌ Error seeding database:', error);
    throw error;
  }
};

export const clearDatabase = async () => {
  try {
    console.log('🧹 Clearing database...');
    
    const snapshot = await db.collection(COLLECTION_NAME).get();
    const batch = db.batch();
    
    snapshot.docs.forEach((doc) => {
      batch.delete(doc.ref);
    });
    
    await batch.commit();
    console.log(`✅ Cleared ${snapshot.docs.length} lightsabers from database`);
    
  } catch (error) {
    console.error('❌ Error clearing database:', error);
    throw error;
  }
};