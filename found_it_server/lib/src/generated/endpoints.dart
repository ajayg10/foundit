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
import 'package:found_it_server/src/generated/locations/location.dart'
    as _id9j6dcf;
import 'package:found_it_server/src/generated/locations/location_area.dart'
    as _in7zv6r5;
import 'package:found_it_server/src/generated/reports/item_report.dart'
    as _iy9iiki0;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../dashboard/dashboard_endpoint.dart' as _izwoh05q;
import '../greetings/greeting_endpoint.dart' as _il624ik7;
import '../locations/location_endpoint.dart' as _i1lhihy8;
import '../matching/match_endpoint.dart' as _i6q1rn0s;
import '../notifications/notification_endpoint.dart' as _ibyw8x7k;
import '../reports/report_endpoint.dart' as _iqte9uvc;
import '../users/user_endpoint.dart' as _ibe74724;
import '../verification/verification_endpoint.dart' as _i6in6ig5;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'dashboard': _izwoh05q.DashboardEndpoint()
        ..initialize(
          server,
          'dashboard',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'location': _i1lhihy8.LocationEndpoint()
        ..initialize(
          server,
          'location',
          null,
        ),
      'match': _i6q1rn0s.MatchEndpoint()
        ..initialize(
          server,
          'match',
          null,
        ),
      'notification': _ibyw8x7k.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'report': _iqte9uvc.ReportEndpoint()
        ..initialize(
          server,
          'report',
          null,
        ),
      'user': _ibe74724.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
      'verification': _i6in6ig5.VerificationEndpoint()
        ..initialize(
          server,
          'verification',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['dashboard'] = _is.EndpointConnector(
      name: 'dashboard',
      endpoint: endpoints['dashboard']!,
      methodConnectors: {
        'getStats': _is.MethodConnector(
          name: 'getStats',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['dashboard'] as _izwoh05q.DashboardEndpoint)
                  .getStats(session),
        ),
        'seedDemoData': _is.MethodConnector(
          name: 'seedDemoData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['dashboard'] as _izwoh05q.DashboardEndpoint)
                  .seedDemoData(session),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    connectors['location'] = _is.EndpointConnector(
      name: 'location',
      endpoint: endpoints['location']!,
      methodConnectors: {
        'getLocation': _is.MethodConnector(
          name: 'getLocation',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['location'] as _i1lhihy8.LocationEndpoint)
                  .getLocation(
                    session,
                    params['id'],
                  ),
        ),
        'listLocations': _is.MethodConnector(
          name: 'listLocations',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'type': _is.ParameterDescription(
              name: 'type',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['location'] as _i1lhihy8.LocationEndpoint)
                  .listLocations(
                    session,
                    query: params['query'],
                    type: params['type'],
                  ),
        ),
        'createLocation': _is.MethodConnector(
          name: 'createLocation',
          params: {
            'location': _is.ParameterDescription(
              name: 'location',
              type: _is.getType<_id9j6dcf.Location>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['location'] as _i1lhihy8.LocationEndpoint)
                  .createLocation(
                    session,
                    params['location'],
                  ),
        ),
        'getLocationAreas': _is.MethodConnector(
          name: 'getLocationAreas',
          params: {
            'locationId': _is.ParameterDescription(
              name: 'locationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['location'] as _i1lhihy8.LocationEndpoint)
                  .getLocationAreas(
                    session,
                    params['locationId'],
                  ),
        ),
        'createLocationArea': _is.MethodConnector(
          name: 'createLocationArea',
          params: {
            'area': _is.ParameterDescription(
              name: 'area',
              type: _is.getType<_in7zv6r5.LocationArea>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['location'] as _i1lhihy8.LocationEndpoint)
                  .createLocationArea(
                    session,
                    params['area'],
                  ),
        ),
      },
    );
    connectors['match'] = _is.EndpointConnector(
      name: 'match',
      endpoint: endpoints['match']!,
      methodConnectors: {
        'getMatchesForReport': _is.MethodConnector(
          name: 'getMatchesForReport',
          params: {
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['match'] as _i6q1rn0s.MatchEndpoint)
                  .getMatchesForReport(
                    session,
                    params['reportId'],
                  ),
        ),
        'getUserMatches': _is.MethodConnector(
          name: 'getUserMatches',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['match'] as _i6q1rn0s.MatchEndpoint)
                  .getUserMatches(
                    session,
                    params['userId'],
                  ),
        ),
        'getMatchDetails': _is.MethodConnector(
          name: 'getMatchDetails',
          params: {
            'matchId': _is.ParameterDescription(
              name: 'matchId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['match'] as _i6q1rn0s.MatchEndpoint)
                  .getMatchDetails(
                    session,
                    params['matchId'],
                  ),
        ),
        'runMatchingForReport': _is.MethodConnector(
          name: 'runMatchingForReport',
          params: {
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['match'] as _i6q1rn0s.MatchEndpoint)
                  .runMatchingForReport(
                    session,
                    params['reportId'],
                  ),
        ),
      },
    );
    connectors['notification'] = _is.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'getUserNotifications': _is.MethodConnector(
          name: 'getUserNotifications',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ibyw8x7k.NotificationEndpoint)
                      .getUserNotifications(
                        session,
                        params['userId'],
                      ),
        ),
        'markAsRead': _is.MethodConnector(
          name: 'markAsRead',
          params: {
            'notificationId': _is.ParameterDescription(
              name: 'notificationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ibyw8x7k.NotificationEndpoint)
                      .markAsRead(
                        session,
                        params['notificationId'],
                      ),
        ),
        'markAllAsRead': _is.MethodConnector(
          name: 'markAllAsRead',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ibyw8x7k.NotificationEndpoint)
                      .markAllAsRead(
                        session,
                        params['userId'],
                      ),
        ),
        'watchNotifications': _is.MethodStreamConnector(
          name: 'watchNotifications',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['notification'] as _ibyw8x7k.NotificationEndpoint)
                  .watchNotifications(
                    session,
                    params['userId'],
                  ),
        ),
      },
    );
    connectors['report'] = _is.EndpointConnector(
      name: 'report',
      endpoint: endpoints['report']!,
      methodConnectors: {
        'createReport': _is.MethodConnector(
          name: 'createReport',
          params: {
            'report': _is.ParameterDescription(
              name: 'report',
              type: _is.getType<_iy9iiki0.ItemReport>(),
              nullable: false,
            ),
            'verificationQuestion': _is.ParameterDescription(
              name: 'verificationQuestion',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'verificationAnswer': _is.ParameterDescription(
              name: 'verificationAnswer',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['report'] as _iqte9uvc.ReportEndpoint)
                  .createReport(
                    session,
                    report: params['report'],
                    verificationQuestion: params['verificationQuestion'],
                    verificationAnswer: params['verificationAnswer'],
                  ),
        ),
        'getReport': _is.MethodConnector(
          name: 'getReport',
          params: {
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['report'] as _iqte9uvc.ReportEndpoint).getReport(
                    session,
                    params['reportId'],
                  ),
        ),
        'listReports': _is.MethodConnector(
          name: 'listReports',
          params: {
            'locationId': _is.ParameterDescription(
              name: 'locationId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'reportType': _is.ParameterDescription(
              name: 'reportType',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'searchQuery': _is.ParameterDescription(
              name: 'searchQuery',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['report'] as _iqte9uvc.ReportEndpoint).listReports(
                    session,
                    locationId: params['locationId'],
                    reportType: params['reportType'],
                    category: params['category'],
                    status: params['status'],
                    searchQuery: params['searchQuery'],
                    limit: params['limit'],
                  ),
        ),
        'listUserReports': _is.MethodConnector(
          name: 'listUserReports',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['report'] as _iqte9uvc.ReportEndpoint)
                  .listUserReports(
                    session,
                    params['userId'],
                  ),
        ),
        'updateReportStatus': _is.MethodConnector(
          name: 'updateReportStatus',
          params: {
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['report'] as _iqte9uvc.ReportEndpoint)
                  .updateReportStatus(
                    session,
                    reportId: params['reportId'],
                    status: params['status'],
                    userId: params['userId'],
                  ),
        ),
        'uploadPhoto': _is.MethodConnector(
          name: 'uploadPhoto',
          params: {
            'filename': _is.ParameterDescription(
              name: 'filename',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'base64Data': _is.ParameterDescription(
              name: 'base64Data',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['report'] as _iqte9uvc.ReportEndpoint).uploadPhoto(
                    session,
                    filename: params['filename'],
                    base64Data: params['base64Data'],
                  ),
        ),
      },
    );
    connectors['user'] = _is.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'getOrCreateUser': _is.MethodConnector(
          name: 'getOrCreateUser',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'phone': _is.ParameterDescription(
              name: 'phone',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _ibe74724.UserEndpoint).getOrCreateUser(
                    session,
                    userId: params['userId'],
                    name: params['name'],
                    email: params['email'],
                    phone: params['phone'],
                  ),
        ),
        'getUser': _is.MethodConnector(
          name: 'getUser',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _ibe74724.UserEndpoint).getUser(
                session,
                params['userId'],
              ),
        ),
      },
    );
    connectors['verification'] = _is.EndpointConnector(
      name: 'verification',
      endpoint: endpoints['verification']!,
      methodConnectors: {
        'getVerificationQuestion': _is.MethodConnector(
          name: 'getVerificationQuestion',
          params: {
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _i6in6ig5.VerificationEndpoint)
                      .getVerificationQuestion(
                        session,
                        params['reportId'],
                      ),
        ),
        'submitVerificationAnswer': _is.MethodConnector(
          name: 'submitVerificationAnswer',
          params: {
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'claimantUserId': _is.ParameterDescription(
              name: 'claimantUserId',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'answer': _is.ParameterDescription(
              name: 'answer',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _i6in6ig5.VerificationEndpoint)
                      .submitVerificationAnswer(
                        session,
                        reportId: params['reportId'],
                        claimantUserId: params['claimantUserId'],
                        answer: params['answer'],
                      ),
        ),
        'markItemReturned': _is.MethodConnector(
          name: 'markItemReturned',
          params: {
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _i6in6ig5.VerificationEndpoint)
                      .markItemReturned(
                        session,
                        reportId: params['reportId'],
                        userId: params['userId'],
                      ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
