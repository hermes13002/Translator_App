// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:translator_app/features/ads/ad_helper.dart';

// class BannerScreen extends StatefulWidget {
//   const BannerScreen({super.key});

//   @override
//   State<BannerScreen> createState() => _BannerScreenState();
// }

// class _BannerScreenState extends State<BannerScreen> {
//   static const _kAdIndex = 4;

//   BannerAd? _ad;

//   int _getDestinationItemIndex(int rawIndex) {
//     if (rawIndex >= _kAdIndex && _ad != null) {
//       return rawIndex - 1;
//     }
//     return rawIndex;
//   }

//   @override
//   void initState() {
//     super.initState();
//     BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       size: AdSize.banner,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             _ad = ad as BannerAd;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           // Releases an ad resource when it fails to load
//           ad.dispose();
//           print('Ad load failed (code=${error.code} message=${error.message})');
//         },
//       ),
//     ).load();
//   }

//   @override
//   void dispose() {
//     _ad?.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: widget.entries.length + (_ad != null ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (_ad != null && index == _kAdIndex) {
//             return Container(
//               width: _ad!.size.width.toDouble(),
//               height: 72.0,
//               alignment: Alignment.center,
//               child: AdWidget(ad: _ad!),
//             );
//           } else {
//             final item = widget.entries[_getDestinationItemIndex(index)];

//             return ListTile(
//               title: Text(item.title),
//               subtitle: Text(item.subtitle),
//             );
//           }
//         },
//       ),
//     );
//   }
// }