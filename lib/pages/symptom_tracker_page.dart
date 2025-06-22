import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/symptom_tracker_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../models/user.dart';
import '../constants/app_colors.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/cycle_calendar.dart';
import '../widgets/modern_save_button.dart';
import '../utils/responsive.dart';

class WelcomeMessage {
  final String emoji;
  final String message;

  const WelcomeMessage({
    required this.emoji,
    required this.message,
  });
}

class SymptomTrackerPage extends StatefulWidget {
  const SymptomTrackerPage({super.key});

  @override
  State<SymptomTrackerPage> createState() => _SymptomTrackerPageState();
}

class _SymptomTrackerPageState extends State<SymptomTrackerPage> {
  DateTime _selectedDate = DateTime.now();
  CycleDay? _selectedCycleDay;

  FlowIntensity? _selectedFlow;
  MoodType? _selectedMood;
  final List<String> _selectedSymptoms = [];
  final TextEditingController _notesController = TextEditingController();

  // Helper methods for safe data access
  String _safeGetUserName(User? user) {
    if (user == null || user.name.isEmpty) return 'Utilisateur';
    return user.name;
  }

  int _safeGetCycleLength(User? user) {
    if (user == null) return 28;
    return user.averageCycleLength;
  }

  int _safeGetPeriodLength(User? user) {
    if (user == null) return 5;
    return user.averagePeriodLength;
  }

  DateTime _safeGetLastPeriodDate(User? user) {
    if (user == null || user.lastPeriodStartDate == null) {
      return DateTime.now().subtract(const Duration(days: 28));
    }
    return user.lastPeriodStartDate;
  }

  Map<String, CycleDay> _safeGetCycleData(User? user) {
    if (user == null) return {};
    return user.cycleData;
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentMonthData();
  }

  void _loadCurrentMonthData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
      final endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

      context.read<SymptomTrackerBloc>().add(LoadCycleData(
            uid: authState.firebaseUser.uid,
            startDate: startDate,
            endDate: endDate,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Suivi des Symptômes',
          style: GoogleFonts.inter(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: Responsive.scale(context, 20, tablet: 22, desktop: 24),
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is Authenticated) {
            return BlocBuilder<SymptomTrackerBloc, SymptomTrackerState>(
              builder: (context, state) {
                if (state is SymptomTrackerLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state is SymptomTrackerLoaded) {
                  return _buildContent(state, authState.userProfile);
                } else if (state is SymptomTrackerError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Erreur: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadCurrentMonthData,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          }
          return const Center(
            child: Text('Veuillez vous connecter'),
          );
        },
      ),
    );
  }

  Widget _buildContent(SymptomTrackerLoaded state, User user) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(state, user),
      tablet: _buildTabletLayout(state, user),
      desktop: _buildDesktopLayout(state, user),
    );
  }

  Widget _buildMobileLayout(SymptomTrackerLoaded state, User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildWelcomeSection(user),
          const SizedBox(height: 20),
          _buildCalendarInfoSection(),
          CycleCalendar(
            cycleData: _safeGetCycleData(user),
            lastPeriodStartDate: _safeGetLastPeriodDate(user),
            averageCycleLength: _safeGetCycleLength(user),
            averagePeriodLength: _safeGetPeriodLength(user),
            onDaySelected: _onDaySelected,
            selectedDate: _selectedDate,
          ),
          const SizedBox(height: 20),
          _buildDailyLogForm(state, user),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(SymptomTrackerLoaded state, User user) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildWelcomeSection(user),
                const SizedBox(height: 20),
                _buildCalendarInfoSection(),
                CycleCalendar(
                  cycleData: _safeGetCycleData(user),
                  lastPeriodStartDate: _safeGetLastPeriodDate(user),
                  averageCycleLength: _safeGetCycleLength(user),
                  averagePeriodLength: _safeGetPeriodLength(user),
                  onDaySelected: _onDaySelected,
                  selectedDate: _selectedDate,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: _buildDailyLogForm(state, user),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(SymptomTrackerLoaded state, User user) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildWelcomeSection(user),
                const SizedBox(height: 24),
                _buildCalendarInfoSection(),
                CycleCalendar(
                  cycleData: _safeGetCycleData(user),
                  lastPeriodStartDate: _safeGetLastPeriodDate(user),
                  averageCycleLength: _safeGetCycleLength(user),
                  averagePeriodLength: _safeGetPeriodLength(user),
                  onDaySelected: _onDaySelected,
                  selectedDate: _selectedDate,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(24),
            child: _buildDailyLogForm(state, user),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(User user) {
    final currentHour = DateTime.now().hour;
    final welcomeMessage = _getWelcomeMessage(currentHour);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                welcomeMessage.emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_safeGetUserName(user)}',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            welcomeMessage.message,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  WelcomeMessage _getWelcomeMessage(int hour) {
    if (hour >= 5 && hour < 11) {
      return WelcomeMessage(
        emoji: '☀️',
        message: 'Commencez votre journée en douceur.',
      );
    } else if (hour >= 11 && hour < 14) {
      return WelcomeMessage(
        emoji: '🍽️',
        message: 'Bon appétit ! N\'oubliez pas de vous hydrater.',
      );
    } else if (hour >= 14 && hour < 18) {
      return WelcomeMessage(
        emoji: '🌞',
        message: 'Bon après-midi ! Comment vous sentez-vous ?',
      );
    } else if (hour >= 18 && hour < 22) {
      return WelcomeMessage(
        emoji: '🌇',
        message: 'Bonsoir ! Prenez soin de vous ce soir.',
      );
    } else {
      return WelcomeMessage(
        emoji: '🌙',
        message: 'Il est tard... N\'oubliez pas de vous reposer.',
      );
    }
  }

  Widget _buildCalendarInfoSection() {
    // Get user data safely
    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.userProfile : null;
    final cycleLength = _safeGetCycleLength(user);
    final periodLength = _safeGetPeriodLength(user);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Guide du calendrier menstruel',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(
                  '🌸 Icônes de flux menstruel',
                  'L\'icône 🌸 indique les jours où un flux menstruel a été enregistré. '
                      'Lorsque cette icône apparaît en teinte claire avec transparence, '
                      'cela signifie qu\'il s\'agit d\'une prévision automatique des prochaines règles, '
                      'basée sur vos cycles précédents.',
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  '🌼 Fenêtre fertile',
                  'L\'icône 🌼 signale la fenêtre fertile estimée (phase ovulatoire), '
                      'calculée à partir de votre durée moyenne de cycle. '
                      'Elle n\'est affichée que pour les cycles passés ou en cours '
                      'afin d\'éviter toute confusion avec des données non confirmées.',
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  'Points d\'humeur',
                  'Les points d\'humeur offrent une représentation colorée de votre état émotionnel :\n'
                      '• Rose ou rose foncé : humeurs difficiles (tristesse, anxiété, irritabilité)\n'
                      '• Jaune : émotions positives (joie, confiance) - affiché uniquement si aucune humeur difficile n\'a été notée\n'
                      '• Bleu : état de calme - affiché si aucune humeur difficile ou positive n\'a été enregistrée\n'
                      '• Absence de point : aucune humeur pertinente saisie pour cette date',
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  'Données utilisées',
                  'Ces représentations sont générées à partir de vos données de cycle :\n'
                      '• Durée moyenne du cycle ($cycleLength jours)\n'
                      '• Durée moyenne des règles ($periodLength jours)\n'
                      '• Date de début des dernières règles\n'
                      '• Nombre de cycles complétés',
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Text(
                    '💡 L\'estimation du cycle repose principalement sur votre durée moyenne de cycle (ACL), '
                    'permettant une expérience personnalisée et l\'anticipation des phases clés de votre cycle.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyLogForm(SymptomTrackerLoaded state, User user) {
    // Use safe data access methods
    final safeSymptoms = user.symptoms.isNotEmpty
        ? user.symptoms
        : ['Aucun symptôme enregistré'];
    final selectedDate = _selectedDate;
    final selectedCycleDay = _selectedCycleDay;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enregistrement du ${DateFormat('dd MMMM yyyy', 'fr_FR').format(selectedDate)}',
            style: GoogleFonts.inter(
              fontSize: Responsive.scale(context, 18, tablet: 20, desktop: 22),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Sélecteur de flux
          _buildFlowSelector(),
          const SizedBox(height: 16),

          // Sélecteur d'humeur
          _buildMoodSelector(),
          const SizedBox(height: 16),

          // Sélecteur de symptômes
          _buildSymptomSelector(safeSymptoms),
          const SizedBox(height: 16),

          // Notes
          _buildNotesField(),
          const SizedBox(height: 24),

          // Bouton de sauvegarde moderne
          ModernSaveButton(
            onPressed: () => _saveDailyLog(state, user),
            isLoading: state.isSaving,
            text: selectedCycleDay != null
                ? 'Mettre à jour'
                : 'Enregistrer aujourd\'hui',
          ),
        ],
      ),
    );
  }

  Widget _buildFlowSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flux menstruel',
          style: GoogleFonts.inter(
            fontSize: Responsive.scale(context, 14, tablet: 16, desktop: 18),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: FlowIntensity.values.map((flow) {
            final isSelected = _selectedFlow == flow;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getFlowIcon(flow)),
                  const SizedBox(width: 6),
                  Text(_getFlowLabel(flow)),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFlow = selected ? flow : null;
                });
              },
              backgroundColor: AppColors.background,
              selectedColor: AppColors.primary.withOpacity(0.2),
              labelStyle: GoogleFonts.inter(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Humeur',
          style: GoogleFonts.inter(
            fontSize: Responsive.scale(context, 14, tablet: 16, desktop: 18),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: MoodType.values.map((mood) {
            final isSelected = _selectedMood == mood;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getMoodIcon(mood)),
                  const SizedBox(width: 6),
                  Text(_getMoodLabel(mood)),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedMood = selected ? mood : null;
                });
              },
              backgroundColor: AppColors.background,
              selectedColor: _getMoodColor(mood).withOpacity(0.2),
              labelStyle: GoogleFonts.inter(
                color:
                    isSelected ? _getMoodColor(mood) : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSymptomSelector(List<String> symptoms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Symptômes',
          style: GoogleFonts.inter(
            fontSize: Responsive.scale(context, 14, tablet: 16, desktop: 18),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (symptoms.isEmpty ||
            (symptoms.length == 1 &&
                symptoms.first == 'Aucun symptôme enregistré'))
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Aucun symptôme configuré. Veuillez les définir dans votre profil.',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 8,
            children: symptoms.map((symptom) {
              final isSelected = _selectedSymptoms.contains(symptom);
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_getSymptomIcon(symptom)),
                    const SizedBox(width: 6),
                    Text(symptom),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSymptoms.add(symptom);
                    } else {
                      _selectedSymptoms.remove(symptom);
                    }
                  });
                },
                backgroundColor: AppColors.background,
                selectedColor: AppColors.secondary.withOpacity(0.2),
                labelStyle: GoogleFonts.inter(
                  color: isSelected
                      ? AppColors.secondary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: GoogleFonts.inter(
            fontSize: Responsive.scale(context, 14, tablet: 16, desktop: 18),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Ajoutez vos notes pour aujourd\'hui...',
            hintStyle: GoogleFonts.inter(
              color: AppColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _onDaySelected(DateTime date, CycleDay? cycleDay) {
    setState(() {
      _selectedDate = date;
      _selectedCycleDay = cycleDay;

      // Pre-fill form with existing data if available
      if (cycleDay != null) {
        _selectedFlow = cycleDay.flow;
        _selectedMood = cycleDay.mood;
        _selectedSymptoms.clear();
        _selectedSymptoms.addAll(cycleDay.symptoms);
        _notesController.text = cycleDay.notes ?? '';
      } else {
        _selectedFlow = null;
        _selectedMood = null;
        _selectedSymptoms.clear();
        _notesController.clear();
      }
    });
  }

  void _saveDailyLog(SymptomTrackerLoaded state, User user) {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<SymptomTrackerBloc>().add(SaveCycleDay(
            uid: authState.firebaseUser.uid,
            date: _selectedDate,
            flow: _selectedFlow,
            mood: _selectedMood,
            symptoms: _selectedSymptoms,
            notes:
                _notesController.text.isNotEmpty ? _notesController.text : null,
          ));
    }
  }

  String _getFlowLabel(FlowIntensity flow) {
    switch (flow) {
      case FlowIntensity.light:
        return 'Léger';
      case FlowIntensity.moderate:
        return 'Modéré';
      case FlowIntensity.heavy:
        return 'Abondant';
    }
  }

  String _getMoodLabel(MoodType mood) {
    switch (mood) {
      case MoodType.happy:
        return 'Heureuse';
      case MoodType.calm:
        return 'Calme';
      case MoodType.sad:
        return 'Triste';
      case MoodType.anxious:
        return 'Anxieuse';
      case MoodType.irritable:
        return 'Irritable';
      case MoodType.confident:
        return 'Confiance';
    }
  }

  Color _getMoodColor(MoodType mood) {
    switch (mood) {
      case MoodType.happy:
      case MoodType.confident:
        return Colors.yellow[600]!;
      case MoodType.calm:
        return Colors.blue[400]!;
      case MoodType.sad:
      case MoodType.anxious:
      case MoodType.irritable:
        return Colors.red[400]!;
    }
  }

  String _getFlowIcon(FlowIntensity flow) {
    switch (flow) {
      case FlowIntensity.light:
        return '💧';
      case FlowIntensity.moderate:
        return '💧💧';
      case FlowIntensity.heavy:
        return '💧💧💧';
    }
  }

  String _getMoodIcon(MoodType mood) {
    switch (mood) {
      case MoodType.happy:
        return '😄';
      case MoodType.calm:
        return '😌';
      case MoodType.sad:
        return '😢';
      case MoodType.anxious:
        return '😟';
      case MoodType.irritable:
        return '😠';
      case MoodType.confident:
        return '😊';
    }
  }

  String _getSymptomIcon(String symptom) {
    // Map symptoms to emojis (same as in calendar)
    final Map<String, String> symptomEmojis = {
      'maux de tête': '🤕',
      'nausée': '🤢',
      'ballonnements': '💨',
      'douleur au bas-ventre': '💔',
      'fatigue': '😴',
      'bouffées de chaleur': '🌡️',
      'crampes': '💔',
      'douleurs lombaires': '🦴',
      'irritabilité': '😤',
      'anxiété': '😰',
      'dépression': '😔',
      'insomnie': '😴',
      'sueurs nocturnes': '💦',
      'sécheresse vaginale': '🌵',
      'gain de poids': '⚖️',
      'perte de libido': '💔',
      'migraine': '🤕',
      'vertiges': '💫',
      'palpitations': '💓',
      'douleurs articulaires': '🦴',
      'sécheresse cutanée': '🌵',
      'changements d\'humeur': '😤',
      'difficultés de concentration': '🤔',
      'troubles du sommeil': '😴',
      'bouffées de chaleur nocturnes': '🌡️',
      'sécheresse oculaire': '👁️',
      'douleurs mammaires': '💔',
      'saignements irréguliers': '🩸',
      'pertes vaginales': '💧',
    };

    return symptomEmojis[symptom.toLowerCase()] ?? '⚠️';
  }
}
