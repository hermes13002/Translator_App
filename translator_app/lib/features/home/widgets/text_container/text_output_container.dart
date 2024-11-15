import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextOutputContainer extends StatelessWidget {
  final String text;
  const TextOutputContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Container(
      height: screenHeight * 0.32,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.2,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(fontSize: 17.sp, color: Colors.black, fontWeight: FontWeight.w600)
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.01,),

                const Divider(),

                SizedBox(height: screenHeight * 0.01,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){},
                      child: const Icon(Icons.clear_rounded)),

                    SizedBox(width: screenWidth * 0.04,),
                    
                    InkWell(
                      onTap: (){},
                      child: const Icon(Icons.volume_up_outlined)),

                    SizedBox(width: screenWidth * 0.04,),

                    InkWell(
                      onTap: (){},
                      child: const Icon(Icons.content_copy))
                  ],
                )
              ],
            ),
          ),

          
        ],
      )
    );
  }
}