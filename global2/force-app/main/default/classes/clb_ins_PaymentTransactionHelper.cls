/**
 * Soulberto Lorenzo <soulberto@cloudblues.us>
 */
public with sharing class clb_ins_PaymentTransactionHelper {
  /**
   * Estado de transaccion permitidos para ser recibidos por la consultas de actualización
   */
  public static final Set<String> ALLOWED_STATUSES = new Set<String>{
    //'PENDING', // Sólo disponible internamente, cuando se crea la transacción
    //'INIT', // Sólo disponible internamente, cuando se ha iniciado la transacción
    'APPROVED', // Cuando el servicio remoto aprueba la transacción
    'DECLINE', // Cuando el servicio remoto rechaza la transacción
    'EXPIRED', // Cuando el servicio remoto ha intentado la transacción durante cierto tiempo y no ha podido completarse
    'ERROR'
  };
  /**
   * Obtiene una transacción de pago usando el ID de la transacción
   */
  public static clb_ins_PaymentTransaction__c findByTransactionId(
    String transactionId
  ) {
    List<clb_ins_PaymentTransaction__c> paymentTransaction = [
      SELECT
        Id,
        Name,
        clb_ins_TransactionId__c,
        clb_ins_PaymentId__c,
        clb_ins_Status__c,
        clb_ins_Amount__c,
        CurrencyIsoCode,
        clb_ins_Reference__c
      FROM clb_ins_PaymentTransaction__c
      WHERE clb_ins_TransactionId__c = :transactionId
      WITH SECURITY_ENFORCED
    ];

    if (paymentTransaction.isEmpty()) {
      clb_ins_Logger.log(
        'Payment transaction with Id="' +
        transactionId +
        '" not found!'
      );
      return null;
    }

    clb_ins_PaymentTransaction__c requestedPaymentTransaction = paymentTransaction.get(
      0
    );
    return requestedPaymentTransaction;
  }
  /**
   * Actualiza el estado de una transacción de pago usando el ID de transacción
   */
  public static clb_ins_PaymentTransaction__c updatePaymentTransactionStatus(
    String transactionId,
    String newStatus
  ) {
    clb_ins_PaymentTransaction__c paymentTransaction = findByTransactionId(
      transactionId
    );

    if (!ALLOWED_STATUSES.contains(newStatus)) {
      /**
       * Payment transaction statuses:
       *  PENDING
       *  INIT
       *  APPROVED
       *  DECLINED
       *  EXPIRED
       *  ERROR
       */
      throw new clb_ins_PaymentTransactionException(
        400,
        'Payment transaction status is not valid...'
      );
      // throw new clb_ins_PaymentTransactionException(
      //   400,
      //   'Payment transaction status "' +
      //   newStatus +
      //   '" is not valid...'
      // );
    }

    if (paymentTransaction == null) {
      return null;
    }

    if (
      !Schema.sObjectType.clb_ins_PaymentTransaction__c.fields.clb_ins_Status__c.isUpdateable()
    ) {
      clb_ins_Logger.log(
        'This payment transaction field "clb_ins_Status__c" is not accessible!'
      );
      return null;
    }

    // Comprueba que no se haya ya actualizado el estado de la transaction
    if (
      paymentTransaction.clb_ins_Status__c == 'APPROVED' ||
      paymentTransaction.clb_ins_Status__c == 'DECLINED' ||
      paymentTransaction.clb_ins_Status__c == 'EXPIRED' ||
      paymentTransaction.clb_ins_Status__c == 'ERROR'
    ) {
      clb_ins_Logger.log(
        'This payment transaction Id "' +
        transactionId +
        '" is already closed!'
      );

      return paymentTransaction;
    }

    paymentTransaction.clb_ins_Status__c = newStatus; // Actualiza el estado al reportado por el servicio de pagos
    update paymentTransaction;

    return paymentTransaction;
  }
}