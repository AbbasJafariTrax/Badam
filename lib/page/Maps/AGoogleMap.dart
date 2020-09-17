import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AGoogleMap extends StatefulWidget {
  static String routeName = 'a_google_map';

  @override
  _AGoogleMapState createState() => _AGoogleMapState();
}

class _AGoogleMapState extends State<AGoogleMap> {
  Completer<GoogleMapController> controller1;
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition;
  int counter = 1;
  LatLng propertyLatLng = null;

  MapType _currentMapType = MapType.normal;

  List<MapType> _listMapType = [
    MapType.satellite,
    MapType.normal,
    MapType.hybrid,
    MapType.terrain,
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  void _onMapTypeButtonPressed() {
    if (counter < 3) {
      setState(() {
        _currentMapType = _listMapType[counter];
        counter++;
      });
    } else {
      counter = 0;
    }
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Widget mapButton(Function function, Icon icon) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      fillColor: Colors.green,
      shape: new CircleBorder(),
      elevation: 2.0,
      padding: const EdgeInsets.all(7.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("data")),
      body: _initialPosition == null
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                    fontFamily: 'Avenir-Medium',
                    color: Colors.grey[400],
                  ),
                ),
              ),
            )
          : Container(
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    onTap: (onTapLatLong) {
                      setState(() {
                        _markers.clear();
                        _markers.add(
                          Marker(
                            markerId: MarkerId("id"),
                            position: LatLng(
                              onTapLatLong.latitude,
                              onTapLatLong.longitude,
                            ),
                          ),
                        );
                      });
                      propertyLatLng = new LatLng(
                        onTapLatLong.latitude,
                        onTapLatLong.longitude,
                      );
                    },
                    markers: _markers,
                    mapType: _currentMapType,
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 16,
                    ),
                    onMapCreated: _onMapCreated,
                    zoomGesturesEnabled: true,
                    onCameraMove: _onCameraMove,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    myLocationButtonEnabled: false,
                  ),
                  mapButton(
                    _onMapTypeButtonPressed,
                    Icon(Icons.map, color: Colors.white),
                  ),
                  Positioned.fill(
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        child: Text(
                          "ثبت موقعیت",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(
                            context,
                            propertyLatLng,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
