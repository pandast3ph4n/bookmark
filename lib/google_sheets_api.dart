import 'package:gsheets/gsheets.dart';
import 'package:flutter/material.dart';

class GoogleSheetsApi {

  // create credentials
static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "?",
  "private_key_id": "?",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDI1wov7SEocBY7\n95b2UZjXzXq6lohFmq7gaiM0aN8i4qkvaVPBKmLZxnJ+In0QvFKCinIE8pIYoar5\nEFW6m9EJrGbbGtdC3UFgV4BCy7d8COLslv5ilyRJLhMRbhkgIC+X9+oehBQ/SepR\n1Mq705J1FY24Xdjt2bWo3FubSpWWMxqlT9UAdrav93zvM/lkwVBZ16R+dY3doYUA\ncVchjh0q66OGs+m2MkXPejWIJnUkHh1acPSgUEhcb5hXLvItNl1WbcrWWxsYWfH3\nlCVzdWHSCHpVjRjIFkjQVnI9cpChSnnagD3wbCAZyzXKgi+mR1laJfwQcivUmm/a\nJ+IjgFo7AgMBAAECggEAGG1nNMsPpF51pdeISe9EusKoMbeLXYPhzzO5km9K7HBL\nCZQy9qSUH06usD67nWR6WJxEH+vs7wgCxoZBFxBKjXWlkPKjyeMlR3V9CSLD71cZ\nWpNG33Donen3scAFWE3x2/bwR8Pivovb7xYFjnC+OHVlpk3ry4oWOTKMBcg9h2X6\nqEAv4nKCL2Dqspj+RfzqcLBZ0jI+EVR+f0GeyjFnaPGv7t9GOHLPRWN5CIX1DNfX\nS6dBE0AnUZSCQloeGLIScUa2zkTX0PjFE3tUqO+uvDyBU+Jj1c8+kGnA9j6d9Ugd\n006yryAinccxbOp7jl9fZJrGAo9y+h/JIlyD+65D6QKBgQDi11GZYZVMvpgyL0Y/\nw5Ag37NeP5EZFjT8UTbwrXU0iKL3HNkRtc/IzvYtqcc0V2W+hbMxey/gwhO5xMTs\nkC/hLpnRrnzU8yx6WeiaUdA9mEko6SytJLXa4OJPzyMiZm0bCTuzyynGtYSSSV+a\nXIlWws9zzdnCj3JAfuiE4rItBQKBgQDiqBnI0O/5cVIfLu7SOz+fxNGvy3bFJeR2\nUmhr61bfwjRZBXPHeG9YB5bvCvMx76qWiYHHDAlLcgazqzpg/ZgQdUF0nJ9rX8Vw\nzJRBKKKt2Ngodl+5EIF3GXvczXPgT4uZOT5wEpr3eLVF8h+lOPKXnLI0dSn6ShxL\nKh7iLT0OPwKBgQCgDlGTKhmQVwNIlba5kyGFMJJ9M9kLnHGyfxOG6r1CXg6u0foP\n1vtPs0hcm+jk863kqq3vgf4cVpRYhZB1Yp+GAb2jB70o/JQrmHjZOlT2wRcN+Mj/\nOmHemMLWkU83HJJrey5XBEjr3nQ2S/NbFWQKhdae3WaDM3foLiOeb95MiQKBgAea\nB7NafpHpIQ32rv/SCOI84aN5uXQHP1BQlzv3WqSKiOLrceSgv2s+ZeuCfIGSPjBq\nUDXyy2UCYAMqnPyfxLfYludoUVhyj9ampdpBmKMoAKfqwG8ehJkP+71+DoLZaB8t\nclCj7xqZq8q6wiDydgBruvZTb6L7VVOYCA0h40hVAoGBALZJhe5t4a9hbRb9zVt/\n1Xbl5yZlF403P3xXxA+cmhpjP7hyKV9DX4jzEV4OJnyRVD6yYZQo2fdwSKU/ltEy\nKxCBl25cNMRSLPWZjaKPZXQwdmOsj5Ra+dQHsbYZhDQYTi5anOiuvEPprd+IyMcK\nvOUWnTcQpCXJU3utbZEgXuW4\n-----END PRIVATE KEY-----\n",
  "client_email": "?",
  "client_id": "?",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "?"
}

''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '?';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfNotes = 0;
  static List<String> currentNotes = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('NOTES');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }
    // now we know how many notes to load, now let's load them!
    loadNotes();
  }

  // insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add(note);
    await _worksheet!.values.appendRow([note]);
  }

  // load existing notes from the spreadsheet
  static Future loadNotes() async {
    if (_worksheet == null) return;

    for (int i = 0; i < numberOfNotes; i++) {
      final String newNote =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add(newNote);
      }
    }
    // this will stop the circular loading indicator
    loading = false;
  }
}
