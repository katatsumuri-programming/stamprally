import 'package:flutter/material.dart';
import 'informationPage.dart';
import 'main.dart';

class PointList extends StatefulWidget {
  const PointList({Key? key}) : super(key: key);

  @override
  State<PointList> createState() => _PointListState();
}

class _PointListState extends State<PointList> {
  List<Color> colorList = [];

  @override
  void initState() {
    super.initState();

    // print(nearCheck);

    for (var i = 0; i < markerPosition.length; i++) {
      switch (markerPosition[i]["type"]) {
        case "facility":
          colorList.add(Colors.blue);
          break;
        case "park":
          colorList.add(Colors.green);
          break;
        case "shrinesAndTemples":
          colorList.add(Colors.amber);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            for (var i = 0; i < markerPosition.length; i++) ...[
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1.0,
                            blurRadius: 10.0,
                          )
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              Image.network(images[i]),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    markerPosition[i]["name"],
                                    style: TextStyle(
                                      fontSize: deviceWidth * 0.05,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Visibility(
                            child: FractionallySizedBox(
                              widthFactor: 1,
                              heightFactor: 1,
                              child: Container(
                                width: 30,
                                color: colorList[i].withOpacity(0.2),
                                child: Visibility(
                                  child: Icon(
                                    Icons.check,
                                    color: colorList[i],
                                    size: 40,
                                  ),
                                  visible: true,
                                ),
                              ),
                            ),
                            visible: box.get(markerPosition[i]["name"]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationPage(num: i),
                          fullscreenDialog: true,
                        ));
                    // print(result);
                    box.put(markerPosition[i]["name"], result);
                    setState(() {});
                  },
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
