import 'package:flutter/material.dart';
import 'main.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:flutter_map/flutter_map.dart';
import 'informationPage.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  var mapState = MyApp();
  List<Marker> markers = [];
  List<CircleMarker> circleMarkers = [];
  MapController mapController = MapController();
  List location = [0.0, 0.0];

  bool traking = false;
  List<CircleMarker> currentLocationMarkers = [
    CircleMarker(
      color: Colors.indigo.withOpacity(0.9),
      radius: 10,
      borderColor: Colors.white.withOpacity(0.9),
      borderStrokeWidth: 3,
      point: latLng.LatLng(0.0, 0.0),
    )
  ];
  void initCircleMarker(double latitude, double longitude) {
    CircleMarker circleMarler = CircleMarker(
      color: Colors.indigo.withOpacity(0.9),
      radius: 10,
      borderColor: Colors.white.withOpacity(0.9),
      borderStrokeWidth: 3,
      point: latLng.LatLng(latitude, longitude),
    );
    currentLocationMarkers[0] = circleMarler;
  }

  void getLocationMap() async {
    List<dynamic> locationResult = await getLocation();

    initCircleMarker(locationResult[0][0], locationResult[0][1]);

    if (traking == true) {
      try {
        mapController.move(
            latLng.LatLng(locationResult[0][0], locationResult[0][1]), mapZoom);
      } catch (e) {
        // pass
      }
    }
    try {
      setState(() {});
    } catch (e) {
      // pass
    }
  }

  void initLocation() async {
    getLocationMap();
    Future.delayed(Duration(seconds: 2), () {
      initLocation();
    });
  }

  @override
  void initState() {
    super.initState();
    mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveStart) {
        traking = false;
        // print("user moved.");
      }
    });

    // print(markerPosition);
    // print(box);
    for (var i = 0; i < markerPosition.length; i++) {
      initMarker(i);
    }

    traking = true;

    initLocation();
  }

  void initMarker(i) {
    Color iconcolor = Colors.black;
    Icon icon = const Icon(Icons.abc);
    // print(i);
    // print(markerPosition[i]);
    switch (markerPosition[i]["type"]) {
      case "facility":
        iconcolor = Colors.blue;
        icon = const Icon(Icons.domain);
        break;
      case "park":
        iconcolor = Colors.green;
        icon = const Icon(Icons.park);
        break;
      case "shrinesAndTemples":
        iconcolor = Colors.amber;
        icon = const Icon(Icons.temple_buddhist);
        break;
    }
    Marker marker = Marker(
        point: latLng.LatLng(markerPosition[i]["point"].latitude,
            markerPosition[i]["point"].longitude),
        rotate: true,
        rotateAlignment: Alignment.center,
        width: 60,
        height: 60,
        builder: (context) {
          return IconButton(
            icon: box.get(markerPosition[i]["name"])
                ? const Icon(Icons.check)
                : icon,
            iconSize: 30,
            color: iconcolor,
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InformationPage(num: i),
                    fullscreenDialog: true,
                  ));
              // print(result);
              box.put(markerPosition[i]["name"], result);
              // print(box.get(markerPosition[i]["name"]));
              setState(() {});
            },
          );
        });
    CircleMarker circleMarker = CircleMarker(
        point: latLng.LatLng(markerPosition[i]["point"].latitude,
            markerPosition[i]["point"].longitude),
        useRadiusInMeter: true,
        radius: 60,
        color: iconcolor.withOpacity(0.2));
    markers.add(marker);
    circleMarkers.add(circleMarker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'images/appBarImage.png',
          fit: BoxFit.contain,
          height: 50,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: latLng.LatLng(0.0, 0.0),
          zoom: 16,
          maxZoom: 17,
          minZoom: 5,
        ),
        layers: [
          mapTile,
          CircleLayerOptions(
            circles: circleMarkers,
          ),
          CircleLayerOptions(
            circles: currentLocationMarkers,
          ),
          MarkerLayerOptions(
            markers: markers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          traking = true;
          getLocationMap();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
