class Vehicle {
  final String plate;
  final String brand;
  final String model;
  final String year;
  final double currentKm;
  final String status;

  const Vehicle({
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    required this.currentKm,
    this.status = 'available',
  });
}
