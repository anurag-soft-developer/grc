import 'package:dart_mappable/dart_mappable.dart';

part 'user_model.mapper.dart';

@MappableClass()
class UserModel with UserModelMappable {
  @MappableField(key: '_id')
  final String? id;
  final String? email;
  final String? role;
  @MappableField(key: 'fullName')
  final String? fullName;
  final String? bio;
  final String? avatar;
  @MappableField(key: 'isActive')
  final bool? isActive;
  @MappableField(key: 'isVerified')
  final bool? isVerified;
  @MappableField(key: 'isEmailVerified')
  final bool? isEmailVerified;
  final String? phone;
  @MappableField(key: 'lastLogin')
  final String? lastLogin;
  @MappableField(key: 'createdAt')
  final String? createdAt;
  @MappableField(key: 'updatedAt')
  final String? updatedAt;
  @MappableField(key: 'isPasswordExists')
  final bool? isPasswordExists;
  @MappableField(key: 'twoFactorEnabled')
  final bool? twoFactorEnabled;

  const UserModel({
    this.id,
    this.email,
    this.role,
    this.fullName,
    this.bio,
    this.avatar,
    this.isActive,
    this.isVerified,
    this.isEmailVerified,
    this.phone,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.isPasswordExists,
    this.twoFactorEnabled,
  });

  String get displayName => fullName ?? email?.split('@').first ?? 'User';

  static final fromMap = UserModelMapper.fromMap;
  static final fromJson = UserModelMapper.fromJson;
}

@MappableClass()
class AuthResponse with AuthResponseMappable {
  final UserModel user;
  @MappableField(key: 'accessToken')
  final String accessToken;
  @MappableField(key: 'refreshToken')
  final String refreshToken;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  static final fromMap = AuthResponseMapper.fromMap;
  static final fromJson = AuthResponseMapper.fromJson;
}

@MappableClass()
class LoginOtpChallengeResponse with LoginOtpChallengeResponseMappable {
  final String message;
  @MappableField(key: 'requiresOtp')
  final bool requiresOtp;
  final String email;

  const LoginOtpChallengeResponse({
    required this.message,
    required this.requiresOtp,
    required this.email,
  });

  static final fromMap = LoginOtpChallengeResponseMapper.fromMap;
  static final fromJson = LoginOtpChallengeResponseMapper.fromJson;
}

/// Not serialized — login flow union type.
class LoginResult {
  final UserModel? user;
  final LoginOtpChallengeResponse? otpChallenge;

  const LoginResult._({this.user, this.otpChallenge});

  bool get requiresOtp => otpChallenge?.requiresOtp == true;

  factory LoginResult.authenticated(UserModel user) => LoginResult._(user: user);

  factory LoginResult.challenge(LoginOtpChallengeResponse challenge) =>
      LoginResult._(otpChallenge: challenge);
}

@MappableClass()
class AuthStatusResponse with AuthStatusResponseMappable {
  @MappableField(key: 'isAuthenticated')
  final bool isAuthenticated;
  final UserModel user;

  const AuthStatusResponse({
    required this.isAuthenticated,
    required this.user,
  });

  static final fromMap = AuthStatusResponseMapper.fromMap;
  static final fromJson = AuthStatusResponseMapper.fromJson;
}

@MappableClass()
class VerifyEmailTokensResponse with VerifyEmailTokensResponseMappable {
  final String message;
  @MappableField(key: 'accessToken')
  final String accessToken;
  @MappableField(key: 'refreshToken')
  final String refreshToken;

  const VerifyEmailTokensResponse({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
  });

  static final fromMap = VerifyEmailTokensResponseMapper.fromMap;
  static final fromJson = VerifyEmailTokensResponseMapper.fromJson;
}
