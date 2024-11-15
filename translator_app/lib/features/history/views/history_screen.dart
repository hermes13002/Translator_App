import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  final List<Map<String, String>> history;

  const HistoryScreen({super.key, required this.history});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = '';

  List<Map<String, String>> get _filteredHistory {
    if (_searchQuery.isEmpty) {
      return widget.history;
    } else {
      return widget.history
          .where((entry) => entry['original']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  late List<Map<String, String>> _history;

  @override
  void initState() {
    super.initState();
    _history = widget.history;
  }

  void _deleteEntry(int index) async {
    setState(() {
      _history.removeAt(index);
    });

    // Save updated history to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('translation_history', jsonEncode(_history));
  }


  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    // final screenHeight = mediaQuery.size.height;
    // final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: GoogleFonts.poppins(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      ),
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,),
                child: Column(
                  children: [
                    SearchBar(
                      controller: _searchController,
                      hintText: 'Search history...',
                      hintStyle: WidgetStatePropertyAll(GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(211, 208, 217, 1))),
                      leading: const Icon(Icons.search),
                      trailing: [
                        _searchQuery.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.close), onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          )
                        : const SizedBox.shrink()
                      ],
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor: const WidgetStatePropertyAll(Colors.white),
                      side: const WidgetStatePropertyAll(BorderSide(color: Color.fromRGBO(211, 208, 217, 1), width: 1)),
                      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                      onTap: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    ListView.builder(
                      shrinkWrap: true,
                      // itemCount: widget.history.length,
                      itemCount: _filteredHistory.length,
                      itemBuilder: (context, index) {
                        // final entry = widget.history[index];
                        final entry = _filteredHistory[index];

                        return Column(
                          children: [
                            ListTile(
                              title: Text(entry['original'] ?? '', overflow: TextOverflow.ellipsis,),
                              subtitle: Text(entry['translated'] ?? '', overflow: TextOverflow.ellipsis,),
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteEntry(index),
                              ),
                            ),
                            
                            SizedBox(height: 8.h),
                          ],
                        );
                      },
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
}
