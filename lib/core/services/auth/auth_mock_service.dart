import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  // ignore: prefer_const_declarations
  static final _defaultUser = const ChatUser(
    id: '',
    name: '',
    email: '',
    imageURL: '',
  );

  // ignore: prefer_final_fields
  static Map<String, ChatUser> _users = {
    _defaultUser.email: _defaultUser,
  };
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
  });

  // ignore: annotate_overrides
  ChatUser? get currentUser {
    return _currentUser;
  }

  // ignore: annotate_overrides
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  // ignore: annotate_overrides
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageURL: image?.path ?? 'assets/images/avatar.png',
    );

    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  // ignore: annotate_overrides
  Future<void> login(String email, String password) async {
    _updateUser(_users[email]);
  }

  // ignore: annotate_overrides
  Future<void> logout() async {
    _updateUser(null);
  }

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
