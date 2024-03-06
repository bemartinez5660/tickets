import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _scopes = [calendar.CalendarApi.calendarScope];
  var _credentials;
  @override
  void initState() {
    super.initState();
    _credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "isu-corp-test",
      "private_key_id": "1db2d01c65780c5e5389230ef0dfd9fe79962cd6",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC/RM4ZPhpU3C5a\nZtWlcBOZdEdd/aBvF+o/LLtgrZWj0TdPPdA2G3wH0EVvusk2cPAahQZF/KGCFNzJ\nV9exJX7HxQVB5xOBHgIge68w1Ldr9RWQxEyoXtV1edcjUdSALs6kmAMu65X92uZk\nD1WcehHW2onUPViKjwUHWUreBrUF4R4ZS9X9UUByiTfQ4LPJtklhwzBKcruMy08x\nieBYN1Z1l78oCy5UFcKGn0SBT5FWyhF0ZJptxBcfnACJ1AvAG9Th/IAo0Wiyexts\nn+gqdKtGPE0LKGb5goHLz0YVEW1QVEqOkKPoKKuy2DVIfJnwdvUaspGfi42Klx68\nCRkT0nsPAgMBAAECggEAAOjmyD5RpqdRdSAT6bZbN1PqWp+kfIibxOcoYnaz0Q6p\nP1MnIErCcrmcnGT8amQmOPLMH9d2Dku0vpjKo/G0WX3/aq1JVl9un1buiqsCiREy\nASfSPSj3C4GMlZpVOOFo19pOtHpWksJE+V1pq9Wvt32icDKjl9AJblv400ifnFnQ\nHhRiqZ9MXrPWpdXNDxAN2OfykhAOlR7ttJiDAO5OwzwM5f6VCNuhwCYBD2ImGpVN\ne6+AbyQsapkSidqabsagfOIL3v7njNHR9jR5XEugnDC64esevHAlP50rO+A6UJv8\nK/ctPH0W68RerbidqRkeOSyXz2IUA5IQo6OKISfDMQKBgQDqI4Zk2qFxFK33We9e\nuW3i5A0Wyl3bCpbEtIJ9C0c4DeLHARepesQcSxefWVMTXtuTSTfhIvXsJWojogxu\nu2opuStJPvQBLk5SJ1+9KBUmMYU9Y4Jd9rgao6fybAOeUDfslcLgJLdSNvRtxBnW\nL+3V3EarwD3PbByLxOD2nFPz+QKBgQDRIJW5P4leL3jwZr8syTDh7q/ii0mT6due\nEOVf4EelFu6R++1fiDdkkLD7vTQ796wkg84vGJWkaJW3kAP/7TPg3gUUUAf1cUf9\n4h8A8UlZez0pGmURguzaedv5I4+OQcl0CVDFmyirk1E7+4VkDWP6MqCLVSFLSTFP\n8ULnJAqZRwKBgQCpGztoAFh1+f+kFTrD6Z2qMBgcC9E58S3vqIhOlCS+IZlXLjzO\n1bJq1Pmcx8EuzmY8vLc1TjDcfDFqxxG/sHD+7ZSL9IH7kFxVDcciMZ8E1ONs8UAp\naZaS9vzIJKeAYmPh5lC33wzgvnxQA0C96CQZQF1ykwiRlX4QnQP2WfZw0QKBgAxN\nHWGDMkJfCn8hnBc3Um/HyYLK7K4NsIRwu/1SxQQaADiIGCNpcNCyjiaQr5TjcbXI\nJwWwLYU5Pa1JhGK2gjm09ZmHR6CRZEmz1l0I1Ga2EBft3IoWKHaFeoICLHyStBXm\nQmENSmwlQz8DAYqsGvhpp/XqMQYrrQHl0CimfxUbAoGANXGqO4hNxU7SvChN3fYx\nVwaUcxpHG9cEee5jZQcQCgeIRqMW/fVCOkeMVxa0qIDFdnp8FtSV/zYBiN9HD2oc\nBSN/zFoEVfUkEPoVG6T4cdBp0VcS4JUaxNB1V49ljqwjjeXim1GOFr8NCpjo7v17\npDSszSuUgHNvobAtjOo8qYM=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "cuenta-de-servicio-936@isu-corp-test.iam.gserviceaccount.com",
      "client_id": "118425592656166468213",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/cuenta-de-servicio-936%40isu-corp-test.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });
    print(_credentials);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Calendar Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _fetchEventsFromCalendar(),
          child: const Text('Obtener Eventos del Calendario'),
        ),
      ),
    );
  }

  Future<void> _fetchEventsFromCalendar() async {
    // Autenticación con Google
    final client = await clientViaServiceAccount(_credentials, _scopes);

    // Inicialización del cliente de la API de Google Calendar
    final calendarApi = calendar.CalendarApi(client);

    try {
      // Obtener eventos del calendario del usuario
      final events = await calendarApi.events.list('primary');

      // Imprimir los títulos de los eventos
      events.items?.forEach((event) {
        print(event.summary);
      });
    } catch (e) {
      print('Error al obtener eventos: $e');
    } finally {
      // Cerrar la conexión del cliente
      client.close();
    }
  }
}
