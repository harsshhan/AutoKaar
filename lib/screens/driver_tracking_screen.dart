import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverTrackingScreen extends StatefulWidget {
  final LatLng driverLocation;
  final String otp;
  final LatLng pickupLocation;
  final LatLng dropLocation;

  DriverTrackingScreen({
    required this.driverLocation, 
    required this.otp,
    required this.pickupLocation,
    required this.dropLocation,
  });

  @override
  _DriverTrackingScreenState createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = true;
  Location _location = Location();
  LatLng? _userLocation;
  String _distance = '';
  String _duration = '';
  final String _googleMapsApiKey = 'AIzaSyAvibCYQuoqU1BNqfWV0QkTXvT39-Wz954';

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _location.onLocationChanged.listen((LocationData locationData) {
      if (!mounted || locationData.latitude == null || locationData.longitude == null) return;

      setState(() {
        _userLocation = LatLng(locationData.latitude!, locationData.longitude!);
        _updateMarkers();
        _fetchRoute(_userLocation!, widget.driverLocation);
      });
    });
  }

  Future<void> _loadCustomMarker() async {
    final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/auto.png',
    );

    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId('driver'),
          position: widget.driverLocation,
          infoWindow: InfoWindow(title: 'Driver Location'),
          icon: customIcon,
        ),
        Marker(
          markerId: MarkerId('pickup'),
          position: widget.pickupLocation,
          infoWindow: InfoWindow(title: 'Pickup Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
        Marker(
          markerId: MarkerId('drop'),
          position: widget.dropLocation,
          infoWindow: InfoWindow(title: 'Drop Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
      _isLoading = false;
    });
  }

  Future<void> _fetchRoute(LatLng origin, LatLng destination) async {
    final String url = 'https://routes.googleapis.com/directions/v2:computeRoutes';

    final Map<String, dynamic> requestBody = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": origin.latitude,
            "longitude": origin.longitude,
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": destination.latitude,
            "longitude": destination.longitude,
          }
        }
      },
      "travelMode": "DRIVE",
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _googleMapsApiKey,
        'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters,routes.polyline',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final polyline = data['routes'][0]['polyline']['encodedPolyline'];
        final duration = data['routes'][0]['duration'] ?? '0s';
        final distance = data['routes'][0]['distanceMeters'] ?? 0;

        setState(() {
          _distance = '${(distance / 1000).toStringAsFixed(1)} km';
          _duration = _formatDuration(duration);
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: _decodePolyline(polyline),
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      }
    }
  }

  String _formatDuration(String duration) {
    final seconds = int.tryParse(duration.replaceAll('s', '')) ?? 0;

    if (seconds < 60) {
      return '$seconds seconds';
    } else if (seconds < 3600) {
      final minutes = (seconds / 60).round();
      return '$minutes mins';
    } else {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).round();
      return '$hours hour${hours > 1 ? 's' : ''} $minutes mins';
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _updateMarkers() {
    if (!mounted) return;

    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId('driver'),
          position: widget.driverLocation,
          infoWindow: InfoWindow(title: 'Driver Location'),
          icon: _markers.first.icon, // Keep the custom icon
        ),
        Marker(
          markerId: MarkerId('pickup'),
          position: widget.pickupLocation,
          infoWindow: InfoWindow(title: 'Pickup Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
        Marker(
          markerId: MarkerId('drop'),
          position: widget.dropLocation,
          infoWindow: InfoWindow(title: 'Drop Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        if (_userLocation != null)
          Marker(
            markerId: MarkerId('user'),
            position: _userLocation!,
            infoWindow: InfoWindow(title: 'Your Location'),
          ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Tracking'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: widget.driverLocation,
                          zoom: 14,
                        ),
                        markers: _markers,
                        polylines: _polylines,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Distance to Driver: $_distance'),
                              Text('Estimated Time: $_duration'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('OTP: ${widget.otp}', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
}