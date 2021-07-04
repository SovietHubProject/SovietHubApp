import 'package:flutter/cupertino.dart';
import 'package:openapi/api.dart';
import 'package:retroshare/model/auth.dart';
import 'package:retroshare/model/chat.dart';
import 'package:retroshare/model/location.dart';
import 'package:retroshare/services/chat.dart';

class ChatLobby with ChangeNotifier {
  List<Chat> _listchat = [];
  AuthToken _authToken;
  List<VisibleChatLobbyRecord> _unsubscribedlist = [];
  List<Chat> get subscribedlist => _listchat;
  List<VisibleChatLobbyRecord> get unSubscribedlist => _unsubscribedlist;
  Future<void> fetchAndUpdate() async {
    _listchat = await getSubscribedChatLobbies();
    notifyListeners();
  }

  void setAuthToken(AuthToken authToken) {
    _authToken = authToken;
    notifyListeners();
  }

  Future<void> fetchAndUpdateUnsubscribed() async {
    _unsubscribedlist = await getUnsubscribedChatLobbies();
    notifyListeners();
  }

  Future<void> unsubscribed(String lobbyId) async {
    await unsubscribeChatLobby(lobbyId);
    _listchat = await getSubscribedChatLobbies();
    _unsubscribedlist = await getUnsubscribedChatLobbies();
    notifyListeners();
  }

  Future<bool> createChatlobby(
      String lobbyName, String idToUse, String lobbyTopic,
      {List<Location> inviteList = const <Location>[],
      bool public = true,
      bool anonymous = true}) async {
    bool success = await createChatLobby(lobbyName, idToUse, lobbyTopic,
        inviteList: inviteList, anonymous: anonymous, public: public);
    if (success) fetchAndUpdate();
    return success;
  }
}
