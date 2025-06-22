# Guide d'utilisation du Symptom Tracker

## Vue d'ensemble

Le Symptom Tracker est une fonctionnalité complète permettant aux utilisatrices de suivre leur cycle menstruel, leurs symptômes et leurs humeurs quotidiennes. Il intègre un calendrier visuel avec des icônes et des couleurs pour une expérience utilisateur intuitive.

## Fonctionnalités principales

### 1. Calendrier visuel
- **Icône 🌸** : Marque les jours où l'utilisatrice a enregistré un flux menstruel
- **Icône 🌼** : Représente la fenêtre fertile estimée (jours 12-16 du cycle)
- **Points de couleur** : Indiquent les humeurs
  - 🔴 Rouge : Humeurs difficiles (tristesse, anxiété, irritabilité)
  - 🟡 Jaune : Humeurs positives (joie, confiance)
  - 🔵 Bleu : Humeur calme
- **Numéros de cycle** : Affichent le jour du cycle dans chaque case
- **Mise en évidence du jour actuel** : Fond doux et couleur distincte

### 2. Journal quotidien
- **Flux menstruel** : Léger, Modéré, Abondant
- **Humeur** : Heureuse, Calme, Triste, Anxieuse, Irritable, Confiance
- **Symptômes** : Liste prédéfinie des symptômes de ménopause
- **Notes** : Champ libre pour des observations personnelles

### 3. Sauvegarde automatique
- Toutes les données sont sauvegardées dans Firestore
- Structure organisée par utilisateur et par date
- Synchronisation en temps réel

## Architecture technique

### Modèles de données

#### CycleDay
```dart
class CycleDay {
  final DateTime date;
  final int? cycleDay;
  final FlowIntensity? flow;
  final MoodType? mood;
  final List<String> symptoms;
  final String? notes;
}
```

#### User (mis à jour)
```dart
class User {
  final String uid;
  final String name;
  final String email;
  final MenopausePhase menopausePhase;
  final List<String> symptoms;
  final List<String> concerns;
  final DateTime lastPeriodStartDate;
  final int averageCycleLength;
  final int averagePeriodLength;
  final Map<String, CycleDay> cycleData;
  // ... autres propriétés
}
```

### Gestion d'état avec BLoC

#### SymptomTrackerBloc
- **Events** : LoadCycleData, SaveCycleDay, UpdateSelectedDate
- **States** : SymptomTrackerInitial, SymptomTrackerLoading, SymptomTrackerLoaded, SymptomTrackerError

#### AuthBloc (mis à jour)
- Récupère automatiquement les données utilisateur complètes au login
- Gère l'état d'authentification avec les données Firestore

### Services

#### DatabaseService
- `getUserData(String uid)` : Récupère les données utilisateur
- `getUser(String uid)` : Récupère l'utilisateur complet
- `saveCycleDay(String uid, CycleDay cycleDay)` : Sauvegarde les données de cycle
- `getCycleData(String uid, DateTime startDate, DateTime endDate)` : Récupère les données de cycle

## Bonnes pratiques Flutter

### 1. Gestion d'état
```dart
// Utilisation du BLoC pattern
BlocBuilder<SymptomTrackerBloc, SymptomTrackerState>(
  builder: (context, state) {
    if (state is SymptomTrackerLoaded) {
      return _buildCalendar(state);
    }
    return const CircularProgressIndicator();
  },
)
```

### 2. Responsive Design
```dart
ResponsiveLayout(
  mobile: _buildMobileLayout(),
  tablet: _buildTabletLayout(),
  desktop: _buildDesktopLayout(),
)
```

### 3. Gestion des erreurs
```dart
try {
  await _databaseService.saveCycleDay(uid, cycleDay);
} catch (e) {
  emit(SymptomTrackerError(message: 'Erreur: $e'));
}
```

### 4. Performance
- Chargement des données par mois uniquement
- Mise en cache des données utilisateur
- Optimisation des requêtes Firestore

## Structure Firestore

### Collection `users`
```json
{
  "uid": {
    "personalInfo": {
      "name": "Nom utilisateur",
      "email": "email@example.com",
      "profileImageUrl": "url_image"
    },
    "menopauseInfo": {
      "phase": "peri"
    },
    "cycleInfo": {
      "lastPeriodStartDate": "2024-01-01T00:00:00.000Z",
      "averageCycleLength": 28,
      "averagePeriodLength": 5,
      "estimatedByAI": false,
      "completedCycles": 0
    },
    "symptoms": ["bouffées", "fatigue"],
    "concerns": ["anxiété"],
    "cycleData": {
      "2024-01-15": {
        "date": "2024-01-15T00:00:00.000Z",
        "cycleDay": 15,
        "flow": "moderate",
        "mood": "calm",
        "symptoms": ["fatigue"],
        "notes": "Journée calme"
      }
    },
    "preferences": {},
    "onboarding": {},
    "metadata": {}
  }
}
```

## Conseils UI/UX

### 1. Design moderne
- Utilisation de cartes avec ombres douces
- Coins arrondis (borderRadius: 12-16)
- Couleurs cohérentes avec le thème bien-être

### 2. Accessibilité
- Contraste suffisant pour les couleurs
- Tailles de texte lisibles
- Indicateurs visuels clairs

### 3. Feedback utilisateur
- Messages de confirmation après sauvegarde
- Indicateurs de chargement
- Gestion gracieuse des erreurs

### 4. Navigation intuitive
- Boutons clairement identifiés
- Navigation fluide entre les mois
- Sélection facile des dates

## Fonctionnalités avancées

### 1. Calcul automatique du cycle
- Détection automatique du début des règles
- Calcul des jours de cycle
- Prédiction de la fenêtre fertile

### 2. Analyse des tendances
- Visualisation des patterns de symptômes
- Corrélation entre humeur et cycle
- Recommandations personnalisées

### 3. Export des données
- Génération de rapports PDF
- Export CSV pour analyse externe
- Partage avec professionnels de santé

## Sécurité et confidentialité

### 1. Authentification
- Vérification de l'identité utilisateur
- Accès sécurisé aux données personnelles
- Déconnexion automatique

### 2. Protection des données
- Chiffrement des données sensibles
- Sauvegarde sécurisée dans Firestore
- Respect du RGPD

### 3. Contrôle d'accès
- Règles Firestore restrictives
- Validation côté serveur
- Audit des accès

## Tests et maintenance

### 1. Tests unitaires
```dart
test('should emit SymptomTrackerLoaded when data is loaded', () {
  // Test du BLoC
});
```

### 2. Tests d'intégration
- Test des interactions avec Firestore
- Validation du flux complet
- Test des cas d'erreur

### 3. Monitoring
- Logs détaillés pour le debugging
- Métriques de performance
- Alertes en cas d'erreur

## Déploiement

### 1. Configuration Firebase
- Règles Firestore mises à jour
- Règles Storage configurées
- Cloud Functions déployées

### 2. Variables d'environnement
- Clés API sécurisées
- Configuration par environnement
- Gestion des secrets

### 3. CI/CD
- Tests automatiques
- Déploiement progressif
- Rollback en cas de problème

## Support et documentation

### 1. Documentation utilisateur
- Guide d'utilisation détaillé
- FAQ
- Tutoriels vidéo

### 2. Support technique
- Logs d'erreur détaillés
- Base de connaissances
- Support utilisateur

### 3. Mises à jour
- Nouvelles fonctionnalités
- Corrections de bugs
- Améliorations de performance 