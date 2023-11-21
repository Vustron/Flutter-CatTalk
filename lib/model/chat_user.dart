// ignore_for_file: no_leading_underscores_for_local_identifiers

class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.id,
    required this.pushToken,
    required this.email,
  });
  late final String image;
  late final String about;
  late final String name;
  late final String createdAt;
  late final bool isOnline;
  late final String lastActive;
  late final String id;
  late final String pushToken;
  late final String email;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? [];
    about = json['about'] ?? [];
    name = json['name'] ?? [];
    createdAt = json['created_at'] ?? [];
    isOnline = json['is_online'] ?? [];
    lastActive = json['last_active'] ?? [];
    id = json['id'] ?? [];
    pushToken = json['push_token'] ?? [];
    email = json['email'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['id'] = id;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}
