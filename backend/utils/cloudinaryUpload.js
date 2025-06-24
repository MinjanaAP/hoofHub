import cloudinary  from './cloudinary.js';
import { createReadStream } from 'streamifier';

const uploadToCloudinary = (buffer, folder) => {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { folder },
      (error, result) => {
        if (result) resolve(result.secure_url);
        else reject(error);
      }
    );
    createReadStream(buffer).pipe(stream);
  });
};

export default uploadToCloudinary;
