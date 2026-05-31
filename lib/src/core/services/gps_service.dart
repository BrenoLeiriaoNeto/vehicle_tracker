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
