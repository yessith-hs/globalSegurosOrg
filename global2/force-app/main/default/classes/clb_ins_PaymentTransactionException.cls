public with sharing class clb_ins_PaymentTransactionException extends Exception {
  public Integer code;
  public String description;
  public clb_ins_PaymentTransactionException(Integer code, String description) {
    this.code = code;
    this.description = description;
  }

  public String toString() {
    return String.format(
      '{0}:{1}',
      new List<Object>{ this.code, this.description }
    );
  }
}