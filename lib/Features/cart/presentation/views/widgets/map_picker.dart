import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/show_message.dart' show ShowMessage;
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng selectedLocation = const LatLng(29.574217686990803, 31.289961721105982); // Default location
  String address = '';

  final MapController _mapController = MapController();
  final Location _location = Location();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> searchResults = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _goToCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize address with localized string after context is ready
    address = S.of(context).loading_location;
    setState(() {}); // Update state to reflect the initialized address
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${latLng.latitude}&lon=${latLng.longitude}&accept-language=${S.of(context).localeName}',
    );

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'ECommerceApp (hk3648345@email.com)',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          address = data['display_name'] ?? S.of(context).failed_to_fetch_address;
        });
      } else {
        setState(() {
          address = S.of(context).failed_to_fetch_address;
        });
      }
    } catch (e) {
      setState(() {
        address = S.of(context).failed_to_fetch_address;
      });
    }
  }

  Future<void> _goToCurrentLocation() async {
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

    final locationData = await _location.getLocation();

    if (locationData.latitude != null && locationData.longitude != null) {
      final current = LatLng(locationData.latitude!, locationData.longitude!);
      if (!mounted) return;
      setState(() {
        selectedLocation = current;
      });
      _mapController.move(current, 17.0);
      _getAddressFromLatLng(current);
    }
  }

  void _zoomIn() {
    final zoom = _mapController.camera.zoom;
    if (zoom < 18) {
      _mapController.move(_mapController.camera.center, zoom + 1);
    }
  }

  void _zoomOut() {
    final zoom = _mapController.camera.zoom;
    if (zoom > 3) {
      _mapController.move(_mapController.camera.center, zoom - 1);
    }
  }

  void _onConfirm() {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${selectedLocation.latitude},${selectedLocation.longitude}';
    if (address != S.of(context).loading_location) {
      Navigator.pop(context, {
        'address': address,
        'url': url,
        'lat': selectedLocation.latitude,
        'lng': selectedLocation.longitude,
      });
    } else {
      ShowMessage.showToast(
        S.of(context).please_wait_for_location,
        backgroundColor: Colors.green,
      );
    }
  }

  Future<void> _searchPlace(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&accept-language=${S.of(context).localeName}&limit=5');

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'ECommerceApp (your@email.com)',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          searchResults = data.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    } catch (e) {
      setState(() {
        searchResults.clear();
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPlace(query);
    });
  }

  void _selectSearchResult(Map<String, dynamic> result) {
    final lat = double.parse(result['lat']);
    final lon = double.parse(result['lon']);
    final name = result['display_name'];

    final newLocation = LatLng(lat, lon);
    setState(() {
      selectedLocation = newLocation;
      address = name;
      searchResults.clear();
      _searchController.clear();
      _searchController.text = address;
    });
    _mapController.move(newLocation, 17.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: selectedLocation,
              initialZoom: 17.0,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedLocation = point;
                  searchResults.clear();
                  _searchController.clear();
                });
                _getAddressFromLatLng(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yourcompany.ecommerceapp',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Search bar and results
          Positioned(
            top: 25,
            left: 12,
            right: 12,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      style: const TextStyle(color: Colors.black),
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),

                        hintText: S.of(context).search_for_location,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: _onSearchChanged,
                    ),
                    if (searchResults.isNotEmpty)
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: searchResults.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final result = searchResults[index];
                            return ListTile(
                              title: Text(
                                result['display_name'],
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => _selectSearchResult(result),
                            );
                          },
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),

          // Address and confirm button at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.transparent,
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    address,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _onConfirm,
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: Text(
                        S.of(context).confirm_location,
                        style: AppStyles.semiBold18(context),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 12,
            top: context.mediaQuery.size.height / 2,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoomIn",
                  onPressed: _zoomIn,
                  mini: true,
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  onPressed: _zoomOut,
                  mini: true,
                  child: const Icon(Icons.zoom_out),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "currentLocation",
                  onPressed: _goToCurrentLocation,
                  mini: true,
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}