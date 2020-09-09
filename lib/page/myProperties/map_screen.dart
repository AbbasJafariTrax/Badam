import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  final LatLng initialLocation;
  bool isSelecting;

  MapScreen({ this.initialLocation = const LatLng(0, 0), this.isSelecting = false,Key key}): super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  void initState() {
    _pickedLocation = widget.initialLocation;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

   
    return Scaffold(
      appBar: AppBar(
        title: Text('انتخاب موقعیت'),
        actions: <Widget>[
          if (widget.isSelecting)
            FlatButton(
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    
                    FaIcon(
                      FontAwesomeIcons.check,
                      color: Colors.white,
                    ),
                    
                  ],
                ),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: (data){
           setState(() {
              widget.isSelecting = true;
              _pickedLocation = data;

           });
        },
        markers: _pickedLocation == null
            ? null
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation,
                ),
              },
      ),
    );
  }
}
