import 'package:flutter/material.dart';
import 'package:finalproject/routes/routes.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildPage(
                image: 'assets/images/image1.jpeg',
                text: 'Welcome to our App',
              ),
              _buildPage(
                image: 'assets/images/image2.jpeg',
                text: 'Explore the features',
              ),
              _buildPage(
                image: 'assets/images/image3.jpeg',
                text: 'Get Started',
                isLastPage: true,
              ),
            ],
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  height: 10.0,
                  width: _currentPage == index ? 20.0 : 10.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPage(
      {required String image, required String text, bool isLastPage = false}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: isLastPage
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.loginRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Text color when the button is pressed
              ),
              child: Text('Login',style: TextStyle(
                  color:Colors.blue
              ),),
            ),
            SizedBox(height: 20.0), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.SignupRoute); // Handle creating an account action
              },
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        )
            : Text(
          text,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}




