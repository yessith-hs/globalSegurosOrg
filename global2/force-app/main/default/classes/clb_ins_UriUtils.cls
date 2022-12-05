public with sharing class clb_ins_UriUtils {
  public static String parsePaymentTransaction(String uri) {
    String found = '';
    try {
      Pattern guidPattern = pattern.compile(
        '.*/([0-9a-z]{8}\\-[0-9a-z]{4}\\-[0-9a-z]{4}\\-[0-9a-z]{4}\\-[0-9a-z]{12})'
      );
      Matcher guidMatcher = guidPattern.matcher(uri);

      Boolean match = guidMatcher.matches();
      System.debug('match=' + match + ',found=' + guidMatcher.group(1));

      found = guidMatcher.group(1);
    } catch (Exception e) {
      System.debug('No payment transaction Id found');
    }

    return found;
  }
}