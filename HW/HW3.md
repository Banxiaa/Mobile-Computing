### The Various States that an App Can Enter on iOS

#### 1. Not Running
The app is completely closed and not in memory. This state occurs:
- Before the app is launched for the first time.
- After the app has been terminated by the system or user.

#### 2. Inactive
The app is running in the foreground but not receiving events. This state often occurs briefly as the app transitions between other states.
- **Example:** When a user receives a phone call while using the app, it may become inactive momentarily before moving to the background.

#### 3. Active
The app is running in the foreground and actively receiving user events.
- **Example:** This is the normal state for most foreground apps when in use.

#### 4. Background
The app is in the background and executing code. Apps enter this state when they:
- Move out of the foreground.
- Need time to finish a task or perform background processing.

#### 5. Suspended
The app is in memory but not executing any code. The system moves apps to this state to save power when they are in the background and not actively performing tasks.
- **Example:** Apps not actively needed may be suspended but can resume quickly if the user reopens them.

---

### The Various States to Consider for the DailyTarot App, Why, and What Must Happen in Each State

1. **Active**:
   - **Why**: Users are actively interacting with the app to draw tarot cards, view readings, or make settings changes.
   - **What to Do**: Display daily page, ensure smooth animations, and respond to user actions like touch interactions or button presses.

2. **Inactive**:
   - **Why**: This state occurs when there’s a brief interruption (e.g., an incoming call or notification).
   - **What to Do**: Pause animations or in-progress tasks. No data-saving is typically required, as this state is usually temporary and may return to active shortly.

3. **Background**:
   - **Why**: The app moves to the background when the user navigates away. To preserve the user experience, the app must save its current state.
   - **What to Do**: Save the user’s tarot reading progress (e.g., selected cards or spread layout) and any other unsaved settings. Release resources and pause any non-critical processes.

4. **Suspended**:
   - **Why**: After staying in the background for some time, the app may be suspended by iOS.
   - **What to Do**: All critical data must already be saved before suspension, as the app has no control in this state. When resumed, the app should restore the last saved state efficiently.

5. **Terminated**:
   - **Why**: The app is closed either by the user or by the system to free up memory.
   - **What to Do**: Ensure all user settings, such as theme preferences or recent readings, are saved before termination. When restarted, the app should retrieve saved data to maintain continuity, allowing users to continue from where they left off.
