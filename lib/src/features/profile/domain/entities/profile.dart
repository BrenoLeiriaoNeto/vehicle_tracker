class Profile {
  final String? avatarUrl;
  final int tripsCompleted;
  final double sumKilometers;
  final int totalVehicles;
  final String? bio;
  final DateTime? memberSince;

  const Profile({
    this.avatarUrl,
    this.bio,
    this.tripsCompleted = 0,
    this.sumKilometers = 0.0,
    this.totalVehicles = 0,
    this.memberSince,
  });
}
