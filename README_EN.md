[中文](README.md) | [English](README_EN.md)

# Replace It - Habit Replacement Challenge

A Flutter application that helps users change bad habits by replacing them with positive good habits, fostering a healthy lifestyle.

## Core Features

### 1. "Replace It" Module
- Users can set bad habits they want to break
- Choose a positive replacement habit
- Set challenge duration (21 days, 30 days, 60 days, 90 days, or 100 days)

### 2. Check-in and Reward System
- Daily record of successfully replacing bad habits with good ones
- Progress tracking and visualization
- Check-in calendar to view history
- Motivational messages to enhance persistence

## Technical Features

- Uses Provider for state management
- Local data persistence storage (SharedPreferences)
- Modern UI design with Material Design
- Responsive layout, adapts to different screen sizes

## How to Use

1. Click the "+" button in the bottom right corner of the home page to create a new habit replacement challenge
2. Fill in the bad habit you want to change and the good habit to replace it
3. Select the challenge duration
4. Check in after completing the good habit each day
5. View progress and check-in records on the details page

## Development Environment

- Flutter SDK: ^3.7.2
- Dart: ^3.0.0
- Dependencies:
  - provider: ^6.1.1
  - shared_preferences: ^2.2.2
  - intl: ^0.19.0
  - flutter_slidable: ^3.0.1
