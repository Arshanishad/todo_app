# GitHub Profile Explorer

A Flutter application that allows users to search and explore GitHub profiles and their repositories using the GitHub REST API.

## Features

### 🔎 GitHub Profile Search

- Search GitHub users by username
- Fetch profile information from the GitHub API
- Display:
  - Profile avatar
  - Name
  - Username
  - Bio
  - Followers
  - Following
  - Public repositories
- Search using the keyboard or search button

### 📦 Repository Explorer

- View repositories of a selected GitHub user
- Display:
  - Repository name
  - Description
  - Stars
  - Programming language
  - Last updated date
- Sort repositories by:
  - ⭐ Most stars
  - 🕒 Recently updated

### 🕘 Recent Searches

- Stores the last 5 searched usernames locally
- Prevents duplicate usernames
- Tap a previous search to search again instantly

### ⚠️ Error Handling

Handles different application states:

- Loading
- Successful data
- User not found
- Network errors
- Empty search validation
- Empty repository list

## Tech Stack

- **Flutter**
- **Dart**
- **Riverpod** – State management
- **Dio** – HTTP/API requests
- **SharedPreferences** – Local storage
- **GitHub REST API**

## Architecture

The project follows a simple layered structure to keep the code organized and maintainable.

```text
lib/
│
├── main.dart
│
├── models/
│   ├── user_model.dart
│   └── repository_model.dart
│
├── services/
│   └── profile_service.dart
│
├── providers/
│   ├── user_provider.dart
│   └── repository_provider.dart
│
└── screens/
    ├── search_screen.dart
    ├── repositories_screen.dart
    └── recent_searches.dart
