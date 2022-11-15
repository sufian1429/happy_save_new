import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheets-340622",
  "private_key_id": "2afc474462256e5bef453d2bc3b519f5a24e32e1",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCbtE/UppSj2ZJ5\nWbRq3L8juS/sCB2qRJpxlYY6CoHETssOtT1CuLtSJw6aSrJXRZQnAQ7PWCtviIaj\nIZu/VZxOnUMxAoqQ4am90glY5iNTs8x/IoqqeQwiIpIiVHTN4rC3nUCU7ql63yr8\nVbXVR46fqQdSjOYU/Cm0quVRfQZOkLGdPyen6FgigXKMZI6iuq5WFr4o+DySHj5D\nLX1QLDzrrIlEqC5a/2HYNHcntVuikW2HKrwl6dHZzNnXg86TRbHgNO/RzeREOtCV\ny1E8SDnjq2QFTQXMfgYFoa/EgAWcp7Qk/2XJayNY1vztGv0K8mkhozOkVLPIRhO3\nfKUsKBx9AgMBAAECggEAEBT6ndsqxRWm1FPYl6T/NQBem8Fm1vxI+2xXNc16A72j\nqXw8vJR5/I0+K9+FNhBgsfqg/fd8XQO77EN/Y67C+zexBfHeQAKe1pVIE9+JTI7o\nk0UND3h7MVdiwpr4iX9dg0mBryBLbv534SI1Krc+Wu1JbVRSO16kLB3um5EPQrPz\n4SdwIRIPjZVfjXJzm7H+JR6XwTiF+95ezKzSBeKOcHbj0WhW+c7YgIjurmzBA9dA\nCnselpOm4OuQ3QRfA2oKGCjGQeoS5veFb8Tf4KHK8sjgMpyEWeMoaLhpj5MzRJCK\n0kkmZRoJ2rUUxzptC+X72nWf31VpqoNl6YJKWdBSfQKBgQDUtHx6YhQBm1/vwMIl\nQCUlNekse/9BLXOXhGo5Y9VyFXMscisUq0ASwp8ouYm0rYYfj27uKE58id0TX6yU\nNDvmQoaA5YSuHRbMhqJWChUSdOppEywtFYLKGTrWMQjy/krPollXcF/hpgIfswW3\n5yixr42tlNDsxde/g1VWPrmI0wKBgQC7ZaqJjU0Sba5iIE/jMjC3CMcVQbS/eOyo\nrBgkxWagXWDfjYmuAkaw3v5I+IkWY4E66re3sEtw+XbplJMdLsdTy90pkufyYP0L\n6ikvBwW/rAcsgjs1SBNQWb6eRoyiweub0+x87CUz1BPHA+FLtUc/sUMowvUVo5PK\nu8Q6AmVzbwKBgQCLvcfJ34WlSJ7OtKTYNDwzJif6wbwA5gt7D9N5wM0KFm2EVb1X\n5upBaPuHld2Shi4HrgQDExf9WdWUVNbcxzRTIoGbTS7N9O51kD42qIkPhyA5yA7N\nz8QNYmX1MmHewpIDt3VarMlRRe8/RC4NlCB4HA3IbGyWIaSMfYwjDTJ3YQKBgF62\nVInu24w72Q4JLLc0b8CidBQ/QD4hvOLHD/DNwD++0i5Kl9JVnirYmYaB7q9dHTyM\n0svJE2gG/V2y1OPD98RXXfEcKZSsBljWQXheQT6NkJajP49/XRuYMCpIl93OyujY\nJEdDBs56GoDUajLcbSU4zyuz1TDZmuG1Isj62xGLAoGAS/JxGsvxKCp3WWXZjR6c\n+/hjaqbB5LwbHFT4jkLRKuMn3MwSvut0Wf+vnSM6MYS9iZSoj3XYMqIhfFK8xhnN\n8y7xEUigZLP+8YtQww+wF8nWZ2n+bfiJClCAMeX25Z8OVqYn9BUaMAxKmmcXzL7V\nTUPuRXXqYfJ2E4kNpH6rScw=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheet@gsheets-340622.iam.gserviceaccount.com",
  "client_id": "106628087441501257562",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheet%40gsheets-340622.iam.gserviceaccount.com"
}

  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1BSrxKH_6NIMa2zJa1OSG8LgeBc2YoKmBt1Mla508Mrk';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init1() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('มกราคม');
    countRows();
  }

  Future init2() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('กุมภาพันธ์');
    countRows();
  }

  Future init3() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('มีนาคม');
    countRows();
  }

  Future init4() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('เมษายน');
    countRows();
  }

  Future init5() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('พฤษภาคม');
    countRows();
  }

  Future init6() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('มิถุนายน');
    countRows();
  }

  Future init7() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('กรกฎาคม');
    countRows();
  }

  Future init8() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('สิงหาคม');
    countRows();
  }

  Future init9() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('กันยายน');
    countRows();
  }

  Future init10() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('ตุลาคม');
    countRows();
  }

  Future init11() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('พฤศจิกายน');
    countRows();
  }

  Future init12() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('ธันวาคม');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);
      final String formattedDate =
          await _worksheet!.values.value(column: 4, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
          formattedDate,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(
      String name, String amount, bool _isIncome, String day) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
      day,
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
      day,
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
