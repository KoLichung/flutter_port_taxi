import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/pages/edit_password.dart';
import 'package:flutter_port_taxi/pages/login.dart';
import 'package:flutter_port_taxi/pages/register.dart';
import 'package:provider/provider.dart';

import 'config/color.dart';
import 'notifier_model/user_model.dart';
import 'pages/home.dart';
import 'pages/my.dart';

void main() {

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context)=>UserModel(),),
    ],
    child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(AppColor.blue),
          ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
           ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColor.blue,
        ),
      ),
      debugShowCheckedModeBanner:false,
      // home: const MyHomePage(),
      // home: Register(),
      home: LogIn(),
      routes: {
        '/main':(context) => const TabPage(),
        '/log_in':(context) => const LogIn(),
        '/edit_password':(context) => const EditPassword(),
      },
    );
  }
}

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: pageCaller(_selectedIndex),),

      bottomNavigationBar: BottomNavigationBar(
        elevation: _selectedIndex == 0 ? 0 : 8,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xffFCFCFC),
        selectedItemColor: AppColor.blue,
        unselectedItemColor: const Color(0xff737273),
        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.local_taxi_rounded), label: '叫車'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: '我的'),
        ],
      ),
    );
  }

  pageCaller(int index){
    switch(index){
      case 0:{return const Home();}
      case 1:{return const My();}
    }
  }

}
