class TokenResponse {
  String accessToken;
  String refreshToken;

  TokenResponse({required this.accessToken, required this.refreshToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"]
    );
  }
}

class UserResponse {
  int userId;
  String name;
  String profileUrl;

  UserResponse({required this.userId, required this.name, required this.profileUrl});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
        userId: json["userId"],
        name: json["name"],
        profileUrl: json["profileUrl"]
    );
  }
}

class DoneResponse {
  int doneId, kakaoId;
  String name, writeAt, title, content;
  bool isPublic;

  DoneResponse({required this.doneId, required this.kakaoId, required this.name, required this.writeAt, required this.title, required this.content, required this.isPublic});

  factory DoneResponse.fromJson(Map<String, dynamic> json) {
    return DoneResponse(
      doneId: json['doneId'],
      name: json['userName'],
      kakaoId: json['kakaoId'],
      writeAt: json['writeAt'],
      title: json['title'],
      content: json['content'],
      isPublic: json['isPublic']
    );
  }
}