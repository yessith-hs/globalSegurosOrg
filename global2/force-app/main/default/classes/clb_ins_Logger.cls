global class clb_ins_Logger {
  public static String preffix = '::';
  /**
   * Muestra en la consola de depuración la información obtenida de la excepsión.
   */
  public static void error(Exception e) {
    System.debug(
      preffix +
      'Exception: ' +
      e.getMessage() +
      ' => ' +
      e.getStackTraceString()
    );
  }
  /**
   * Muestra en la consola de depuración la información enviada
   */
  public static void log(String message) {
    System.debug(preffix + 'Debug: ' + message);
  }
}