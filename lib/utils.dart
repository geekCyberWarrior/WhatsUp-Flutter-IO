import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

String? isValidPhoneNumber(String? number) {
  if (number == null || number.isEmpty) {
    return "Please Enter Phone Number";
  }
  String patttern = r'(^[0-9]{10}$)';
  RegExp regExp = RegExp(patttern);
  if (!regExp.hasMatch(number)) {
    return 'Please Enter Valid Mobile Number';
  }
  return null;
}

bool isValidName(String? name) {
  return !(name == null || name.isEmpty);
}

class Parameter {
  final String key;
  final String value;
  const Parameter({required this.key, required this.value});
}

String getNormalisedString(List<Parameter> params) {
  List<String> pairs =
      params.map((param) => param.key + "=" + param.value).toList();
  return pairs.join("&");
}

String getHmacSha1(String normalisedString, String k) {
  var key = utf8.encode(k);
  var bytes = utf8.encode(normalisedString);

  var hmacSha1 = Hmac(sha1, key);
  var digest = hmacSha1.convert(bytes);

  return digest.toString();
}

String getNonce() {
  var nonce = 10000 + Random().nextInt(99999 - 10000);
  return nonce.toString();
}

class WhatsUpUser {
  final String id;
  final String fullName;
  String lastMessage = "";
  String lastMessageSent = "";
  WhatsUpUser({required this.id, required this.fullName});

  factory WhatsUpUser.fromJson(Map<String, dynamic> json) {
    return WhatsUpUser(
        id: json['user']['id'].toString(),
        fullName: json['user']['full_name'].toString());
  }

  void setLastMessage(String lastMsg) {
    lastMessage = lastMsg == "null" ? "" : lastMsg;
  }

  void setLastMessageSent(String lastMsgSent) {
    if (lastMsgSent != "null") {
      DateTime datetime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(lastMsgSent) * 1000, isUtc: true);
      String formattedDate =
          DateFormat('yyyy-MM-ddTkk:mm:ss').format(datetime) + "Z";
      lastMessageSent = formattedDate;
    } else {
      lastMessageSent = "";
    }
  }

  @override
  String toString() {
    return id + " " + fullName;
  }
}

class Message {
  final message;
  final fromId;
  final toId;
  final createdAt;
  const Message(
      {required this.message,
      required this.fromId,
      required this.toId,
      required this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'].toString(),
      fromId: json['sender_id'].toString(),
      toId: json['recipient_id'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }

  @override
  String toString() {
    return message + " " + fromId + " " + toId;
  }
}
