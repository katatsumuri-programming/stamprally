import 'package:flutter/material.dart';
import 'main.dart';
import 'informationPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categoryIconsList = [];
  List categoryColorsList = [];
  var categoryNameList = {};

  @override
  void initState() {
    super.initState();

    checknum = 0;
    for (var i = 0; i < markerPosition.length; i++) {
      if (box.get(markerPosition[i]["name"]) == true) {
        checknum++;
      }
      switch (markerPosition[i]["type"]) {
        case "park":
          if (!categoryNameList.containsKey("park")) {
            categoryIconsList.add(Icons.park);
            categoryColorsList.add(Colors.green);

            categoryNameList["park"] = "公園・自然";
          }
          break;
        case "facility":
          if (!categoryNameList.containsKey("facility")) {
            categoryIconsList.add(Icons.domain);
            categoryColorsList.add(Colors.blue);
            categoryNameList["facility"] = "施設";
          }
          break;
        case "shrinesAndTemples":
          if (!categoryNameList.containsKey("shrinesAndTemples")) {
            categoryIconsList.add(Icons.temple_buddhist);
            categoryColorsList.add(Colors.amber);
            categoryNameList["shrinesAndTemples"] = "社寺仏閣";
          }
          break;
        default:
          categoryIconsList.add(Icons.abc);
          categoryColorsList.add(Colors.black);
          break;
      }
    }
    // print(categoryNameList.keys.toList());
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1.0,
                      blurRadius: 10.0,
                    )
                  ],
                ),
                width: double.infinity,
                height: 150,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        checknum.toString(),
                        style:
                            const TextStyle(fontSize: 60, color: Colors.blue),
                      ),
                      Text(
                        "/" + markerPosition.length.toString(),
                        style: const TextStyle(fontSize: 40),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(children: [
                for (var i = 0; i < categoryNameList.length; i++) ...[
                  Container(
                    width: double.infinity,
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: Icon(
                          categoryIconsList[i],
                          color: categoryColorsList[i],
                        ),
                        title: Text(
                          categoryNameList[categoryNameList.keys.toList()[i]],
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParkListPage(
                                    categoryType:
                                        categoryNameList.keys.toList()[i],
                                    categoryName: categoryNameList[
                                        categoryNameList.keys.toList()[i]]),
                              ));
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ]
              ]),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParkListPage extends StatefulWidget {
  final String categoryType;
  final String categoryName;

  const ParkListPage(
      {Key? key, required this.categoryType, required this.categoryName})
      : super(key: key);

  @override
  State<ParkListPage> createState() => _ParkListPageState();
}

class _ParkListPageState extends State<ParkListPage> {
  String categoryType = "";
  String categoryName = "";
  List categoryWidgetNum = [];

  @override
  void initState() {
    super.initState();
    categoryType = widget.categoryType;
    for (var i = 0; i < markerPosition.length; i++) {
      if (markerPosition[i]["type"] == categoryType) {
        categoryWidgetNum.add(i);
      }
    }
    // print(categoryType);
    categoryName = widget.categoryName;
    // print(categoryWidgetNum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(children: [
            for (var i = 0; i < categoryWidgetNum.length; i++) ...[
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: ListTile(
                    leading: ClipOval(
                      child: Image.network(
                        images[categoryWidgetNum[i]],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      markerPosition[categoryWidgetNum[i]]["name"],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InformationPage(num: categoryWidgetNum[i]),
                            fullscreenDialog: true,
                          ));
                      // print(result);
                      box.put(
                          markerPosition[categoryWidgetNum[i]]["name"], result);
                      setState(() {});
                    },
                  ),
                ),
              ),
            ]
          ]),
        ),
      ),
    );
  }
}
