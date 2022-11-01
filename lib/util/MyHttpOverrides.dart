import 'dart:io';

// Prevents exception "Handshake error in client (OS Error: CERTIFICATE_VERIFY_FAILED: unable to get local issuer certificate(handshake.cc:393))"
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
