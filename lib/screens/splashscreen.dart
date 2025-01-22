import 'package:byaparlekha/components/screen_size_config.dart';
import 'package:byaparlekha/config/configuration.dart';
import 'package:byaparlekha/config/routes/routes.dart';
import 'package:byaparlekha/providers/preference_provider.dart';

import 'package:byaparlekha/services/sharedPreferenceService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (SharedPreferenceService.isReady.value) {
      initialize();
    } else
      SharedPreferenceService.isReady.addListener(() {
        initialize();
      });
  }

  initialize() async {
    await Future.delayed(Duration(seconds: 1));
    Provider.of<PreferenceProvider>(context, listen: false).language = SharedPreferenceService().getLanguage;
    final userToken = SharedPreferenceService().accessToken;
    if (userToken.isEmpty) {
      Navigator.of(context).pushReplacementNamed(Routes.authenticationPage);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.height,
            child: SvgPicture.asset('assets/images/splash_screen.svg', fit: BoxFit.fitWidth, alignment: Alignment.bottomCenter),
          ),
          Center(
            child: Image.asset(
              "assets/images/logo.png",
              height: 250,
              width: double.maxFinite,
              // fit: BoxFit.cover,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SizedBox(
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.hasData ? ('Version' + ' ' + snapshot.data!.version) : '',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xffffffff),
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguagePreferencePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose Your Language',
              style: TextStyle(color: Configuration().appColor, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'भाषा छान्नुहोस्',
              style: TextStyle(color: Configuration().appColor, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 40,
            ),
            languageSelectionWidget('नेपाली', 'assets/language/nepali.png', () {
              final preferenceProvider = Provider.of<PreferenceProvider>(context, listen: false);
              preferenceProvider.language = Lang.NP;
              SharedPreferenceService().isFirstTime = false;
              Navigator.of(context).pushNamed(Routes.authenticationPage);
            }),
            SizedBox(
              height: 25,
            ),
            languageSelectionWidget('English', 'assets/language/english.png', () {
              final preferenceProvider = Provider.of<PreferenceProvider>(context, listen: false);
              preferenceProvider.language = Lang.EN;
              SharedPreferenceService().isFirstTime = false;
              Navigator.of(context).pushNamed(Routes.authenticationPage);
            })
          ],
        ),
      ),
    );
  }

  Widget languageSelectionWidget(String title, String imageSource, Function() onTap) {
    return TextButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith((states) => 10),
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => Configuration().appColor,
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.white),
            )),
            Image.asset(
              imageSource,
              height: 35,
              width: 35,
              fit: BoxFit.contain,
            )
          ],
        ),
      ),
    );
  }
}
