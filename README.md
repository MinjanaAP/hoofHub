
# **HoofHub – Horse Riding Management System**

Welcome to the **HoofHub** project repository! This system aims to enhance the efficiency and transparency of horse riding tourism in Sri Lanka. It combines a **Flutter-based frontend** and a **Node.js backend** to create a seamless experience for users and administrators.

---

## **Table of Contents**
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Technologies Used](#technologies-used)
4. [Folder Structure](#folder-structure)
5. [Setup Instructions](#setup-instructions)
6. [Usage](#usage)
7. [Contributing](#contributing)
8. [License](#license)

---

## **Project Overview**
**HoofHub** is designed to:
- Provide an efficient booking system for horse riding.
- Offer verified and transparent information about horses and guides.
- Enable collaboration between horse owners and the Royal Turf Club.
- Enhance user safety and satisfaction through rigorous checks and training programs.

---

## **Features**
### **Frontend**
- Built with Flutter for a smooth and interactive user experience.
- Allows users to book horse rides and select guides.
- Displays real-time data fetched from the backend.

### **Backend**
- Developed with Node.js and Express.js.
- Provides RESTful API endpoints for user authentication, booking, and data management.
- Ensures security and scalability.

---

## **Technologies Used**
- **Frontend:** Flutter (Dart)
- **Backend:** Node.js, Express.js
- **Database:** MongoDB (or Firebase if used)
- **API Communication:** RESTful APIs
- **Version Control:** Git & GitHub

---

## **Folder Structure**
```plaintext
hoofhub/
├── backend/        # Node.js backend code
│   ├── models/     # Database models
│   ├── routes/     # API routes
│   ├── controllers/ # API controllers
│   ├── app.js      # Main server file
│   ├── package.json # Backend dependencies
│   └── README.md   # Backend-specific instructions
├── frontend/       # Flutter frontend code
│   ├── lib/        # Flutter app files
│   ├── pubspec.yaml # Flutter dependencies
│   └── README.md   # Frontend-specific instructions
├── README.md       # General project overview (this file)
```

---

## **Setup Instructions**

### **1. Prerequisites**
- **Node.js** and **npm** installed for the backend.
- **Flutter SDK** installed for the frontend.
- **Git** installed for version control.
- MongoDB database setup (or Firebase if using it).

### **2. Clone the Repository**
```bash
git clone https://github.com/your-username/hoofhub.git
cd hoofhub
```

---

### **3. Backend Setup**
1. Navigate to the `backend` folder:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Configure the `.env` file with your environment variables:
   ```plaintext
   MONGO_URI=your_mongo_db_connection_string
   JWT_SECRET=your_secret_key
   PORT=5000
   ```
4. Start the server:
   ```bash
   npm start
   ```
5. The backend will run on `http://localhost:5000`.

---

### **4. Frontend Setup**
1. Navigate to the `frontend` folder:
   ```bash
   cd ../frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Connect to the backend by updating the API base URL in the appropriate Dart file (e.g., `lib/constants.dart`):
   ```dart
   const String apiUrl = "http://localhost:5000";
   ```
4. Run the Flutter app:
   ```bash
   flutter run
   ```
5. The app will launch in your chosen emulator or physical device.

---

## **Usage**
1. Start the backend server:
   ```bash
   cd backend
   npm start
   ```
2. Launch the frontend app:
   ```bash
   cd frontend
   flutter run
   ```

---

## **Contributing**
We welcome contributions! Follow these steps to contribute:
1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add feature-name"
   ```
4. Push to your branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.

---

## **License**
This project is licensed under the [MIT License](LICENSE).

---
