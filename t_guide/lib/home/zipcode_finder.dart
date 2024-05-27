import 'dart:math';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart';

class ZipcodeFinder {
  Future<List<Location>?> locationFromAddressSafe(String address) async {
    try {
      final instance = GeocodingPlatform.instance;
      if (instance == null) {
        print('Geocoding platform instance is null');
        return null;
      }
      return await instance.locationFromAddress(address);
    } on PlatformException catch (e) {
      print('PlatformException: $e');
      return null;
    } catch (e) {
      print('Error in locationFromAddress: $e');
      return null;
    }
  }

  Future<Set<String>> findDifferentZipCodes(double lat, double lon, double radius) async {
    const double earthRadius = 6371.0; // Earth's radius in kilometers

    Set<String> zipCodes = {};

    while (zipCodes.length < 5 && radius <= 16.0934) { // Limit to 10 miles
      double latRadians = lat * (pi / 180);
      double lonRadians = lon * (pi / 180);

      double north = lat + (radius / earthRadius) * (180 / pi);
      double south = lat - (radius / earthRadius) * (180 / pi);
      double east = lon + (radius / earthRadius) * (180 / pi) / cos(latRadians);
      double west = lon - (radius / earthRadius) * (180 / pi) / cos(latRadians);

      try {
        List<Placemark> northPlacemarks = await placemarkFromCoordinates(north, lon);
        List<Placemark> southPlacemarks = await placemarkFromCoordinates(south, lon);
        List<Placemark> eastPlacemarks = await placemarkFromCoordinates(lat, east);
        List<Placemark> westPlacemarks = await placemarkFromCoordinates(lat, west);

        northPlacemarks.forEach((placemark) => zipCodes.add(placemark.postalCode ?? ''));
        southPlacemarks.forEach((placemark) => zipCodes.add(placemark.postalCode ?? ''));
        eastPlacemarks.forEach((placemark) => zipCodes.add(placemark.postalCode ?? ''));
        westPlacemarks.forEach((placemark) => zipCodes.add(placemark.postalCode ?? ''));
      } catch (e) {
        print('Error in fetching zip codes: $e');
      }

      if (zipCodes.length < 5) {
        radius += 1.60934; // Increase by 1 mile
        zipCodes.clear(); // Clear the set to retry with a larger radius
      }
    }

    return zipCodes;
  }
}
