import 'package:flutter/material.dart';
import 'package:rebook/services/auth_service.dart';
import 'package:rebook/utils/snackbar_util.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final AuthService authService = AuthService.instance;
  ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;
  final String _email = Supabase.instance.client.auth.currentUser!.email!;
  String _nickname =
      Supabase.instance.client.auth.currentUser!.userMetadata?['nickname'];
  late final TextEditingController _emailController;
  late final TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: _email);
    _nicknameController = TextEditingController(text: _nickname);
  }

  /// 닉네임 조건 검사 후 변경
  void onPressedEditButton() async {
    setState(() {
      _isLoading = true;
    });

    final newNickname = _nicknameController.text;
    // 길이 조건 확인
    if (newNickname.length < 3) {
      SnackbarUtil.showError(context, "닉네임은 3자 이상이어야 합니다.");
      setState(() {
        _isEditing = false;
      });
      return;
    } else if (newNickname.length > 16) {
      SnackbarUtil.showError(context, "닉네임은 16자 이하여야 합니다.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // 중복 확인
    final bool isAvailable = await widget.authService.isNicknameAvailable(
      newNickname,
    );

    if (!isAvailable) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }
      SnackbarUtil.showError(context, "이미 사용중인 닉네임입니다.");
      return;
    }

    final String userId = Supabase.instance.client.auth.currentUser!.id;
    bool isSuccess = await widget.authService.changeNickname(
      userId,
      newNickname,
    );

    if (!isSuccess) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }
      SnackbarUtil.showError(context, "예외가 발생하여 닉네임 변경이 실패했습니다.");
      return;
    }

    setState(() {
      _nickname =
          Supabase.instance.client.auth.currentUser!.userMetadata?['nickname'];
      _isEditing = false;
      _isLoading = false;
    });
    if (!mounted) {
      return;
    }
    SnackbarUtil.showSuccess(context, "닉네임이 변경되었습니다.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "내 정보"),
      body: Column(
        children: [
          LabelInputWidget(
            label: "이메일",
            readonly: true,
            controller: _emailController,
          ),
          LabelInputWidget(
            label: "닉네임",
            readonly: !_isEditing,
            controller: _nicknameController,
          ),
          _isEditing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: onPressedEditButton,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('변경'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          _nicknameController.text = _nickname;
                        });
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('취소'),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text("닉네임 변경"),
                ),
        ],
      ),
    );
  }
}

class LabelInputWidget extends StatefulWidget {
  final String _label;
  final bool _readonly;
  final TextEditingController? _controller;

  const LabelInputWidget({
    super.key,
    required String label,
    required bool readonly,
    TextEditingController? controller,
  }) : _label = label,
       _readonly = readonly,
       _controller = controller;

  @override
  State<LabelInputWidget> createState() => _LabelInputWidgetState();
}

class _LabelInputWidgetState extends State<LabelInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget._label, style: TextStyle(fontSize: 16)),
          SizedBox(height: 5),
          TextField(
            controller: widget._controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(border: OutlineInputBorder()),
            readOnly: widget._readonly,
          ),
        ],
      ),
    );
  }
}
