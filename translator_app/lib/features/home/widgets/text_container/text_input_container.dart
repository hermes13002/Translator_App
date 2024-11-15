// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TextInputContainer extends StatefulWidget {
//   final TextEditingController controller;
//   final void Function()? onTap;
//   const TextInputContainer({super.key, required this.controller, this.onTap});

//   @override
//   State<TextInputContainer> createState() => _TextInputContainerState();
// }

// class _TextInputContainerState extends State<TextInputContainer> {
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenHeight = mediaQuery.size.height;
//     final screenWidth = mediaQuery.size.width;

//     return Container(
//       height: screenHeight * 0.33,
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20)
//       ),
//       child: Column(
//         children: [
//           SizedBox(
//             height: screenHeight * 0.2,
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: widget.controller,
//                     minLines: 5,
//                     maxLines: 999,
//                     textAlign: TextAlign.left,
//                     style: GoogleFonts.poppins(fontSize: 17.sp, color: Colors.black, fontWeight: FontWeight.w600),
//                     decoration: InputDecoration(
//                       hintText: 'Type here',
//                       hintStyle: GoogleFonts.poppins(fontSize: 17.sp, color: Colors.black12, fontWeight: FontWeight.w600),
//                       border: const OutlineInputBorder(
//                         borderSide: BorderSide.none,
//                       )
//                     )
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           SizedBox(
//             child: Column(
//               children: [
//                 SizedBox(height: screenHeight * 0.01,),

//                 const Divider(),

//                 SizedBox(height: screenHeight * 0.01,),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Material(
//                       child: InkWell(
//                         onTap: () {
//                           translateFunc;
//                         },
//                         splashColor: const Color.fromARGB(255, 242, 192, 255),
//                         child: Container(
//                           width: screenWidth * 0.25,
//                           height: screenHeight * 0.04,
//                           decoration: BoxDecoration(
//                             color:const Color.fromRGBO(204, 0, 255, 1),
//                             borderRadius: BorderRadius.circular(14)
//                           ),
//                           child: Center(child: Text('Translate', style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),)),
//                         ),
//                       ),
//                     ),
                    
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: (){},
//                           child: const Icon(Icons.clear_rounded)),
                    
//                         SizedBox(width: screenWidth * 0.04,),
                    
//                         InkWell(
//                           onTap: (){},
//                           child: const Icon(Icons.volume_up_outlined)),
                    
//                         SizedBox(width: screenWidth * 0.04,),
                    
//                         InkWell(
//                           onTap: (){},
//                           child: const Icon(Icons.mic_none)),
//                       ],
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),

          
//         ],
//       )
//     );
//   }

//   // Widget translateButton() {
//   //   final mediaQuery = MediaQuery.of(context);
//   //   final screenHeight = mediaQuery.size.height;
//   //   final screenWidth = mediaQuery.size.width;

//   //   return Material(
//   //     child: InkWell(
//   //       onTap: widget.onTap,
//   //       splashColor: const Color.fromARGB(255, 242, 192, 255),
//   //       child: Container(
//   //         width: screenWidth * 0.25,
//   //         height: screenHeight * 0.04,
//   //         decoration: BoxDecoration(
//   //           color:const Color.fromRGBO(204, 0, 255, 1),
//   //           borderRadius: BorderRadius.circular(14)
//   //         ),
//   //         child: Center(child: Text('Translate', style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),)),
//   //       ),
//   //     ),
//   //   );
//   // }
// }