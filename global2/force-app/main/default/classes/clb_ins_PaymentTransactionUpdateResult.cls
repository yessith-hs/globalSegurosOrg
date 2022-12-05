/**
 * Soulberto Lorenzo <soulberto@cloudblues.us>
 */
global class clb_ins_PaymentTransactionUpdateResult {
  public Boolean success = true;
  public Integer errorCode;
  public String errorDescription;
  public clb_ins_PaymentTransaction__c paymentTransaction;

  /**
   * Genera un resultado de actualización a partir de un objeto de un objeto genérico de excepsión
   */
  public static clb_ins_PaymentTransactionUpdateResult fromException(
    Exception e
  ) {
    clb_ins_PaymentTransactionUpdateResult result = new clb_ins_PaymentTransactionUpdateResult();
    result.success = false;
    // Sólo se asignan en caso de error
    result.errorCode = 500;
    result.errorDescription = e.getMessage();

    return result;
  }

  /**
   * Genera un resultado de actualización a partir de un objeto de transacción de pago
   */
  public static clb_ins_PaymentTransactionUpdateResult fromPaymentTransaction(
    clb_ins_PaymentTransaction__c paymentTransaction
  ) {
    clb_ins_PaymentTransactionUpdateResult result = new clb_ins_PaymentTransactionUpdateResult();
    result.success = true;
    // Almacena en objeto de transacción de pago
    result.paymentTransaction = paymentTransaction;

    return result;
  }

  public static clb_ins_PaymentTransactionUpdateResult build(
    Integer code,
    String description
  ) {
    clb_ins_PaymentTransactionUpdateResult result = new clb_ins_PaymentTransactionUpdateResult();
    result.success = false;
    result.errorCode = code;
    result.errorDescription = description;
    return result;
  }

  public static clb_ins_PaymentTransactionUpdateResult build(
    clb_ins_PaymentTransaction__c paymentTransaction
  ) {
    clb_ins_PaymentTransactionUpdateResult result = new clb_ins_PaymentTransactionUpdateResult();
    result.success = true;
    result.paymentTransaction = paymentTransaction;
    return result;
  }
}