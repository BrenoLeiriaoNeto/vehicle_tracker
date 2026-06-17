import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/features/garage/garage_domain_exports.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(16),
        border: .all(color: colors.primary.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: .circular(6),
              border: .all(color: const Color(0xFF003399), width: 2),
            ),
            child: Column(
              mainAxisSize: .min,
              children: [
                Container(
                  height: 4,
                  width: double.infinity,
                  color: const Color(0xFF003399),
                ),
                const SizedBox(height: 2),
                Text(
                  vehicle.plate,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: .bold,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                Text(
                  vehicle.model,
                  style: textTheme.titleMedium,
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${vehicle.brand} - ${vehicle.year}',
                  style: textTheme.bodySmall,
                ),
                Row(
                  children: [
                    Icon(Icons.speed, size: 14, color: colors.secondary),
                    const SizedBox(width: 4),
                    Text(
                      '${vehicle.currentKm.toStringAsFixed(0)} Km',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.secondary,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: vehicle.status == 'available'
                  ? colors.secondary.withValues(alpha: 0.1)
                  : Colors.orangeAccent.withValues(alpha: 0.1),
              borderRadius: .circular(20),
            ),
            child: Text(
              vehicle.status == 'available' ? 'Disponível' : 'Em Rota',
              style: TextStyle(
                color: vehicle.status == 'available'
                    ? colors.secondary
                    : Colors.orangeAccent,
                fontSize: 11,
                fontWeight: .bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
