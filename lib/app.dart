import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:netease_music_api/netease_cloud_music.dart' as api;
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiet/component.dart';
import 'package:quiet/material/app.dart';
import 'package:quiet/pages/account/account.dart';
import 'package:quiet/pages/player/page_fm_playing_controller.dart';
import 'package:quiet/pages/splash/page_splash.dart';
import 'package:quiet/repository/netease.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel/wheel.dart';

void loadApp(ConfigType configType) {
  GlobalConfig.init(configType);
  WidgetsFlutterBinding.ensureInitialized();
  neteaseRepository = NeteaseRepository();
  api.debugPrint = debugPrint;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.time} ${record.level.name} '
        '${record.loggerName}: ${record.message}');
  });

  runZonedGuarded(() {
    runApp(ProviderScope(
      child: PageSplash(
        futures: [
          SharedPreferences.getInstance(),
          getApplicationDocumentsDirectory().then((dir) {
            Hive.init(dir.path);
            return Hive.openBox<Map>('player');
          }),
        ],
        builder: (BuildContext context, List<dynamic> data) {
          return MyApp(
            setting: Settings(data[0] as SharedPreferences),
            player: data[1] as Box<Map>,
          );
        },
      ),
    ));
    Timer.periodic(const Duration(seconds: 10), (Timer t) => updateQueueCount());

    //BackgroundFetch.re
  }, (error, stack) {
    AppLogHandler.restLogger('uncaught error : $error $stack');
  });
}

void updateQueueCount() {
  try {
    final cartController = Get.isRegistered<PagePlayingFmController>();
    if (cartController) {
      Get.find<PagePlayingFmController>().updateQueueCount();
    }
  } on Exception catch (e) {
    AppLogHandler.logError(RestApiError("type exception cartController error"), e.toString());
  } catch (error) {
    AppLogHandler.logError(RestApiError("cartController error"), error.toString());
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({
    Key? key,
    required this.setting,
    this.player,
  }) : super(key: key);

  final Settings setting;

  final Box<Map>? player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScopedModel<Settings>(
      model: setting,
      child: ScopedModelDescendant<Settings>(builder: (context, child, setting) {
        return Netease(
          child: Quiet(
            box: player,
            child: CopyRightOverlay(
              child: OverlaySupport(
                child: MaterialApp(
                  routes: routes,
                  onGenerateRoute: routeFactory,
                  title: 'Quiet',
                  supportedLocales: const [Locale("en"), Locale("zh")],
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                  ],
                  theme: setting.theme,
                  darkTheme: setting.darkTheme,
                  themeMode: setting.themeMode,
                  initialRoute: getInitialRoute(ref),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  String getInitialRoute(WidgetRef ref) {
    final bool login = ref.read(isLoginProvider);
    if (!login && !setting.skipWelcomePage) {
      return pageWelcome;
    }
    return pageMain;
  }
}
