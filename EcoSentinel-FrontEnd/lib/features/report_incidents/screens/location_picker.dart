// lib/features/report_incident/screens/location_picker.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/custom_button.dart';
import '../bloc/report_state.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng, String) onLocationSelected;

  const LocationPickerScreen({
    Key? key,
    this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _controller;
  LatLng? _selectedLocation;
  String _selectedAddress = '';
  bool _isLoading = false;
  bool _locationPermissionGranted = false;
  final loc.Location _location = loc.Location();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _checkLocationPermission();
    if (_selectedLocation != null) {
      _getAddressFromLatLng(_selectedLocation!);
      _updateMarker(_selectedLocation!);
    }
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    loc.PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _locationPermissionGranted = true;
    });
  }

  Future<void> _getCurrentLocation() async {
    if (!_locationPermissionGranted) {
      await _checkLocationPermission();
      if (!_locationPermissionGranted) return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final loc.LocationData locationData = await _location.getLocation();
      final LatLng currentLocation = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );

      setState(() {
        _selectedLocation = currentLocation;
        _isLoading = false;
      });

      _updateMarker(currentLocation);
      _getAddressFromLatLng(currentLocation);

      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, 16),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to get current location: $e');
    }
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];
        setState(() {
          _selectedAddress = _formatAddress(place);
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = 'Address not available';
      });
    }
  }

  String _formatAddress(Placemark place) {
    List<String> addressParts = [];

    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      addressParts.add(place.postalCode!);
    }

    return addressParts.join(', ');
  }

  void _updateMarker(LatLng location) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: location,
          infoWindow: InfoWindow(
            title: 'Selected Location',
            snippet: _selectedAddress,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };
    });
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _updateMarker(location);
    _getAddressFromLatLng(location);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.unRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: AppColors.unBlue,
        foregroundColor: AppColors.unWhite,
        actions: [
          TextButton(
            onPressed: _selectedLocation != null
                ? () {
                    widget.onLocationSelected(
                        _selectedLocation!, _selectedAddress);
                    Navigator.of(context).pop();
                  }
                : null,
            child: Text(
              'Done',
              style: TextStyle(
                color: _selectedLocation != null
                    ? AppColors.unWhite
                    : AppColors.unLightGray,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map View
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? const LatLng(0, 0),
              zoom: _selectedLocation != null ? 16 : 2,
            ),
            onTap: _onMapTap,
            markers: _markers,
            myLocationEnabled: _locationPermissionGranted,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
          ),

          // Current Location Button
          Positioned(
            right: 16,
            bottom: 200,
            child: FloatingActionButton(
              onPressed: _isLoading ? null : _getCurrentLocation,
              backgroundColor: AppColors.unBlue,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: AppColors.unWhite,
                      strokeWidth: 2,
                    )
                  : const Icon(
                      Icons.my_location,
                      color: AppColors.unWhite,
                    ),
            ),
          ),

          // Address Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 80,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.unBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Selected Location',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedAddress.isEmpty
                          ? 'Tap on the map to select a location'
                          : _selectedAddress,
                      style: AppTextStyles.bodySmall,
                    ),
                    if (_selectedLocation != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Coordinates: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Instructions
          if (_selectedLocation == null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: AppColors.unBlue.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.unWhite,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap on the map to select the incident location',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.unWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
