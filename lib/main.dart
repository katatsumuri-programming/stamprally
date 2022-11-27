import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stamprally/settings.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'mapPage.dart';
import 'pointListPage.dart';
import 'informationPage.dart';
import 'homePage.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

launchURL(url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not Launch $url';
  }
}

List markerPosition = [];
var box;
List nearCheck = [];
double mapZoom = 17;
List images = [];
int checknum = 0;

TileLayerOptions mapTile = TileLayerOptions(
  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  subdomains: ['a', 'b', 'c'],
);

Future<List> getLocation() async {
  List location = [0.0, 0.0];
  List markerDistance = [];
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  location = [position.latitude, position.longitude];
  // print(location);

  // print(markerPosition);
  for (var i = 0; i < markerPosition.length; i++) {
    List currentLocation = location;

    GeoPoint markerLocation = markerPosition[i]["point"];
    double distance = 6371000 *
        acos(cos(currentLocation[0] * pi / 180) *
                cos(markerLocation.latitude * pi / 180) *
                cos(markerLocation.longitude * pi / 180 -
                    currentLocation[1] * pi / 180) +
            sin(currentLocation[0] * pi / 180) *
                sin(markerLocation.latitude * pi / 180));
    // print(distance);
    markerDistance.add(distance);
  }
  return [location, markerDistance];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class Controller extends GetxController {
  //(1) 選択されたタブの番号
  var selected = 0.obs;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new Tab());
  }
}

class Tab extends StatefulWidget {
  const Tab({Key? key}) : super(key: key);

  @override
  State<Tab> createState() => _TabState();
}

class _TabState extends State<Tab> {
  String boxName = "stamprally";

  final PageController pager = PageController();
  var state = Get.put(Controller());
  var pageView = PageView();
  bool loading = true;

  void loadHive() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
    box = Hive.box(boxName);
    // print(box.isEmpty);
    if (box.isEmpty) {
      box.put("mapZoom", 17.0);
      for (var i = 0; i < markerPosition.length; i++) {
        box.put(markerPosition[i]["name"], false);
      }
    }
    mapZoom = box.get("mapZoom");
    // Map(box:box, markerPosition: markerPosition,);
    pageView = PageView(
        controller: pager,
        children: const [Home(), Map(), PointList(), SettingsPage()],
        onPageChanged: (int i) {
          state.selected.value = i;
        });
    loading = false;
    setState(() {});
    for (var i = 0; i < markerPosition.length; i++) {
      nearCheck.add(false);
    }
    initLocation();
  }

  void loadData() async {
    final snapshot = await FirebaseFirestore.instance.collection('point').get();
    FirebaseStorage storage = FirebaseStorage.instance;
    for (final data in snapshot.docs) {
      markerPosition.add(data.data());
    }
    for (var i = 0; i < markerPosition.length; i++) {
      Reference imageRef = storage.ref().child(markerPosition[i]["image"]);
      String imageUrl = await imageRef.getDownloadURL();
      images.add(imageUrl);
    }
    loadHive();
  }

  void initLocation() async {
    List<dynamic> locationResult = await getLocation();
    // print(locationResult[0]);
    for (var i = 0; i < locationResult[1].length; i++) {
      if (locationResult[1][i] <= 60) {
        if (nearCheck[i] == false &&
            box.get(markerPosition[i]["name"]) == false) {
          print("checkin");
          print(nearCheck);
          print(box.get(markerPosition[i]["name"]));
          nearCheck[i] = true;
          // print(nearCheck[i]);
          // print(markerPosition[i].runtimeType);
          if (infomationPageView == false) {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformationPage(num: i),
                  fullscreenDialog: true,
                ));
            // print(result);
            box.put(markerPosition[i]["name"], result);
            setState(() {});
          }
        }
        nearCheck[i] = true;
      } else {
        // print(nearCheck);
        nearCheck[i] = false;
      }
    }
    Future.delayed(const Duration(seconds: 2), () {
      initLocation();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "NotoSansJP",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            }),
      ),
      home: Stack(
        children: [
          Scaffold(
            body: pageView,
            bottomNavigationBar: Obx(() => BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "ホーム",
                    ),
                    BottomNavigationBarItem(icon: Icon(Icons.map), label: "地図"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.grid_view), label: "スタンプカード"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings), label: "設定"),
                  ],
                  currentIndex: state.selected.value,
                  onTap: (int i) {
                    state.selected.value = i;
                    pager.jumpToPage(i);
                  },
                )),
          ),
          Visibility(
            visible: loading,
            child: Scaffold(
              body: Center(
                child: Image.asset(
                  "images/icon.png",
                  width: 130,
                  height: 130,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
