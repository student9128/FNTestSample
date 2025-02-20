// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/cell.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

/// The entrypoint for the flutter module.
void main() {
  // This call ensures the Flutter binding has been set up before creating the
  // MethodChannel-based model.
  WidgetsFlutterBinding.ensureInitialized();

  // final model = CounterModel();
  //
  // runApp(
  //   ChangeNotifierProvider.value(
  //     value: model,
  //     child: const MyApp(),
  //   ),
  // );
  // runApp(Hello());
  // runApp(OnGenerate());
  runApp(OnGenerateWithGetX());
}
class Hello extends StatelessWidget {
  const Hello({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // '/': (context) => HelloTest(),
        '/hello1': (context) => HelloTest1(),
        '/hello2': (context) => HelloTest2()
      },
      initialRoute: '/hello2',
    );
  }
}
class OnGenerate extends StatelessWidget {
  const OnGenerate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
    debugPrint('OnGenerate===default=${View.of(context).platformDispatcher.defaultRouteName},${window.defaultRouteName}');
        debugPrint('OnGenerate====${settings.name}');
        switch (settings.name) {
          // case '/':
          //   return MaterialPageRoute(builder: (_) => OnGenerateTest());
          case '/onGenerate1':
            return MaterialPageRoute(builder: (_) => OnGenerateTest1());
          case '/onGenerate2':
            return MaterialPageRoute(builder: (_) => OnGenerateTest2());
          case '/onGenerate3':
            return MaterialPageRoute(builder: (_) => OnGenerateTest3());
          // default:
          //   return MaterialPageRoute(builder: (_) => OnGenerateTest2());
        }
      },
      // routes: {
      //   // '/': (context) => HelloTest(),
      //   '/onGenerate1': (context) => OnGenerateTest1(),
      //   '/onGenerate2': (context) => OnGenerateTest2(),
      //   '/onGenerate3': (context) => OnGenerateTest3()
      // },
      initialRoute:View.of(context).platformDispatcher.defaultRouteName,
    );
  }
}
class OnGenerateWithGetX extends StatelessWidget {
  const OnGenerateWithGetX({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // onGenerateRoute: (settings) {
      //   debugPrint('OnGenerateWithGetX====${settings.name}');
      //   switch (settings.name) {
      //     // case '/':
      //     //   return MaterialPageRoute(builder: (_) => OnGenerateTest());
      //     case '/onGenerate1':
      //       return MaterialPageRoute(builder: (_) => OnGenerateTest1());
      //      case '/onGenerate2':
      //       return MaterialPageRoute(builder: (_) => OnGenerateTest2());
      //     // default:
      //     //   return MaterialPageRoute(builder: (_) => OnGenerateTest2());
      //   }
      // },
      routes: {
        // '/': (context) => HelloTest(),
        '/onGenerate1': (context) => onGenerate1(),
        '/onGenerate2': (context) => OnGenerateTest2()
      },
      initialRoute: window.defaultRouteName,
    );
  }
}

@pragma("vm:entry-point")
void showCell() {
  runApp(const Cell());
}

@pragma('vm:entry-point')
void testFlutter(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

@pragma('vm:entry-point')
void testN() {
  // This call ensures the Flutter binding has been set up before creating the
  // MethodChannel-based model.
  WidgetsFlutterBinding.ensureInitialized();

  // final model = CounterModel();

  runApp(
    TestNApp()
    // ChangeNotifierProvider.value(
    //   value: model,
    //   child: const TestNApp(),
    // ),
  );
}
class TestNApp extends StatelessWidget {
  const TestNApp({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TestNApp',
      theme: ThemeData.light(),
      // routes: {
      //   '/': (context) => const FlutterFragmentView(),
      // },
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}):super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MethodChannel channel = MethodChannel('iosTest');
  @override
  void initState() {
    super.initState();
    channel.setMethodCallHandler((MethodCall call)async{
      debugPrint("pop======${call.method}");
      if(call.method=='jump'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>FlutterFragmentView()));
      }else{
        debugPrint("pop======");
        Navigator.pop(context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(color: Colors.green,),);
  }
}

class FlutterFragmentView extends StatelessWidget {
  const FlutterFragmentView({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult:(b,d){
        debugPrint("b===========$b,d==$d");
      } ,
        child: Scaffold(
      appBar: AppBar(title: Text('FlutterFragmentView'),),
      body: Container(
        color: Colors.red,
        child: Column(children: [
          Center(child: Text('当前fragment中放置的flutter页面,${window.defaultRouteName}')),
          ElevatedButton(onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TestXViewN(params: '从fragment中放置的flutter页面跳过来的',)));
          }, child: Text('跳转')),
          ElevatedButton(onPressed:(){
            SystemNavigator.pop();
            // Navigator.pop(context);
          }, child: Text('返回'))
        ],),
      ),
    ));
  }
}

/// A simple model that uses a [MethodChannel] as the source of truth for the
/// state of a counter.
///
/// Rather than storing app state data within the Flutter module itself (where
/// the native portions of the app can't access it), this module passes messages
/// back to the containing app whenever it needs to increment or retrieve the
/// value of the counter.
class CounterModel extends ChangeNotifier {
  CounterModel() {
    _channel.setMethodCallHandler(_handleMessage);
    _channel.invokeMethod<void>('requestCounter');
  }

  final _channel = const MethodChannel('dev.flutter.example/counter');

  int _count = 0;

  int get count => _count;

  void increment() {
    _channel.invokeMethod<void>('incrementCounter');
  }

  Future<dynamic> _handleMessage(MethodCall call) async {
    if (call.method == 'reportCounter') {
      _count = call.arguments as int;
      notifyListeners();
    }
  }
}

/// The "app" displayed by this module.
///
/// It offers two routes, one suitable for displaying as a full screen and
/// another designed to be part of a larger UI.class MyApp extends StatelessWidget {
class MyApp extends StatelessWidget {
  const MyApp({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("build======routeName=${window.defaultRouteName}");
    return MaterialApp(
      title: 'Flutter Module Title',
      theme: ThemeData.light(),
      routes: {
        // '/':(context)=>TestFlutterScreent(),
        '/test':(context)=>TestXView(),
        '/main': (context) => const FullScreenView(),//移除路由名称为/的，解决设置指定路由的时候还会从/跳转，返回的时候会返回到/
        '/mini': (context) => const Contents(),
      },
      initialRoute: window.defaultRouteName,
    );
  }
}
class TestFlutterScreent extends StatelessWidget {
  const TestFlutterScreent({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('TestFlutterScreen'),),body: Column(children: [Text('TestFlutterScreen'),   ElevatedButton(onPressed:(){
      SystemNavigator.pop();
      // Navigator.pop(context);
    }, child: Text('返回'))],),);
  }
}


/// Wraps [Contents] in a Material [Scaffold] so it looks correct when displayed
/// full-screen.
class FullScreenView extends StatelessWidget {
  const FullScreenView({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full-screen Flutter'),
      ),
      body: const Contents(showExit: true),
    );
  }
}
class TestXView extends StatelessWidget {
  const TestXView ({Key? key}):super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("自定义route"),),body: Column(children: [
      Text('@${window.defaultRouteName}'),
      ElevatedButton(onPressed: (){
        Navigator.push(context, CupertinoPageRoute(builder: (context)=>TestXViewN(params: '从 flutter页面跳过来的',)));
      }, child: Text('跳转 flutter页面'))
    ],),);
  }
}

class TestXViewN extends StatelessWidget {
  const TestXViewN ({Key? key,this.params=''}):super(key: key);
  final String params;


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("自定义route"),),body: Column(children: [
      // Text('@${window.defaultRouteName}'),
      ElevatedButton(onPressed: (){}, child: Text('跳转 flutter页面1233,,,${params}'))
    ],),);
  }
}

class HelloTest extends StatelessWidget {
  const HelloTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('Hello'),),
      body: Container(child: Text('main方法中hello'),),
    );
  }
}
class HelloTest1 extends StatelessWidget {
  const HelloTest1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('Hello1'),),
      body: Container(child: Text('main方法中hello1'),),
    );
  }
}
class HelloTest2 extends StatelessWidget {
  const HelloTest2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('Hello2'),),
      body: Container(child: Text('main方法中hello2'),),
    );
  }
}

//
class OnGenerateTest extends StatelessWidget {
  const OnGenerateTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('OnGenerateTest'),),
      body: Container(child: Text('main方法中OnGenerateTest'),),
    );
  }
}
class onGenerate1 extends StatefulWidget {
  const onGenerate1({Key? key}) : super(key: key);

  @override
  State<onGenerate1> createState() => _onGenerate1State();
}

class _onGenerate1State extends State<onGenerate1> {
  var _result='等待回调';
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('OnGenerateTest1'),),
      body:Column(children: [
        Container(child: Text('main方法中OnGenerateTest1'),),
        Text(_result),
        ElevatedButton(onPressed:(){
          Get.to(()=>OnGenerateTest2())?.then((result){
            debugPrint("result============$result");
            setState(() {
              _result="回调结果$result";
            });
          });
        }, child: Text('跳转到下一个页面'))
      ],),
    );
  }
}
class OnGenerateTest1 extends StatelessWidget {
  const OnGenerateTest1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('OnGenerateTest1'),),
      body:Column(children: [
        Container(child: Text('main方法中OnGenerateTest1'),),
        ElevatedButton(onPressed:(){
          Get.to(()=>OnGenerateTest2())?.then((result){
            debugPrint("result============$result");
          });
        }, child: Text('跳转到下一个页面'))
      ],),
    );
  }
}

class OnGenerateTest3 extends StatefulWidget {
  const OnGenerateTest3({Key? key}) : super(key: key);

  @override
  State<OnGenerateTest3> createState() => _OnGenerateTest3State();
}

class _OnGenerateTest3State extends State<OnGenerateTest3> {
  @override
  void initState() {
    super.initState();
    debugPrint('initState=====');
  }
  
  @override
  Widget build(BuildContext context) {
    debugPrint('build=====');
     return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('OnGenerateTest3'),),
      body: Column(children: [
        Container(child: Text('main方法中OnGenerateTest3'),),
        ElevatedButton(onPressed:(){
          // Get.until((route)=>route.settings.name=='/onGenerate1');
          Get.back();
          Get.back(result: "Hello to 1");
        }, child: Text('返回到1'))
      ],),
    );
  }
}
class OnGenerateTest2 extends StatelessWidget {
  const OnGenerateTest2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('OnGenerateTest2'),),
      body: Column(children: [
        Container(child: Text('main方法中OnGenerateTest2'),),
        ElevatedButton(onPressed:(){
          Get.to(()=>OnGenerateTest3());
        }, child: Text('跳转到下一个页面'))
      ],),
    );
  }
}

/// The actual content displayed by the module.
///
/// This widget displays info about the state of a counter and how much room (in
/// logical pixels) it's been given. It also offers buttons to increment the
/// counter and (optionally) close the Flutter view.
class Contents extends StatelessWidget {
  final bool showExit;

  const Contents({this.showExit = false, Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaInfo = MediaQuery.of(context);

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          const Positioned.fill(
            child: Opacity(
              opacity: .25,
              child: FittedBox(
                fit: BoxFit.cover,
                child: FlutterLogo(),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${window.defaultRouteName}'),
                Text(
                  'Window is ${mediaInfo.size.width.toStringAsFixed(1)} x '
                      '${mediaInfo.size.height.toStringAsFixed(1)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                // Consumer<CounterModel>(
                //   builder: (context, model, child) {
                //     return Text(
                //       'Taps: ${model.count}',
                //       style: Theme.of(context).textTheme.headlineSmall,
                //     );
                //   },
                // ),
                // const SizedBox(height: 16),
                // Consumer<CounterModel>(
                //   builder: (context, model, child) {
                //     return ElevatedButton(
                //       onPressed: () => model.increment(),
                //       child: const Text('Tap me!'),
                //     );
                //   },
                // ),
                if (showExit) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => SystemNavigator.pop(animated: true),
                    child: const Text('Exit this screen'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
