// ignore_for_file: no_leading_underscores_for_local_identifiers
class Message {
  Message({
    required this.fromId,
    required this.msg,
    required this.read,
    required this.sent,
    required this.told,
    required this.type,
  });
  late String fromId;
  late String msg;
  late String read;
  late String sent;
  late String told;
  late Type type;

  Message.fromJson(Map<String, dynamic> json) {
    fromId = json['fromId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fromId'] = fromId;
    data['msg'] = msg;
    data['read'] = read;
    data['sent'] = sent;
    data['told'] = told;
    data['type'] = type.name;
    return data;
  }
}

enum Type { text, image }
