import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator_app/features/home/views/translate_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _switchValue2 = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const TranslateScreen())
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.arrow_back_ios_new_rounded),
          )
        ),
        title: Text('Settings', style: GoogleFonts.poppins(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0,top: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('General Settings', style: GoogleFonts.poppins(fontSize: 18.5.sp, fontWeight: FontWeight.bold, color: const Color.fromRGBO(204, 0, 255, 1),)),
            
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    height: screenHeight * 0.09,
                    width: screenWidth * 0.18,
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/man.png'),
                      // backgroundColor: Colors.green,
                      // child: Text('AS', style: GoogleFonts.poppins(fontSize: 15.5.sp, color: Colors.white)),
                    ),
                  ),
                  title: Text('Your name...', style: GoogleFonts.poppins(fontSize: 15.5.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Text('Edit your profile', style: GoogleFonts.poppins(fontSize: screenWidth * 0.04, color: Colors.black)),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 30,)
                ),
            
                const Divider(),
            
                SwitchListTile( 
                  thumbColor: const WidgetStatePropertyAll(Colors.white),
                  activeColor: const Color.fromRGBO(2, 253, 253, 1),
                  trackOutlineColor: const WidgetStatePropertyAll(Colors.white),
                  contentPadding: EdgeInsets.zero,
                  title: Text('Email Notifications', style: GoogleFonts.poppins(fontSize: 15.5.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Text('Allow app to send email notifications on your device', style: GoogleFonts.poppins(fontSize: screenWidth * 0.035, color: Colors.grey[700])),
                  value: _switchValue2, 
                  onChanged: (newValue) { 
                    setState(() { 
                      _switchValue2 = newValue; 
                    }); 
                  }, 
                ),
            
                SizedBox(height: screenHeight * 0.03,),
                Text('Support', style: GoogleFonts.poppins(fontSize: 18.5.sp, fontWeight: FontWeight.bold, color: const Color.fromRGBO(204, 0, 255, 1))),
            
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Terms of Service', style: GoogleFonts.poppins(fontSize: 15.5.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 30,)
                ),
            
                const Divider(),
            
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Data Policy', style: GoogleFonts.poppins(fontSize: 15.5.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 30,)
                ),
            
                const Divider(),
            
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Help / FAQ', style: GoogleFonts.poppins(fontSize: 15.5.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 30,)
                ),
            
                const Divider(),
            
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Contact Us', style: GoogleFonts.poppins(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 30,)
                ),
        
                SizedBox(height: screenHeight * 0.05,),
        
                InkWell(
                  onTap: () {
                  
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: SizedBox(
                      height: screenHeight * 0.06,
                      // width: screenWidth * 0.9,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color:  const Color.fromRGBO(204, 0, 255, 1),
                          borderRadius: BorderRadius.circular(24)
                        ),
                        child: Center(child: Text('Log Out', style: GoogleFonts.poppins(fontSize: 19.sp, color: Colors.white, fontWeight: FontWeight.bold),)),
                      ),
                    ),
                  ),
                ),
        
                SizedBox(height: screenHeight * 0.02,),
              ],
            ),
          ),
        ),
      )
    );
  }
}