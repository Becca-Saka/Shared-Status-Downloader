import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class TestAdmob extends StatefulWidget {
  @override
  _TestAdmobState createState() => _TestAdmobState();
}

class _TestAdmobState extends State<TestAdmob> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  @override
  void initState(){
    super.initState();
    bannerSize = AdmobBannerSize.BANNER;
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    rewardAd = AdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );

    interstitialAd.load();
    rewardAd.load();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: _scaffoldKey.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                _scaffoldKey.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1500),
    ));
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
          title: const Text('AdmobFlutter'),
        ),
        bottomNavigationBar: Builder(
          builder: (BuildContext context) {
            return Container(
              color: Colors.blueGrey,
              child: SafeArea(
                child: SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          child: Text(
                            'Show Interstitial',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (await interstitialAd.isLoaded) {
                              interstitialAd.show();
                            } else {
                              showSnackBar(
                                  'Interstitial ad is still loading...');
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          child: Text(
                            'Show Reward',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (await rewardAd.isLoaded) {
                              rewardAd.show();
                            } else {
                              showSnackBar('Reward ad is still loading...');
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: PopupMenuButton(
                          initialValue: bannerSize,
                          child: Center(
                            child: Text(
                              'Banner size',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                          offset: Offset(0, 20),
                          onSelected: (AdmobBannerSize newSize) {
                            setState(() {
                              bannerSize = newSize;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<AdmobBannerSize>>[
                            PopupMenuItem(
                              value: AdmobBannerSize.BANNER,
                              child: Text('BANNER'),
                            ),
                            PopupMenuItem(
                              value: AdmobBannerSize.LARGE_BANNER,
                              child: Text('LARGE_BANNER'),
                            ),
                            PopupMenuItem(
                              value: AdmobBannerSize.MEDIUM_RECTANGLE,
                              child: Text('MEDIUM_RECTANGLE'),
                            ),
                            PopupMenuItem(
                              value: AdmobBannerSize.FULL_BANNER,
                              child: Text('FULL_BANNER'),
                            ),
                            PopupMenuItem(
                              value: AdmobBannerSize.LEADERBOARD,
                              child: Text('LEADERBOARD'),
                            ),
                            PopupMenuItem(
                              value: AdmobBannerSize.SMART_BANNER(context),
                              child: Text('SMART_BANNER'),
                            ),
                            PopupMenuItem(
                              value: AdmobBannerSize.ADAPTIVE_BANNER(
                                width:
                                    MediaQuery.of(context).size.width.toInt() -
                                        40, // considering EdgeInsets.all(20.0)
                              ),
                              child: Text('ADAPTIVE_BANNER'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(20.0),
          itemCount: 1000,
          itemBuilder: (BuildContext context, int index) {
            if (index != 0 && index % 6 == 0) {
              return Column(
                children: <Widget>[
                  Container(
                    height:200,
                    color: Colors.grey[300],
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(child: Text('This ad makes app free')),
                        ),
                        Expanded(
                          flex: 2,
                                                  child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AdmobBanner(
                                adUnitId: getBannerAdUnitId(),
                                adSize: bannerSize,
                                listener:
                                    (AdmobAdEvent event, Map<String, dynamic> args) {
                                  handleEvent(event, args, 'Banner');
                                },
                                onBannerCreated: (AdmobBannerController controller) {
                                  // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                                  // Normally you don't need to worry about disposing this yourself, it's handled.
                                  // If you need direct access to dispose, this is your guy!
                                  // controller.dispose();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200.0,
                    margin: EdgeInsets.only(bottom: 20.0),
                    color: Colors.cyan,
                  ),
                ],
              );
            }
            return Container(
              height: 200.0,
              margin: EdgeInsets.only(bottom: 20.0),
              color: Colors.cyan,
            );
          },
        ),
        );
  }

   @override
  void dispose() {
    interstitialAd.dispose();
    rewardAd.dispose();
    super.dispose();
  }
}




String getBannerAdUnitId() {
 return 'ca-app-pub-5792102376935277/9121589274';
}

String getInterstitialAdUnitId() {
 return 'ca-app-pub-5792102376935277/4547919443';
}

String getRewardBasedVideoAdUnitId() {
 return 'ca-app-pub-5792102376935277/7202196460';
}

