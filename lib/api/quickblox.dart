import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:whats_up/api/consts.dart';
import 'package:whats_up/utils.dart';

Future<String> getApplicationToken() async {
  var client = http.Client();
  var token = '';
  var nowTimestamp = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
  var nonce = getNonce();
  List<Parameter> params = [
    const Parameter(key: "application_id", value: appId),
    const Parameter(key: "auth_key", value: authKey),
    Parameter(key: "nonce", value: nonce),
    Parameter(key: "timestamp", value: nowTimestamp),
  ];
  String normalisedString = getNormalisedString(params);
  String signature = getHmacSha1(normalisedString, authSecret);
  try {
    var response = await client
        .post(Uri.https(baseUrl, createApplicationSessionPath), body: {
      'application_id': appId,
      'auth_key': authKey,
      'nonce': nonce,
      'signature': signature,
      'timestamp': nowTimestamp,
    });
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    token = decodedResponse['session']['token'] as String;
  } finally {
    client.close();
  }
  return token;
}

Future<void> createUser(String number, String fullName, String appToken) async {
  var client = http.Client();
  var temp = jsonEncode({
    'login': number,
    'password': number,
    'full_name': fullName,
    'phone': number,
  });
  try {
    var response = await client.post(Uri.https(baseUrl, usersPath),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'QB-Token': appToken,
        },
        body: jsonEncode({
          'user': {
            'login': number,
            'password': number,
            'full_name': fullName,
            'phone': number,
          },
        }));
  } finally {
    client.close();
  }
}

Future<void> loginUser(String number, String appToken) async {
  var client = http.Client();
  var temp = jsonEncode({
    'login': number,
    'password': number,
  });
  try {
    await client.post(Uri.https(baseUrl, loginUserPath),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'QB-Token': appToken,
        },
        body: jsonEncode({
          'login': number,
          'password': number,
        }));
  } finally {
    client.close();
  }
}

Future<List<String>> getUserSession(String number, String appToken) async {
  var client = http.Client();
  var token = '';
  var userId = '';
  var nowTimestamp = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
  var nonce = getNonce();
  List<Parameter> params = [
    const Parameter(key: "application_id", value: appId),
    const Parameter(key: "auth_key", value: authKey),
    Parameter(key: "nonce", value: nonce),
    Parameter(key: "timestamp", value: nowTimestamp),
    Parameter(key: "user[login]", value: number),
    Parameter(key: "user[password]", value: number),
  ];
  String normalisedString = getNormalisedString(params);
  String signature = getHmacSha1(normalisedString, authSecret);
  try {
    var response =
        await client.post(Uri.https(baseUrl, createApplicationSessionPath),
            headers: {
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.contentTypeHeader: 'application/json',
              // 'Accept': 'application/json',
              // 'Content-type': 'application/json',
              'QB-Token': appToken,
            },
            body: jsonEncode({
              'application_id': appId,
              'auth_key': authKey,
              'nonce': nonce,
              'signature': signature,
              'timestamp': nowTimestamp,
              'user': {
                'login': number,
                'password': number,
              },
            }));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    token = decodedResponse['session']['token'] as String;
    userId = decodedResponse['session']['user_id'].toString();
  } finally {
    client.close();
  }
  return [token, userId];
}

Future<List<String>> getLastDialogDetails(
    String userToken, String oppId) async {
  var client = http.Client();
  String lastMessage = '';
  String lastMessageSent = '';
  try {
    var response = await client.post(Uri.https(baseUrl, createDialogPath),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          'QB-Token': userToken,
        },
        body: jsonEncode({
          'type': 3,
          'occupants_ids': oppId,
        }));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    lastMessage = decodedResponse['last_message'].toString();
    lastMessageSent = decodedResponse['last_message_date_sent'].toString();
  } finally {
    client.close();
  }
  return [lastMessage, lastMessageSent];
}

Future<List<WhatsUpUser>> getAllUsers(String userToken, String userId) async {
  var client = http.Client();
  List<WhatsUpUser> users = List<WhatsUpUser>.empty();
  try {
    var response = await client.get(
      Uri.https(baseUrl, usersPath),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        'QB-Token': userToken,
      },
    );
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    List usersJson = decodedResponse['items'] as List;
    users = usersJson
        .map((userJson) => WhatsUpUser.fromJson(userJson))
        .where((user) => user.id != userId)
        .toList();
    for (var user in users) {
      // WhatsUpUser usr = WhatsUpUser.fromJson(userJson);
      List<String> usrDetails = await getLastDialogDetails(userToken, user.id);
      user.setLastMessage(usrDetails[0]);
      user.setLastMessageSent(usrDetails[1]);
      // users.add(usr);
    }
    users = users.where((user) => user.id != userId).toList();
  } finally {
    client.close();
  }
  return users;
}

Future<String> createDialog(String userToken, String oppId) async {
  var client = http.Client();
  var dialogId = '';
  try {
    var response = await client.post(Uri.https(baseUrl, createDialogPath),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          'QB-Token': userToken,
        },
        body: jsonEncode({
          'type': 3,
          'occupants_ids': oppId,
        }));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    dialogId = decodedResponse['_id'] as String;
  } finally {
    client.close();
  }
  return dialogId;
}

Future<List<Message>> getMessages(String dialogId, String userToken) async {
  var client = http.Client();
  var messages = List<Message>.empty();
  try {
    var response = await client.get(
      Uri.https(baseUrl, messagesPath, {'chat_dialog_id': dialogId}),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        'QB-Token': userToken,
      },
    );
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    messages = (decodedResponse['items'] as List)
        .map((message) => Message.fromJson(message))
        .toList();
  } finally {
    client.close();
  }
  return messages;
}

Future<void> sendMessage(
    String recipientId, String message, String userToken) async {
  var client = http.Client();
  try {
    var response = await client.post(Uri.https(baseUrl, messagesPath),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          'QB-Token': userToken,
        },
        body: jsonEncode({
          'recipient_id': recipientId,
          'message': message,
        }));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  } finally {
    client.close();
  }
}
