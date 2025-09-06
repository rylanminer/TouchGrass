# Touch Grass - C323 Final Project

**Course:** C323/Spring 2025
**Due Date:** Mon May 05 - 4 PM
**Team:** Azure Team 25
**Authors:**
- Rylan Miner - ryminer - ryminer@iu.edu
- Maya Iyer - mayaiyer - mayaiyer@iu.edu

---

## Development Environment & Requirements

- **Xcode Version:** This project was completed using Xcode Version 16.2 (16C5032a).
- **Hardware:** The app requires a physical iPhone to run.
- **iOS Version:** Development was done on an iPhone 15 running iOS Version 18.5.

---

## App Interactions

### Play View
The main functionality of the app is accessed through the **Play** tab.
- Opening this tab activates the device's camera to detect a flat surface suitable for the game grid.
- Clicking the **Start Game** button places the grid on the detected surface and begins the countdown timer.
- The objective is to physically run to one of the green checkpoints to score a point.
- When a checkpoint is reached, the timer resets, and a new checkpoint is generated. The game ends when the timer runs out.
- Detailed instructions can be found by clicking the "?" icon in the bottom right corner of the screen.

### Settings View
To customize the game and prevent it from becoming repetitive, users can adjust the grid size in the **Settings** tab.
- Users can choose between a 3x3, 4x4, or 5x5 grid size.
- The selected setting will be applied on the next game run.

### History View
The **History** tab implements persistent storage to track all previous game runs.
- Each entry includes the score and the location of the run.
- The history is organized into subcategories by day for easy viewing.

---

## Student Responsibilities

During the development process, Maya and Rylan met several times a week to work on the code together. Most of the code was produced cohesively through this collaborative effort. While there were minor occasions where one person would debug features independently, this did not account for a significant amount of the code. As a result, the codebase cannot be divided into sections developed by a single individual.

---

## Technical Features and Design

### Frameworks
Our app utilizes a variety of frameworks to implement its features.

**Frameworks Shown in Class**
- `CoreLocation`
- `AVFoundation`

**Frameworks Not Shown in Class**
- `ARKit`
- `RealityKit`

### MVVM Design
The app is designed in SwiftUI and utilizes the MVVM (Model-View-ViewModel) design pattern. This structure allowed us to delegate tasks, functions, and interactions into a cohesive and understandable architecture.

### User Interface
- The final implementation features multiple views built with a plethora of HStacks and VStacks.
- The **History View** uses a dynamic `List` view to display and organize past runs in a scrollable interface, categorized by day. This is also where persistent storage was implemented.
- The **Settings View** collects user input to customize the game's grid size.
- Examples of output are seen throughout the app, such as views appearing/disappearing based on state variables and the game grid generating when the start button is clicked.

---

## Substantial Changes from Original Design

### Framework Changes
- **MapKit vs. CoreLocation:** We replaced `MapKit` with `CoreLocation`. We discovered that `CoreLocation` was the correct framework for simply obtaining device location, as we did not need to display a map.
- **UserNotifications vs. AVFoundation:** We replaced `UserNotifications` with `AVFoundation`. This was primarily due to time constraints, as `AVFoundation` elements were already implemented. Additionally, our original notification plan would have required an external server, which we chose to avoid.
- These changes were documented in Assignment 3 and implemented in the `TouchGrassModel`.

### Additional Feedback Changes
- Haptic and audio feedback were added to provide clearer communication to the user upon reaching a checkpoint.
- This change was documented in Assignment 4 and implemented in the `TouchGrassModel`.

### Countdown Timer
- The initial timer design, which reset to a shorter duration after each checkpoint, was found to make the game too difficult.
- The timer now consistently resets to 5.2 seconds to provide a better user experience.
- This change was documented in Assignment 4 and implemented in the `TouchGrassModel`.
