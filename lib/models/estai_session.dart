/// Sessão autenticada retornada pelo endpoint `GET /me` da API do Estai.
///
/// A resposta da API vem embrulhada em `{ "data": { ... } }`; use
/// [EstaiSession.fromJson] passando o conteúdo de `data`.
class EstaiSession {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final EstaiUser user;

  const EstaiSession({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory EstaiSession.fromJson(Map<String, dynamic> json) {
    return EstaiSession(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
      user: EstaiUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class EstaiUser {
  final String id;
  final String name;
  final String email;
  final String type;
  final EstaiMarina? marina;

  const EstaiUser({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    this.marina,
  });

  factory EstaiUser.fromJson(Map<String, dynamic> json) {
    final marina = json['marina'];
    return EstaiUser(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      type: json['type'] as String? ?? '',
      marina: marina is Map<String, dynamic>
          ? EstaiMarina.fromJson(marina)
          : null,
    );
  }
}

class EstaiMarina {
  final String id;
  final String name;

  const EstaiMarina({required this.id, required this.name});

  factory EstaiMarina.fromJson(Map<String, dynamic> json) {
    return EstaiMarina(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
    );
  }
}
