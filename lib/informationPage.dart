import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:confetti/confetti.dart';
import 'main.dart';
import 'dart:math';

bool infomationPageView = false;

class InformationPage extends StatefulWidget {
  final int num;

  const InformationPage({Key? key, required this.num}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  var info = {};
  var check = false;
  var near = false;
  var num = 0;
  bool _isShowing = false;
  final _controllerConfetti =
      ConfettiController(duration: const Duration(seconds: 1));

  // info:markerPosition[i], check: box.get(markerPosition[i]["name"]), nearCheck: nearCheck[i]
  Color color = Colors.black;
  Color completeColor = Colors.black;
  var icon = Icons.abc;

  @override
  void initState() {
    super.initState();
    infomationPageView = true;
    num = widget.num;
    info = markerPosition[num];
    check = box.get(markerPosition[num]["name"]);
    near = nearCheck[num];
    switch (info["type"]) {
      case "facility":
        color = Colors.blue;
        completeColor = color;
        icon = Icons.domain;
        break;
      case "park":
        color = Colors.green;
        completeColor = color;
        icon = Icons.park;
        break;
      case "shrinesAndTemples":
        color = Colors.amber;
        completeColor = color;
        icon = Icons.temple_buddhist;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        infomationPageView = false;
        // 第2引数に渡す値を設定
        Navigator.pop(context, check);
        return Future.value(false);
      },
      child: Stack(children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Row(
              children: [
                Text(info['name']),
                const SizedBox(width: 10),
                Text(
                  check ? "★" : "",
                  style: const TextStyle(color: Colors.yellow, fontSize: 20),
                )
              ],
            ),
            backgroundColor: color,
            elevation: 0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Image.network(images[num]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                info["name"],
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                check ? "★" : "",
                                style: const TextStyle(
                                    color: Colors.yellow, fontSize: 20),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(info['info']),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "チェック",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      onPressed: !(near && !(check))
                          ? null
                          : () {
                              // print("checked");
                              check = true;
                              checknum++;
                              print(info);
                              var sameCategorycheckedNum = 0;
                              var sameCategoryNum = 0;
                              var checkedNum = 0;
                              for (int i = 0; i < markerPosition.length; i++) {
                                if (info["type"] == markerPosition[i]["type"] &&
                                    !(info["name"] ==
                                        markerPosition[i]["name"])) {
                                  if (box.get(markerPosition[i]["name"])) {
                                    sameCategorycheckedNum++;
                                  }
                                  sameCategoryNum++;
                                }
                                if (box.get(markerPosition[i]["name"])) {
                                  checkedNum++;
                                }
                              }
                              print(sameCategorycheckedNum);
                              print(sameCategoryNum);
                              print(checkedNum);
                              print(markerPosition.length);
                              if (sameCategorycheckedNum == sameCategoryNum) {
                                setState(() {
                                  _isShowing = true;
                                });
                                _controllerConfetti.play();

                                Future.delayed(const Duration(seconds: 2), () {
                                  _isShowing = false;
                                  setState(() {});
                                  if ((markerPosition.length - 1) ==
                                      checkedNum) {
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      icon = Icons.verified;
                                      completeColor = Colors.purple;

                                      setState(() {
                                        _isShowing = true;
                                      });
                                      _controllerConfetti.play();
                                      Future.delayed(const Duration(seconds: 4),
                                          () {
                                        _isShowing = false;
                                        setState(() {});
                                      });
                                    });
                                  }
                                });
                              }
                              setState(() {});
                            },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.location_pin),
                          title: Text(
                            info["address"],
                            style: const TextStyle(fontSize: 13),
                          ),
                          onTap: () {
                            launchURL(info["mapUrl"]);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.web),
                          title: Text(
                            info["webSiteUrl"],
                            style: const TextStyle(fontSize: 13),
                          ),
                          onTap: () {
                            launchURL(info["webSiteUrl"]);
                          },
                        ),
                        Visibility(
                          child: ListTile(
                            leading: const Icon(Icons.currency_yen),
                            title: Text(
                              info["admission"].replaceAll('\\n', '\n'),
                              style: const TextStyle(fontSize: 13),
                            ),
                            onTap: () {},
                          ),
                          visible: info["admission"] != "",
                        ),
                        Visibility(
                          child: ListTile(
                            leading: const Icon(Icons.access_time),
                            title: Text(
                              info["openingHours"].replaceAll('\\n', '\n'),
                              style: const TextStyle(fontSize: 13),
                            ),
                            onTap: () {},
                          ),
                          visible: info["admission"] != "",
                        ),
                        const Divider(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Stack(children: [
            Center(
              child: ConfettiWidget(
                confettiController: _controllerConfetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 100,
                colors: const [
                  Colors.green,
                  Colors.pink,
                  Colors.orange,
                  Colors.yellow,
                  Colors.blue
                ],
              ),
            ),
            Center(
              child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.ease,
                  decoration: BoxDecoration(
                    border: Border.all(color: color, width: 5),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  width: _isShowing ? 300 : 0,
                  height: _isShowing ? 300 : 0,
                  child: Center(
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                          opacity: _isShowing ? 1.0 : 0.0,
                          duration: const Duration(seconds: 1),
                          child: Stack(children: [
                            for (int i = 0; i < 10; i++) ...{
                              Align(
                                  alignment: Alignment(
                                      Random().nextBool()
                                          ? Random().nextDouble() * 1
                                          : Random().nextDouble() * -1,
                                      Random().nextBool()
                                          ? Random().nextDouble() * 1
                                          : Random().nextDouble() * -1),
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: Colors.yellow,
                                    size: _isShowing ? 60 : 0,
                                  )),
                              Align(
                                  alignment: Alignment(
                                      Random().nextBool()
                                          ? Random().nextDouble() * 1
                                          : Random().nextDouble() * -1,
                                      Random().nextBool()
                                          ? Random().nextDouble() * 1
                                          : Random().nextDouble() * -1),
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.orange,
                                    size: _isShowing ? 20 : 0,
                                  )),
                              Align(
                                  alignment: Alignment(
                                      Random().nextBool()
                                          ? Random().nextDouble() * 1
                                          : Random().nextDouble() * -1,
                                      Random().nextBool()
                                          ? Random().nextDouble() * 1
                                          : Random().nextDouble() * -1),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.pink[200],
                                    size: _isShowing ? 30 : 0,
                                  ))
                            }
                          ]),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedOpacity(
                                opacity: _isShowing ? 1.0 : 0.0,
                                duration: const Duration(seconds: 1),
                                child: Icon(
                                  icon,
                                  size: _isShowing ? 80 : 0,
                                  color: completeColor,
                                ),
                              ),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(seconds: 1),
                                curve: Curves.ease,
                                style: TextStyle(
                                  fontSize: _isShowing ? 30 : 0,
                                  color: completeColor,
                                ),
                                child: const Center(
                                  child: Text(
                                    'Complete',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ]),
        ),
      ]),
    );
  }
}
