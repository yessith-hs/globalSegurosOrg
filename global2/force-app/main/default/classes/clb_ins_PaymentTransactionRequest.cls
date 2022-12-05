/**
 * Author: Soulberto Lorenzo <soulberto@cloudblue.us>
 */
global class clb_ins_PaymentTransactionRequest {
  public class PaymentTransactionPayer {
    public String dniType;
    public String dniNumber;
    public String contactPhone;
    public String emailAddress;
    public String billingAddress;
    public String fullName;
  }

  public class PaymentTransactionBuyer {
    public String phone;
    public String email;
    public String documentType;
    public String idNumber;
    public String lastName;
    public String firstName;
    public String idPerson;
  }

  public class PaymentTransactionItem {
    public Integer quantity;
    public Decimal price;
    public String name;
    public String id;
  }

  public class Payment {
    public List<PaymentTransactionItem> items;
    public PaymentTransactionPayer payer;
    public PaymentTransactionBuyer buyer;

    public String reference;
    public String currencyCode;
    public String description;
    public String callbackUrl;
    public String returnUrl;
    public String ipAddress;
    public String channel;
    public String paymentMethod;
    public String transactionId;
    public String paymentId;
    public String paymentGateway;
    public String entity;
    public String comercioId;
    public String status;
    public Decimal amount;
    public Decimal tax;
    public DateTime paymentCreationDate;
    public Decimal taxReturnBase;
  }

  public Payment payment;
}