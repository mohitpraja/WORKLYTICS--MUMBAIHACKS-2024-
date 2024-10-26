import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = getServiceAccountJson();
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client);
    client.close();
    return credentials.accessToken.data;
  }
   static getServiceAccountJson() {
        return {
          "type": "service_account",
          "project_id": "mumbai-hackthon",
          "private_key_id": "da9a4f01958a2091982af75860d462e50f45a8e3",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQChkunIxqjtUvFj\nhkBm/bUV4D4Aag3AhSJ2XyXP8aFKqCwREJIxOWvbqTjsW4BOWOiJ2R3FEHpaw3q8\nPmMiOBCW4fI2l7ziYbggBZXUfgkLkPWbWlht9qHPvMrGumM1jXBUzpjgPx7tiURw\n6VzWKwOFRiEqU+xJJ7wb+uIcegWM5AvGnLHmAbR9N9walNIxPsrhnnd2ydxD1Tbn\nWSuVJ7tNu2kf69wrsCIQeqCKiu6LDL4k1KnFD5ex263WCArf0JBG359OqilkXSh3\n5hJgZ2erFlW1EUlN3Z/9cPek2RE4yyv08mLpR+LJKs7eV4Sa9egCX2zBjDWpvVcM\nlM5AYPeFAgMBAAECggEANhCMVOgQt5T0++n829mSQhcueAIExwJllTliVDIU1//s\n+urSGFGQA0kdKI23ob/DU/kIKpxIbN2TULEJh/Y9qtdBLr5YcGHldCWaTKe9zBZ9\n8LVq+KS54WLZcWUF9HH3ABG/eu30IeS4N5YGwA1VmL9uMpUxcAsxOSWaio/UEp/m\nJbYScORA7utgjukwhJeKb7v40i9/R9GiQZQveS7d7rNTDo8WZqqc49ocqvbRfE60\ntiVyIqRxx9+3/qJe1mKRZqgXmeQCHqnmu4m8eRWrk0OnSDU9vc7REwYty1LyrsCH\nc83AjpwqrJhcYcoSz0A/ZIUYC3CBfD0yr2C+gmvL4wKBgQDH0gvf++8fdvtfJXYL\n+Wmz6ajaX7lKgWkUHGb4g5H0Tsf1HBB//MaYaS9vV6Fcvn+pZP9txAcOUqzeXoNb\nHcJxWLOIskaS00+k5o7Xv1OTITl63NGowtkkVcqiFC2+hkPVPXI77/3S3bWUAB6+\nFuypFKQDjgp2gKbr4ZpSRf5yFwKBgQDPABdLUm8QVRhGvbsprmJ7bI1juSy4mCuR\nQNuTOiLCmBcjDBFUEqZfOz3C4vzxV3AE23OFiT3zayGG9njffrRVoYuwC5qQzzcj\nUvNcGZoGMxPEiykXbB3JjMwPZl3SHr92vuk6wDI0GXy5i1OrsQU0e7tkhoS39HXG\n11SzVUpwwwKBgQDHqXVeKPHF4fDJILh0vJJHSIoFMjMGZIrnon2tgmI72OBqZdGC\n4cRbFHdmbQx6jIspaxbjykU2pZvAUnY0fGcHNRen1mM4YNcrMYm3wKC02jUCNFV2\nqMOqT+M60qjmwGhVUaGsjGB27Dx8lyYg0O1HAa3lM2/2+xRPjEzUOsZFnwKBgQCK\nqzXvqH5sg4Tqxuldx8uDgTnKh181HgN5n+g4Xaaxk29UdB4bow6/FxGNv7/Q8VFC\nf7yIxWKx8Z+ZKP3aQqgOAVVxjqRxw87dJBGRLjlnU8o3TT4uyae+wEpnOp05SI3c\nv5HAYMaA7l4GchaQGtswyH7FnfPEw8gud0vvgwCGPwKBgEsjfINxyDW51kxDK2ga\nL2NswRZvxRlrwr+W0XCtuqd1wszhKXkHSN4eRrXCKdXezEMpkvq4kPLByUbKhlKq\nczKRbeVdgjoEjXy7xgLfDO26PS1ktLwKOjbLNlYf6XAAOCwJlkIUDZZFUnlwbA7H\nMC393hrC2ZSkl8J6npZY5FLI\n-----END PRIVATE KEY-----\n",
          "client_email": "mumbai-hackthon@appspot.gserviceaccount.com",
          "client_id": "113272647800943928675",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/mumbai-hackthon%40appspot.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        };

  }
  static Future<void> notificationEmpToSelectTopic(String topic, String title, String nBody) async {
    String projectId = 'mumbai-hackthon';
    debugPrint("Notification will trigger on$topic");
    final String serverAccessTokenKey = await getAccessToken();

    // debugPrint("Notification will trigger topic----\n${serverAccessTokenKey.toString()}");
    String endpointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
    final Map<String, dynamic> message = {
      'message': {
        "topic": topic,
        'notification': {
          'title': title,
          'body': nBody
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done',
          'screen': 'tripRequest'
        }
      }
    };

    final http.Response response = await http.post(Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey',
      },
      body: jsonEncode(message),
    );
    if (response.statusCode == 200) {
      debugPrint('FCM message sent successfully');
    } else {
      debugPrint('Response body: ${response.body}');
    }
  }



}
