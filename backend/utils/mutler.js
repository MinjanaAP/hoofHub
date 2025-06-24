import multer, { memoryStorage } from 'multer';

const storage = memoryStorage();

const upload = multer({
  storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // max 5MB per file
    files: 6, 
  },
});

export default upload;
