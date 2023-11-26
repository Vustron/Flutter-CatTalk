// ignore_for_file: no_leading_underscores_for_local_identifiers
class Message {
  Message({
    required this.told,
    required this.msg,
    required this.read,
    required this.fromId,
    required this.type,
    required this.sent,
  });
  late String told;
  late String msg;
  late String read;
  late String fromId;
  late Type type;
  late String sent;

  Message.fromJson(Map<String, dynamic> json) {
    told = json['told'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    fromId = json['fromId'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['told'] = told;
    data['msg'] = msg;
    data['read'] = read;
    data['fromId'] = fromId;
    data['type'] = type.name;
    data['sent'] = sent;
    return data;
  }
}

enum Type { text, image }
