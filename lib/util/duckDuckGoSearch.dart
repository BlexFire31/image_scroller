import 'package:http/http.dart' as http;

Future<String?> duckDuckGoSearch(String searchQuery) async {
  try {
    http.Response response = await http.get(
      Uri(
        scheme: "https",
        host: "duckduckgo.com",
        queryParameters: {
          "q": searchQuery,
          "ia": "images",
          "iax": "images",
        },
      ),
    );

    RegExp exp = RegExp(r'vqd=([\d-]+)\&');
    String? token = exp.allMatches(response.body).first[1];

    if (token == null) {
      return null;
    }

    const headers = {
      'authority': 'duckduckgo.com',
      'accept': 'application/json, text/javascript, */*; q=0.01',
      'sec-fetch-dest': 'empty',
      'x-requested-with': 'XMLHttpRequest',
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-mode': 'cors',
      'referer': 'https://duckduckgo.com/',
      'accept-language': 'en-US,en;q=0.9',
    };

    Map<String, String> params = {
      "ia": "images",
      "iax": "images",
      'o': 'json',
      'q': searchQuery,
      'vqd': token,
    };

    response = await http.get(
      Uri.https(
        "duckduckgo.com",
        "/i.js",
        params,
      ),
      headers: headers,
    );

    return response.body;
  } catch (e) {
    return null;
  }
}
