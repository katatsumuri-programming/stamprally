import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
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
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  title: const Text("利用規約"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TeamsOfService()),
                    );
                  },
                ),
                Visibility(
                  visible: !kIsWeb,
                  child: Column(
                    children: [
                      const Divider(),
                      ListTile(
                        title: const Text("このアプリについて"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AppInfo()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                    title: const Text("お問い合わせ"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      if (!kIsWeb) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InquiryPage()),
                        );
                      } else {
                        launchURL(
                            'https://docs.google.com/forms/d/e/1FAIpQLScNARfIhrl2UG9L7U59x6tnjUgevGmZWTFDr7hBz4VWaa5m1g/viewform?usp=sf_link');
                      }
                    }),
                const Divider(),
                ListTile(
                  title: const Text("地図設定"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapSetting()),
                    );
                  },
                ),
                const Divider(),
                TextButton(
                    child: const Text(
                      "リセット",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text("リセットしますか？"),
                            content: const Text("これまでに訪れた履歴を削除します。"),
                            actions: <Widget>[
                              // ボタン領域
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  for (var i = 0;
                                      i < markerPosition.length;
                                      i++) {
                                    box.put(markerPosition[i]["name"], false);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    })
              ],
            ),
          ),
        ]));
  }
}

class InquiryPage extends StatefulWidget {
  const InquiryPage({Key? key}) : super(key: key);

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "問い合わせ",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: const WebView(
        initialUrl:
            'https://docs.google.com/forms/d/e/1FAIpQLScNARfIhrl2UG9L7U59x6tnjUgevGmZWTFDr7hBz4VWaa5m1g/viewform?usp=sf_link',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  var osName = "";
  var osVersion = "";
  var buildNum = "";
  var device = "";
  var version = "";
  void getDeviceInfo() async {
    osName = Platform.operatingSystem;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    version = packageInfo.version;
    buildNum = packageInfo.buildNumber;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      osVersion = androidInfo.version.release!;
      device = androidInfo.device!;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      osVersion = iosInfo.systemVersion!;
      device = iosInfo.utsname.machine!;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "このアプリについて",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 10, right: 10),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  title: const Text("OS"),
                  trailing: Text(osName),
                ),
                const Divider(),
                ListTile(
                  title: const Text("OSバージョン"),
                  trailing: Text(osVersion),
                ),
                const Divider(),
                ListTile(
                  title: const Text("デバイス"),
                  trailing: Text(device),
                ),
                const Divider(),
                ListTile(
                  title: const Text("バージョン"),
                  trailing: Text(version),
                ),
                const Divider(),
                ListTile(
                  title: const Text("ビルド番号"),
                  trailing: Text(buildNum),
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeamsOfService extends StatelessWidget {
  const TeamsOfService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "利用規約",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "本サービスユーザー利用規約",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(
                  "この利用規約（以下，「本規約」といいます。）は，katatsumuri（以下，「当方」といいます。）がこのアプリケーションで提供するサービス（以下，「本サービス」といいます。）の利用条件を定めるものです。利用ユーザーの皆さま（以下，「ユーザー」といいます。）には，本規約に従って，本サービスをご利用いただきます。",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "第1条（適用）",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "本規約は，ユーザーと当方との間の本サービスの利用に関わる一切の関係に適用されるものとします。",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "第2条（禁止事項）",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text(
                  "ユーザーは，本サービスの利用にあたり，以下の行為をしてはなりません。",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　1.	法令または公序良俗に違反する行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　2.	犯罪行為に関連する行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　3.	本サービスの内容等，本サービスに含まれる著作権，商標権ほか知的財産権を侵害する行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　4.	当方，ほかのユーザー，またはその他第三者のサーバーまたはネットワークの機能を破壊したり，妨害したりする行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　5.	本サービスによって得られた情報を商業的に利用する行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　6.	当方のサービスの運営を妨害するおそれのある行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　7.	不正アクセスをし，またはこれを試みる行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　8.	他のユーザーに関する個人情報等を収集または蓄積する行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　9.	不正な目的を持って本サービスを利用する行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　10.	本サービスの他のユーザーまたはその他の第三者に不利益，損害，不快感を与える行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　11.	当方のサービスに関連して，反社会的勢力に対して直接または間接に利益を供与する行為",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　12.	その他，当方が不適切と判断する行為",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "第3条（本サービスの提供の停止等）",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text(
                  "1.	当方は，以下のいずれかの事由があると判断した場合，ユーザーに事前に通知することなく本サービスの全部または一部の提供を停止または中断することができるものとします。",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　1.	本サービスにかかるコンピュータシステムの保守点検または更新を行う場合",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　2.	地震，落雷，火災，停電または天災などの不可抗力により，本サービスの提供が困難となった場合",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　3.	コンピュータまたは通信回線等が事故により停止した場合",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　4.	その他，当方が本サービスの提供が困難と判断した場合",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "2.	当方は，本サービスの提供の停止または中断により，ユーザーまたは第三者が被ったいかなる不利益または損害についても，一切の責任を負わないものとします。",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "第4条（利用制限および登録抹消）",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text(
                  "1.	当方は，ユーザーが以下のいずれかに該当する場合には，事前の通知なく，ユーザーに対して，本サービスの全部もしくは一部の利用を制限し，またはユーザーとしての登録を抹消することができるものとします。",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　1.	本規約のいずれかの条項に違反した場合",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　2.	その他，当方が本サービスの利用を適当でないと判断した場合",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "2.	当方は，本条に基づき当方が行った行為によりユーザーに生じた損害について，一切の責任を負いません。",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "第5条（サービス内容の変更等）",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text(
                  "当方は，ユーザーへの事前の告知をもって、本サービスの内容を変更、追加または廃止することがあり、ユーザーはこれを承諾するものとします",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "第6条（利用規約の変更）",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text(
                  "1.	当方は以下の場合には、ユーザーの個別の同意を要せず、本規約を変更することができるものとします。",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　1.	本規約の変更がユーザーの一般の利益に適合するとき。",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "　2.	本規約の変更が本サービス利用契約の目的に反せず、かつ、変更の必要性、変更後の内容の相当性その他の変更に係る事情に照らして合理的なものであるとき。",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "2.	当方はユーザーに対し、前項による本規約の変更にあたり、事前に、本規約を変更する旨及び変更後の本規約の内容並びにその効力発生時期を通知します。",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "第7条（個人情報の取扱い）",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text(
                  "当方は，本サービスの利用によって取得する個人情報については，スタンプが押された場所を除く一切を記録いたしません。 ",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "第8条（権利義務の譲渡の禁止）",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text(
                  "ユーザーは，当方の書面による事前の承諾なく，利用契約上の地位または本規約に基づく権利もしくは義務を第三者に譲渡し，または担保に供することはできません。",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "第9条（準拠法・裁判管轄）",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text(
                  "本規約の解釈にあたっては，日本法を準拠法とします。",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 20,
                ),
              ]),
        ),
      ),
    );
  }
}

class MapSetting extends StatefulWidget {
  const MapSetting({Key? key}) : super(key: key);

  @override
  State<MapSetting> createState() => _MapSettingState();
}

class _MapSettingState extends State<MapSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "地図設定",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "標準倍率",
                style: TextStyle(fontSize: 20),
              ),
              Slider(
                label: mapZoom.toString(),
                min: 5.0,
                max: 17.0,
                value: mapZoom,
                divisions: 24,
                onChanged: (double e) => setState(() {
                  mapZoom = e;
                  box.put("mapZoom", mapZoom);
                }),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }
}
