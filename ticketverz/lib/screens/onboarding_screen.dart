import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              buildPage("assets/logo.svg", "Scan Tickets",
                  "Scan and validate movie tickets instantly!"),
              buildPage("assets/secure.svg", "Secure",
                  "Ensure valid bookings with our secure scanner."),
              buildPage("assets/easy.svg", "Easy to Use",
                  "Simple and user-friendly interface."),
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(),
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: "Get Started",
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(String image, String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Image.asset(image, height: 200),
        SizedBox(height: 30),
        Text(title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(subtitle,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        Spacer(),
      ],
    );
  }
}
