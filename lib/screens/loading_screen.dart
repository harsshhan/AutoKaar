import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'driver_tracking_screen.dart'; // Import the DriverTrackingScreen
import 'dart:math';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final SupabaseClient _client = Supabase.instance.client;
  bool _isLoading = true;
  int? _requestId; // Store the ride request ID

  @override
  void initState() {
    super.initState();
    _fetchLatestRideRequestId(); // Fetch the latest ride request ID
  }

  // Fetch the latest ride request ID for the current user
  Future<void> _fetchLatestRideRequestId() async {
    try {
      // Replace `3` with the actual user ID
      final response = await _client
          .from('ride_request')
          .select('id')
          .eq('user_id', 3) // Filter by user ID
          .order('created_at', ascending: false) // Get the latest request
          .limit(1)
          .maybeSingle();

      if (response != null) {
        setState(() {
          _requestId = response['id']; // Store the request ID
        });

        // Start checking the ride request status
        _checkRideRequestStatus();
      }
    } catch (e) {
      print('Error fetching latest ride request ID: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch ride request details. Please try again.')),
      );
    }
  }

  // Check the status of the ride request periodically
  Future<void> _checkRideRequestStatus() async {
    while (_isLoading && _requestId != null) {
      final rideRequest = await _checkRideRequestStatusInDB(_requestId!);

      if (rideRequest != null && rideRequest['ride_accepted'] == true) {
        final driverDetails = await _fetchDriverDetailsInDB(_requestId!);

        if (driverDetails != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DriverTrackingScreen(
                driverLocation: LatLng(
                  driverDetails['latitude'] ?? 0.0,
                  driverDetails['longitude'] ?? 0.0,
                ),
                otp: driverDetails['otp'],
                pickupLocation: LatLng(
                  driverDetails['pick_up_lat'] ?? 0.0,
                  driverDetails['pick_up_lng'] ?? 0.0,
                ),
                dropLocation: LatLng(
                  driverDetails['drop_lat'] ?? 0.0,
                  driverDetails['drop_lng'] ?? 0.0,
                ),
              ),
            ),
          );
          break;
        }
      }

      await Future.delayed(Duration(seconds: 5));
    }
  }

  // Check if a ride request has been accepted by a driver
  Future<Map<String, dynamic>?> _checkRideRequestStatusInDB(int requestId) async {
    try {
      // Fetch the ride status from the ridestatus table
      final response = await _client
          .from('ridestatus')
          .select('ride_accepted, ride_cancelled, req_status')
          .eq('requestid', requestId)
          .maybeSingle(); // Use maybeSingle() instead of single()

      // If no rows are returned or ride not accepted, return null
      if (response == null || response['ride_accepted'] != true) {
        return null;
      }

      return response;
    } catch (e) {
      print('Error checking ride request status: $e');
      return null;
    }
  }

  // Fetch driver details and OTP for an accepted ride request
  Future<Map<String, dynamic>?> _fetchDriverDetailsInDB(int requestId) async {
    try {
      final statusResponse = await _client
          .from('ridestatus')
          .select('driverid')
          .eq('requestid', requestId)
          .maybeSingle();

      if (statusResponse == null) {
        return null;
      }

      final driverId = statusResponse['driverid'];

      final requestResponse = await _client
          .from('ride_request')
          .select('otp, pick_up_lat, pick_up_lng, drop_lat, drop_lng')
          .eq('id', requestId)
          .maybeSingle();

      if (requestResponse == null) {
        return null;
      }

      final driverDetails = await _client
          .from('driver')
          .select('drivername, phoneno, latitude, longitude')
          .eq('driverid', driverId)
          .maybeSingle();

      if (driverDetails == null) {
        return null;
      }

      return {
        ...driverDetails,
        'otp': requestResponse['otp'],
        'pick_up_lat': requestResponse['pick_up_lat'],
        'pick_up_lng': requestResponse['pick_up_lng'],
        'drop_lat': requestResponse['drop_lat'],
        'drop_lng': requestResponse['drop_lng'],
      };
    } catch (e) {
      print('Error fetching driver details: $e');
      return null;
    }
  }

  // Insert a new ride request with OTP
  Future<void> _insertRideRequest({
    required int userId,
    required String userName,
    required String userPhno,
    required double pickUpLat,
    required double pickUpLng,
    required double dropLat,
    required double dropLng,
    required String dropAddress,
    required String pickupAddress,
  }) async {
    try {
      // Generate a random 6-digit OTP
      final otp = _generateOTP();

      await _client.from('ride_request').insert({
        'user_id': userId,
        'user_name': userName,
        'user_phno': userPhno,
        'pick_up_lat': pickUpLat,
        'pick_up_lng': pickUpLng,
        'drop_lat': dropLat,
        'drop_lng': dropLng,
        'drop_address': dropAddress,
        'pick_up_address': pickupAddress,
        'otp': otp, // Store the OTP in the database
      });
    } catch (e) {
      print('Error inserting ride request: $e');
      rethrow;
    }
  }

  // Generate a random 6-digit OTP
  String _generateOTP() {
    final random = Random();
    final otp = 100000 + random.nextInt(900000); // Generates a number between 100000 and 999999
    return otp.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Loading spinner
            SizedBox(height: 20), // Spacing
            Text(
              'Waiting for a driver to accept your ride...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}