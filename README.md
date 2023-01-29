# ISBLog
Responsive Full Stack Blog Application - Works on Android, iOS & Web! 

To **Download⬇️⬇️** the App [click here📱📱](https://drive.google.com/file/d/1RLSJYw8l48sJK7rJ8ea7uSgru5P_pYrP/view?usp=share_link)   


## Features
- Google/Guest Authentication
- Create, Join community
- Community Profile (Avatar, Banner, Members) 
- Edit Description and Avatar of community
- Post (link only, photo, text only) 
- Upvote, Downvote
- Comment
- Add Moderators
- Delete post
- User Profile (Avatar, Banner) 
- Light/Dark Theme
- State Persistence 

## Installation
After cloning this repository, migrate to ```iasblog``` folder. Then, follow the following steps:
- Create Firebase Project
- Enable Authentication (Google Sign In, Guest Sign In)
- Make Firestore Rules
- Create Android, iOS & Web Apps
- Use FlutterFire CLI to add the Firebase Project to this app.
Then run the following commands to run your app:
```bash
  flutter pub get
  open -a simulator (to get iOS Simulator)
  flutter run
  flutter run -d chrome --web-renderer html (to see the best output)
```

## Tech Used
**Server**: Firebase Auth, Firebase Storage, Firebase Firestore

**Client**: Flutter, Riverpod 2.0, Routemaster
    
