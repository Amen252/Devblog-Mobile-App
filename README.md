# DevBlog - Flutter Group Project 🚀

A modern developer blogging mobile application built with Flutter and Node.js.

## 📝 Project Overview
DevBlog is a platform designed for developers to share their stories, insights, and technical knowledge. This project was built as part of the Flutter Group Project assessment, focusing on professional software architecture, state management, and backend integration.

---

## 🏛️ Architecture & Design Pattern (Assessment Requirement #3)

### **MVVM (Model-View-ViewModel)**
We chose the **MVVM** architecture combined with the **Provider** pattern for state management. This pattern ensures a clean separation of concerns:

-   **Models:** Define the data structure (Users and Posts).
-   **Views (Screens):** The UI layer that interacts with the user.
-   **ViewModels (Providers):** The logic layer that handles data fetching, business rules, and state updates.

### **Why we chose this?**
-   **Separation of Logic & UI:** Makes the code easier to test and maintain.
-   **Reusability:** Business logic in Providers can be reused across different UI components.
-   **Scalability:** Allows adding new features (like bookmarks or search) without breaking existing code.

---

## 📁 Project Structure

### **Flutter App (`/app`)**
-   `lib/models/`: Data classes for JSON parsing.
-   `lib/providers/`: State management logic (Auth & Posts).
-   `lib/screens/`: All application screens (Home, Profile, Post Editor).
-   `lib/services/`: API communication layer.
-   `lib/theme/`: Centralized design system (Colors & Fonts).
-   `lib/widgets/`: Reusable UI components.

### **Backend (`/backend`)**
-   Built with **Node.js** and **Express**.
-   **MongoDB Atlas** for cloud database storage.
-   **JWT (jose)** for secure authentication.

---

## 🎨 Color System & Branding (Requirement #5 & #8)
-   **Primary Color:** Indigo (`#6366F1`) - Represents technology and creativity.
-   **Neutral Colors:** White and Slate Gray for a clean, professional "Tech Feed" look.
-   **Logo:** Custom terminal-themed logo designed for the developer community.

---

## 🇸🇴 Code Documentation (Requirement #6)
All critical logic in this project is documented in **Somali**. This includes:
-   `providers/post_provider.dart`: Faahfaahinta sida loo maamulo qoraallada.
-   `providers/auth_provider.dart`: Sharaxaadda hannaanka gelitaanka (Login/Register).
-   `services/api_service.dart`: Sida app-ku ula xiriiro server-ka.

---

## 🛠️ How to Run
1.  **Backend:** `cd backend && npm install && npm start`
2.  **App:** `cd app && flutter run`

---

## 👥 Group Contribution
This project was built with a focus on teamwork and understanding the full software development lifecycle—from backend deployment to frontend polish.
