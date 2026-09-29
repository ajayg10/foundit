import 'package:serverpod/serverpod.dart';

class AppConfigWidget extends JsonWidget {
  final String apiUrl;

  AppConfigWidget({
    required this.apiUrl,
  }) : super(object: {'apiUrl': apiUrl});
}

class AppConfigRoute extends WidgetRoute {
  final ServerConfig apiConfig;

  AppConfigRoute({
    required this.apiConfig,
  });

  @override
  Future<WebWidget> build(Session session, Request request) async {
    final reqHost = request.url.host;
    final host = (reqHost.isNotEmpty && reqHost != 'localhost' && reqHost != '127.0.0.1')
        ? reqHost
        : apiConfig.publicHost;

    final apiUrl = Uri(
      scheme: apiConfig.publicScheme,
      host: host,
      port: apiConfig.publicPort,
    );

    return AppConfigWidget(apiUrl: apiUrl.toString());
  }
}
