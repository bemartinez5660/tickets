import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:isu_corp_test/environment.dart';

class GoogleMapsService {
  // Method to check if getCoordinates returned a valid coordinates and use it 
  // for move the camera to this point in the map
  Future<LatLng?> determinePosition(
      GoogleMapController controller, String address) async {
    final coordinates = await getCoordinates(address);
    // If not valid coordinates return null
    if (coordinates.isEmpty) {
      return null;
    }
    final locData = LatLng(coordinates['lat'], coordinates['lng']);

    // For a valid pairs of coordinates updating the camera position to the new location
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          locData.latitude,
          locData.longitude,
        ),
        zoom: 16)));
    return locData;
  }

  // Method to determine the coordinates of the address provide with the googlemap
  // Geocoding API
  Future<Map<String, dynamic>> getCoordinates(String address) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${Environment.googleApiKey}';

    final response = await Dio().get(url);
    if (response.statusCode == 200) {
      final datos = response.data;
      if (datos['status'] == 'OK') {
        final Map<String, dynamic> location =
            datos['results'][0]['geometry']['location'];
        return location;
      } else {
        return {};
      }
    } else {
      throw Exception('Error al obtener las coordenadas');
    }
  }

  // Aux metho for update the markers of the map, allow to put a marker in the
  // coordinates obtained 
  void updateMarkers(Set<Marker> markers, LatLng location, String address) {
    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId('Address'),
        infoWindow: InfoWindow(title: address),
        position: location,
        icon: BitmapDescriptor.defaultMarker));
  }
}
