import horseService from '../services/horse.service.js';

export const createHorse = async (req, res) => {
  try {
    const horseId = await horseService.createHorse(req.body);
    res.status(201).json({ status: true, id: horseId });
  } catch (error) {
    res.status(500).json({ status: false, error: error.message });
  }
};

export const getAllHorses = async (req, res) => {
  try {
    const horses = await horseService.getAllHorses();
    res.status(200).json({ status: true, data: horses });
  } catch (error) {
    res.status(500).json({ status: false, error: error.message });
  }
};

export const getHorseById = async (req, res) => {
  try {
    const horse = await horseService.getHorseById(req.params.id);
    if (!horse) return res.status(404).json({ status: false, message: 'Horse not found' });
    res.status(200).json({ status: true, data: horse });
  } catch (error) {
    res.status(500).json({ status: false, error: error.message });
  }
};

export const updateHorse = async (req, res) => {
  try {
    await horseService.updateHorse(req.params.id, req.body);
    res.status(200).json({ status: true, message: 'Horse updated' });
  } catch (error) {
    res.status(500).json({ status: false, error: error.message });
  }
};

export const deleteHorse = async (req, res) => {
  try {
    await horseService.deleteHorse(req.params.id);
    res.status(200).json({ status: true, message: 'Horse deleted' });
  } catch (error) {
    res.status(500).json({ status: false, error: error.message });
  }
}; 