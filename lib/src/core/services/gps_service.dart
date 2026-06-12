import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> getPosition() async {
  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == .denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == .whileInUse || permission == .always) {
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) return lastPosition;

      Position position = await Geolocator.getCurrentPosition();
      return position;
    }

    return null;
  } catch (e) {
    print('Falha ao obter GPS, usando coordenadas padrão: $e');
    return null;
  }
}

Future<String> fetchCurrentLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'O serviço de localização (GPS) está desativado no dispositivo';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == .denied) {
      permission = await Geolocator.requestPermission();
      if (permission == .denied) {
        throw 'Permissão de localização negada pelo usuário';
      }
    }

    if (permission == .deniedForever) {
      throw 'A permissão de localização esta negada permanentemente nas configurações';
    }

    final position = await Geolocator.getCurrentPosition().timeout(
      const Duration(seconds: 7),
    );

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    ).timeout(const Duration(seconds: 5));

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      final formattedAddress =
          '${place.thoroughfare ?? place.subLocality ?? ''}, ${place.subAdministrativeArea ?? place.locality ?? ''}';

      return formattedAddress;
    }
    return '';
  } catch (e) {
    throw Exception('Erro de GPS: $e');
  }
}
