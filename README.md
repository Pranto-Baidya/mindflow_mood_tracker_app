# Mindflow

A new mood tracking app created using Flutter, Firebase, Provider, REST API & Sqflite

# Core Features

* Daily Mood Tracking

  * Select your mood from predefined mood options.
  * Optionally add a note describing your feelings.
  * Attach tags (e.g., “Work”, “Family”, “Health”).

* Mood History & Search

  * View all past entries in a list or filtered by category/tags.
  * Search moods by keyword.
  * Filter moods by category or date range.

* Mood Insights & Analytics

  * Pie Chart – shows mood distribution over time.
  * Bar Chart – displays mood trends over days/weeks.
  * Chart Toggle – switch between pie and bar charts.

* Quote Generator

  * Random quote – shows randomized quotes.
    
* Save generated quote offline

  * Save random quote – shows randomized saved quotes offline.

###  Reminder System

* Custom Reminder Notifications

  * Pick a date & time for the notification.
  * Local notification delivered even when the app is closed.
  * Uses flutter\_local\_notifications & timezone package.
  * Supports multiple reminders (optional future enhancement).

* Daily Habit Building

  * Remind yourself to track your mood at a fixed time daily.

---

###  Privacy & Security

* PIN Lock & Biometric Authentication

  * Set a 4-digit PIN to protect app data.
  * Unlock with fingerprint/face recognition (if supported).
  * Lock screen shown after inactivity or app restart.

---

###  Realtime internet connectivity check

  * Ensures a seamless connectivity checking.

###  Localization

* Multi-language Support

  * Supports English & Bangla.
  * Language can be switched anytime from settings.
  * All UI texts are fully localized using `.arb` files.

---

###  UI & UX

* Fully Responsive Layout

  * Scales perfectly across phones & tablets using flutter\_screenutil.
* Light & Dark Mode

  * User can toggle theme from settings.
* Onboarding Screens

  * Introduction to app features with beautiful titles & subtitles.
  * Swipe navigation for first-time users.

---

###  Technical Stack

* Frontend: Flutter (Provider for state management)
* Database:Firebase Firestore (stores moods, notes, settings)
* Offline Database : Sqflite and Shared prefenrences
* Rest API : Includes REST API for random quote generation
* Auth: Firebase Authentication (Email/Password), Local Authentication
* Notifications: flutter\_local\_notifications + timezone
* Responsive UI: flutter\_screenutil
* Localization: intl + generated `.arb` files

# Project screenshots
![IMG-20250812-WA0098](https://github.com/user-attachments/assets/55020b82-766b-4f05-af7e-52b441a139eb)
![IMG-20250812-WA0097](https://github.com/user-attachments/assets/fe5c6ab1-3711-43b8-bc99-670f1f671c85)
![IMG-20250812-WA0096](https://github.com/user-attachments/assets/878fc52e-b22e-41db-9c2c-0517faedbb12)
![IMG-20250812-WA0095](https://github.com/user-attachments/assets/b403fe3c-b9cb-43ae-92fc-e77a9c1481b1)
![IMG-20250812-WA0094](https://github.com/user-attachments/assets/b2398f45-bfff-464a-9361-915e1584fd93)
![IMG-20250812-WA0093](https://github.com/user-attachments/assets/46e0f6c1-9002-45a5-b6a7-c6ef85f1ddee)
![IMG-20250812-WA0092](https://github.com/user-attachments/assets/f463cf71-f37c-4481-8106-ddb395f03f6d)
![IMG-20250812-WA0091](https://github.com/user-attachments/assets/ad23c505-8884-4608-9a25-aff09d7c37f8)
![IMG-20250812-WA0090](https://github.com/user-attachments/assets/db7d3619-670d-4fd5-bfa1-23986548e3a8)
![IMG-20250812-WA0089](https://github.com/user-attachments/assets/d8e5c81a-e661-4f42-a6af-36e13ea3e64f)
![IMG-20250812-WA0088](https://github.com/user-attachments/assets/af62e052-7844-43ee-8808-28791a8846c3)
![IMG-20250812-WA0087](https://github.com/user-attachments/assets/4a0805d4-b7cb-4329-aa17-0c678979a9f8)
![IMG-20250812-WA0086](https://github.com/user-attachments/assets/6ad68e0e-e666-40bb-a390-42e113c33363)
![IMG-20250812-WA0085](https://github.com/user-attachments/assets/5e12ac41-0d92-40f9-a71b-e458ec15647c)
![IMG-20250812-WA0084](https://github.com/user-attachments/assets/f4d4b42e-edde-4a1f-83f1-87d690876edf)
![IMG-20250812-WA0083](https://github.com/user-attachments/assets/4a68c6c0-2591-416c-b4e6-c76b837a9377)
![IMG-20250812-WA0082](https://github.com/user-attachments/assets/0c159738-4b7a-47e0-aef6-9f43b8c3743a)
![IMG-20250812-WA0081](https://github.com/user-attachments/assets/aad7ca9c-05bf-4a24-9735-199e492cf03d)
![IMG-20250812-WA0080](https://github.com/user-attachments/assets/0aab5cc2-bffc-44e4-86e9-a59cbbef7518)
![IMG-20250812-WA0079](https://github.com/user-attachments/assets/38b922b4-3189-4821-b93b-a23e84748ed5)
![IMG-20250812-WA0078](https://github.com/user-attachments/assets/8d882be4-c1eb-4439-937e-d381f07b096e)
![IMG-20250812-WA0077](https://github.com/user-attachments/assets/2a27b96a-5b56-4fdd-8ce6-54933795f23e)
![IMG-20250812-WA0076](https://github.com/user-attachments/assets/00315b68-e26f-4dee-9633-17c7e3987f2a)
![IMG-20250812-WA0075](https://github.com/user-attachments/assets/bd6fc661-9cce-494a-84e0-732d76b2a53c)
![IMG-20250812-WA0074](https://github.com/user-attachments/assets/57321abd-19cf-4618-8d0d-cbe9858bf05b)
![IMG-20250812-WA0073](https://github.com/user-attachments/assets/2e1ab954-f0e3-4b6a-a552-834c2dec94b2)
![IMG-20250812-WA0072](https://github.com/user-attachments/assets/60b039f8-916b-4a67-8254-f8c6305b9c02)
![IMG-20250812-WA0071](https://github.com/user-attachments/assets/5c468783-af22-4da5-910c-1ca53eb24b8e)
![IMG-20250812-WA0070](https://github.com/user-attachments/assets/ef942423-d35e-4b42-930b-a6d989474508)
![IMG-20250812-WA0069](https://github.com/user-attachments/assets/5cd9e87d-1477-4188-baba-dc69933a48d1)
![IMG-20250812-WA0068](https://github.com/user-attachments/assets/fcac5c21-2e33-4664-9381-41c7c7c42d4d)
![IMG-20250812-WA0067](https://github.com/user-attachments/assets/96e51145-c5b1-41e5-a555-4094e5bf79b1)
![IMG-20250812-WA0066](https://github.com/user-attachments/assets/158d759c-6a65-45b8-8e7c-e930c7d472a8)
![IMG-20250812-WA0065](https://github.com/user-attachments/assets/e2d0e5fe-230a-4269-b88d-924672e7335b)
![IMG-20250812-WA0064](https://github.com/user-attachments/assets/d1b8ad8a-dec3-47f0-8676-724e06f35299)
![IMG-20250812-WA0063](https://github.com/user-attachments/assets/61175972-5c1e-4036-9e17-23e611a6cbdd)
![IMG-20250812-WA0062](https://github.com/user-attachments/assets/198a45c8-54ea-4713-83cb-3420d902d70e)
![IMG-20250812-WA0061](https://github.com/user-attachments/assets/5b0ca4ad-267f-42c8-ab0c-881988831e67)
![IMG-20250812-WA0060](https://github.com/user-attachments/assets/156dbc09-2c05-4740-ac48-36de79b873ae)
![IMG-20250812-WA0059](https://github.com/user-attachments/assets/c2f41b5b-72bd-49d4-b730-8174c78a90b7)
![IMG-20250812-WA0058](https://github.com/user-attachments/assets/46f61b3e-34e8-403c-99a4-67cb26a5a76f)
![IMG-20250812-WA0056](https://github.com/user-attachments/assets/5bcce1c6-fba6-48e4-bb99-d62e82324a8b)
![IMG-20250812-WA0050](https://github.com/user-attachments/assets/2284c0ed-251e-4b0e-9a8f-3ae417356e60)
![IMG-20250812-WA0052](https://github.com/user-attachments/assets/12503c39-6fc2-42c5-a2b4-4334b299d1ed)
![IMG-20250812-WA0054](https://github.com/user-attachments/assets/3b269b23-8f93-4bba-b891-2167df8283b4)


