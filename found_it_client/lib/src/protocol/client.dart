/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:found_it_client/src/protocol/dashboard/dashboard_stats.dart'
    as _ila16efb;
import 'package:found_it_client/src/protocol/greetings/greeting.dart'
    as _i2mcst3r;
import 'package:found_it_client/src/protocol/locations/location.dart'
    as _ikizyhu2;
import 'package:found_it_client/src/protocol/locations/location_area.dart'
    as _ia9iwpp5;
import 'package:found_it_client/src/protocol/matching/item_match.dart'
    as _ik1j6p4l;
import 'package:found_it_client/src/protocol/matching/match_details_dto.dart'
    as _ipha0ngu;
import 'package:found_it_client/src/protocol/notifications/app_notification.dart'
    as _i0k0rxep;
import 'package:found_it_client/src/protocol/reports/item_report.dart'
    as _ii8kv2u4;
import 'package:found_it_client/src/protocol/users/app_user.dart' as _i14gzzqr;
import 'package:found_it_client/src/protocol/verification/verification_attempt_result.dart'
    as _iabg45g9;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Endpoint providing platform-level analytics and demo seeding.
/// {@category Endpoint}
class EndpointDashboard extends _isc.EndpointRef {
  EndpointDashboard(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'dashboard';

  /// Fetches platform statistics for the home screen and metrics counter.
  _ida.Future<_ila16efb.DashboardStats> getStats() =>
      caller.callServerEndpoint<_ila16efb.DashboardStats>(
        'dashboard',
        'getStats',
        {},
      );

  /// One-click reset and initialization of realistic hackathon demo data.
  _ida.Future<bool> seedDemoData() => caller.callServerEndpoint<bool>(
    'dashboard',
    'seedDemoData',
    {},
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_i2mcst3r.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i2mcst3r.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// Endpoint handling Location and LocationArea management, lookup, and search.
/// {@category Endpoint}
class EndpointLocation extends _isc.EndpointRef {
  EndpointLocation(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'location';

  /// Fetches a location by ID.
  _ida.Future<_ikizyhu2.Location?> getLocation(int id) =>
      caller.callServerEndpoint<_ikizyhu2.Location?>(
        'location',
        'getLocation',
        {'id': id},
      );

  /// Lists all active locations with optional search and type filtering.
  _ida.Future<List<_ikizyhu2.Location>> listLocations({
    String? query,
    String? type,
  }) => caller.callServerEndpoint<List<_ikizyhu2.Location>>(
    'location',
    'listLocations',
    {
      'query': query,
      'type': type,
    },
  );

  /// Creates a new location.
  _ida.Future<_ikizyhu2.Location> createLocation(_ikizyhu2.Location location) =>
      caller.callServerEndpoint<_ikizyhu2.Location>(
        'location',
        'createLocation',
        {'location': location},
      );

  /// Fetches areas belonging to a specific location.
  _ida.Future<List<_ia9iwpp5.LocationArea>> getLocationAreas(int locationId) =>
      caller.callServerEndpoint<List<_ia9iwpp5.LocationArea>>(
        'location',
        'getLocationAreas',
        {'locationId': locationId},
      );

  /// Creates an area within a location.
  _ida.Future<_ia9iwpp5.LocationArea> createLocationArea(
    _ia9iwpp5.LocationArea area,
  ) => caller.callServerEndpoint<_ia9iwpp5.LocationArea>(
    'location',
    'createLocationArea',
    {'area': area},
  );
}

/// Endpoint for querying matches, explanations, and triggering match recalculations.
/// {@category Endpoint}
class EndpointMatch extends _isc.EndpointRef {
  EndpointMatch(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'match';

  /// Fetches all matches for a specific report, populated with full report details.
  _ida.Future<List<_ipha0ngu.MatchDetailsDto>> getMatchesForReport(
    int reportId,
  ) => caller.callServerEndpoint<List<_ipha0ngu.MatchDetailsDto>>(
    'match',
    'getMatchesForReport',
    {'reportId': reportId},
  );

  /// Fetches all matches involving any reports created by a user.
  _ida.Future<List<_ipha0ngu.MatchDetailsDto>> getUserMatches(String userId) =>
      caller.callServerEndpoint<List<_ipha0ngu.MatchDetailsDto>>(
        'match',
        'getUserMatches',
        {'userId': userId},
      );

  /// Fetches details for a single match.
  _ida.Future<_ipha0ngu.MatchDetailsDto?> getMatchDetails(int matchId) =>
      caller.callServerEndpoint<_ipha0ngu.MatchDetailsDto?>(
        'match',
        'getMatchDetails',
        {'matchId': matchId},
      );

  /// Triggers or recalculates matches for a specific report.
  _ida.Future<List<_ik1j6p4l.ItemMatch>> runMatchingForReport(int reportId) =>
      caller.callServerEndpoint<List<_ik1j6p4l.ItemMatch>>(
        'match',
        'runMatchingForReport',
        {'reportId': reportId},
      );
}

/// Endpoint providing real-time notification streaming and query management.
/// {@category Endpoint}
class EndpointNotification extends _isc.EndpointRef {
  EndpointNotification(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  /// Fetches recent notifications for a user.
  _ida.Future<List<_i0k0rxep.AppNotification>> getUserNotifications(
    String userId,
  ) => caller.callServerEndpoint<List<_i0k0rxep.AppNotification>>(
    'notification',
    'getUserNotifications',
    {'userId': userId},
  );

  /// Marks a notification as read.
  _ida.Future<bool> markAsRead(int notificationId) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'markAsRead',
        {'notificationId': notificationId},
      );

  /// Marks all notifications for a user as read.
  _ida.Future<bool> markAllAsRead(String userId) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'markAllAsRead',
        {'userId': userId},
      );

  /// Idiomatic Serverpod 4 real-time streaming method.
  /// Clients subscribe to this stream to receive instant live alerts.
  _ida.Stream<_i0k0rxep.AppNotification> watchNotifications(String userId) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i0k0rxep.AppNotification>,
        _i0k0rxep.AppNotification
      >(
        'notification',
        'watchNotifications',
        {'userId': userId},
        {},
      );
}

/// Endpoint handling Lost & Found item reporting, browsing, and image uploads.
/// {@category Endpoint}
class EndpointReport extends _isc.EndpointRef {
  EndpointReport(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'report';

  /// Creates a lost or found report, stores optional verification questions,
  /// and automatically triggers Serverpod matching engine.
  _ida.Future<_ii8kv2u4.ItemReport> createReport({
    required _ii8kv2u4.ItemReport report,
    String? verificationQuestion,
    String? verificationAnswer,
  }) => caller.callServerEndpoint<_ii8kv2u4.ItemReport>(
    'report',
    'createReport',
    {
      'report': report,
      'verificationQuestion': verificationQuestion,
      'verificationAnswer': verificationAnswer,
    },
  );

  /// Fetches a single report by ID.
  _ida.Future<_ii8kv2u4.ItemReport?> getReport(int reportId) =>
      caller.callServerEndpoint<_ii8kv2u4.ItemReport?>(
        'report',
        'getReport',
        {'reportId': reportId},
      );

  /// Lists reports with optional filters for the public board and exploration.
  _ida.Future<List<_ii8kv2u4.ItemReport>> listReports({
    int? locationId,
    String? reportType,
    String? category,
    String? status,
    String? searchQuery,
    required int limit,
  }) => caller.callServerEndpoint<List<_ii8kv2u4.ItemReport>>(
    'report',
    'listReports',
    {
      'locationId': locationId,
      'reportType': reportType,
      'category': category,
      'status': status,
      'searchQuery': searchQuery,
      'limit': limit,
    },
  );

  /// Fetches all reports submitted by a specific user.
  _ida.Future<List<_ii8kv2u4.ItemReport>> listUserReports(String userId) =>
      caller.callServerEndpoint<List<_ii8kv2u4.ItemReport>>(
        'report',
        'listUserReports',
        {'userId': userId},
      );

  /// Updates report status with authorization check.
  _ida.Future<_ii8kv2u4.ItemReport> updateReportStatus({
    required int reportId,
    required String status,
    required String userId,
  }) => caller.callServerEndpoint<_ii8kv2u4.ItemReport>(
    'report',
    'updateReportStatus',
    {
      'reportId': reportId,
      'status': status,
      'userId': userId,
    },
  );

  /// Direct photo upload handler using Serverpod database storage.
  /// Converts base64 bytes and stores in Serverpod cloud storage.
  _ida.Future<String> uploadPhoto({
    required String filename,
    required String base64Data,
  }) => caller.callServerEndpoint<String>(
    'report',
    'uploadPhoto',
    {
      'filename': filename,
      'base64Data': base64Data,
    },
  );
}

/// Endpoint for managing user profiles and sessions.
/// {@category Endpoint}
class EndpointUser extends _isc.EndpointRef {
  EndpointUser(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  /// Fetches an existing user or creates a new profile.
  _ida.Future<_i14gzzqr.AppUser> getOrCreateUser({
    required String userId,
    required String name,
    required String email,
    String? phone,
  }) => caller.callServerEndpoint<_i14gzzqr.AppUser>(
    'user',
    'getOrCreateUser',
    {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
    },
  );

  /// Gets a user by unique ID.
  _ida.Future<_i14gzzqr.AppUser?> getUser(String userId) =>
      caller.callServerEndpoint<_i14gzzqr.AppUser?>(
        'user',
        'getUser',
        {'userId': userId},
      );
}

/// Endpoint managing verification challenges and final item returns.
/// {@category Endpoint}
class EndpointVerification extends _isc.EndpointRef {
  EndpointVerification(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'verification';

  /// Fetches ONLY the public question for verification.
  /// IMPORTANT: The expected answer is NEVER sent to the client.
  _ida.Future<String?> getVerificationQuestion(int reportId) =>
      caller.callServerEndpoint<String?>(
        'verification',
        'getVerificationQuestion',
        {'reportId': reportId},
      );

  /// Submits an answer attempt for server-side verification.
  _ida.Future<_iabg45g9.VerificationAttemptResult> submitVerificationAnswer({
    required int reportId,
    required String claimantUserId,
    required String answer,
  }) => caller.callServerEndpoint<_iabg45g9.VerificationAttemptResult>(
    'verification',
    'submitVerificationAnswer',
    {
      'reportId': reportId,
      'claimantUserId': claimantUserId,
      'answer': answer,
    },
  );

  /// Marks an item as handed over / returned, completing the full lifecycle.
  _ida.Future<bool> markItemReturned({
    required int reportId,
    required String userId,
  }) => caller.callServerEndpoint<bool>(
    'verification',
    'markItemReturned',
    {
      'reportId': reportId,
      'userId': userId,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    dashboard = EndpointDashboard(this);
    greeting = EndpointGreeting(this);
    location = EndpointLocation(this);
    match = EndpointMatch(this);
    notification = EndpointNotification(this);
    report = EndpointReport(this);
    user = EndpointUser(this);
    verification = EndpointVerification(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointDashboard dashboard;

  late final EndpointGreeting greeting;

  late final EndpointLocation location;

  late final EndpointMatch match;

  late final EndpointNotification notification;

  late final EndpointReport report;

  late final EndpointUser user;

  late final EndpointVerification verification;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'dashboard': dashboard,
    'greeting': greeting,
    'location': location,
    'match': match,
    'notification': notification,
    'report': report,
    'user': user,
    'verification': verification,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
