import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/models/app_update_checker.dart';
import 'package:school_bell/screens/custom_dialog.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // TODO: change it to real ID
  static const _adUnitId = 'ca-app-pub-3940256099942544/2247696110';
  static const _factoryId = 'sbNativeAdFactory';

  late SettingManager settingManager;
  late AppUpdateChecker appUpdateChecker;
  late NativeAd _nativeAdWidget;

  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _nativeAdWidget = NativeAd(
      adUnitId: _adUnitId,
      factoryId: _factoryId,
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _nativeAdWidget.load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    settingManager = Provider.of<SettingManager>(context, listen: false);
    appUpdateChecker = Provider.of<AppUpdateChecker>(context, listen: false);
  }

  @override
  void dispose() {
    _nativeAdWidget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (_isAdLoaded)
            Container(
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              height: 80,
              child: AdWidget(ad: _nativeAdWidget),
            ),
          const SizedBox(height: 16),
          const SettingCategory(title: '?????? ??????'),
          buildBellModeItem(context),
          buildClassLengthItem(context),
          buildRestLengthItem(context),
          const SizedBox(height: 8),
          const SettingCategory(title: '????????? ??????'),
          buildClassBellItem(context),
          buildRestBellItem(context),
          const SizedBox(height: 8),
          const SettingCategory(title: '??????????????????'),
          buildAppVersionItem(context),
          SettingItem(
            title: '???????????? ????????????',
            attribute: '',
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false)
                  .openLicensesPage();
            },
          ),
        ],
      ),
    );
  }

  Widget buildBellModeItem(BuildContext context) {
    final bool _isCounting =
        context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final String _bellModeValue = context
        .select<SettingManager, String>((SettingManager sm) => sm.bellModeName);

    return SettingItem(
      title: '????????? ??????',
      attribute: _bellModeValue,
      isDisabled: _isCounting,
      onTap: () async {
        if (!_isCounting) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.setBellMode,
                  title: '????????? ??????',
                  positive: '????????????',
                  negative: '??????',
                );
              });
          if (result != null && result['returnValue'] > -1) {
            settingManager.setBellMode(result['returnValue']);
          }
        }
      },
    );
  }

  Widget buildClassLengthItem(BuildContext context) {
    final bool _isCounting =
        context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final bool _isOnTime = context
        .select<SettingManager, bool>((SettingManager sm) => sm.isOnTime);
    final String _classLengthValue = context.select<SettingManager, String>(
        (SettingManager sm) => sm.classLengthString);

    return SettingItem(
      title: '??? ?????? ??????',
      attribute: _classLengthValue,
      isDisabled: _isOnTime || _isCounting,
      onTap: () async {
        if (!_isOnTime && !_isCounting) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.setTimeLength,
                  positive: '????????????',
                  negative: '??????',
                  forClass: true,
                );
              });
          if (result != null && result['returnValue'] > -1) {
            settingManager.setClassLength(result['returnValue']);
          }
        }
      },
    );
  }

  Widget buildRestLengthItem(BuildContext context) {
    final bool _isCounting =
        context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final bool _isOnTime = context
        .select<SettingManager, bool>((SettingManager sm) => sm.isOnTime);
    final String _restLengthValue = context.select<SettingManager, String>(
        (SettingManager sm) => sm.restLengthString);

    return SettingItem(
      title: '?????? ?????? ??????',
      attribute: _restLengthValue,
      isDisabled: _isOnTime || _isCounting,
      onTap: () async {
        if (!_isOnTime && !_isCounting) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.setTimeLength,
                  positive: '????????????',
                  negative: '??????',
                  forClass: false,
                );
              });
          if (result != null && result['returnValue'] > -1) {
            settingManager.setRestLength(result['returnValue']);
          }
        }
      },
    );
  }

  Widget buildClassBellItem(BuildContext context) {
    final bool _isCounting =
        context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final String _classBellValue = context.select<SettingManager, String>(
        (SettingManager sm) => sm.customClassBell ?? sm.classBellString);

    return SettingItem(
      title: '?????? ?????? ???',
      attribute: _classBellValue,
      isDisabled: _isCounting,
      onTap: () async {
        if (!_isCounting) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.setBellType,
                  positive: '????????????',
                  negative: '??????',
                  forClass: true,
                );
              });
          if (result != null && result['returnValue'] > -1) {
            if (result['returnValue'] < 9) {
              settingManager.setClassBell(result['returnValue']);
              settingManager.setCustomClassBell(null);
            } else {
              settingManager.setClassBell(9);
              settingManager.setCustomClassBell(result['extra']);
            }
          }
        }
      },
    );
  }

  Widget buildRestBellItem(BuildContext context) {
    final bool _isCounting =
        context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final String _restBellValue = context.select<SettingManager, String>(
        (SettingManager sm) => sm.customRestBell ?? sm.restBellString);

    return SettingItem(
      title: '?????? ?????? ???',
      attribute: _restBellValue,
      isDisabled: _isCounting,
      onTap: () async {
        if (!_isCounting) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.setBellType,
                  positive: '????????????',
                  negative: '??????',
                  forClass: false,
                );
              });
          if (result != null && result['returnValue'] > -1) {
            if (result['returnValue'] < 9) {
              settingManager.setRestBell(result['returnValue']);
              settingManager.setCustomRestBell(null);
            } else if (result['returnValue'] == 9) {
              settingManager.setRestBell(9);
              settingManager.setCustomRestBell(result['extra']);
            }
          }
        }
      },
    );
  }

  Widget buildAppVersionItem(BuildContext context) {
    return SettingItemVersion(
      onTap: () async {
        if (appUpdateChecker.isUpdateAvailable) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.normalDialog,
                  title: '??????????????? ???????????????',
                  content: '????????? ??? ????????? ??????????????????.\n?????? ?????? ???????????? ?????? ????????????????',
                  positive: '????????? ??????',
                  negative: '?????????',
                );
              });
          if (result != null && result['returnValue'] > -1) {
            appUpdateChecker.redirectToStore();
          }
        } else {
          Fluttertoast.showToast(
            msg: "?????? ?????? ???????????????.",
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      },
      isUpdateAvailable: appUpdateChecker.isUpdateAvailable,
    );
  }
}
