import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quiet/material/dialogs.dart';
import 'package:quiet/pages/account/account.dart';
import 'package:quiet/repository/reddwarf/user/reddwarf_user.dart';
import 'package:wheel/src/net/rest/result.dart' as Result;
import 'package:wheel/wheel.dart';

import 'page_welcome.dart';

///登录流程: 密码输入
class PageLoginPassword extends ConsumerStatefulWidget {
  const PageLoginPassword({Key? key, required this.phone}) : super(key: key);

  ///手机号
  final String? phone;

  @override
  _PageLoginPasswordState createState() => _PageLoginPasswordState();
}

class _PageLoginPasswordState extends ConsumerState<PageLoginPassword> {
  final _inputController = TextEditingController();

  @override
  void initState() {
    _inputController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('手机号登录')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                controller: _inputController,
                obscureText: true,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(hintText: '请输入密码'),
              ),
            ),
            StretchButton(
              text: '登录',
              primary: false,
              onTap: _doLogin,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doLogin() async {
    final password = _inputController.text;
    if (password.isEmpty) {
      toast('请输入密码');
      return;
    }
    final account = ref.read(userProvider.notifier);
    final result = await showLoaderOverlay(context, account.login(widget.phone, password));
    if (result.isValue) {
      final Map linkedHashMap = result.asValue!.value;
      final String nickname = linkedHashMap["profile"]["nickname"];
      final String avatarUrl = linkedHashMap["profile"]["avatarUrl"];
      final AuthResult loginResult = await ReddwarfUser.login(widget.phone!, password, nickname, avatarUrl);
      if(loginResult.result == Result.Result.ok) {
        /**
         * https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html
         */
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pop(true);
      }
    } else {
      toast('登录失败:${result.asError!.error}');
    }
  }
}
