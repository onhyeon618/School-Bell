import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/app_update_checker.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/domain/setting_manager.dart';
import 'package:school_bell/navigation/app_state_manager.dart';
import 'package:school_bell/presentation/screen/setting/widget/category.dart';
import 'package:school_bell/presentation/screen/setting/widget/item.dart';
import 'package:school_bell/presentation/screen/setting/widget/item_version.dart';
import 'package:school_bell/presentation/widget/custom_dialog.dart';

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
          const SettingCategory(title: '기본 설정'),
          buildBellModeItem(context),
          buildClassLengthItem(context),
          buildRestLengthItem(context),
          const SizedBox(height: 8),
          const SettingCategory(title: '종소리 설정'),
          buildClassBellItem(context),
          buildRestBellItem(context),
          const SizedBox(height: 8),
          const SettingCategory(title: '어플리케이션'),
          buildAppVersionItem(context),
          SettingItem(
            title: '오픈소스 라이선스',
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
      title: '종소리 모드',
      attribute: _bellModeValue,
      isDisabled: _isCounting,
      onTap: () async {
        if (!_isCounting) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.setBellMode,
                  title: '종소리 모드',
                  positive: '설정하기',
                  negative: '취소',
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
      title: '한 교시 길이',
      attribute: _classLengthValue,
      isDisabled: _isOnTime || _isCounting,
      onTap: () async {
        if (!_isOnTime && !_isCounting) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.setTimeLength,
                  positive: '설정하기',
                  negative: '취소',
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
      title: '쉬는 시간 길이',
      attribute: _restLengthValue,
      isDisabled: _isOnTime || _isCounting,
      onTap: () async {
        if (!_isOnTime && !_isCounting) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.setTimeLength,
                  positive: '설정하기',
                  negative: '취소',
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
      title: '수업 시작 종',
      attribute: _classBellValue,
      isDisabled: _isCounting,
      onTap: () async {
        if (!_isCounting) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.setBellType,
                  positive: '설정하기',
                  negative: '취소',
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
      title: '수업 종료 종',
      attribute: _restBellValue,
      isDisabled: _isCounting,
      onTap: () async {
        if (!_isCounting) {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog(
                  dialogType: CustomDialogType.setBellType,
                  positive: '설정하기',
                  negative: '취소',
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
                  title: '업데이트가 가능합니다',
                  content: '어플의 새 버전이 출시되었어요.\n지금 바로 업데이트 하러 가시겠어요?',
                  positive: '스토어 가기',
                  negative: '나중에',
                );
              });
          if (result != null && result['returnValue'] > -1) {
            appUpdateChecker.redirectToStore();
          }
        } else {
          Fluttertoast.showToast(
            msg: "현재 최신 버전이에요.",
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      },
      isUpdateAvailable: appUpdateChecker.isUpdateAvailable,
    );
  }
}
