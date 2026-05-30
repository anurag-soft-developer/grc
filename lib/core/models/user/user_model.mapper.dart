// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_model.dart';

class UserModelMapper extends ClassMapperBase<UserModel> {
  UserModelMapper._();

  static UserModelMapper? _instance;
  static UserModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserModel';

  static String? _$id(UserModel v) => v.id;
  static const Field<UserModel, String> _f$id = Field(
    'id',
    _$id,
    key: r'_id',
    opt: true,
  );
  static String? _$email(UserModel v) => v.email;
  static const Field<UserModel, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$role(UserModel v) => v.role;
  static const Field<UserModel, String> _f$role = Field(
    'role',
    _$role,
    opt: true,
  );
  static String? _$fullName(UserModel v) => v.fullName;
  static const Field<UserModel, String> _f$fullName = Field(
    'fullName',
    _$fullName,
    opt: true,
  );
  static String? _$bio(UserModel v) => v.bio;
  static const Field<UserModel, String> _f$bio = Field('bio', _$bio, opt: true);
  static String? _$avatar(UserModel v) => v.avatar;
  static const Field<UserModel, String> _f$avatar = Field(
    'avatar',
    _$avatar,
    opt: true,
  );
  static bool? _$isActive(UserModel v) => v.isActive;
  static const Field<UserModel, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    opt: true,
  );
  static bool? _$isVerified(UserModel v) => v.isVerified;
  static const Field<UserModel, bool> _f$isVerified = Field(
    'isVerified',
    _$isVerified,
    opt: true,
  );
  static bool? _$isEmailVerified(UserModel v) => v.isEmailVerified;
  static const Field<UserModel, bool> _f$isEmailVerified = Field(
    'isEmailVerified',
    _$isEmailVerified,
    opt: true,
  );
  static String? _$phone(UserModel v) => v.phone;
  static const Field<UserModel, String> _f$phone = Field(
    'phone',
    _$phone,
    opt: true,
  );
  static String? _$lastLogin(UserModel v) => v.lastLogin;
  static const Field<UserModel, String> _f$lastLogin = Field(
    'lastLogin',
    _$lastLogin,
    opt: true,
  );
  static String? _$createdAt(UserModel v) => v.createdAt;
  static const Field<UserModel, String> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    opt: true,
  );
  static String? _$updatedAt(UserModel v) => v.updatedAt;
  static const Field<UserModel, String> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
  );
  static bool? _$isPasswordExists(UserModel v) => v.isPasswordExists;
  static const Field<UserModel, bool> _f$isPasswordExists = Field(
    'isPasswordExists',
    _$isPasswordExists,
    opt: true,
  );
  static bool? _$twoFactorEnabled(UserModel v) => v.twoFactorEnabled;
  static const Field<UserModel, bool> _f$twoFactorEnabled = Field(
    'twoFactorEnabled',
    _$twoFactorEnabled,
    opt: true,
  );

  @override
  final MappableFields<UserModel> fields = const {
    #id: _f$id,
    #email: _f$email,
    #role: _f$role,
    #fullName: _f$fullName,
    #bio: _f$bio,
    #avatar: _f$avatar,
    #isActive: _f$isActive,
    #isVerified: _f$isVerified,
    #isEmailVerified: _f$isEmailVerified,
    #phone: _f$phone,
    #lastLogin: _f$lastLogin,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #isPasswordExists: _f$isPasswordExists,
    #twoFactorEnabled: _f$twoFactorEnabled,
  };

  static UserModel _instantiate(DecodingData data) {
    return UserModel(
      id: data.dec(_f$id),
      email: data.dec(_f$email),
      role: data.dec(_f$role),
      fullName: data.dec(_f$fullName),
      bio: data.dec(_f$bio),
      avatar: data.dec(_f$avatar),
      isActive: data.dec(_f$isActive),
      isVerified: data.dec(_f$isVerified),
      isEmailVerified: data.dec(_f$isEmailVerified),
      phone: data.dec(_f$phone),
      lastLogin: data.dec(_f$lastLogin),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      isPasswordExists: data.dec(_f$isPasswordExists),
      twoFactorEnabled: data.dec(_f$twoFactorEnabled),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserModel>(map);
  }

  static UserModel fromJson(String json) {
    return ensureInitialized().decodeJson<UserModel>(json);
  }
}

mixin UserModelMappable {
  String toJson() {
    return UserModelMapper.ensureInitialized().encodeJson<UserModel>(
      this as UserModel,
    );
  }

  Map<String, dynamic> toMap() {
    return UserModelMapper.ensureInitialized().encodeMap<UserModel>(
      this as UserModel,
    );
  }

  UserModelCopyWith<UserModel, UserModel, UserModel> get copyWith =>
      _UserModelCopyWithImpl<UserModel, UserModel>(
        this as UserModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserModelMapper.ensureInitialized().stringifyValue(
      this as UserModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserModelMapper.ensureInitialized().equalsValue(
      this as UserModel,
      other,
    );
  }

  @override
  int get hashCode {
    return UserModelMapper.ensureInitialized().hashValue(this as UserModel);
  }
}

extension UserModelValueCopy<$R, $Out> on ObjectCopyWith<$R, UserModel, $Out> {
  UserModelCopyWith<$R, UserModel, $Out> get $asUserModel =>
      $base.as((v, t, t2) => _UserModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserModelCopyWith<$R, $In extends UserModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? email,
    String? role,
    String? fullName,
    String? bio,
    String? avatar,
    bool? isActive,
    bool? isVerified,
    bool? isEmailVerified,
    String? phone,
    String? lastLogin,
    String? createdAt,
    String? updatedAt,
    bool? isPasswordExists,
    bool? twoFactorEnabled,
  });
  UserModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserModel, $Out>
    implements UserModelCopyWith<$R, UserModel, $Out> {
  _UserModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserModel> $mapper =
      UserModelMapper.ensureInitialized();
  @override
  $R call({
    Object? id = $none,
    Object? email = $none,
    Object? role = $none,
    Object? fullName = $none,
    Object? bio = $none,
    Object? avatar = $none,
    Object? isActive = $none,
    Object? isVerified = $none,
    Object? isEmailVerified = $none,
    Object? phone = $none,
    Object? lastLogin = $none,
    Object? createdAt = $none,
    Object? updatedAt = $none,
    Object? isPasswordExists = $none,
    Object? twoFactorEnabled = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (email != $none) #email: email,
      if (role != $none) #role: role,
      if (fullName != $none) #fullName: fullName,
      if (bio != $none) #bio: bio,
      if (avatar != $none) #avatar: avatar,
      if (isActive != $none) #isActive: isActive,
      if (isVerified != $none) #isVerified: isVerified,
      if (isEmailVerified != $none) #isEmailVerified: isEmailVerified,
      if (phone != $none) #phone: phone,
      if (lastLogin != $none) #lastLogin: lastLogin,
      if (createdAt != $none) #createdAt: createdAt,
      if (updatedAt != $none) #updatedAt: updatedAt,
      if (isPasswordExists != $none) #isPasswordExists: isPasswordExists,
      if (twoFactorEnabled != $none) #twoFactorEnabled: twoFactorEnabled,
    }),
  );
  @override
  UserModel $make(CopyWithData data) => UserModel(
    id: data.get(#id, or: $value.id),
    email: data.get(#email, or: $value.email),
    role: data.get(#role, or: $value.role),
    fullName: data.get(#fullName, or: $value.fullName),
    bio: data.get(#bio, or: $value.bio),
    avatar: data.get(#avatar, or: $value.avatar),
    isActive: data.get(#isActive, or: $value.isActive),
    isVerified: data.get(#isVerified, or: $value.isVerified),
    isEmailVerified: data.get(#isEmailVerified, or: $value.isEmailVerified),
    phone: data.get(#phone, or: $value.phone),
    lastLogin: data.get(#lastLogin, or: $value.lastLogin),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    isPasswordExists: data.get(#isPasswordExists, or: $value.isPasswordExists),
    twoFactorEnabled: data.get(#twoFactorEnabled, or: $value.twoFactorEnabled),
  );

  @override
  UserModelCopyWith<$R2, UserModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthResponseMapper extends ClassMapperBase<AuthResponse> {
  AuthResponseMapper._();

  static AuthResponseMapper? _instance;
  static AuthResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthResponseMapper._());
      UserModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthResponse';

  static UserModel _$user(AuthResponse v) => v.user;
  static const Field<AuthResponse, UserModel> _f$user = Field('user', _$user);
  static String _$accessToken(AuthResponse v) => v.accessToken;
  static const Field<AuthResponse, String> _f$accessToken = Field(
    'accessToken',
    _$accessToken,
  );
  static String _$refreshToken(AuthResponse v) => v.refreshToken;
  static const Field<AuthResponse, String> _f$refreshToken = Field(
    'refreshToken',
    _$refreshToken,
  );

  @override
  final MappableFields<AuthResponse> fields = const {
    #user: _f$user,
    #accessToken: _f$accessToken,
    #refreshToken: _f$refreshToken,
  };

  static AuthResponse _instantiate(DecodingData data) {
    return AuthResponse(
      user: data.dec(_f$user),
      accessToken: data.dec(_f$accessToken),
      refreshToken: data.dec(_f$refreshToken),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthResponse>(map);
  }

  static AuthResponse fromJson(String json) {
    return ensureInitialized().decodeJson<AuthResponse>(json);
  }
}

mixin AuthResponseMappable {
  String toJson() {
    return AuthResponseMapper.ensureInitialized().encodeJson<AuthResponse>(
      this as AuthResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return AuthResponseMapper.ensureInitialized().encodeMap<AuthResponse>(
      this as AuthResponse,
    );
  }

  AuthResponseCopyWith<AuthResponse, AuthResponse, AuthResponse> get copyWith =>
      _AuthResponseCopyWithImpl<AuthResponse, AuthResponse>(
        this as AuthResponse,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AuthResponseMapper.ensureInitialized().stringifyValue(
      this as AuthResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthResponseMapper.ensureInitialized().equalsValue(
      this as AuthResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthResponseMapper.ensureInitialized().hashValue(
      this as AuthResponse,
    );
  }
}

extension AuthResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthResponse, $Out> {
  AuthResponseCopyWith<$R, AuthResponse, $Out> get $asAuthResponse =>
      $base.as((v, t, t2) => _AuthResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthResponseCopyWith<$R, $In extends AuthResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UserModelCopyWith<$R, UserModel, UserModel> get user;
  $R call({UserModel? user, String? accessToken, String? refreshToken});
  AuthResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthResponse, $Out>
    implements AuthResponseCopyWith<$R, AuthResponse, $Out> {
  _AuthResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthResponse> $mapper =
      AuthResponseMapper.ensureInitialized();
  @override
  UserModelCopyWith<$R, UserModel, UserModel> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  $R call({UserModel? user, String? accessToken, String? refreshToken}) =>
      $apply(
        FieldCopyWithData({
          if (user != null) #user: user,
          if (accessToken != null) #accessToken: accessToken,
          if (refreshToken != null) #refreshToken: refreshToken,
        }),
      );
  @override
  AuthResponse $make(CopyWithData data) => AuthResponse(
    user: data.get(#user, or: $value.user),
    accessToken: data.get(#accessToken, or: $value.accessToken),
    refreshToken: data.get(#refreshToken, or: $value.refreshToken),
  );

  @override
  AuthResponseCopyWith<$R2, AuthResponse, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LoginOtpChallengeResponseMapper
    extends ClassMapperBase<LoginOtpChallengeResponse> {
  LoginOtpChallengeResponseMapper._();

  static LoginOtpChallengeResponseMapper? _instance;
  static LoginOtpChallengeResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = LoginOtpChallengeResponseMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'LoginOtpChallengeResponse';

  static String _$message(LoginOtpChallengeResponse v) => v.message;
  static const Field<LoginOtpChallengeResponse, String> _f$message = Field(
    'message',
    _$message,
  );
  static bool _$requiresOtp(LoginOtpChallengeResponse v) => v.requiresOtp;
  static const Field<LoginOtpChallengeResponse, bool> _f$requiresOtp = Field(
    'requiresOtp',
    _$requiresOtp,
  );
  static String _$email(LoginOtpChallengeResponse v) => v.email;
  static const Field<LoginOtpChallengeResponse, String> _f$email = Field(
    'email',
    _$email,
  );

  @override
  final MappableFields<LoginOtpChallengeResponse> fields = const {
    #message: _f$message,
    #requiresOtp: _f$requiresOtp,
    #email: _f$email,
  };

  static LoginOtpChallengeResponse _instantiate(DecodingData data) {
    return LoginOtpChallengeResponse(
      message: data.dec(_f$message),
      requiresOtp: data.dec(_f$requiresOtp),
      email: data.dec(_f$email),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LoginOtpChallengeResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginOtpChallengeResponse>(map);
  }

  static LoginOtpChallengeResponse fromJson(String json) {
    return ensureInitialized().decodeJson<LoginOtpChallengeResponse>(json);
  }
}

mixin LoginOtpChallengeResponseMappable {
  String toJson() {
    return LoginOtpChallengeResponseMapper.ensureInitialized()
        .encodeJson<LoginOtpChallengeResponse>(
          this as LoginOtpChallengeResponse,
        );
  }

  Map<String, dynamic> toMap() {
    return LoginOtpChallengeResponseMapper.ensureInitialized()
        .encodeMap<LoginOtpChallengeResponse>(
          this as LoginOtpChallengeResponse,
        );
  }

  LoginOtpChallengeResponseCopyWith<
    LoginOtpChallengeResponse,
    LoginOtpChallengeResponse,
    LoginOtpChallengeResponse
  >
  get copyWith =>
      _LoginOtpChallengeResponseCopyWithImpl<
        LoginOtpChallengeResponse,
        LoginOtpChallengeResponse
      >(this as LoginOtpChallengeResponse, $identity, $identity);
  @override
  String toString() {
    return LoginOtpChallengeResponseMapper.ensureInitialized().stringifyValue(
      this as LoginOtpChallengeResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoginOtpChallengeResponseMapper.ensureInitialized().equalsValue(
      this as LoginOtpChallengeResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return LoginOtpChallengeResponseMapper.ensureInitialized().hashValue(
      this as LoginOtpChallengeResponse,
    );
  }
}

extension LoginOtpChallengeResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginOtpChallengeResponse, $Out> {
  LoginOtpChallengeResponseCopyWith<$R, LoginOtpChallengeResponse, $Out>
  get $asLoginOtpChallengeResponse => $base.as(
    (v, t, t2) => _LoginOtpChallengeResponseCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class LoginOtpChallengeResponseCopyWith<
  $R,
  $In extends LoginOtpChallengeResponse,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? message, bool? requiresOtp, String? email});
  LoginOtpChallengeResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LoginOtpChallengeResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginOtpChallengeResponse, $Out>
    implements
        LoginOtpChallengeResponseCopyWith<$R, LoginOtpChallengeResponse, $Out> {
  _LoginOtpChallengeResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginOtpChallengeResponse> $mapper =
      LoginOtpChallengeResponseMapper.ensureInitialized();
  @override
  $R call({String? message, bool? requiresOtp, String? email}) => $apply(
    FieldCopyWithData({
      if (message != null) #message: message,
      if (requiresOtp != null) #requiresOtp: requiresOtp,
      if (email != null) #email: email,
    }),
  );
  @override
  LoginOtpChallengeResponse $make(CopyWithData data) =>
      LoginOtpChallengeResponse(
        message: data.get(#message, or: $value.message),
        requiresOtp: data.get(#requiresOtp, or: $value.requiresOtp),
        email: data.get(#email, or: $value.email),
      );

  @override
  LoginOtpChallengeResponseCopyWith<$R2, LoginOtpChallengeResponse, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LoginOtpChallengeResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthStatusResponseMapper extends ClassMapperBase<AuthStatusResponse> {
  AuthStatusResponseMapper._();

  static AuthStatusResponseMapper? _instance;
  static AuthStatusResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthStatusResponseMapper._());
      UserModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthStatusResponse';

  static bool _$isAuthenticated(AuthStatusResponse v) => v.isAuthenticated;
  static const Field<AuthStatusResponse, bool> _f$isAuthenticated = Field(
    'isAuthenticated',
    _$isAuthenticated,
  );
  static UserModel _$user(AuthStatusResponse v) => v.user;
  static const Field<AuthStatusResponse, UserModel> _f$user = Field(
    'user',
    _$user,
  );

  @override
  final MappableFields<AuthStatusResponse> fields = const {
    #isAuthenticated: _f$isAuthenticated,
    #user: _f$user,
  };

  static AuthStatusResponse _instantiate(DecodingData data) {
    return AuthStatusResponse(
      isAuthenticated: data.dec(_f$isAuthenticated),
      user: data.dec(_f$user),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthStatusResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthStatusResponse>(map);
  }

  static AuthStatusResponse fromJson(String json) {
    return ensureInitialized().decodeJson<AuthStatusResponse>(json);
  }
}

mixin AuthStatusResponseMappable {
  String toJson() {
    return AuthStatusResponseMapper.ensureInitialized()
        .encodeJson<AuthStatusResponse>(this as AuthStatusResponse);
  }

  Map<String, dynamic> toMap() {
    return AuthStatusResponseMapper.ensureInitialized()
        .encodeMap<AuthStatusResponse>(this as AuthStatusResponse);
  }

  AuthStatusResponseCopyWith<
    AuthStatusResponse,
    AuthStatusResponse,
    AuthStatusResponse
  >
  get copyWith =>
      _AuthStatusResponseCopyWithImpl<AuthStatusResponse, AuthStatusResponse>(
        this as AuthStatusResponse,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AuthStatusResponseMapper.ensureInitialized().stringifyValue(
      this as AuthStatusResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthStatusResponseMapper.ensureInitialized().equalsValue(
      this as AuthStatusResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthStatusResponseMapper.ensureInitialized().hashValue(
      this as AuthStatusResponse,
    );
  }
}

extension AuthStatusResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthStatusResponse, $Out> {
  AuthStatusResponseCopyWith<$R, AuthStatusResponse, $Out>
  get $asAuthStatusResponse => $base.as(
    (v, t, t2) => _AuthStatusResponseCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AuthStatusResponseCopyWith<
  $R,
  $In extends AuthStatusResponse,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  UserModelCopyWith<$R, UserModel, UserModel> get user;
  $R call({bool? isAuthenticated, UserModel? user});
  AuthStatusResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AuthStatusResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthStatusResponse, $Out>
    implements AuthStatusResponseCopyWith<$R, AuthStatusResponse, $Out> {
  _AuthStatusResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthStatusResponse> $mapper =
      AuthStatusResponseMapper.ensureInitialized();
  @override
  UserModelCopyWith<$R, UserModel, UserModel> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  $R call({bool? isAuthenticated, UserModel? user}) => $apply(
    FieldCopyWithData({
      if (isAuthenticated != null) #isAuthenticated: isAuthenticated,
      if (user != null) #user: user,
    }),
  );
  @override
  AuthStatusResponse $make(CopyWithData data) => AuthStatusResponse(
    isAuthenticated: data.get(#isAuthenticated, or: $value.isAuthenticated),
    user: data.get(#user, or: $value.user),
  );

  @override
  AuthStatusResponseCopyWith<$R2, AuthStatusResponse, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthStatusResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VerifyEmailTokensResponseMapper
    extends ClassMapperBase<VerifyEmailTokensResponse> {
  VerifyEmailTokensResponseMapper._();

  static VerifyEmailTokensResponseMapper? _instance;
  static VerifyEmailTokensResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = VerifyEmailTokensResponseMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'VerifyEmailTokensResponse';

  static String _$message(VerifyEmailTokensResponse v) => v.message;
  static const Field<VerifyEmailTokensResponse, String> _f$message = Field(
    'message',
    _$message,
  );
  static String _$accessToken(VerifyEmailTokensResponse v) => v.accessToken;
  static const Field<VerifyEmailTokensResponse, String> _f$accessToken = Field(
    'accessToken',
    _$accessToken,
  );
  static String _$refreshToken(VerifyEmailTokensResponse v) => v.refreshToken;
  static const Field<VerifyEmailTokensResponse, String> _f$refreshToken = Field(
    'refreshToken',
    _$refreshToken,
  );

  @override
  final MappableFields<VerifyEmailTokensResponse> fields = const {
    #message: _f$message,
    #accessToken: _f$accessToken,
    #refreshToken: _f$refreshToken,
  };

  static VerifyEmailTokensResponse _instantiate(DecodingData data) {
    return VerifyEmailTokensResponse(
      message: data.dec(_f$message),
      accessToken: data.dec(_f$accessToken),
      refreshToken: data.dec(_f$refreshToken),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VerifyEmailTokensResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VerifyEmailTokensResponse>(map);
  }

  static VerifyEmailTokensResponse fromJson(String json) {
    return ensureInitialized().decodeJson<VerifyEmailTokensResponse>(json);
  }
}

mixin VerifyEmailTokensResponseMappable {
  String toJson() {
    return VerifyEmailTokensResponseMapper.ensureInitialized()
        .encodeJson<VerifyEmailTokensResponse>(
          this as VerifyEmailTokensResponse,
        );
  }

  Map<String, dynamic> toMap() {
    return VerifyEmailTokensResponseMapper.ensureInitialized()
        .encodeMap<VerifyEmailTokensResponse>(
          this as VerifyEmailTokensResponse,
        );
  }

  VerifyEmailTokensResponseCopyWith<
    VerifyEmailTokensResponse,
    VerifyEmailTokensResponse,
    VerifyEmailTokensResponse
  >
  get copyWith =>
      _VerifyEmailTokensResponseCopyWithImpl<
        VerifyEmailTokensResponse,
        VerifyEmailTokensResponse
      >(this as VerifyEmailTokensResponse, $identity, $identity);
  @override
  String toString() {
    return VerifyEmailTokensResponseMapper.ensureInitialized().stringifyValue(
      this as VerifyEmailTokensResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return VerifyEmailTokensResponseMapper.ensureInitialized().equalsValue(
      this as VerifyEmailTokensResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return VerifyEmailTokensResponseMapper.ensureInitialized().hashValue(
      this as VerifyEmailTokensResponse,
    );
  }
}

extension VerifyEmailTokensResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VerifyEmailTokensResponse, $Out> {
  VerifyEmailTokensResponseCopyWith<$R, VerifyEmailTokensResponse, $Out>
  get $asVerifyEmailTokensResponse => $base.as(
    (v, t, t2) => _VerifyEmailTokensResponseCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VerifyEmailTokensResponseCopyWith<
  $R,
  $In extends VerifyEmailTokensResponse,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? message, String? accessToken, String? refreshToken});
  VerifyEmailTokensResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VerifyEmailTokensResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VerifyEmailTokensResponse, $Out>
    implements
        VerifyEmailTokensResponseCopyWith<$R, VerifyEmailTokensResponse, $Out> {
  _VerifyEmailTokensResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VerifyEmailTokensResponse> $mapper =
      VerifyEmailTokensResponseMapper.ensureInitialized();
  @override
  $R call({String? message, String? accessToken, String? refreshToken}) =>
      $apply(
        FieldCopyWithData({
          if (message != null) #message: message,
          if (accessToken != null) #accessToken: accessToken,
          if (refreshToken != null) #refreshToken: refreshToken,
        }),
      );
  @override
  VerifyEmailTokensResponse $make(CopyWithData data) =>
      VerifyEmailTokensResponse(
        message: data.get(#message, or: $value.message),
        accessToken: data.get(#accessToken, or: $value.accessToken),
        refreshToken: data.get(#refreshToken, or: $value.refreshToken),
      );

  @override
  VerifyEmailTokensResponseCopyWith<$R2, VerifyEmailTokensResponse, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _VerifyEmailTokensResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

