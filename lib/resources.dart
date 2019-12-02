class Strings {
  static const yourGroup = 'Your Group';
  static const groups = 'Groups';
  static const secretSanta = 'Secret Santa';
}

class Utils {
  static String dateToReadableString(DateTime date) {
    var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[date.month - 1] + ' ' + date.day.toString() + ', ' + date.year.toString();
  }

  static String familyToString(dynamic family) {
    var familyString = new StringBuffer();
    for (int i = 0; i < family.length; i++) {
      familyString.writeln(family[i]['name'] + ': ' + family[i]['pin']);
    }
    return familyString.toString();
  }
}

class Config {
  static String baseURL = 'https://aroonsecretsanta.azurewebsites.net/';
}