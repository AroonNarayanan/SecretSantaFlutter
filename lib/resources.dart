import 'models.dart';

class Strings {
  static const yourGroup = 'Your Group';
  static const groups = 'Groups';
  static const secretSanta = 'Secret Santa';
  static const budget = 'Set your budget:';
  static const removeMember = 'Remove Member';
  static const dueDateButtonTitle = 'Set Gift Exchange Date';
  static const registerGroupTitle = 'Register a Group';
  static const dueDateDefault = 'no date set';
  static const noBudgetErr = 'Oops - your group needs a budget!';
  static const noDueDateErr = 'Oops - your group needs gift exchange date!';
  static const noMembersErr = 'Oops - your group needs members!';
  static const membersTitle = 'Members:';
  static const noGroupIdErr = 'Oops - we need your Group ID.';
  static const shareSubject = 'My Secret Santa Group';
  static const shareTooltip = 'Share Group';
  static const groupErr = 'We could\'t load your group. Do you have the right password?';
  static const copiedPin = 'PIN copied to clipboard.';
  static const cannotFindMember = 'We couldn\'t find that name and PIN combination - make sure you typed everything correctly.';
  static const genericError = 'Error encountered. Please try again.';
  static const interestsHeader = 'they\'re interested in:';
  static const gifteeScreenHeader = 'you\'re shopping for';
  static const haveFun = 'have fun!';
  static const dueHeader = 'your gift is due on';
}

class Utils {
  static String dateToReadableString(DateTime date) {
    var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[date.month - 1] + ' ' + date.day.toString() + ', ' + date.year.toString();
  }

  static String familyToString(Group family) {
    var familyString = new StringBuffer();
    for (int i = 0; i < family.members.length; i++) {
      familyString.writeln(family.members[i].name + ': ' + family.members[i].pin);
    }
    return familyString.toString();
  }
}

class Config {
  static String baseURL = 'https://remotesecretsanta.herokuapp.com/v2/';
  static String registerFamily = baseURL + 'family/';
  static String loadFamily = baseURL + 'family?familyId=';
  static String loadMember = baseURL + 'unified/';
}