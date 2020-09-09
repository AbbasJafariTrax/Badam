import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapsProperties extends StatefulWidget {
  final LatLng initialLocation;
 
  MapsProperties({ this.initialLocation = const LatLng(0, 0),Key key}): super(key: key);

  @override
  _MapsPropertiesState createState() => _MapsPropertiesState();
}


class _MapsPropertiesState extends State<MapsProperties> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

   
    return  Expanded(
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
                    markerId: MarkerId('Location'),
                    position: widget.initialLocation,
                  ),
              },
            ),
    );
  }
}
