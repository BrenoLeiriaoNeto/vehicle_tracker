import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class TripHistoryCard extends StatelessWidget {
  final Trip trip;

  const TripHistoryCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surface,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(trip.vehicleName, style: theme.textTheme.titleMedium),
                  ],
                ),
                _buildStatusBadge(theme, trip.status),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Colors.white10),
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${trip.origin} -> ${trip.destination}',
                    style: theme.textTheme.bodyMedium,
                    overflow: .ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Distância: ${trip.totalDistance.toStringAsFixed(1)} KM',
                  style: theme.textTheme.bodySmall,
                ),
                if (trip.status == .inProgress)
                  Text(
                    'Progresso: ${trip.progressPercentage}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: .bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, TripStatus status) {
    Color badgeColor;
    String label;

    switch (status) {
      case TripStatus.inProgress:
        badgeColor = theme.colorScheme.primary;
        label = 'RFE';
        break;
      case TripStatus.completed:
        badgeColor = theme.colorScheme.secondary;
        label = 'Concluída';
        break;
      case TripStatus.failed:
        badgeColor = Colors.redAccent;
        label = 'Manutenção';
        break;
      case TripStatus.paused:
        badgeColor = Colors.orangeAccent;
        label = 'Pausada';
        break;
      case TripStatus.pending:
        badgeColor = Colors.grey;
        label = 'Pendente';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
