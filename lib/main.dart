

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedProfilePage(),
    );
  }
}

class AnimatedProfilePage extends StatefulWidget {
  @override
  _AnimatedProfilePageState createState() => _AnimatedProfilePageState();
}

class _AnimatedProfilePageState extends State<AnimatedProfilePage> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  bool isProfileVisible = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: ListView(

        children: [
          const SizedBox(height: 50,),
          Center(
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(isHovered ? 30 : 20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    isHovered = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    isHovered = false;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: isHovered ? 1.0 : 0.7,
                      child: const CircleAvatar(
                        radius: 80,

                        backgroundImage: AssetImage(
                            'images/imageapp.jpeg',), // Add your profile image here
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(seconds: 1),
                      style: TextStyle(
                        color: isHovered ? Colors.white : Colors.yellowAccent,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      child: const Text("Sanjay"), // Replace with your name
                    ),
                    const SizedBox(height: 10),
                    AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: isHovered ? 1.0 : 0.6,
                      child: const Text(
                        "Flutter Developer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: isHovered ? 200 : 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isProfileVisible = !isProfileVisible;
                            if (isProfileVisible) {
                              _controller.forward();
                            } else {
                              _controller.reverse();
                            }
                          });
                        },
                        child: const Text(
                          "View Profile",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    if (isProfileVisible)
                      ProfileDetails(slideAnimation: _slideAnimation),
                  ],
                ),
              ),
            ),
          )],
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final Animation<Offset> slideAnimation;

  ProfileDetails({required this.slideAnimation});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
    position: slideAnimation,
    child: Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Full Name: Sanjay',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),
        const Text(
          'Occupation: Flutter Developer at Ascending Software',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),
        const Text(
          'Location: Tirunelveli,TamilNadu',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),
        const Text(
          'Bio: Passionate about coding and building innovative solutions.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 20),
        // GitHub and LinkedIn Buttons
        SocialButton(
          text: 'GitHub',
          color: Colors.black,
          url: 'https://github.com/sanjaytamilan0', // Replace with your GitHub link
        ),
        const SizedBox(height: 10),
        SocialButton(
          text: 'LinkedIn',
          color: Colors.blue,
          url: 'https://www.linkedin.com/in/sanjay-k-86735a277/?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app', // Replace with your LinkedIn link
        ),
      ],
    ),
          );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final Color color;
  final String url;

  SocialButton({
    required this.text,
    required this.color,
    required this.url,
  });

  // Launch URL when the button is clicked
  Future<void> _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchURL,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
