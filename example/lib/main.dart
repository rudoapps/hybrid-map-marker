import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hybrid_map_marker/hybrid_map_marker.dart';
import 'package:hybrid_map_marker/hybrid_map_marker_impl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final HybridMapMarker _hybridMapMarker = HybridMapMarkerImpl.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _map(),
      ),
    );
  }

  Widget _map() {
    final position = const LatLng(39.481785683754346, -0.35585001671455546);
    return FutureBuilder<Set<Marker>>(
      future: _createMarkers(),
      builder: (context, snapshot) {
        return GoogleMap(
          compassEnabled: false,
          myLocationButtonEnabled: false,
          markers: snapshot.data ?? {},
          initialCameraPosition: CameraPosition(
            zoom: 17,
            target: position,
          ),
        );
      },
    );
  }

  Widget _circleMarker({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
      ),
      child: Container(
        clipBehavior: .antiAlias,
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }

  Widget _locationMarker() {
    return _circleMarker(
      child: Icon(Icons.location_on_outlined, color: Colors.white, size: 38),
    );
  }

  Widget _svgMarker() {
    return _circleMarker(
      child: SvgPicture.asset(
        'assets/user.svg',
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  Widget _jpgImageMarker() {
    return _circleMarker(
      child: Image.asset(
        'assets/bird.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _pngImageMarker() {
    return _circleMarker(
      child: Image.asset(
        'assets/bird.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _networkImageMarker() {
    return _circleMarker(
      child: Image.network(
        'https://docs.flutter.dev/assets/images/dash/Dash.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _cacheAssets() async {
    await Future.wait([
      _hybridMapMarker.cacheSvg(path: 'assets/user.svg'),
      _hybridMapMarker.cacheImage(path: 'assets/bird.jpg'),
      _hybridMapMarker.cacheImage(path: 'assets/bird.png'),
      _hybridMapMarker.cacheNetworkImage(
        path: 'https://docs.flutter.dev/assets/images/dash/Dash.png',
      ),
    ]);
  }

  Future<Set<Marker>> _createMarkers() async {
    await _cacheAssets();

    final size = const Size(64, 64);
    final locationIcon = await _hybridMapMarker.createIcon(
      _locationMarker(),
      size: size,
    );
    final svgIcon = await _hybridMapMarker.createIcon(_svgMarker(), size: size);
    final jpgIcon = await _hybridMapMarker.createIcon(
      _jpgImageMarker(),
      size: size,
    );
    final pngIcon = await _hybridMapMarker.createIcon(
      _pngImageMarker(),
      size: size,
    );
    final networkIcon = await _hybridMapMarker.createIcon(
      _networkImageMarker(),
      size: size,
    );

    return {
      Marker(
        infoWindow: InfoWindow(title: 'Location Marker'),
        markerId: MarkerId('location'),
        position: const LatLng(39.481785683754346, -0.35585001671455546),
        icon: locationIcon,
      ),
      Marker(
        infoWindow: InfoWindow(title: 'SVG Marker'),
        markerId: MarkerId('svg'),
        position: const LatLng(39.482232741106344, -0.3567805203800181),
        icon: svgIcon,
      ),
      Marker(
        infoWindow: InfoWindow(title: 'JPG Marker'),
        markerId: MarkerId('jpg'),
        position: const LatLng(39.479932432434474, -0.3556799773645045),
        icon: jpgIcon,
      ),
      Marker(
        infoWindow: InfoWindow(title: 'PNG Marker'),
        markerId: MarkerId('png'),
        position: const LatLng(39.48056070220794, -0.35663411718664756),
        icon: pngIcon,
      ),
      Marker(
        infoWindow: InfoWindow(title: 'Network Marker'),
        markerId: MarkerId('network'),
        position: const LatLng(39.481361447965654, -0.3557271053898057),
        icon: networkIcon,
      ),
    };
  }
}
