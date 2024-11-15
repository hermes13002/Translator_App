import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator_app/features/home/views/translate_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const TranslateScreen())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    // final screenWidth = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('Trange', style: GoogleFonts.poppins(fontSize: 34.sp, color: Colors.white, fontWeight: FontWeight.bold),),

                Image.asset('assets/images/map.png', height: screenHeight * 0.5,),
              ],
            ),
        
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 36, right: 36),
                  child: Text('Translate Your Words', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 26.sp, color: Colors.white, fontWeight: FontWeight.bold),),
                ),

                SizedBox(height: screenHeight * 0.02,),
            
                Padding(
                  padding: const EdgeInsets.only(left: 36, right: 36),
                  child: Text('Communicate With Others In Different Languages', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.white,),),
                ),
                
                Lottie.asset('assets/lottie/loading.json',
                  height: screenHeight * 0.17,
                  // width: screenWidth * 0.3,
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}