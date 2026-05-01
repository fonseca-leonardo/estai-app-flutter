import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ad_banner_viewmodel.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  bool _isLoading = false;

  // IDs de produção
  static const String _androidAdUnitIdProd =
      'ca-app-pub-8668504220912264/5018110032';
  static const String _iosAdUnitIdProd =
      'ca-app-pub-8668504220912264/5887697940';

  // IDs de teste do AdMob (usados durante desenvolvimento)
  static const String _androidAdUnitIdTest =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _iosAdUnitIdTest =
      'ca-app-pub-3940256099942544/2934735716';

  String get _androidAdUnitId =>
      kDebugMode ? _androidAdUnitIdTest : _androidAdUnitIdProd;
  String get _iosAdUnitId => kDebugMode ? _iosAdUnitIdTest : _iosAdUnitIdProd;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _bannerAd == null && !_isLoading) {
        _loadBanner();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerAd == null && !_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _bannerAd == null && !_isLoading) {
          _loadBanner();
        }
      });
    }
  }

  void _loadBanner() {
    if (_isLoading) return;

    final adUnitId = Platform.isAndroid ? _androidAdUnitId : _iosAdUnitId;

    _isLoading = true;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          Future.microtask(() {
            if (!mounted) return;
            final viewModel = Provider.of<AdBannerViewModel>(
              context,
              listen: false,
            );
            setState(() {
              _isBannerAdReady = true;
            });
            viewModel.setLoading(false);
            viewModel.setLoaded(true);
          });
        },
        onAdFailedToLoad: (ad, error) {
          if (!mounted) return;
          Future.microtask(() {
            if (!mounted) return;
            final viewModel = Provider.of<AdBannerViewModel>(
              context,
              listen: false,
            );
            viewModel.setLoading(false);
            viewModel.setError(error.message);
            setState(() {
              _bannerAd = null;
              _isLoading = false;
            });
          });
          ad.dispose();
        },
        onAdOpened: (_) {},
        onAdClosed: (_) {},
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBannerAdReady || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: _bannerAd!.size.height.toDouble(),
        color: Colors.transparent,
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
