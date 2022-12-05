/**
 * Author: Soulberto Lorenzo <soulberto@cloudblue.us>
 */
@RestResource(urlMapping='/PaymentTransaction/*')
global class clb_ins_PaymentTransactionEndpoint {
  /**
   * Método usado para obtener la información de una transacción de pago
   */
  @HttpGet
  global static clb_ins_PaymentTransactionUpdateResult get() {
    clb_ins_PaymentTransactionUpdateResult result = new clb_ins_PaymentTransactionUpdateResult();
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String transactionId = clb_ins_UriUtils.parsePaymentTransaction(
      req.requestURI
    );

    try {
      // Si no se paso un ID de transacción se dispara un error
      if (String.isEmpty(transactionId)) {
        throw new clb_ins_PaymentTransactionException(
          400,
          'Invalid transaction id provided...'
        );
      }

      clb_ins_PaymentTransaction__c paymentTransaction = clb_ins_PaymentTransactionHelper.findByTransactionId(
        transactionId
      );

      // Si no se ecnuentra la transacción se dispara un error indicando
      // que el ID o no existe o esta equivocado
      if (paymentTransaction == null) {
        throw new clb_ins_PaymentTransactionException(
          400,
          'Payment transaction Id is not exits or its wrong...'
        );
      }

      result.paymentTransaction = paymentTransaction;
    } catch (clb_ins_PaymentTransactionException e) {
      result = clb_ins_PaymentTransactionUpdateResult.build(
        e.code,
        e.description
      );
    } catch (Exception e) {
      clb_ins_Logger.error(e);
      result = clb_ins_PaymentTransactionUpdateResult.fromException(e);
    }

    return result;
  }

  /**
   * Método usado para actualizar el estado de la transacción de pago
   */
  @HttpPost
  global static clb_ins_PaymentTransactionUpdateResult post() {
    clb_ins_PaymentTransactionUpdateResult result;
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String transactionId = clb_ins_UriUtils.parsePaymentTransaction(
      req.requestURI
    );

    // TODO: Cambiar por una expresión regular que reemplace ("currency":) por ("currencyCode":) para
    // poder usar currency como nombre de atributo de clase en APEX
    String modifiedBody = req.requestBody.toString()
      .replace('currency', 'currencyCode');
    clb_ins_PaymentTransactionRequest request = (clb_ins_PaymentTransactionRequest) JSON.deserialize(
      modifiedBody,
      clb_ins_PaymentTransactionRequest.class
    );

    try {
      String newStatus = request.payment.status;
      // Si no se paso un ID de transacción se dispara un error
      if (String.isEmpty(transactionId)) {
        throw new clb_ins_PaymentTransactionException(
          400,
          'Invalid transaction id provided...'
        );
      }

      clb_ins_PaymentTransaction__c paymentTransaction;

      paymentTransaction = clb_ins_PaymentTransactionHelper.updatePaymentTransactionStatus(
        transactionId,
        newStatus
      );

      result = clb_ins_PaymentTransactionUpdateResult.fromPaymentTransaction(
        paymentTransaction
      );
    } catch (clb_ins_PaymentTransactionException e) {
      result = clb_ins_PaymentTransactionUpdateResult.build(
        e.code,
        e.description
      );
    } catch (Exception e) {
      clb_ins_Logger.error(e);
      result = clb_ins_PaymentTransactionUpdateResult.fromException(e);
    }

    return result;
  }
}