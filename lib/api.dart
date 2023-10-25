import 'package:http/http.dart' as http;
import 'dart:convert';

const String kApiKey = "D8A1B1B2-AFBE-4E06-93C6-7F566B08D5FB";

Future<double> getCoinRate(String coinName, String currencyName) async {
  Uri exchangeRateUrl = Uri(
    scheme: "https",
    host: "rest.coinapi.io",
    path: "v1/exchangerate/$coinName/$currencyName",
  );

  http.Response response = await http.get(exchangeRateUrl, headers: {
    "X-CoinAPI-Key": "D8A1B1B2-AFBE-4E06-93C6-7F566B08D5FB",
    "Accept": "application/json"
  });

  dynamic responseBody = jsonDecode(response.body);
  return responseBody["rate"];
}
