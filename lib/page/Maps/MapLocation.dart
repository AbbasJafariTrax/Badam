import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapsLocationPage extends StatefulWidget {
  final LatLng initialLocation;
  MapsLocationPage(
      {
      this.initialLocation = const LatLng(34.3471032, 62.1805806),
      Key key})
      : super(key: key);

  @override
  _MapsLocationPage createState() => _MapsLocationPage();
}

class _MapsLocationPage extends State<MapsLocationPage> {
  BitmapDescriptor pinLocationIcon;
  final LatLng initialLocation1 = new LatLng(34.3471032, 64.1805806);
  final LatLng initialLocation2 = new LatLng(33.3471032, 65.1805806);
  final LatLng initialLocation3 = new LatLng(33.3471032, 66.1805806);
  final LatLng initialLocation4 = new LatLng(31.3471032, 63.1805806);
  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/img/mapMarker.png');
  }

  @override
  Widget build(BuildContext context) {


    LatLng pinPosition = LatLng(37.3797536, -122.1017334);
   CameraPosition initialLocation = CameraPosition(
      zoom: 16,
      bearing: 30,
      target: pinPosition
   );


    return Expanded(
      // height: MediaQuery.of(context).size.height -300,//  alignment: Alignment.center,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        markers: {
          Marker(
              markerId: MarkerId("sada"),
              position: initialLocation2,
              icon: pinLocationIcon),
          Marker(
              markerId: MarkerId('location1'),
              position: initialLocation1,
              icon: pinLocationIcon),
          Marker(
              markerId: MarkerId('location4'),
              position: initialLocation4,
              icon: pinLocationIcon),
          Marker(
              markerId: MarkerId('location3'),
              position: initialLocation3,
              icon: pinLocationIcon),
          Marker(
            markerId: MarkerId('Location'),
            position: widget.initialLocation,
          ),
        },
      ),
    );
  }
}
