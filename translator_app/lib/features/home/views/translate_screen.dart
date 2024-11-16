import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:translator_app/features/history/views/history_screen.dart';
import 'package:translator_app/features/home/widgets/text_container/text_output_container.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:translator_app/features/settings/views/settings_screen.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator_app/features/home/model/lang_model.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final GoogleTranslator _translator = GoogleTranslator();
  final TextEditingController inputText = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  late String outputText = '';

  Language _sourceLanguage = languages.first;
  Language _targetLanguage = languages[1];

  bool isSwitched = false;
  bool _isListening = false;

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  List<Map<String, String>> _history = [];

  void _translate() async {
    if (inputText.text.isEmpty) return;

    var translation = await _translator.translate(
      inputText.text,
      from: _sourceLanguage.code,
      to: _targetLanguage.code,
    );

    setState(() => outputText = translation.text);
    
    _saveToHistory(inputText.text, translation.text);
  }

  Future<void> _speak(String text) async {  
    await _flutterTts.setLanguage(_targetLanguage.code);
    await _flutterTts.setPitch(1.0);  // Adjust pitch if needed
    await _flutterTts.speak(text);
  }

  void _startListening() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Status: $status', style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white)),
          backgroundColor: const Color.fromRGBO(204, 0, 255, 1),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          elevation: 2.0,
          duration: const Duration(seconds: 10),
        ));
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $error', style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white)),
          backgroundColor: const Color.fromRGBO(204, 0, 255, 1),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          elevation: 2.0,
          duration: const Duration(seconds: 10),
        ));
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            inputText.text = result.recognizedWords;
          });
        },
        localeId: _sourceLanguage.code,
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speechToText.stop();
  }

  void _saveToHistory(String original, String translated) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, String> newEntry = {
      'original': original,
      'translated': translated,
    };

    setState(() {
      _history.add(newEntry);
    });

    // Save updated history to SharedPreferences
    prefs.setString('translation_history', jsonEncode(_history));
  }

  void _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedHistory = prefs.getString('translation_history');

    if (savedHistory != null) {
      setState(() {
        _history = List<Map<String, String>>.from(jsonDecode(savedHistory));
      });
    }
  }

  void _viewHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(history: _history),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();

    // Initialize the BannerAd
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-1618616184793594/8944560689', // Replace with your Ad Unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speechToText.stop();
    inputText.dispose();
    _bannerAd.dispose();
    super.dispose();
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
            backgroundImage: AssetImage('assets/images/map.png'),
          ),
        ),
        title: Text('Translate', style: GoogleFonts.poppins(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),),
        // centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                InkWell(
                  onTap: _viewHistory,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.history)
                  )
                ),

                SizedBox(width: screenWidth * 0.04,),
                
                InkWell(
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
              ],
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
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
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
                                        Material(
                                          child: InkWell(
                                            onTap: (){inputText.clear();},
                                            child: const Icon(Icons.clear_rounded)),
                                        ),
                                    
                                        SizedBox(width: screenWidth * 0.04,),
                                    
                                        InkWell(
                                          onTap: (){_speak(inputText.text);},
                                          child: const Icon(Icons.volume_up_outlined)),
                                    
                                        SizedBox(width: screenWidth * 0.04,),
                                    
                                        InkWell(
                                          onTap: (){_isListening ? _stopListening : _startListening;},
                                          child: Icon(_isListening ? Icons.mic_off : Icons.mic)),

                                        SizedBox(width: screenWidth * 0.04,),
                                        
                                        Material(child:InkWell(
                                          onTap: (){
                                            Clipboard.setData(ClipboardData(text: inputText.text));
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
                      textOutput: outputText,
                      onTapSpeak: () => _speak(outputText),
                    ),

                    if (_isBannerAdLoaded)
                    SizedBox(
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    ),
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
                    child: Image.asset(lang.icon),
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
                    child: Image.asset(lang.icon),
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