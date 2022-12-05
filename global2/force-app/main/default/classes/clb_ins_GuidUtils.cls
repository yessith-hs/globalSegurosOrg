/**
 * Author: Soulberto Lorenzo <soulberto@cloudblue.us>
 */
global with sharing class clb_ins_GuidUtils implements vlocity_ins.VlocityOpenInterface, Callable {
  private static String kHexChars = '0123456789abcdef';

  global static String generate() {
    String returnValue = '';
    Integer nextByte = 0;

    for (Integer i = 0; i < 16; i++) {
      if (i == 4 || i == 6 || i == 8 || i == 10)
        returnValue += '-';

      nextByte = (Math.round(Math.random() * 255) - 128) & 255;

      if (i == 6) {
        nextByte = nextByte & 15;
        nextByte = nextByte | (4 << 4);
      }

      if (i == 8) {
        nextByte = nextByte & 63;
        nextByte = nextByte | 128;
      }

      returnValue += getCharAtIndex(kHexChars, nextByte >> 4);
      returnValue += getCharAtIndex(kHexChars, nextByte & 15);
    }

    return returnValue;
  }

  global static String getCharAtIndex(String str, Integer index) {
    if (str == null) {
      return null;
    }

    if (str.length() <= 0) {
      return str;
    }

    if (index == str.length()) {
      return null;
    }

    return str.substring(index, index + 1);
  }

  /**
   * @param inputMaps
   * @param outputMaps
   * @param options
   */
  public Boolean invokeMethod(
    String methodName,
    Map<String, Object> inputMap,
    Map<String, Object> outputMap,
    Map<String, Object> options
  ) {
    Boolean result = true;

    try {
      switch on methodName {
        when 'generateUid' {
          String guid = clb_ins_GuidUtils.generate();

          outputMap.put('guid', guid);
        }
        when else {
          throw new clb_ins_UnsupportedMethodException(
            'Method ' +
            methodName +
            ' is not supported'
          );
        }
      }
    } catch (Exception e) {
      System.debug('Method ' + methodName + ' is not supported');
      result = false;
    }

    return result;
  }

  /**
   * Método implementado por la interfaz Callable para poder invocarlo desde un Remote Action
   */
  public Object call(String methodName, Map<String, Object> args) {
    Map<String, Object> inputMap = (Map<String, Object>) args.get('input');
    Map<String, Object> outputMap = (Map<String, Object>) args.get('output');
    Map<String, Object> options = (Map<String, Object>) args.get('options');

    return invokeMethod(methodName, inputMap, outputMap, options);
  }
}