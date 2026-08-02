# 📚 The Best Books App

An intuitive and visually engaging Flutter application designed to provide an interactive English learning experience for children with an offline-first architecture. 
Clone it and make it grow!

---

## ✨ Features

💡 **Dynamic Color-Theming**: Automatic card background and text contrast calculation for high accessibility.  
📖 **Structured Curriculum**: Fast content loading powered by local JSON data models (`BookModel`, `UnitModel`, `PageModel`, `ItemModel`).  
⚡ **Offline-First**: Complete offline access to books and units without network dependency.  
📱 **Modern UI**: Clean layout with custom components (`UnitCard`) and smooth navigation between screens.  

---

## 📸 Screenshots

| App Preview |
|-------------|
<img width="540" height="1200" alt="home_screen_light_mood" src="https://github.com/user-attachments/assets/cab72c93-db4d-47b1-bd70-048c47e88850" />

---

## 📁 Project Structure

```text
lib/
├── models/                  # Data models (Book, Unit, Page, Item)
│   ├── book_model.dart
│   ├── item_model.dart
│   ├── page_model.dart
│   └── unit_model.dart
├── screens/                 # Application screens
│   ├── home_screen.dart
│   ├── intro_screen.dart
│   ├── lesson_screen.dart
│   └── units_screen.dart
├── services/                # Local data handling
│   └── local_data_service.dart
├── utils/                   # Helper tools & extensions
│   └── string_extensions.dart
├── widgets/                 # Reusable UI components
│   └── unit_card.dart
└── main.dart                # App entry point
