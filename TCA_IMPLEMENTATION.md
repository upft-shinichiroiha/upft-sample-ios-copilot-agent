# TCA Implementation Guide

This document explains the changes made to separate WebAPI processing and implement TCA (The Composable Architecture).

## Changes Made

### 1. File Structure
- **Model/ZipResponse.swift**: Contains `PostalCodeResponse` and `PostalCodeResult` structs
- **Repository/ZipApi.swift**: Contains the `searchAddress` function using `withCheckedContinuation`
- **Features/ZipSearchFeature.swift**: Contains TCA Reducer with State and Action
- **ContentView.swift**: Updated to use TCA patterns (when TCA is configured)
- **ContentViewSeparated.swift**: Working version without TCA dependency

### 2. WebAPI Separation
- Moved API models from ContentView to dedicated Model file
- Moved URLSession logic to Repository layer
- Changed `searchAddress` to return String instead of setting UI state directly
- Used `withCheckedContinuation` for better async handling

### 3. TCA Integration
- Created `@Reducer struct ZipSearchFeature`
- Added `@ObservableState struct State` with `isLoading` and `resultText`
- Added `enum Action` with `zipCode(String)` case
- Updated ContentView to use `WithViewStore` and `viewStore.send(.zipCode(postalCode))`

## To Complete TCA Setup in Xcode:

### 1. Add Package Dependencies
In Xcode project settings, add these Swift Package Manager dependencies:
- **swift-composable-architecture**: `https://github.com/pointfreeco/swift-composable-architecture` version 1.17.1
- **swift-syntax**: Automatically included with TCA

### 2. Enable TCA Features
1. Uncomment the TCA imports and implementations in:
   - `Features/ZipSearchFeature.swift`
   - `ContentView.swift`
2. Comment out the fallback implementations

### 3. Update App.swift (if needed)
```swift
import SwiftUI
import ComposableArchitecture

@main
struct ZipSearchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: ZipSearchFeature.State()) {
                    ZipSearchFeature()
                }
            )
        }
    }
}
```

## Current Working Version
The current implementation in `ContentView.swift` and `ContentViewSeparated.swift` works without TCA and demonstrates:
- Separation of concerns between UI and API
- Async/await pattern for WebAPI calls
- Modular file structure

## File Dependencies
```
ContentView.swift
├── Features/ZipSearchFeature.swift (when TCA enabled)
├── Repository/ZipApi.swift
└── Model/ZipResponse.swift
```

## Benefits Achieved
1. **Separation of Concerns**: UI, API models, and network logic are in separate files
2. **Better Async Handling**: Using `withCheckedContinuation` for readable async code
3. **Modular Architecture**: Ready for TCA when dependencies are configured
4. **Testability**: Repository and models can be easily unit tested