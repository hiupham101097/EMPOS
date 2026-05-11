import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../controllers/config.dart';
import '../controllers/postapi.dart';
import '../models/config_model.dart';
import '../models/key_value.dart';
import '../models/user_model.dart';

class WebViewPage extends StatefulWidget {
  final VoidCallback voidCallback;

  const WebViewPage({required this.voidCallback, super.key});

  @override
  State<WebViewPage> createState() =>
      // ignore: no_logic_in_create_state
      _WebViewPageState(voidCallback: voidCallback);
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();
  final VoidCallback voidCallback;
  final defaulUrl = 'http://nhatdev.empos.info/vi/web-reponsive-order';

  _WebViewPageState({required this.voidCallback});

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: isKeyboardVisible == false
              ? getPlatformWebView(context)
              : getWebView(voidCallback),
        );
      },
    );
  }

  Widget getPlatformWebView(BuildContext contex) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      MediaQueryData mediaQueryData = MediaQuery.of(context);
      return OverflowBox(
        maxWidth: mediaQueryData.size.width + 1,
        maxHeight: mediaQueryData.size.height + 1,
        //- Scaffold.of(context).appBarMaxHeight!
        alignment: Alignment.topCenter,
        child: getWebView(voidCallback),
      );
    } else {
      return getWebView(voidCallback);
    }
  }

  InAppWebView getWebView(VoidCallback voidCallback) {
    GetIt getIt = GetIt.instance;
    var config = getIt.get<ConfigModel>();

    InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllowFullscreen: true,
      transparentBackground: true,
      allowUniversalAccessFromFileURLs: true,
      useShouldInterceptRequest: true,
      supportZoom: false,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    );

    return InAppWebView(
      key: webViewKey,
      initialSettings: settings,
      onWebViewCreated: (controller) async {
        config.controller = controller;

        if (defaultTargetPlatform != TargetPlatform.android ||
            await WebViewFeature.isFeatureSupported(
              WebViewFeature.WEB_MESSAGE_LISTENER,
            )) {
          await controller.addWebMessageListener(
            WebMessageListener(
              jsObjectName: "mobileHub",
              onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) {
                config.replyProxy = replyProxy;

                if (message != null && message.data != null) {
                  var json = jsonDecode(message.data);

                  if (json['value'] is List) {
                    var accessToken = json['value'][0];
                    var dataUser = UserModel.fromJson(json['value'][1]);
                    config.token = accessToken;

                    json['value'] = accessToken;

                    var keyValue = KeyValue.fromJson(json);

                    if (keyValue.key == "USER:LOGIN") {
                      keyValue = Config.getDeviceConnect();

                      replyProxy.postMessage(
                        WebMessage(data: jsonEncode(keyValue)),
                      );
                    }
                  } else {
                    var keyValue = KeyValue.fromJson(json);
                    if (keyValue.key == "USER:LOGOUT") {
                      PostDefaultUrlApi().signOut();
                      config.token = null;
                      config.firebaseToken = null;
                    }
                  }
                }
              },
            ),
          );
        }

        await controller.loadUrl(
          urlRequest: URLRequest(url: WebUri(defaulUrl!)),
        );
      },
      onLoadStart: (controller, url) {},
      onLoadStop: (controller, url) {
        voidCallback();
      },
    );
  }
}
