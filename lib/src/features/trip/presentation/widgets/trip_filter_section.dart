import 'package:flutter/material.dart';
import 'package:vehicle_tracker/src/features/trip/trip_domain_exports.dart';

class FilterItem {
  final String label;
  final TripStatus? status;
  FilterItem({required this.label, this.status});
}

class TripFilterSection extends StatelessWidget {
  final TripStatus? selectedFilter;
  final ValueChanged<TripStatus?> onFilterChanged;

  const TripFilterSection({
    super.key,
    required this.onFilterChanged,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filters = [
      FilterItem(label: 'Todas', status: null),
      FilterItem(label: 'Em Progresso', status: TripStatus.inProgress),
      FilterItem(label: 'Concluídas', status: TripStatus.completed),
      FilterItem(label: 'Manutenção', status: TripStatus.failed),
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final item = filters[index];
          final isSelected = selectedFilter == item.status;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(item.label),
              selected: isSelected,
              selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.tertiary.withValues(alpha: 0.1),
              ),
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) => onFilterChanged(item.status),
            ),
          );
        },
      ),
    );
  }
}
