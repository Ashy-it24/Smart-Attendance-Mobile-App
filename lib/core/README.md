# Core Layer

This folder contains core utilities, constants, and helpers used across the entire application.

## Structure

### constants/
- **app_constants.dart** - App-wide constants (API keys, timeouts, limits)
- **color_constants.dart** - Color palette for the app
- **string_constants.dart** - String constants for texts and messages

### errors/
- **exceptions.dart** - Custom exception classes
- **failures.dart** - Failure classes for error handling

### network/
- **network_info.dart** - Network connectivity checker

### utils/
- **date_utils.dart** - Date formatting and manipulation helpers
- **location_utils.dart** - Location calculation helpers (Haversine formula)
- **face_utils.dart** - Face recognition utility functions

## Purpose

The core layer provides shared functionality that doesn't belong to any specific feature. It ensures code reusability and consistency across the app.
