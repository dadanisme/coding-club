export interface Lightsaber {
  id: string;
  name: string;
  color: string;
  creator: string;
  crystalType: string;
  hiltMaterial: string;
  createdAt: Date;
  isActive: boolean;
}

export interface CreateLightsaberRequest {
  name: string;
  color: string;
  creator: string;
  crystalType: string;
  hiltMaterial: string;
  isActive?: boolean;
}

export interface UpdateLightsaberRequest {
  name?: string;
  color?: string;
  creator?: string;
  crystalType?: string;
  hiltMaterial?: string;
  isActive?: boolean;
}

export const LIGHTSABER_COLORS = [
  'blue',
  'green',
  'red',
  'purple',
  'yellow',
  'orange',
  'white',
  'black',
  'silver'
] as const;

export const CRYSTAL_TYPES = [
  'Kyber',
  'Synthetic',
  'Adegan',
  'Ilum',
  'Hurrikaine',
  'Krayt Dragon Pearl',
  'Solari',
  'Mantle of the Force'
] as const;

export const HILT_MATERIALS = [
  'Durasteel',
  'Phrik',
  'Cortosis',
  'Beskar',
  'Electrum',
  'Chromium',
  'Bronzium',
  'Aurodium'
] as const;