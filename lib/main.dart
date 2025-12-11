// import 'package:firebase_core/firebase_core.dart';
import 'package:finalproject/widgets/Splash_homepage.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/widgets/dashboard.dart';
import 'package:finalproject/login_page.dart';
import 'package:finalproject/routes/routes.dart';
import 'package:finalproject/widgets/Register.dart';
import 'package:finalproject/widgets/SearchPage.dart';
import 'package:finalproject/widgets/RoomDetails.dart';
import 'package:finalproject/widgets/HostelDetails.dart';
import 'package:finalproject/widgets/Booking.dart';
import 'package:finalproject/widgets/Review.dart';
import 'package:finalproject/widgets/My_Bookings.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      //debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {

        "/" : (context)=>SplashPage(),
        MyRoutes.SignupRoute:(context)=>SignupScreen(),
        MyRoutes.loginRoute : (context)=> LoginPage(),
        MyRoutes.searchRoute : (context)=> SearchPage(),
        MyRoutes.RoomInputRoute : (context)=> RoomInputPage(),
        MyRoutes.AdminPageRoute : (context)=> AdminDashboard(),
        MyRoutes.HostelInputRoute : (context)=> HostelForm(),
         MyRoutes.BookingPageRoute : (context)=> BookingPage(),

      },
    );
  }
}
