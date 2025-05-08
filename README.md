# 🌤️ Météo Sénégal
![Flutter](https://img.shields.io/badge/flutter-3.19-blue?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-stable-blue?logo=dart)

Application Flutter permettant d'afficher la météo actuelle et les prévisions (à court et long terme) pour les villes du Sénégal, à partir de l'API OpenWeatherMap.

---

## 📱 Fonctionnalités

- 🔍 Recherche de la météo par ville
- ☀️ Météo actuelle : température, vent, humidité, description
- ⏳ Prévisions à court terme (prochaines heures)
- 📅 Prévisions à long terme (prochains jours)
- 📱 Interface simple, responsive et mobile-friendly

---

## 🛠️ Technologies

- [Flutter](https://flutter.dev) 3.19+
- [Dart](https://dart.dev)
- [OpenWeatherMap API](https://openweathermap.org/api)
- HTTP client (`http` package)

---

## 🔧 Installation

1. **Clone ce dépôt** :
   ```bash
   git clone https://github.com/NathanGildas/meteo_senegal.git
   cd meteo_senegal
    ```

2. **Installe les dépendances** :

   ```bash
   flutter pub get
   ```

3. **Configure ta clé API** :

   * Va sur [openweathermap.org/api\_keys](https://home.openweathermap.org/api_keys) pour générer ta clé
   * Ouvre `lib/services/weather_service.dart` et remplace la ligne suivante :

     ```dart
     static const String _apiKey = 'VOTRE_CLÉ_API';
     ```

4. **Lance l'application** :

   ```bash
   flutter run
   ```

---

## ✨ Aperçu

Voici quelques captures d'écran de l'application :

<img src="https://github.com/user-attachments/assets/afd8732e-2ad6-4a6c-854d-2b02492c45b5" alt="screenshot1" width="280"/>
<img src="https://github.com/user-attachments/assets/29f2971a-97e0-425a-a179-3a8d3866fded" alt="screenshot2" width="280"/>
<img src="https://github.com/user-attachments/assets/6fe80c3e-378c-4e6e-bad0-3a77683796c6" alt="screenshot3" width="280"/>

---

## 📄 Licence

Projet académique ESP (École Supérieure Polytechnique) – Tous droits réservés ©

---
