import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class LiveTripCard extends StatelessWidget {
  final Trip trip;
  const LiveTripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(12),
        border: .all(color: colors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.directions_car, color: colors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trip.vehicleName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: .bold,
                        ),
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: .circular(20),
                ),
                child: Text(
                  '• EM ROTA',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: .bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: colors.secondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${trip.origin} -> ${trip.destination}',
                  style: textTheme.bodyMedium?.copyWith(fontWeight: .w500),
                  overflow: .ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text('Percorrido', style: textTheme.bodySmall),
                  Text(
                    '${trip.currentKm.toStringAsFixed(1)} KM',
                    style: textTheme.bodyLarge?.copyWith(fontWeight: .bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: .end,
                children: [
                  Text('Restante', style: textTheme.bodySmall),
                  Text(
                    '${trip.remainingDistance.toStringAsFixed(1)} KM',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: .bold,
                      color: colors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: .circular(8),
                  child: LinearProgressIndicator(
                    value: trip.progress,
                    minHeight: 8,
                    backgroundColor: colors.primary.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${trip.progressPercentage}%',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: .bold,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
