import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextOutputContainer extends StatelessWidget {
  final String textOutput;
  // final void Function()? onTapClear;
  final void Function()? onTapSpeak;
  // final void Function()? onTapCopy;
  const TextOutputContainer({super.key, required this.textOutput, this.onTapSpeak});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textOutput,
                    textAlign: TextAlign.justify,
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
                    // Material(child:InkWell(
                    //   onTap: (){},
                    //   child: const Icon(Icons.clear_rounded)),),

                    SizedBox(width: screenWidth * 0.04,),
                    
                    Material(child:InkWell(
                      onTap: onTapSpeak,
                      child: const Icon(Icons.volume_up_outlined)),),

                    SizedBox(width: screenWidth * 0.04,),

                    Material(child:InkWell(
                      onTap: (){
                        Clipboard.setData(ClipboardData(text: textOutput));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Text Copied', style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white)),
                          backgroundColor: const Color.fromRGBO(204, 0, 255, 1),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          ),
                          elevation: 2.0,
                          )
                        );
                      },
                      child: const Icon(Icons.content_copy))),
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