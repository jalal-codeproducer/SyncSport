# SyncSport - SwiftUI Fitness Game

FitRun is a mobile fitness application built with SwiftUI that turns your running and walking activities into a game. Earn points by completing challenges and tracking your movements.

## Features

### 🚀 Onboarding
Personalized onboarding experience to help users get started with the app.

### 🔐 Authentication
Secure user authentication powered by Firebase Authentication.

### 📊 Dashboard
Main interface displaying user stats, active challenges, and achievements.

### 🏆 Challenges
Compete in various fitness challenges to earn points and rewards.

### 📍 Tracking
Advanced location tracking system for accurate distance and path recording.

### 👤 Profile
User profile management and activity history.

## Technical Architecture

### MVVM Architecture
The application follows the Model-View-ViewModel (MVVM) architecture pattern for clean separation of concerns and improved testability.

### Dependency Injection
A singleton dependency injection container manages the creation and lifecycle of view models:

- AuthViewModel
- DashboardViewModel
- ChallengeViewModel
- TrackingViewModel

### Repositories
Data access is abstracted through repository interfaces:

- SportUserRepository
- AuthRepository
- ChallengeRepository

### Location Tracking
Core Location based tracking system to record and calculate:
- Total distance moved
- Current path visualization
- Background location updates

### Database
Firebase Firestore is used for storing user data, challenges, and tracking information.

## Requirements

- iOS 18.0+
- Xcode 13.0+
- Swift 5.5+
- Active Firebase project with Authentication and Firestore



## Privacy Permissions

The app requires the following permissions:
- Location access (when in use and background)


## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [Firebase](https://firebase.google.com/)
- [CoreLocation](https://developer.apple.com/documentation/corelocation)
