import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator_app/features/home/widgets/text_container/text_output_container.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:translator_app/features/settings/views/settings_screen.dart';
import 'package:translator/translator.dart';
import 'package:translator_app/features/home/model/lang_model.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final GoogleTranslator _translator = GoogleTranslator();
  final TextEditingController inputText = TextEditingController();

  late String outputText = '';

  Language _sourceLanguage = languages.first;
  Language _targetLanguage = languages[1];

  bool isSwitched = false;

  // dynamic selectedLanguageA;
  // dynamic selectedLanguageB;

  // // String selectedLanguage = 'English';

  // late String selectedLanguageCodeB = '';


  void _translate() async {
    if (inputText.text.isEmpty) return;

    var translation = await _translator.translate(
      inputText.text,
      from: _sourceLanguage.code,
      to: _targetLanguage.code,
    );

    setState(() => outputText = translation.text);
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
        leading: const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/ayo.jpeg'),
          ),
        ),
        title: Text('Translate', style: GoogleFonts.poppins(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: InkWell(
              onTap: (){
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen())
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.settings_outlined)
              )
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 34, bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // countryContainerA(),
                        dropdownA(),

                        GestureDetector(
                           onTap: () {
                            setState(() {
                              isSwitched = !isSwitched;
                            });
                          },
                          child: Container(
                            height: screenHeight * 0.065,
                            width: screenWidth * 0.13,
                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(50)),
                            child: const Center(
                              child: Icon(Icons.change_circle_outlined, color: Colors.white, size: 35),
                            ),
                          ),
                        ),
                        
                        dropdownB(),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.036,),

                    Container(
                      height: screenHeight * 0.33,
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
                                  TextField(
                                    controller: inputText,
                                    minLines: 5,
                                    maxLines: 999,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(fontSize: 17.sp, color: Colors.black, fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                      hintText: 'Type here',
                                      hintStyle: GoogleFonts.poppins(fontSize: 17.sp, color: Colors.black12, fontWeight: FontWeight.w600),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      )
                                    )
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Material(
                                      child: InkWell(
                                        onTap: _translate,
                                        splashColor: const Color.fromARGB(255, 242, 192, 255),
                                        child: Container(
                                          width: screenWidth * 0.25,
                                          height: screenHeight * 0.04,
                                          decoration: BoxDecoration(
                                            color:const Color.fromRGBO(204, 0, 255, 1),
                                            borderRadius: BorderRadius.circular(14)
                                          ),
                                          child: Center(child: Text('Translate', style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),)),
                                        ),
                                      ),
                                    ),
                                    
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
                                          child: const Icon(Icons.mic_none)),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                          
                        ],
                      )
                    ),

                    SizedBox(height: screenHeight * 0.036,),

                    TextOutputContainer(
                      text: outputText,
                    )
                  ]
                )
              )
            )
          );
        }
      )
    );
  }

  
  Widget dropdownA() {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Language>(
        alignment: Alignment.centerLeft,
        isExpanded: true,
        hint: Padding(
          padding: const EdgeInsets.only(left: 8,),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: screenHeight * 0.035,
                width: screenWidth * 0.07,
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(50)),
                child: Center(
                  child: Image.asset(
                    'assets/images/france.png'
                  ),
                ),
              ),
          
              SizedBox(width: screenWidth * 0.03,),
          
              Flexible(
                child: SizedBox(
                  child: Text(
                    'English',
                    // '${_sourceLanguage != null ? _sourceLanguage : "English"}', 
                    // '${selectedItemB != null ? isSwitched ? selectedItemA['country'] : selectedItemB['country'] : "English"}',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 13.5.sp, color: Colors.white, fontWeight: FontWeight.bold),
                  )
                )
              ),
            ],
          ),
        ),
        value: _sourceLanguage,
        onChanged: (Language? newLang) {
          setState(() => _sourceLanguage = newLang!);
        },
        items: languages.map((lang) => DropdownMenuItem(
          alignment: Alignment.centerLeft,
          value: lang,
          child: Padding(
            padding: const EdgeInsets.only(left: 8,),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: screenHeight * 0.035,
                  width: screenWidth * 0.07,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Image.asset('assets/images/france.png'),
                  ),
                ),
                
                SizedBox(width: screenWidth * 0.03,),
            
                Flexible(
                  child: SizedBox(
                    child: Text(
                      lang.name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 13.5.sp, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  )
                ),
              ],
            ),
          )
        )).toList(),
        buttonStyleData: ButtonStyleData(
          height: screenHeight * 0.065,
          width: screenWidth * 0.375,
          padding: const EdgeInsets.only(left: 6, right: 6),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(204, 0, 255, 1),
            borderRadius: BorderRadius.circular(32)
          ),
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 24.sp,
          iconEnabledColor: Colors.white,
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 2,
          maxHeight: screenHeight * 0.6,
          width: screenWidth - 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          offset: const Offset(0, 0),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.only(top: 7, left: 10),
        ),
      ),
    );
  }
  
  Widget dropdownB() {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Language>(
        alignment: Alignment.centerLeft,
        isExpanded: true,
        hint: Padding(
          padding: const EdgeInsets.only(left: 8,),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: screenHeight * 0.035,
                width: screenWidth * 0.07,
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(50)),
                child: Center(
                  child: Image.asset(
                    'assets/images/france.png'
                  ),
                ),
              ),
          
              SizedBox(width: screenWidth * 0.03,),
          
              Flexible(
                child: SizedBox(
                  child: Text(
                    'Other',
                    // '${_targetLanguage != null ? _targetLanguage : "English"}', 
                    // '${selectedItemB != null ? isSwitched ? selectedItemB['country'] : selectedItemA['country'] : "English"}',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 13.5.sp, color: Colors.white, fontWeight: FontWeight.bold),))),
            ],
          ),
        ),
        value: _targetLanguage,
        onChanged: (Language? newLang) {
          setState(() => _targetLanguage = newLang!);
        },
        items: languages.map((lang) => DropdownMenuItem(
          alignment: Alignment.centerLeft,
          value: lang,
          child: Padding(
            padding: const EdgeInsets.only(left: 8,),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: screenHeight * 0.035,
                  width: screenWidth * 0.07,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Image.asset('assets/images/france.png'),
                  ),
                ),
                
                SizedBox(width: screenWidth * 0.03,),
            
                Flexible(
                  child: SizedBox(
                    child: Text(
                      lang.name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 13.5.sp, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  )
                ),
            
              ],
            ),
          )
        )).toList(),
        
        buttonStyleData: ButtonStyleData(
          height: screenHeight * 0.065,
          width: screenWidth * 0.375,
          padding: const EdgeInsets.only(left: 6, right: 6),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(204, 0, 255, 1),
            borderRadius: BorderRadius.circular(32)
          ),
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 24.sp,
          iconEnabledColor: Colors.white,
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 2,
          maxHeight: screenHeight * 0.6,
          width: screenWidth - 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          offset: const Offset(0, 0),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.only(top: 7, left: 10),
        ),
      ),
    );
  }
}