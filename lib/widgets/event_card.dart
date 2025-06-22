import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../constants/app_colors.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final bool showStatus;

  const EventCard({
    Key? key,
    required this.event,
    this.onTap,
    this.showStatus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPast = event.isPast;
    final isFull = event.isFull;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isPast ? 2 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isPast ? Colors.grey.shade100 : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image et badges
              Stack(
                children: [
                  // Image de l'événement
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      color: _getEventTypeColor(event.type).withOpacity(0.1),
                    ),
                    child: event.imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              event.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholderImage();
                              },
                            ),
                          )
                        : _buildPlaceholderImage(),
                  ),

                  // Badges de statut
                  if (showStatus) ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildStatusBadge(),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _buildTypeBadge(),
                    ),
                  ],

                  // Badge "Complet" si l'événement est plein
                  if (isFull)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'COMPLET',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Contenu de la carte
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isPast ? Colors.grey.shade600 : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isPast
                            ? Colors.grey.shade500
                            : Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Informations de l'événement
                    Row(
                      children: [
                        // Date et heure
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: isPast
                                    ? Colors.grey.shade500
                                    : AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  DateFormat('dd/MM/yyyy à HH:mm')
                                      .format(event.date),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isPast
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Durée
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: isPast
                                  ? Colors.grey.shade500
                                  : AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${event.duration} min',
                              style: TextStyle(
                                fontSize: 12,
                                color: isPast
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Hôte et participants
                    Row(
                      children: [
                        // Hôte
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.1),
                                child: Text(
                                  event.host.name.isNotEmpty
                                      ? event.host.name[0].toUpperCase()
                                      : 'H',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  event.host.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isPast
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Nombre de participants
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 16,
                              color: isPast
                                  ? Colors.grey.shade500
                                  : AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${event.currentAttendees}/${event.maxAttendees}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isPast
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Tags
                    if (event.tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: event.tags.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    if (event.isPast) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule,
              color: Colors.white,
              size: 12,
            ),
            SizedBox(width: 4),
            Text(
              'TERMINÉ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_available,
            color: Colors.white,
            size: 12,
          ),
          SizedBox(width: 4),
          Text(
            'À VENIR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getEventTypeColor(event.type),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getEventTypeIcon(event.type),
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            _getEventTypeLabel(event.type),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: _getEventTypeColor(event.type).withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Center(
        child: Icon(
          _getEventTypeIcon(event.type),
          size: 48,
          color: _getEventTypeColor(event.type).withOpacity(0.5),
        ),
      ),
    );
  }

  Color _getEventTypeColor(EventType type) {
    switch (type) {
      case EventType.webinar:
        return Colors.blue;
      case EventType.workshop:
        return Colors.orange;
      case EventType.conference:
        return Colors.purple;
      case EventType.support_group:
        return Colors.green;
      case EventType.meditation:
        return Colors.indigo;
      case EventType.exercise:
        return Colors.red;
      case EventType.nutrition:
        return Colors.teal;
      case EventType.medical:
        return Colors.pink;
      case EventType.education:
        return Colors.amber;
      case EventType.bien_etre:
        return Colors.lightGreen;
    }
  }

  IconData _getEventTypeIcon(EventType type) {
    switch (type) {
      case EventType.webinar:
        return Icons.video_camera_front;
      case EventType.workshop:
        return Icons.work;
      case EventType.conference:
        return Icons.people;
      case EventType.support_group:
        return Icons.favorite;
      case EventType.meditation:
        return Icons.self_improvement;
      case EventType.exercise:
        return Icons.fitness_center;
      case EventType.nutrition:
        return Icons.restaurant;
      case EventType.medical:
        return Icons.medical_services;
      case EventType.education:
        return Icons.school;
      case EventType.bien_etre:
        return Icons.spa;
    }
  }

  String _getEventTypeLabel(EventType type) {
    switch (type) {
      case EventType.webinar:
        return 'WEBINAR';
      case EventType.workshop:
        return 'ATELIER';
      case EventType.conference:
        return 'CONFÉRENCE';
      case EventType.support_group:
        return 'GROUPE';
      case EventType.meditation:
        return 'MÉDITATION';
      case EventType.exercise:
        return 'EXERCICE';
      case EventType.nutrition:
        return 'NUTRITION';
      case EventType.medical:
        return 'MÉDICAL';
      case EventType.education:
        return 'ÉDUCATION';
      case EventType.bien_etre:
        return 'BIEN-ÊTRE';
    }
  }
}
