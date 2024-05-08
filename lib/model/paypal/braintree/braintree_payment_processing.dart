import 'dart:convert';

class BraintreePaymentProcessRes {
  final bool success;
  final Data data;
  final String message;
  BraintreePaymentProcessRes({
    required this.success,
    required this.data,
    required this.message,
  });

  BraintreePaymentProcessRes copyWith({
    bool? success,
    Data? data,
    String? message,
  }) {
    return BraintreePaymentProcessRes(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'data': data.toMap(),
      'message': message,
    };
  }

  factory BraintreePaymentProcessRes.fromMap(Map<String, dynamic> map) {
    return BraintreePaymentProcessRes(
      success: map['success'] as bool,
      data: Data.fromMap(map['data'] as Map<String, dynamic>),
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BraintreePaymentProcessRes.fromJson(String source) =>
      BraintreePaymentProcessRes.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BraintreePaymentProcessRes(success: $success, data: $data, message: $message)';

  @override
  bool operator ==(covariant BraintreePaymentProcessRes other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.data == data &&
        other.message == message;
  }

  @override
  int get hashCode => success.hashCode ^ data.hashCode ^ message.hashCode;
}

class Data {
  final bool success;
  final Transaction transaction;
  Data({
    required this.success,
    required this.transaction,
  });

  Data copyWith({
    bool? success,
    Transaction? transaction,
  }) {
    return Data(
      success: success ?? this.success,
      transaction: transaction ?? this.transaction,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'transaction': transaction.toMap(),
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      success: map['success'] as bool,
      transaction:
          Transaction.fromMap(map['transaction'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Data(success: $success, transaction: $transaction)';

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.success == success && other.transaction == transaction;
  }

  @override
  int get hashCode => success.hashCode ^ transaction.hashCode;
}

class Transaction {
  final String id;
  final String status;
  final String type;
  final String currencyIsoCode;
  final String amount;
  final String amountRequested;
  final String merchantAccountId;
  final SubMerchantAccountId? subMerchantAccountId;
  final MasterMerchantAccountId? masterMerchantAccountId;
  final OrderId? orderId;
  final CreatedAt createdAt;
  final UpdatedAt updatedAt;
  final Customer? customer;
  final Billing? billing;
  final RefundId? refundId;
  final List<dynamic>? refundIds;
  final RefundedTransactionId? refundedTransactionId;
  final List<dynamic>? partialSettlementTransactionIds;
  final AuthorizedTransactionId? authorizedTransactionId;
  final SettlementBatchId? settlementBatchId;
  final Shipping? shipping;
  final CustomFields? customFields;
  final bool? accountFundingTransaction;
  final AvsErrorResponseCode? avsErrorResponseCode;
  final String? avsPostalCodeResponseCode;
  final String? avsStreetAddressResponseCode;
  final String? cvvResponseCode;
  final GatewayRejectionReason? gatewayRejectionReason;
  final String? processorAuthorizationCode;
  final String? processorResponseCode;
  final String? processorResponseText;
  final AdditionalProcessorResponse? additionalProcessorResponse;
  final VoiceReferralNumber? voiceReferralNumber;
  final PurchaseOrderNumber? purchaseOrderNumber;
  final TaxAmount? taxAmount;
  final bool? taxExempt;
  final ScaExemptionRequested? scaExemptionRequested;
  final bool? processedWithNetworkToken;
  final CreditCard? creditCard;
  final List<StatusHistory>? statusHistory;
  final PlanId? planId;
  final SubscriptionId? subscriptionId;
  final Subscription? subscription;
  final List<dynamic>? addOns;
  final List<dynamic>? discounts;
  final Descriptor? descriptor;
  final bool? recurring;
  final Channel? channel;
  final ServiceFeeAmount? serviceFeeAmount;
  final EscrowStatus? escrowStatus;
  final DisbursementDetails? disbursementDetails;
  final List<dynamic>? disputes;
  final List<dynamic>? achReturnResponses;
  final List<dynamic>? authorizationAdjustments;
  final String? paymentInstrumentType;
  final ProcessorSettlementResponseCode? processorSettlementResponseCode;
  final ProcessorSettlementResponseText? processorSettlementResponseText;
  final String? networkResponseCode;
  final String? networkResponseText;
  final MerchantAdviceCode? merchantAdviceCode;
  final MerchantAdviceCodeText? merchantAdviceCodeText;
  final ThreeDSecureInfo? threeDSecureInfo;
  final ShipsFromPostalCode? shipsFromPostalCode;
  final ShippingAmount? shippingAmount;
  final DiscountAmount? discountAmount;
  final String? networkTransactionId;
  final String? processorResponseType;
  final AuthorizationExpiresAt? authorizationExpiresAt;
  final List<dynamic>? retryIds;
  final RetriedTransactionId? retriedTransactionId;
  final List<dynamic>? refundGlobalIds;
  final List<dynamic>? partialSettlementTransactionGlobalIds;
  final RefundedTransactionGlobalId? refundedTransactionGlobalId;
  final AuthorizedTransactionGlobalId? authorizedTransactionGlobalId;
  final String? globalId;
  final List<dynamic>? retryGlobalIds;
  final RetriedTransactionGlobalId? retriedTransactionGlobalId;
  final String? retrievalReferenceNumber;
  final AchReturnCode? achReturnCode;
  final InstallmentCount? installmentCount;
  final List<dynamic>? installments;
  final List<dynamic>? refundedInstallments;
  final ResponseEmvData? responseEmvData;
  final AcquirerReferenceNumber? acquirerReferenceNumber;
  final String? merchantIdentificationNumber;
  final String? terminalIdentificationNumber;
  final String? merchantName;
  final MerchantAddress? merchantAddress;
  final bool? pinVerified;
  final DebitNetwork? debitNetwork;
  final ProcessingMode? processingMode;
  final PaymentReceipt? paymentReceipt;
  final CreditCardDetails? creditCardDetails;
  final CustomerDetails? customerDetails;
  final BillingDetails? billingDetails;
  final ShippingDetails? shippingDetails;
  final SubscriptionDetails? subscriptionDetails;
  final String? graphQLId;
  Transaction({
    required this.id,
    required this.status,
    required this.type,
    required this.currencyIsoCode,
    required this.amount,
    required this.amountRequested,
    required this.merchantAccountId,
    this.subMerchantAccountId,
    this.masterMerchantAccountId,
    this.orderId,
    required this.createdAt,
    required this.updatedAt,
    this.customer,
    this.billing,
    this.refundId,
    this.refundIds,
    this.refundedTransactionId,
    this.partialSettlementTransactionIds,
    this.authorizedTransactionId,
    this.settlementBatchId,
    this.shipping,
    this.customFields,
    this.accountFundingTransaction,
    this.avsErrorResponseCode,
    this.avsPostalCodeResponseCode,
    this.avsStreetAddressResponseCode,
    this.cvvResponseCode,
    this.gatewayRejectionReason,
    this.processorAuthorizationCode,
    this.processorResponseCode,
    this.processorResponseText,
    this.additionalProcessorResponse,
    this.voiceReferralNumber,
    this.purchaseOrderNumber,
    this.taxAmount,
    this.taxExempt,
    this.scaExemptionRequested,
    this.processedWithNetworkToken,
    this.creditCard,
    this.statusHistory,
    this.planId,
    this.subscriptionId,
    this.subscription,
    this.addOns,
    this.discounts,
    this.descriptor,
    this.recurring,
    this.channel,
    this.serviceFeeAmount,
    this.escrowStatus,
    this.disbursementDetails,
    this.disputes,
    this.achReturnResponses,
    this.authorizationAdjustments,
    this.paymentInstrumentType,
    this.processorSettlementResponseCode,
    this.processorSettlementResponseText,
    this.networkResponseCode,
    this.networkResponseText,
    this.merchantAdviceCode,
    this.merchantAdviceCodeText,
    this.threeDSecureInfo,
    this.shipsFromPostalCode,
    this.shippingAmount,
    this.discountAmount,
    this.networkTransactionId,
    this.processorResponseType,
    this.authorizationExpiresAt,
    this.retryIds,
    this.retriedTransactionId,
    this.refundGlobalIds,
    this.partialSettlementTransactionGlobalIds,
    this.refundedTransactionGlobalId,
    this.authorizedTransactionGlobalId,
    this.globalId,
    this.retryGlobalIds,
    this.retriedTransactionGlobalId,
    this.retrievalReferenceNumber,
    this.achReturnCode,
    this.installmentCount,
    this.installments,
    this.refundedInstallments,
    this.responseEmvData,
    this.acquirerReferenceNumber,
    this.merchantIdentificationNumber,
    this.terminalIdentificationNumber,
    this.merchantName,
    this.merchantAddress,
    this.pinVerified,
    this.debitNetwork,
    this.processingMode,
    this.paymentReceipt,
    this.creditCardDetails,
    this.customerDetails,
    this.billingDetails,
    this.shippingDetails,
    this.subscriptionDetails,
    this.graphQLId,
  });

  Transaction copyWith({
    String? id,
    String? status,
    String? type,
    String? currencyIsoCode,
    String? amount,
    String? amountRequested,
    String? merchantAccountId,
    SubMerchantAccountId? subMerchantAccountId,
    MasterMerchantAccountId? masterMerchantAccountId,
    OrderId? orderId,
    CreatedAt? createdAt,
    UpdatedAt? updatedAt,
    Customer? customer,
    Billing? billing,
    RefundId? refundId,
    List<dynamic>? refundIds,
    RefundedTransactionId? refundedTransactionId,
    List<dynamic>? partialSettlementTransactionIds,
    AuthorizedTransactionId? authorizedTransactionId,
    SettlementBatchId? settlementBatchId,
    Shipping? shipping,
    CustomFields? customFields,
    bool? accountFundingTransaction,
    AvsErrorResponseCode? avsErrorResponseCode,
    String? avsPostalCodeResponseCode,
    String? avsStreetAddressResponseCode,
    String? cvvResponseCode,
    GatewayRejectionReason? gatewayRejectionReason,
    String? processorAuthorizationCode,
    String? processorResponseCode,
    String? processorResponseText,
    AdditionalProcessorResponse? additionalProcessorResponse,
    VoiceReferralNumber? voiceReferralNumber,
    PurchaseOrderNumber? purchaseOrderNumber,
    TaxAmount? taxAmount,
    bool? taxExempt,
    ScaExemptionRequested? scaExemptionRequested,
    bool? processedWithNetworkToken,
    CreditCard? creditCard,
    List<StatusHistory>? statusHistory,
    PlanId? planId,
    SubscriptionId? subscriptionId,
    Subscription? subscription,
    List<dynamic>? addOns,
    List<dynamic>? discounts,
    Descriptor? descriptor,
    bool? recurring,
    Channel? channel,
    ServiceFeeAmount? serviceFeeAmount,
    EscrowStatus? escrowStatus,
    DisbursementDetails? disbursementDetails,
    List<dynamic>? disputes,
    List<dynamic>? achReturnResponses,
    List<dynamic>? authorizationAdjustments,
    String? paymentInstrumentType,
    ProcessorSettlementResponseCode? processorSettlementResponseCode,
    ProcessorSettlementResponseText? processorSettlementResponseText,
    String? networkResponseCode,
    String? networkResponseText,
    MerchantAdviceCode? merchantAdviceCode,
    MerchantAdviceCodeText? merchantAdviceCodeText,
    ThreeDSecureInfo? threeDSecureInfo,
    ShipsFromPostalCode? shipsFromPostalCode,
    ShippingAmount? shippingAmount,
    DiscountAmount? discountAmount,
    String? networkTransactionId,
    String? processorResponseType,
    AuthorizationExpiresAt? authorizationExpiresAt,
    List<dynamic>? retryIds,
    RetriedTransactionId? retriedTransactionId,
    List<dynamic>? refundGlobalIds,
    List<dynamic>? partialSettlementTransactionGlobalIds,
    RefundedTransactionGlobalId? refundedTransactionGlobalId,
    AuthorizedTransactionGlobalId? authorizedTransactionGlobalId,
    String? globalId,
    List<dynamic>? retryGlobalIds,
    RetriedTransactionGlobalId? retriedTransactionGlobalId,
    String? retrievalReferenceNumber,
    AchReturnCode? achReturnCode,
    InstallmentCount? installmentCount,
    List<dynamic>? installments,
    List<dynamic>? refundedInstallments,
    ResponseEmvData? responseEmvData,
    AcquirerReferenceNumber? acquirerReferenceNumber,
    String? merchantIdentificationNumber,
    String? terminalIdentificationNumber,
    String? merchantName,
    MerchantAddress? merchantAddress,
    bool? pinVerified,
    DebitNetwork? debitNetwork,
    ProcessingMode? processingMode,
    PaymentReceipt? paymentReceipt,
    CreditCardDetails? creditCardDetails,
    CustomerDetails? customerDetails,
    BillingDetails? billingDetails,
    ShippingDetails? shippingDetails,
    SubscriptionDetails? subscriptionDetails,
    String? graphQLId,
  }) {
    return Transaction(
      id: id ?? this.id,
      status: status ?? this.status,
      type: type ?? this.type,
      currencyIsoCode: currencyIsoCode ?? this.currencyIsoCode,
      amount: amount ?? this.amount,
      amountRequested: amountRequested ?? this.amountRequested,
      merchantAccountId: merchantAccountId ?? this.merchantAccountId,
      subMerchantAccountId: subMerchantAccountId ?? this.subMerchantAccountId,
      masterMerchantAccountId:
          masterMerchantAccountId ?? this.masterMerchantAccountId,
      orderId: orderId ?? this.orderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customer: customer ?? this.customer,
      billing: billing ?? this.billing,
      refundId: refundId ?? this.refundId,
      refundIds: refundIds ?? this.refundIds,
      refundedTransactionId:
          refundedTransactionId ?? this.refundedTransactionId,
      partialSettlementTransactionIds: partialSettlementTransactionIds ??
          this.partialSettlementTransactionIds,
      authorizedTransactionId:
          authorizedTransactionId ?? this.authorizedTransactionId,
      settlementBatchId: settlementBatchId ?? this.settlementBatchId,
      shipping: shipping ?? this.shipping,
      customFields: customFields ?? this.customFields,
      accountFundingTransaction:
          accountFundingTransaction ?? this.accountFundingTransaction,
      avsErrorResponseCode: avsErrorResponseCode ?? this.avsErrorResponseCode,
      avsPostalCodeResponseCode:
          avsPostalCodeResponseCode ?? this.avsPostalCodeResponseCode,
      avsStreetAddressResponseCode:
          avsStreetAddressResponseCode ?? this.avsStreetAddressResponseCode,
      cvvResponseCode: cvvResponseCode ?? this.cvvResponseCode,
      gatewayRejectionReason:
          gatewayRejectionReason ?? this.gatewayRejectionReason,
      processorAuthorizationCode:
          processorAuthorizationCode ?? this.processorAuthorizationCode,
      processorResponseCode:
          processorResponseCode ?? this.processorResponseCode,
      processorResponseText:
          processorResponseText ?? this.processorResponseText,
      additionalProcessorResponse:
          additionalProcessorResponse ?? this.additionalProcessorResponse,
      voiceReferralNumber: voiceReferralNumber ?? this.voiceReferralNumber,
      purchaseOrderNumber: purchaseOrderNumber ?? this.purchaseOrderNumber,
      taxAmount: taxAmount ?? this.taxAmount,
      taxExempt: taxExempt ?? this.taxExempt,
      scaExemptionRequested:
          scaExemptionRequested ?? this.scaExemptionRequested,
      processedWithNetworkToken:
          processedWithNetworkToken ?? this.processedWithNetworkToken,
      creditCard: creditCard ?? this.creditCard,
      statusHistory: statusHistory ?? this.statusHistory,
      planId: planId ?? this.planId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      subscription: subscription ?? this.subscription,
      addOns: addOns ?? this.addOns,
      discounts: discounts ?? this.discounts,
      descriptor: descriptor ?? this.descriptor,
      recurring: recurring ?? this.recurring,
      channel: channel ?? this.channel,
      serviceFeeAmount: serviceFeeAmount ?? this.serviceFeeAmount,
      escrowStatus: escrowStatus ?? this.escrowStatus,
      disbursementDetails: disbursementDetails ?? this.disbursementDetails,
      disputes: disputes ?? this.disputes,
      achReturnResponses: achReturnResponses ?? this.achReturnResponses,
      authorizationAdjustments:
          authorizationAdjustments ?? this.authorizationAdjustments,
      paymentInstrumentType:
          paymentInstrumentType ?? this.paymentInstrumentType,
      processorSettlementResponseCode: processorSettlementResponseCode ??
          this.processorSettlementResponseCode,
      processorSettlementResponseText: processorSettlementResponseText ??
          this.processorSettlementResponseText,
      networkResponseCode: networkResponseCode ?? this.networkResponseCode,
      networkResponseText: networkResponseText ?? this.networkResponseText,
      merchantAdviceCode: merchantAdviceCode ?? this.merchantAdviceCode,
      merchantAdviceCodeText:
          merchantAdviceCodeText ?? this.merchantAdviceCodeText,
      threeDSecureInfo: threeDSecureInfo ?? this.threeDSecureInfo,
      shipsFromPostalCode: shipsFromPostalCode ?? this.shipsFromPostalCode,
      shippingAmount: shippingAmount ?? this.shippingAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      networkTransactionId: networkTransactionId ?? this.networkTransactionId,
      processorResponseType:
          processorResponseType ?? this.processorResponseType,
      authorizationExpiresAt:
          authorizationExpiresAt ?? this.authorizationExpiresAt,
      retryIds: retryIds ?? this.retryIds,
      retriedTransactionId: retriedTransactionId ?? this.retriedTransactionId,
      refundGlobalIds: refundGlobalIds ?? this.refundGlobalIds,
      partialSettlementTransactionGlobalIds:
          partialSettlementTransactionGlobalIds ??
              this.partialSettlementTransactionGlobalIds,
      refundedTransactionGlobalId:
          refundedTransactionGlobalId ?? this.refundedTransactionGlobalId,
      authorizedTransactionGlobalId:
          authorizedTransactionGlobalId ?? this.authorizedTransactionGlobalId,
      globalId: globalId ?? this.globalId,
      retryGlobalIds: retryGlobalIds ?? this.retryGlobalIds,
      retriedTransactionGlobalId:
          retriedTransactionGlobalId ?? this.retriedTransactionGlobalId,
      retrievalReferenceNumber:
          retrievalReferenceNumber ?? this.retrievalReferenceNumber,
      achReturnCode: achReturnCode ?? this.achReturnCode,
      installmentCount: installmentCount ?? this.installmentCount,
      installments: installments ?? this.installments,
      refundedInstallments: refundedInstallments ?? this.refundedInstallments,
      responseEmvData: responseEmvData ?? this.responseEmvData,
      acquirerReferenceNumber:
          acquirerReferenceNumber ?? this.acquirerReferenceNumber,
      merchantIdentificationNumber:
          merchantIdentificationNumber ?? this.merchantIdentificationNumber,
      terminalIdentificationNumber:
          terminalIdentificationNumber ?? this.terminalIdentificationNumber,
      merchantName: merchantName ?? this.merchantName,
      merchantAddress: merchantAddress ?? this.merchantAddress,
      pinVerified: pinVerified ?? this.pinVerified,
      debitNetwork: debitNetwork ?? this.debitNetwork,
      processingMode: processingMode ?? this.processingMode,
      paymentReceipt: paymentReceipt ?? this.paymentReceipt,
      creditCardDetails: creditCardDetails ?? this.creditCardDetails,
      customerDetails: customerDetails ?? this.customerDetails,
      billingDetails: billingDetails ?? this.billingDetails,
      shippingDetails: shippingDetails ?? this.shippingDetails,
      subscriptionDetails: subscriptionDetails ?? this.subscriptionDetails,
      graphQLId: graphQLId ?? this.graphQLId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'type': type,
      'currencyIsoCode': currencyIsoCode,
      'amount': amount,
      'amountRequested': amountRequested,
      'merchantAccountId': merchantAccountId,
      // 'subMerchantAccountId': subMerchantAccountId.toMap(),
      // 'masterMerchantAccountId': masterMerchantAccountId.toMap(),
      // 'orderId': orderId.toMap(),
      'createdAt': createdAt.toMap(),
      'updatedAt': updatedAt.toMap(),
      'customer': customer?.toMap(),
      'billing': billing?.toMap(),
      // 'refundId': refundId.toMap(),
      'refundIds': refundIds,
      // 'refundedTransactionId': refundedTransactionId.toMap(),
      'partialSettlementTransactionIds': partialSettlementTransactionIds,
      // 'authorizedTransactionId': authorizedTransactionId.toMap(),
      // 'settlementBatchId': settlementBatchId.toMap(),
      'shipping': shipping?.toMap(),
      // 'customFields': customFields.toMap(),
      'accountFundingTransaction': accountFundingTransaction,
      // 'avsErrorResponseCode': avsErrorResponseCode.toMap(),
      'avsPostalCodeResponseCode': avsPostalCodeResponseCode,
      'avsStreetAddressResponseCode': avsStreetAddressResponseCode,
      'cvvResponseCode': cvvResponseCode,
      // 'gatewayRejectionReason': gatewayRejectionReason.toMap(),
      'processorAuthorizationCode': processorAuthorizationCode,
      'processorResponseCode': processorResponseCode,
      'processorResponseText': processorResponseText,
      // 'additionalProcessorResponse': additionalProcessorResponse.toMap(),
      // 'voiceReferralNumber': voiceReferralNumber.toMap(),
      // 'purchaseOrderNumber': purchaseOrderNumber.toMap(),
      // 'taxAmount': taxAmount.toMap(),
      'taxExempt': taxExempt,
      // 'scaExemptionRequested': scaExemptionRequested.toMap(),
      'processedWithNetworkToken': processedWithNetworkToken,
      'creditCard': creditCard?.toMap(),
      // 'statusHistory': statusHistory.map((x) => x.toMap()).toList(),
      // 'planId': planId.toMap(),
      // 'subscriptionId': subscriptionId.toMap(),
      'subscription': subscription?.toMap(),
      'addOns': addOns,
      'discounts': discounts,
      // 'descriptor': descriptor.toMap(),
      'recurring': recurring,
      // 'channel': channel.toMap(),
      // 'serviceFeeAmount': serviceFeeAmount.toMap(),
      // 'escrowStatus': escrowStatus.toMap(),
      // 'disbursementDetails': disbursementDetails.toMap(),
      'disputes': disputes,
      'achReturnResponses': achReturnResponses,
      'authorizationAdjustments': authorizationAdjustments,
      'paymentInstrumentType': paymentInstrumentType,
      // 'processorSettlementResponseCode': processorSettlementResponseCode.toMap(),
      // 'processorSettlementResponseText': processorSettlementResponseText.toMap(),
      'networkResponseCode': networkResponseCode,
      'networkResponseText': networkResponseText,
      // 'merchantAdviceCode': merchantAdviceCode.toMap(),
      // 'merchantAdviceCodeText': merchantAdviceCodeText.toMap(),
      // 'threeDSecureInfo': threeDSecureInfo.toMap(),
      // 'shipsFromPostalCode': shipsFromPostalCode.toMap(),
      // 'shippingAmount': shippingAmount.toMap(),
      // 'discountAmount': discountAmount.toMap(),
      'networkTransactionId': networkTransactionId,
      'processorResponseType': processorResponseType,
      'authorizationExpiresAt': authorizationExpiresAt?.toMap(),
      'retryIds': retryIds,
      // 'retriedTransactionId': retriedTransactionId.toMap(),
      'refundGlobalIds': refundGlobalIds,
      'partialSettlementTransactionGlobalIds':
          partialSettlementTransactionGlobalIds,
      // 'refundedTransactionGlobalId': refundedTransactionGlobalId.toMap(),
      // 'authorizedTransactionGlobalId': authorizedTransactionGlobalId.toMap(),
      'globalId': globalId,
      'retryGlobalIds': retryGlobalIds,
      // 'retriedTransactionGlobalId': retriedTransactionGlobalId.toMap(),
      'retrievalReferenceNumber': retrievalReferenceNumber,
      // 'achReturnCode': achReturnCode.toMap(),
      // 'installmentCount': installmentCount.toMap(),
      'installments': installments,
      'refundedInstallments': refundedInstallments,
      // 'responseEmvData': responseEmvData.toMap(),
      // 'acquirerReferenceNumber': acquirerReferenceNumber.toMap(),
      'merchantIdentificationNumber': merchantIdentificationNumber,
      'terminalIdentificationNumber': terminalIdentificationNumber,
      'merchantName': merchantName,
      'merchantAddress': merchantAddress?.toMap(),
      'pinVerified': pinVerified,
      // 'debitNetwork': debitNetwork.toMap(),
      // 'processingMode': processingMode.toMap(),
      // 'paymentReceipt': paymentReceipt.toMap(),
      // 'creditCardDetails': creditCardDetails.toMap(),
      // 'customerDetails': customerDetails.toMap(),
      // 'billingDetails': billingDetails.toMap(),
      // 'shippingDetails': shippingDetails.toMap(),
      // 'subscriptionDetails': subscriptionDetails.toMap(),
      'graphQLId': graphQLId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
        id: map['id'] as String,
        status: map['status'] as String,
        type: map['type'] as String,
        currencyIsoCode: map['currencyIsoCode'] as String,
        amount: map['amount'] as String,
        amountRequested: map['amountRequested'] as String,
        merchantAccountId: map['merchantAccountId'] as String,
        subMerchantAccountId: null,
        masterMerchantAccountId: null,
        // subMerchantAccountId: SubMerchantAccountId.fromMap(map['subMerchantAccountId'] as Map<String,dynamic>),
        // masterMerchantAccountId: MasterMerchantAccountId.fromMap(map['masterMerchantAccountId'] as Map<String,dynamic>),
        orderId: null,
        // orderId: OrderId.fromMap(map['orderId'] as Map<String,dynamic>),
        createdAt: CreatedAt.fromMap(map['createdAt'] as Map<String, dynamic>),
        updatedAt: UpdatedAt.fromMap(map['updatedAt'] as Map<String, dynamic>),
        // customer: Customer.fromMap(map['customer'] as Map<String,dynamic>),
        // billing: Billing.fromMap(map['billing'] as Map<String,dynamic>),
        // refundId: RefundId.fromMap(map['refundId'] as Map<String,dynamic>),
        // refundIds: List<dynamic>.from((map['refundIds'] as List<dynamic>),
        // refundedTransactionId: RefundedTransactionId.fromMap(map['refundedTransactionId'] as Map<String,dynamic>),
        // partialSettlementTransactionIds: List<dynamic>.from((map['partialSettlementTransactionIds'] as List<dynamic>),
        // authorizedTransactionId: AuthorizedTransactionId.fromMap(map['authorizedTransactionId'] as Map<String,dynamic>),
        // settlementBatchId: SettlementBatchId.fromMap(map['settlementBatchId'] as Map<String,dynamic>),
        // shipping: Shipping.fromMap(map['shipping'] as Map<String,dynamic>),
        // customFields: CustomFields.fromMap(map['customFields'] as Map<String,dynamic>),
        // accountFundingTransaction: map['accountFundingTransaction'] as bool,
        // avsErrorResponseCode: AvsErrorResponseCode.fromMap(map['avsErrorResponseCode'] as Map<String,dynamic>),
        // avsPostalCodeResponseCode: map['avsPostalCodeResponseCode'] as String,
        // avsStreetAddressResponseCode: map['avsStreetAddressResponseCode'] as String,
        // cvvResponseCode: map['cvvResponseCode'] as String,
        // gatewayRejectionReason: GatewayRejectionReason.fromMap(map['gatewayRejectionReason'] as Map<String,dynamic>),
        processorAuthorizationCode: map['processorAuthorizationCode'] as String,
        processorResponseCode: map['processorResponseCode'] as String,
        processorResponseText: map['processorResponseText'] as String,
        // additionalProcessorResponse: AdditionalProcessorResponse.fromMap(map['additionalProcessorResponse'] as Map<String,dynamic>),
        // voiceReferralNumber: VoiceReferralNumber.fromMap(map['voiceReferralNumber'] as Map<String,dynamic>),
        // purchaseOrderNumber: PurchaseOrderNumber.fromMap(map['purchaseOrderNumber'] as Map<String,dynamic>),
        // taxAmount: TaxAmount.fromMap(map['taxAmount'] as Map<String,dynamic>),
        taxExempt: map['taxExempt'] as bool,
        // scaExemptionRequested: ScaExemptionRequested.fromMap(map['scaExemptionRequested'] as Map<String,dynamic>),
        processedWithNetworkToken: map['processedWithNetworkToken'] as bool,
        // creditCard: CreditCard.fromMap(map['creditCard'] as Map<String,dynamic>),
        // statusHistory: List<StatusHistory>.from((map['statusHistory'] as List<int>).map<StatusHistory>((x) => StatusHistory.fromMap(x as Map<String,dynamic>),),),
        // planId: PlanId.fromMap(map['planId'] as Map<String,dynamic>),
        // subscriptionId: SubscriptionId.fromMap(map['subscriptionId'] as Map<String,dynamic>),
        // subscription: Subscription.fromMap(map['subscription'] as Map<String,dynamic>),
        addOns: List<dynamic>.from(
          (map['addOns'] as List<dynamic>),
          // discounts: List<dynamic>.from((map['discounts'] as List<dynamic>),
          // descriptor: Descriptor.fromMap(map['descriptor'] as Map<String,dynamic>),
          // recurring: map['recurring'] as bool,
          // channel: Channel.fromMap(map['channel'] as Map<String,dynamic>),
          // serviceFeeAmount: ServiceFeeAmount.fromMap(map['serviceFeeAmount'] as Map<String,dynamic>),
          // escrowStatus: EscrowStatus.fromMap(map['escrowStatus'] as Map<String,dynamic>),
          // disbursementDetails: DisbursementDetails.fromMap(map['disbursementDetails'] as Map<String,dynamic>),
          // disputes: List<dynamic>.from((map['disputes'] as List<dynamic>),
          // achReturnResponses: List<dynamic>.from((map['achReturnResponses'] as List<dynamic>),
          // authorizationAdjustments: List<dynamic>.from((map['authorizationAdjustments'] as List<dynamic>),
          // paymentInstrumentType: map['paymentInstrumentType'] as String,
          // processorSettlementResponseCode: ProcessorSettlementResponseCode.fromMap(map['processorSettlementResponseCode'] as Map<String,dynamic>),
          // processorSettlementResponseText: ProcessorSettlementResponseText.fromMap(map['processorSettlementResponseText'] as Map<String,dynamic>),
          // networkResponseCode: map['networkResponseCode'] as String,
          // networkResponseText: map['networkResponseText'] as String,
          // merchantAdviceCode: MerchantAdviceCode.fromMap(map['merchantAdviceCode'] as Map<String,dynamic>),
          // merchantAdviceCodeText: MerchantAdviceCodeText.fromMap(map['merchantAdviceCodeText'] as Map<String,dynamic>),
          // threeDSecureInfo: ThreeDSecureInfo.fromMap(map['threeDSecureInfo'] as Map<String,dynamic>),
          // shipsFromPostalCode: ShipsFromPostalCode.fromMap(map['shipsFromPostalCode'] as Map<String,dynamic>),
          // shippingAmount: ShippingAmount.fromMap(map['shippingAmount'] as Map<String,dynamic>),
          // discountAmount: DiscountAmount.fromMap(map['discountAmount'] as Map<String,dynamic>),
          // networkTransactionId: map['networkTransactionId'] as String,
          // processorResponseType: map['processorResponseType'] as String,
          // authorizationExpiresAt: AuthorizationExpiresAt.fromMap(map['authorizationExpiresAt'] as Map<String,dynamic>),
          // retryIds: List<dynamic>.from((map['retryIds'] as List<dynamic>),
          // retriedTransactionId: RetriedTransactionId.fromMap(map['retriedTransactionId'] as Map<String,dynamic>),
          // refundGlobalIds: List<dynamic>.from((map['refundGlobalIds'] as List<dynamic>),
          // partialSettlementTransactionGlobalIds: List<dynamic>.from((map['partialSettlementTransactionGlobalIds'] as List<dynamic>),
          // refundedTransactionGlobalId: RefundedTransactionGlobalId.fromMap(map['refundedTransactionGlobalId'] as Map<String,dynamic>),
          // authorizedTransactionGlobalId: AuthorizedTransactionGlobalId.fromMap(map['authorizedTransactionGlobalId'] as Map<String,dynamic>),
          // globalId: map['globalId'] as String,
          // retryGlobalIds: List<dynamic>.from((map['retryGlobalIds'] as List<dynamic>),
          // retriedTransactionGlobalId: RetriedTransactionGlobalId.fromMap(map['retriedTransactionGlobalId'] as Map<String,dynamic>),
          // retrievalReferenceNumber: map['retrievalReferenceNumber'] as String,
          // achReturnCode: AchReturnCode.fromMap(map['achReturnCode'] as Map<String,dynamic>),
          // installmentCount: InstallmentCount.fromMap(map['installmentCount'] as Map<String,dynamic>),
          // installments: List<dynamic>.from((map['installments'] as List<dynamic>),
          // refundedInstallments: List<dynamic>.from((map['refundedInstallments'] as List<dynamic>),
          // responseEmvData: ResponseEmvData.fromMap(map['responseEmvData'] as Map<String,dynamic>),
          // acquirerReferenceNumber: AcquirerReferenceNumber.fromMap(map['acquirerReferenceNumber'] as Map<String,dynamic>),
          // merchantIdentificationNumber: map['merchantIdentificationNumber'] as String,
          // terminalIdentificationNumber: map['terminalIdentificationNumber'] as String,
          // merchantName: map['merchantName'] as String,
          // merchantAddress: MerchantAddress.fromMap(map['merchantAddress'] as Map<String,dynamic>),
          // pinVerified: map['pinVerified'] as bool,
          // debitNetwork: DebitNetwork.fromMap(map['debitNetwork'] as Map<String,dynamic>),
          // processingMode: ProcessingMode.fromMap(map['processingMode'] as Map<String,dynamic>),
          // paymentReceipt: PaymentReceipt.fromMap(map['paymentReceipt'] as Map<String,dynamic>),
          // creditCardDetails: CreditCardDetails.fromMap(map['creditCardDetails'] as Map<String,dynamic>),
          // customerDetails: CustomerDetails.fromMap(map['customerDetails'] as Map<String,dynamic>),
          // billingDetails: BillingDetails.fromMap(map['billingDetails'] as Map<String,dynamic>),
          // shippingDetails: ShippingDetails.fromMap(map['shippingDetails'] as Map<String,dynamic>),
          // subscriptionDetails: SubscriptionDetails.fromMap(map['subscriptionDetails'] as Map<String,dynamic>),
          // graphQLId: map['graphQLId'] as String,
        ));
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(id: $id, status: $status, type: $type, currencyIsoCode: $currencyIsoCode, amount: $amount, amountRequested: $amountRequested, merchantAccountId: $merchantAccountId, subMerchantAccountId: $subMerchantAccountId, masterMerchantAccountId: $masterMerchantAccountId, orderId: $orderId, createdAt: $createdAt, updatedAt: $updatedAt, customer: $customer, billing: $billing, refundId: $refundId, refundIds: $refundIds, refundedTransactionId: $refundedTransactionId, partialSettlementTransactionIds: $partialSettlementTransactionIds, authorizedTransactionId: $authorizedTransactionId, settlementBatchId: $settlementBatchId, shipping: $shipping, customFields: $customFields, accountFundingTransaction: $accountFundingTransaction, avsErrorResponseCode: $avsErrorResponseCode, avsPostalCodeResponseCode: $avsPostalCodeResponseCode, avsStreetAddressResponseCode: $avsStreetAddressResponseCode, cvvResponseCode: $cvvResponseCode, gatewayRejectionReason: $gatewayRejectionReason, processorAuthorizationCode: $processorAuthorizationCode, processorResponseCode: $processorResponseCode, processorResponseText: $processorResponseText, additionalProcessorResponse: $additionalProcessorResponse, voiceReferralNumber: $voiceReferralNumber, purchaseOrderNumber: $purchaseOrderNumber, taxAmount: $taxAmount, taxExempt: $taxExempt, scaExemptionRequested: $scaExemptionRequested, processedWithNetworkToken: $processedWithNetworkToken, creditCard: $creditCard, statusHistory: $statusHistory, planId: $planId, subscriptionId: $subscriptionId, subscription: $subscription, addOns: $addOns, discounts: $discounts, descriptor: $descriptor, recurring: $recurring, channel: $channel, serviceFeeAmount: $serviceFeeAmount, escrowStatus: $escrowStatus, disbursementDetails: $disbursementDetails, disputes: $disputes, achReturnResponses: $achReturnResponses, authorizationAdjustments: $authorizationAdjustments, paymentInstrumentType: $paymentInstrumentType, processorSettlementResponseCode: $processorSettlementResponseCode, processorSettlementResponseText: $processorSettlementResponseText, networkResponseCode: $networkResponseCode, networkResponseText: $networkResponseText, merchantAdviceCode: $merchantAdviceCode, merchantAdviceCodeText: $merchantAdviceCodeText, threeDSecureInfo: $threeDSecureInfo, shipsFromPostalCode: $shipsFromPostalCode, shippingAmount: $shippingAmount, discountAmount: $discountAmount, networkTransactionId: $networkTransactionId, processorResponseType: $processorResponseType, authorizationExpiresAt: $authorizationExpiresAt, retryIds: $retryIds, retriedTransactionId: $retriedTransactionId, refundGlobalIds: $refundGlobalIds, partialSettlementTransactionGlobalIds: $partialSettlementTransactionGlobalIds, refundedTransactionGlobalId: $refundedTransactionGlobalId, authorizedTransactionGlobalId: $authorizedTransactionGlobalId, globalId: $globalId, retryGlobalIds: $retryGlobalIds, retriedTransactionGlobalId: $retriedTransactionGlobalId, retrievalReferenceNumber: $retrievalReferenceNumber, achReturnCode: $achReturnCode, installmentCount: $installmentCount, installments: $installments, refundedInstallments: $refundedInstallments, responseEmvData: $responseEmvData, acquirerReferenceNumber: $acquirerReferenceNumber, merchantIdentificationNumber: $merchantIdentificationNumber, terminalIdentificationNumber: $terminalIdentificationNumber, merchantName: $merchantName, merchantAddress: $merchantAddress, pinVerified: $pinVerified, debitNetwork: $debitNetwork, processingMode: $processingMode, paymentReceipt: $paymentReceipt, creditCardDetails: $creditCardDetails, customerDetails: $customerDetails, billingDetails: $billingDetails, shippingDetails: $shippingDetails, subscriptionDetails: $subscriptionDetails, graphQLId: $graphQLId)';
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.status == status &&
        other.type == type &&
        other.currencyIsoCode == currencyIsoCode &&
        other.amount == amount &&
        other.amountRequested == amountRequested &&
        other.merchantAccountId == merchantAccountId &&
        other.subMerchantAccountId == subMerchantAccountId &&
        other.masterMerchantAccountId == masterMerchantAccountId &&
        other.orderId == orderId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.customer == customer &&
        other.billing == billing &&
        other.refundId == refundId &&
        // listEquals(other.refundIds, refundIds) &&
        other.refundedTransactionId == refundedTransactionId &&
        // listEquals(other.partialSettlementTransactionIds, partialSettlementTransactionIds) &&
        other.authorizedTransactionId == authorizedTransactionId &&
        other.settlementBatchId == settlementBatchId &&
        other.shipping == shipping &&
        other.customFields == customFields &&
        other.accountFundingTransaction == accountFundingTransaction &&
        other.avsErrorResponseCode == avsErrorResponseCode &&
        other.avsPostalCodeResponseCode == avsPostalCodeResponseCode &&
        other.avsStreetAddressResponseCode == avsStreetAddressResponseCode &&
        other.cvvResponseCode == cvvResponseCode &&
        other.gatewayRejectionReason == gatewayRejectionReason &&
        other.processorAuthorizationCode == processorAuthorizationCode &&
        other.processorResponseCode == processorResponseCode &&
        other.processorResponseText == processorResponseText &&
        other.additionalProcessorResponse == additionalProcessorResponse &&
        other.voiceReferralNumber == voiceReferralNumber &&
        other.purchaseOrderNumber == purchaseOrderNumber &&
        other.taxAmount == taxAmount &&
        other.taxExempt == taxExempt &&
        other.scaExemptionRequested == scaExemptionRequested &&
        other.processedWithNetworkToken == processedWithNetworkToken &&
        other.creditCard == creditCard &&
        // listEquals(other.statusHistory, statusHistory) &&
        other.planId == planId &&
        other.subscriptionId == subscriptionId &&
        other.subscription == subscription &&
        // listEquals(other.addOns, addOns) &&
        // listEquals(other.discounts, discounts) &&
        other.descriptor == descriptor &&
        other.recurring == recurring &&
        other.channel == channel &&
        other.serviceFeeAmount == serviceFeeAmount &&
        other.escrowStatus == escrowStatus &&
        other.disbursementDetails == disbursementDetails &&
        // listEquals(other.disputes, disputes) &&
        // listEquals(other.achReturnResponses, achReturnResponses) &&
        // listEquals(other.authorizationAdjustments, authorizationAdjustments) &&
        other.paymentInstrumentType == paymentInstrumentType &&
        other.processorSettlementResponseCode ==
            processorSettlementResponseCode &&
        other.processorSettlementResponseText ==
            processorSettlementResponseText &&
        other.networkResponseCode == networkResponseCode &&
        other.networkResponseText == networkResponseText &&
        other.merchantAdviceCode == merchantAdviceCode &&
        other.merchantAdviceCodeText == merchantAdviceCodeText &&
        other.threeDSecureInfo == threeDSecureInfo &&
        other.shipsFromPostalCode == shipsFromPostalCode &&
        other.shippingAmount == shippingAmount &&
        other.discountAmount == discountAmount &&
        other.networkTransactionId == networkTransactionId &&
        other.processorResponseType == processorResponseType &&
        other.authorizationExpiresAt == authorizationExpiresAt &&
        // listEquals(other.retryIds, retryIds) &&
        other.retriedTransactionId == retriedTransactionId &&
        // listEquals(other.refundGlobalIds, refundGlobalIds) &&
        // listEquals(other.partialSettlementTransactionGlobalIds, partialSettlementTransactionGlobalIds) &&
        other.refundedTransactionGlobalId == refundedTransactionGlobalId &&
        other.authorizedTransactionGlobalId == authorizedTransactionGlobalId &&
        other.globalId == globalId &&
        // listEquals(other.retryGlobalIds, retryGlobalIds) &&
        other.retriedTransactionGlobalId == retriedTransactionGlobalId &&
        other.retrievalReferenceNumber == retrievalReferenceNumber &&
        other.achReturnCode == achReturnCode &&
        other.installmentCount == installmentCount &&
        // listEquals(other.installments, installments) &&
        // listEquals(other.refundedInstallments, refundedInstallments) &&
        other.responseEmvData == responseEmvData &&
        other.acquirerReferenceNumber == acquirerReferenceNumber &&
        other.merchantIdentificationNumber == merchantIdentificationNumber &&
        other.terminalIdentificationNumber == terminalIdentificationNumber &&
        other.merchantName == merchantName &&
        other.merchantAddress == merchantAddress &&
        other.pinVerified == pinVerified &&
        other.debitNetwork == debitNetwork &&
        other.processingMode == processingMode &&
        other.paymentReceipt == paymentReceipt &&
        other.creditCardDetails == creditCardDetails &&
        other.customerDetails == customerDetails &&
        other.billingDetails == billingDetails &&
        other.shippingDetails == shippingDetails &&
        other.subscriptionDetails == subscriptionDetails &&
        other.graphQLId == graphQLId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        status.hashCode ^
        type.hashCode ^
        currencyIsoCode.hashCode ^
        amount.hashCode ^
        amountRequested.hashCode ^
        merchantAccountId.hashCode ^
        subMerchantAccountId.hashCode ^
        masterMerchantAccountId.hashCode ^
        orderId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        customer.hashCode ^
        billing.hashCode ^
        refundId.hashCode ^
        refundIds.hashCode ^
        refundedTransactionId.hashCode ^
        partialSettlementTransactionIds.hashCode ^
        authorizedTransactionId.hashCode ^
        settlementBatchId.hashCode ^
        shipping.hashCode ^
        customFields.hashCode ^
        accountFundingTransaction.hashCode ^
        avsErrorResponseCode.hashCode ^
        avsPostalCodeResponseCode.hashCode ^
        avsStreetAddressResponseCode.hashCode ^
        cvvResponseCode.hashCode ^
        gatewayRejectionReason.hashCode ^
        processorAuthorizationCode.hashCode ^
        processorResponseCode.hashCode ^
        processorResponseText.hashCode ^
        additionalProcessorResponse.hashCode ^
        voiceReferralNumber.hashCode ^
        purchaseOrderNumber.hashCode ^
        taxAmount.hashCode ^
        taxExempt.hashCode ^
        scaExemptionRequested.hashCode ^
        processedWithNetworkToken.hashCode ^
        creditCard.hashCode ^
        statusHistory.hashCode ^
        planId.hashCode ^
        subscriptionId.hashCode ^
        subscription.hashCode ^
        addOns.hashCode ^
        discounts.hashCode ^
        descriptor.hashCode ^
        recurring.hashCode ^
        channel.hashCode ^
        serviceFeeAmount.hashCode ^
        escrowStatus.hashCode ^
        disbursementDetails.hashCode ^
        disputes.hashCode ^
        achReturnResponses.hashCode ^
        authorizationAdjustments.hashCode ^
        paymentInstrumentType.hashCode ^
        processorSettlementResponseCode.hashCode ^
        processorSettlementResponseText.hashCode ^
        networkResponseCode.hashCode ^
        networkResponseText.hashCode ^
        merchantAdviceCode.hashCode ^
        merchantAdviceCodeText.hashCode ^
        threeDSecureInfo.hashCode ^
        shipsFromPostalCode.hashCode ^
        shippingAmount.hashCode ^
        discountAmount.hashCode ^
        networkTransactionId.hashCode ^
        processorResponseType.hashCode ^
        authorizationExpiresAt.hashCode ^
        retryIds.hashCode ^
        retriedTransactionId.hashCode ^
        refundGlobalIds.hashCode ^
        partialSettlementTransactionGlobalIds.hashCode ^
        refundedTransactionGlobalId.hashCode ^
        authorizedTransactionGlobalId.hashCode ^
        globalId.hashCode ^
        retryGlobalIds.hashCode ^
        retriedTransactionGlobalId.hashCode ^
        retrievalReferenceNumber.hashCode ^
        achReturnCode.hashCode ^
        installmentCount.hashCode ^
        installments.hashCode ^
        refundedInstallments.hashCode ^
        responseEmvData.hashCode ^
        acquirerReferenceNumber.hashCode ^
        merchantIdentificationNumber.hashCode ^
        terminalIdentificationNumber.hashCode ^
        merchantName.hashCode ^
        merchantAddress.hashCode ^
        pinVerified.hashCode ^
        debitNetwork.hashCode ^
        processingMode.hashCode ^
        paymentReceipt.hashCode ^
        creditCardDetails.hashCode ^
        customerDetails.hashCode ^
        billingDetails.hashCode ^
        shippingDetails.hashCode ^
        subscriptionDetails.hashCode ^
        graphQLId.hashCode;
  }
}

class SubMerchantAccountId {}

class MasterMerchantAccountId {}

class OrderId {}

class CreatedAt {
  final String date;
  final int timezone_type;
  final String timezone;
  CreatedAt({
    required this.date,
    required this.timezone_type,
    required this.timezone,
  });

  CreatedAt copyWith({
    String? date,
    int? timezone_type,
    String? timezone,
  }) {
    return CreatedAt(
      date: date ?? this.date,
      timezone_type: timezone_type ?? this.timezone_type,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'timezone_type': timezone_type,
      'timezone': timezone,
    };
  }

  factory CreatedAt.fromMap(Map<String, dynamic> map) {
    return CreatedAt(
      date: map['date'] as String,
      timezone_type: map['timezone_type'].toInt() as int,
      timezone: map['timezone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatedAt.fromJson(String source) =>
      CreatedAt.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CreatedAt(date: $date, timezone_type: $timezone_type, timezone: $timezone)';

  @override
  bool operator ==(covariant CreatedAt other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.timezone_type == timezone_type &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      date.hashCode ^ timezone_type.hashCode ^ timezone.hashCode;
}

class UpdatedAt {
  final String date;
  final int timezone_type;
  final String timezone;
  UpdatedAt({
    required this.date,
    required this.timezone_type,
    required this.timezone,
  });

  UpdatedAt copyWith({
    String? date,
    int? timezone_type,
    String? timezone,
  }) {
    return UpdatedAt(
      date: date ?? this.date,
      timezone_type: timezone_type ?? this.timezone_type,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'timezone_type': timezone_type,
      'timezone': timezone,
    };
  }

  factory UpdatedAt.fromMap(Map<String, dynamic> map) {
    return UpdatedAt(
      date: map['date'] as String,
      timezone_type: map['timezone_type'].toInt() as int,
      timezone: map['timezone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdatedAt.fromJson(String source) =>
      UpdatedAt.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UpdatedAt(date: $date, timezone_type: $timezone_type, timezone: $timezone)';

  @override
  bool operator ==(covariant UpdatedAt other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.timezone_type == timezone_type &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      date.hashCode ^ timezone_type.hashCode ^ timezone.hashCode;
}

class Customer {
  final Id id;
  final FirstName firstName;
  final LastName lastName;
  final Company company;
  final Email email;
  final Website website;
  final Phone phone;
  final Fax fax;
  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.email,
    required this.website,
    required this.phone,
    required this.fax,
  });

  Customer copyWith({
    Id? id,
    FirstName? firstName,
    LastName? lastName,
    Company? company,
    Email? email,
    Website? website,
    Phone? phone,
    Fax? fax,
  }) {
    return Customer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      email: email ?? this.email,
      website: website ?? this.website,
      phone: phone ?? this.phone,
      fax: fax ?? this.fax,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id.toMap(),
      // 'firstName': firstName.toMap(),
      // 'lastName': lastName.toMap(),
      // 'company': company.toMap(),
      // 'email': email.toMap(),
      // 'website': website.toMap(),
      // 'phone': phone.toMap(),
      // 'fax': fax.toMap(),
    };
  }

  // factory Customer.fromMap(Map<String, dynamic> map) {
  //   return Customer(
  //     id: Id.fromMap(map['id'] as Map<String,dynamic>),
  //     firstName: FirstName.fromMap(map['firstName'] as Map<String,dynamic>),
  //     lastName: LastName.fromMap(map['lastName'] as Map<String,dynamic>),
  //     company: Company.fromMap(map['company'] as Map<String,dynamic>),
  //     email: Email.fromMap(map['email'] as Map<String,dynamic>),
  //     website: Website.fromMap(map['website'] as Map<String,dynamic>),
  //     phone: Phone.fromMap(map['phone'] as Map<String,dynamic>),
  //     fax: Fax.fromMap(map['fax'] as Map<String,dynamic>),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory Customer.fromJson(String source) => Customer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Customer(id: $id, firstName: $firstName, lastName: $lastName, company: $company, email: $email, website: $website, phone: $phone, fax: $fax)';
  }

  @override
  bool operator ==(covariant Customer other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.company == company &&
        other.email == email &&
        other.website == website &&
        other.phone == phone &&
        other.fax == fax;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        company.hashCode ^
        email.hashCode ^
        website.hashCode ^
        phone.hashCode ^
        fax.hashCode;
  }
}

class Id {}

class FirstName {}

class LastName {}

class Company {}

class Email {}

class Website {}

class Phone {}

class Fax {}

class Billing {
  final Id id;
  final FirstName firstName;
  final LastName lastName;
  final Company company;
  final StreetAddress streetAddress;
  final ExtendedAddress extendedAddress;
  final Locality locality;
  final Region region;
  final PostalCode postalCode;
  final CountryName countryName;
  final CountryCodeAlpha2 countryCodeAlpha2;
  final CountryCodeAlpha3 countryCodeAlpha3;
  final CountryCodeNumeric countryCodeNumeric;
  Billing({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.streetAddress,
    required this.extendedAddress,
    required this.locality,
    required this.region,
    required this.postalCode,
    required this.countryName,
    required this.countryCodeAlpha2,
    required this.countryCodeAlpha3,
    required this.countryCodeNumeric,
  });

  Billing copyWith({
    Id? id,
    FirstName? firstName,
    LastName? lastName,
    Company? company,
    StreetAddress? streetAddress,
    ExtendedAddress? extendedAddress,
    Locality? locality,
    Region? region,
    PostalCode? postalCode,
    CountryName? countryName,
    CountryCodeAlpha2? countryCodeAlpha2,
    CountryCodeAlpha3? countryCodeAlpha3,
    CountryCodeNumeric? countryCodeNumeric,
  }) {
    return Billing(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      streetAddress: streetAddress ?? this.streetAddress,
      extendedAddress: extendedAddress ?? this.extendedAddress,
      locality: locality ?? this.locality,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      countryName: countryName ?? this.countryName,
      countryCodeAlpha2: countryCodeAlpha2 ?? this.countryCodeAlpha2,
      countryCodeAlpha3: countryCodeAlpha3 ?? this.countryCodeAlpha3,
      countryCodeNumeric: countryCodeNumeric ?? this.countryCodeNumeric,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id.toMap(),
      // 'firstName': firstName.toMap(),
      // 'lastName': lastName.toMap(),
      // 'company': company.toMap(),
      // 'streetAddress': streetAddress.toMap(),
      // 'extendedAddress': extendedAddress.toMap(),
      // 'locality': locality.toMap(),
      // 'region': region.toMap(),
      // 'postalCode': postalCode.toMap(),
      // 'countryName': countryName.toMap(),
      // 'countryCodeAlpha2': countryCodeAlpha2.toMap(),
      // 'countryCodeAlpha3': countryCodeAlpha3.toMap(),
      // 'countryCodeNumeric': countryCodeNumeric.toMap(),
    };
  }

  // factory Billing.fromMap(Map<String, dynamic> map) {
  //   return Billing(
  //     id: Id.fromMap(map['id'] as Map<String,dynamic>),
  //     firstName: FirstName.fromMap(map['firstName'] as Map<String,dynamic>),
  //     lastName: LastName.fromMap(map['lastName'] as Map<String,dynamic>),
  //     company: Company.fromMap(map['company'] as Map<String,dynamic>),
  //     streetAddress: StreetAddress.fromMap(map['streetAddress'] as Map<String,dynamic>),
  //     extendedAddress: ExtendedAddress.fromMap(map['extendedAddress'] as Map<String,dynamic>),
  //     locality: Locality.fromMap(map['locality'] as Map<String,dynamic>),
  //     region: Region.fromMap(map['region'] as Map<String,dynamic>),
  //     postalCode: PostalCode.fromMap(map['postalCode'] as Map<String,dynamic>),
  //     countryName: CountryName.fromMap(map['countryName'] as Map<String,dynamic>),
  //     countryCodeAlpha2: CountryCodeAlpha2.fromMap(map['countryCodeAlpha2'] as Map<String,dynamic>),
  //     countryCodeAlpha3: CountryCodeAlpha3.fromMap(map['countryCodeAlpha3'] as Map<String,dynamic>),
  //     countryCodeNumeric: CountryCodeNumeric.fromMap(map['countryCodeNumeric'] as Map<String,dynamic>),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory Billing.fromJson(String source) => Billing.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Billing(id: $id, firstName: $firstName, lastName: $lastName, company: $company, streetAddress: $streetAddress, extendedAddress: $extendedAddress, locality: $locality, region: $region, postalCode: $postalCode, countryName: $countryName, countryCodeAlpha2: $countryCodeAlpha2, countryCodeAlpha3: $countryCodeAlpha3, countryCodeNumeric: $countryCodeNumeric)';
  }

  @override
  bool operator ==(covariant Billing other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.company == company &&
        other.streetAddress == streetAddress &&
        other.extendedAddress == extendedAddress &&
        other.locality == locality &&
        other.region == region &&
        other.postalCode == postalCode &&
        other.countryName == countryName &&
        other.countryCodeAlpha2 == countryCodeAlpha2 &&
        other.countryCodeAlpha3 == countryCodeAlpha3 &&
        other.countryCodeNumeric == countryCodeNumeric;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        company.hashCode ^
        streetAddress.hashCode ^
        extendedAddress.hashCode ^
        locality.hashCode ^
        region.hashCode ^
        postalCode.hashCode ^
        countryName.hashCode ^
        countryCodeAlpha2.hashCode ^
        countryCodeAlpha3.hashCode ^
        countryCodeNumeric.hashCode;
  }
}

class StreetAddress {}

class ExtendedAddress {}

class Locality {}

class Region {}

class PostalCode {}

class CountryName {}

class CountryCodeAlpha2 {}

class CountryCodeAlpha3 {}

class CountryCodeNumeric {}

class RefundId {}

class RefundedTransactionId {}

class AuthorizedTransactionId {}

class SettlementBatchId {}

class Shipping {
  final Id id;
  final FirstName firstName;
  final LastName lastName;
  final Company company;
  final StreetAddress streetAddress;
  final ExtendedAddress extendedAddress;
  final Locality locality;
  final Region region;
  final PostalCode postalCode;
  final CountryName countryName;
  final CountryCodeAlpha2 countryCodeAlpha2;
  final CountryCodeAlpha3 countryCodeAlpha3;
  final CountryCodeNumeric countryCodeNumeric;
  Shipping({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.streetAddress,
    required this.extendedAddress,
    required this.locality,
    required this.region,
    required this.postalCode,
    required this.countryName,
    required this.countryCodeAlpha2,
    required this.countryCodeAlpha3,
    required this.countryCodeNumeric,
  });

  Shipping copyWith({
    Id? id,
    FirstName? firstName,
    LastName? lastName,
    Company? company,
    StreetAddress? streetAddress,
    ExtendedAddress? extendedAddress,
    Locality? locality,
    Region? region,
    PostalCode? postalCode,
    CountryName? countryName,
    CountryCodeAlpha2? countryCodeAlpha2,
    CountryCodeAlpha3? countryCodeAlpha3,
    CountryCodeNumeric? countryCodeNumeric,
  }) {
    return Shipping(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      streetAddress: streetAddress ?? this.streetAddress,
      extendedAddress: extendedAddress ?? this.extendedAddress,
      locality: locality ?? this.locality,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      countryName: countryName ?? this.countryName,
      countryCodeAlpha2: countryCodeAlpha2 ?? this.countryCodeAlpha2,
      countryCodeAlpha3: countryCodeAlpha3 ?? this.countryCodeAlpha3,
      countryCodeNumeric: countryCodeNumeric ?? this.countryCodeNumeric,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id.toMap(),
      // 'firstName': firstName.toMap(),
      // 'lastName': lastName.toMap(),
      // 'company': company.toMap(),
      // 'streetAddress': streetAddress.toMap(),
      // 'extendedAddress': extendedAddress.toMap(),
      // 'locality': locality.toMap(),
      // 'region': region.toMap(),
      // 'postalCode': postalCode.toMap(),
      // 'countryName': countryName.toMap(),
      // 'countryCodeAlpha2': countryCodeAlpha2.toMap(),
      // 'countryCodeAlpha3': countryCodeAlpha3.toMap(),
      // 'countryCodeNumeric': countryCodeNumeric.toMap(),
    };
  }

  // factory Shipping.fromMap(Map<String, dynamic> map) {
  //   return Shipping(
  //     id: Id.fromMap(map['id'] as Map<String,dynamic>),
  //     firstName: FirstName.fromMap(map['firstName'] as Map<String,dynamic>),
  //     lastName: LastName.fromMap(map['lastName'] as Map<String,dynamic>),
  //     company: Company.fromMap(map['company'] as Map<String,dynamic>),
  //     streetAddress: StreetAddress.fromMap(map['streetAddress'] as Map<String,dynamic>),
  //     extendedAddress: ExtendedAddress.fromMap(map['extendedAddress'] as Map<String,dynamic>),
  //     locality: Locality.fromMap(map['locality'] as Map<String,dynamic>),
  //     region: Region.fromMap(map['region'] as Map<String,dynamic>),
  //     postalCode: PostalCode.fromMap(map['postalCode'] as Map<String,dynamic>),
  //     countryName: CountryName.fromMap(map['countryName'] as Map<String,dynamic>),
  //     countryCodeAlpha2: CountryCodeAlpha2.fromMap(map['countryCodeAlpha2'] as Map<String,dynamic>),
  //     countryCodeAlpha3: CountryCodeAlpha3.fromMap(map['countryCodeAlpha3'] as Map<String,dynamic>),
  //     countryCodeNumeric: CountryCodeNumeric.fromMap(map['countryCodeNumeric'] as Map<String,dynamic>),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory Shipping.fromJson(String source) => Shipping.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Shipping(id: $id, firstName: $firstName, lastName: $lastName, company: $company, streetAddress: $streetAddress, extendedAddress: $extendedAddress, locality: $locality, region: $region, postalCode: $postalCode, countryName: $countryName, countryCodeAlpha2: $countryCodeAlpha2, countryCodeAlpha3: $countryCodeAlpha3, countryCodeNumeric: $countryCodeNumeric)';
  }

  @override
  bool operator ==(covariant Shipping other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.company == company &&
        other.streetAddress == streetAddress &&
        other.extendedAddress == extendedAddress &&
        other.locality == locality &&
        other.region == region &&
        other.postalCode == postalCode &&
        other.countryName == countryName &&
        other.countryCodeAlpha2 == countryCodeAlpha2 &&
        other.countryCodeAlpha3 == countryCodeAlpha3 &&
        other.countryCodeNumeric == countryCodeNumeric;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        company.hashCode ^
        streetAddress.hashCode ^
        extendedAddress.hashCode ^
        locality.hashCode ^
        region.hashCode ^
        postalCode.hashCode ^
        countryName.hashCode ^
        countryCodeAlpha2.hashCode ^
        countryCodeAlpha3.hashCode ^
        countryCodeNumeric.hashCode;
  }
}

class CustomFields {}

class AvsErrorResponseCode {}

class GatewayRejectionReason {}

class AdditionalProcessorResponse {}

class VoiceReferralNumber {}

class PurchaseOrderNumber {}

class TaxAmount {}

class ScaExemptionRequested {}

class CreditCard {
  final Token token;
  final String bin;
  final String last4;
  final String cardType;
  final String expirationMonth;
  final String expirationYear;
  final String customerLocation;
  final CardholderName cardholderName;
  final String imageUrl;
  final bool isNetworkTokenized;
  final String prepaid;
  final String healthcare;
  final String debit;
  final String durbinRegulated;
  final String commercial;
  final String payroll;
  final String issuingBank;
  final String countryOfIssuance;
  final String productId;
  final GlobalId globalId;
  final String accountType;
  final UniqueNumberIdentifier uniqueNumberIdentifier;
  final bool venmoSdk;
  final AccountBalance accountBalance;
  CreditCard({
    required this.token,
    required this.bin,
    required this.last4,
    required this.cardType,
    required this.expirationMonth,
    required this.expirationYear,
    required this.customerLocation,
    required this.cardholderName,
    required this.imageUrl,
    required this.isNetworkTokenized,
    required this.prepaid,
    required this.healthcare,
    required this.debit,
    required this.durbinRegulated,
    required this.commercial,
    required this.payroll,
    required this.issuingBank,
    required this.countryOfIssuance,
    required this.productId,
    required this.globalId,
    required this.accountType,
    required this.uniqueNumberIdentifier,
    required this.venmoSdk,
    required this.accountBalance,
  });

  CreditCard copyWith({
    Token? token,
    String? bin,
    String? last4,
    String? cardType,
    String? expirationMonth,
    String? expirationYear,
    String? customerLocation,
    CardholderName? cardholderName,
    String? imageUrl,
    bool? isNetworkTokenized,
    String? prepaid,
    String? healthcare,
    String? debit,
    String? durbinRegulated,
    String? commercial,
    String? payroll,
    String? issuingBank,
    String? countryOfIssuance,
    String? productId,
    GlobalId? globalId,
    String? accountType,
    UniqueNumberIdentifier? uniqueNumberIdentifier,
    bool? venmoSdk,
    AccountBalance? accountBalance,
  }) {
    return CreditCard(
      token: token ?? this.token,
      bin: bin ?? this.bin,
      last4: last4 ?? this.last4,
      cardType: cardType ?? this.cardType,
      expirationMonth: expirationMonth ?? this.expirationMonth,
      expirationYear: expirationYear ?? this.expirationYear,
      customerLocation: customerLocation ?? this.customerLocation,
      cardholderName: cardholderName ?? this.cardholderName,
      imageUrl: imageUrl ?? this.imageUrl,
      isNetworkTokenized: isNetworkTokenized ?? this.isNetworkTokenized,
      prepaid: prepaid ?? this.prepaid,
      healthcare: healthcare ?? this.healthcare,
      debit: debit ?? this.debit,
      durbinRegulated: durbinRegulated ?? this.durbinRegulated,
      commercial: commercial ?? this.commercial,
      payroll: payroll ?? this.payroll,
      issuingBank: issuingBank ?? this.issuingBank,
      countryOfIssuance: countryOfIssuance ?? this.countryOfIssuance,
      productId: productId ?? this.productId,
      globalId: globalId ?? this.globalId,
      accountType: accountType ?? this.accountType,
      uniqueNumberIdentifier:
          uniqueNumberIdentifier ?? this.uniqueNumberIdentifier,
      venmoSdk: venmoSdk ?? this.venmoSdk,
      accountBalance: accountBalance ?? this.accountBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'token': token.toMap(),
      'bin': bin,
      'last4': last4,
      'cardType': cardType,
      'expirationMonth': expirationMonth,
      'expirationYear': expirationYear,
      'customerLocation': customerLocation,
      // 'cardholderName': cardholderName.toMap(),
      'imageUrl': imageUrl,
      'isNetworkTokenized': isNetworkTokenized,
      'prepaid': prepaid,
      'healthcare': healthcare,
      'debit': debit,
      'durbinRegulated': durbinRegulated,
      'commercial': commercial,
      'payroll': payroll,
      'issuingBank': issuingBank,
      'countryOfIssuance': countryOfIssuance,
      'productId': productId,
      // 'globalId': globalId.toMap(),
      'accountType': accountType,
      // 'uniqueNumberIdentifier': uniqueNumberIdentifier.toMap(),
      'venmoSdk': venmoSdk,
      // 'accountBalance': accountBalance.toMap(),
    };
  }

  // factory CreditCard.fromMap(Map<String, dynamic> map) {
  //   return CreditCard(
  //     token: Token.fromMap(map['token'] as Map<String,dynamic>),
  //     bin: map['bin'] as String,
  //     last4: map['last4'] as String,
  //     cardType: map['cardType'] as String,
  //     expirationMonth: map['expirationMonth'] as String,
  //     expirationYear: map['expirationYear'] as String,
  //     customerLocation: map['customerLocation'] as String,
  //     cardholderName: CardholderName.fromMap(map['cardholderName'] as Map<String,dynamic>),
  //     imageUrl: map['imageUrl'] as String,
  //     isNetworkTokenized: map['isNetworkTokenized'] as bool,
  //     prepaid: map['prepaid'] as String,
  //     healthcare: map['healthcare'] as String,
  //     debit: map['debit'] as String,
  //     durbinRegulated: map['durbinRegulated'] as String,
  //     commercial: map['commercial'] as String,
  //     payroll: map['payroll'] as String,
  //     issuingBank: map['issuingBank'] as String,
  //     countryOfIssuance: map['countryOfIssuance'] as String,
  //     productId: map['productId'] as String,
  //     globalId: GlobalId.fromMap(map['globalId'] as Map<String,dynamic>),
  //     accountType: map['accountType'] as String,
  //     uniqueNumberIdentifier: UniqueNumberIdentifier.fromMap(map['uniqueNumberIdentifier'] as Map<String,dynamic>),
  //     venmoSdk: map['venmoSdk'] as bool,
  //     accountBalance: AccountBalance.fromMap(map['accountBalance'] as Map<String,dynamic>),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory CreditCard.fromJson(String source) => CreditCard.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreditCard(token: $token, bin: $bin, last4: $last4, cardType: $cardType, expirationMonth: $expirationMonth, expirationYear: $expirationYear, customerLocation: $customerLocation, cardholderName: $cardholderName, imageUrl: $imageUrl, isNetworkTokenized: $isNetworkTokenized, prepaid: $prepaid, healthcare: $healthcare, debit: $debit, durbinRegulated: $durbinRegulated, commercial: $commercial, payroll: $payroll, issuingBank: $issuingBank, countryOfIssuance: $countryOfIssuance, productId: $productId, globalId: $globalId, accountType: $accountType, uniqueNumberIdentifier: $uniqueNumberIdentifier, venmoSdk: $venmoSdk, accountBalance: $accountBalance)';
  }

  @override
  bool operator ==(covariant CreditCard other) {
    if (identical(this, other)) return true;

    return other.token == token &&
        other.bin == bin &&
        other.last4 == last4 &&
        other.cardType == cardType &&
        other.expirationMonth == expirationMonth &&
        other.expirationYear == expirationYear &&
        other.customerLocation == customerLocation &&
        other.cardholderName == cardholderName &&
        other.imageUrl == imageUrl &&
        other.isNetworkTokenized == isNetworkTokenized &&
        other.prepaid == prepaid &&
        other.healthcare == healthcare &&
        other.debit == debit &&
        other.durbinRegulated == durbinRegulated &&
        other.commercial == commercial &&
        other.payroll == payroll &&
        other.issuingBank == issuingBank &&
        other.countryOfIssuance == countryOfIssuance &&
        other.productId == productId &&
        other.globalId == globalId &&
        other.accountType == accountType &&
        other.uniqueNumberIdentifier == uniqueNumberIdentifier &&
        other.venmoSdk == venmoSdk &&
        other.accountBalance == accountBalance;
  }

  @override
  int get hashCode {
    return token.hashCode ^
        bin.hashCode ^
        last4.hashCode ^
        cardType.hashCode ^
        expirationMonth.hashCode ^
        expirationYear.hashCode ^
        customerLocation.hashCode ^
        cardholderName.hashCode ^
        imageUrl.hashCode ^
        isNetworkTokenized.hashCode ^
        prepaid.hashCode ^
        healthcare.hashCode ^
        debit.hashCode ^
        durbinRegulated.hashCode ^
        commercial.hashCode ^
        payroll.hashCode ^
        issuingBank.hashCode ^
        countryOfIssuance.hashCode ^
        productId.hashCode ^
        globalId.hashCode ^
        accountType.hashCode ^
        uniqueNumberIdentifier.hashCode ^
        venmoSdk.hashCode ^
        accountBalance.hashCode;
  }
}

class Token {}

class CardholderName {}

class GlobalId {}

class UniqueNumberIdentifier {}

class AccountBalance {}

class StatusHistory {}

class PlanId {}

class SubscriptionId {}

class Subscription {
  final BillingPeriodEndDate billingPeriodEndDate;
  final BillingPeriodStartDate billingPeriodStartDate;
  Subscription({
    required this.billingPeriodEndDate,
    required this.billingPeriodStartDate,
  });

  Subscription copyWith({
    BillingPeriodEndDate? billingPeriodEndDate,
    BillingPeriodStartDate? billingPeriodStartDate,
  }) {
    return Subscription(
      billingPeriodEndDate: billingPeriodEndDate ?? this.billingPeriodEndDate,
      billingPeriodStartDate:
          billingPeriodStartDate ?? this.billingPeriodStartDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'billingPeriodEndDate': billingPeriodEndDate.toMap(),
      // 'billingPeriodStartDate': billingPeriodStartDate.toMap(),
    };
  }

  // factory Subscription.fromMap(Map<String, dynamic> map) {
  //   return Subscription(
  //     billingPeriodEndDate: BillingPeriodEndDate.fromMap(map['billingPeriodEndDate'] as Map<String,dynamic>),
  //     billingPeriodStartDate: BillingPeriodStartDate.fromMap(map['billingPeriodStartDate'] as Map<String,dynamic>),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory Subscription.fromJson(String source) => Subscription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Subscription(billingPeriodEndDate: $billingPeriodEndDate, billingPeriodStartDate: $billingPeriodStartDate)';

  @override
  bool operator ==(covariant Subscription other) {
    if (identical(this, other)) return true;

    return other.billingPeriodEndDate == billingPeriodEndDate &&
        other.billingPeriodStartDate == billingPeriodStartDate;
  }

  @override
  int get hashCode =>
      billingPeriodEndDate.hashCode ^ billingPeriodStartDate.hashCode;
}

class BillingPeriodEndDate {}

class BillingPeriodStartDate {}

class Descriptor {}

class Channel {}

class ServiceFeeAmount {}

class EscrowStatus {}

class DisbursementDetails {}

class ProcessorSettlementResponseCode {}

class ProcessorSettlementResponseText {}

class MerchantAdviceCode {}

class MerchantAdviceCodeText {}

class ThreeDSecureInfo {}

class ShipsFromPostalCode {}

class ShippingAmount {}

class DiscountAmount {}

class AuthorizationExpiresAt {
  final String date;
  final int timezone_type;
  final String timezone;
  AuthorizationExpiresAt({
    required this.date,
    required this.timezone_type,
    required this.timezone,
  });

  AuthorizationExpiresAt copyWith({
    String? date,
    int? timezone_type,
    String? timezone,
  }) {
    return AuthorizationExpiresAt(
      date: date ?? this.date,
      timezone_type: timezone_type ?? this.timezone_type,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'timezone_type': timezone_type,
      'timezone': timezone,
    };
  }

  factory AuthorizationExpiresAt.fromMap(Map<String, dynamic> map) {
    return AuthorizationExpiresAt(
      date: map['date'] as String,
      timezone_type: map['timezone_type'].toInt() as int,
      timezone: map['timezone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthorizationExpiresAt.fromJson(String source) =>
      AuthorizationExpiresAt.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthorizationExpiresAt(date: $date, timezone_type: $timezone_type, timezone: $timezone)';

  @override
  bool operator ==(covariant AuthorizationExpiresAt other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.timezone_type == timezone_type &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      date.hashCode ^ timezone_type.hashCode ^ timezone.hashCode;
}

class RetriedTransactionId {}

class RefundedTransactionGlobalId {}

class AuthorizedTransactionGlobalId {}

class RetriedTransactionGlobalId {}

class AchReturnCode {}

class InstallmentCount {}

class ResponseEmvData {}

class AcquirerReferenceNumber {}

class MerchantAddress {
  final StreetAddress streetAddress;
  final String locality;
  final String region;
  final String postalCode;
  final String phone;
  MerchantAddress({
    required this.streetAddress,
    required this.locality,
    required this.region,
    required this.postalCode,
    required this.phone,
  });

  MerchantAddress copyWith({
    StreetAddress? streetAddress,
    String? locality,
    String? region,
    String? postalCode,
    String? phone,
  }) {
    return MerchantAddress(
      streetAddress: streetAddress ?? this.streetAddress,
      locality: locality ?? this.locality,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'streetAddress': streetAddress.toMap(),
      'locality': locality,
      'region': region,
      'postalCode': postalCode,
      'phone': phone,
    };
  }

  // factory MerchantAddress.fromMap(Map<String, dynamic> map) {
  //   return MerchantAddress(
  //     streetAddress: StreetAddress.fromMap(map['streetAddress'] as Map<String,dynamic>),
  //     locality: map['locality'] as String,
  //     region: map['region'] as String,
  //     postalCode: map['postalCode'] as String,
  //     phone: map['phone'] as String,
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory MerchantAddress.fromJson(String source) => MerchantAddress.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MerchantAddress(streetAddress: $streetAddress, locality: $locality, region: $region, postalCode: $postalCode, phone: $phone)';
  }

  @override
  bool operator ==(covariant MerchantAddress other) {
    if (identical(this, other)) return true;

    return other.streetAddress == streetAddress &&
        other.locality == locality &&
        other.region == region &&
        other.postalCode == postalCode &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return streetAddress.hashCode ^
        locality.hashCode ^
        region.hashCode ^
        postalCode.hashCode ^
        phone.hashCode;
  }
}

class DebitNetwork {}

class ProcessingMode {}

class PaymentReceipt {
  final String id;
  final String globalId;
  final String amount;
  final String currencyIsoCode;
  final String processorResponseCode;
  final String processorResponseText;
  final String processorAuthorizationCode;
  final String merchantName;
  final MerchantAddress merchantAddress;
  final String merchantIdentificationNumber;
  final String terminalIdentificationNumber;
  final String type;
  final bool pinVerified;
  final ProcessingMode processingMode;
  final NetworkIdentificationCode networkIdentificationCode;
  final String cardType;
  final String cardLast4;
  final AccountBalance accountBalance;
  PaymentReceipt({
    required this.id,
    required this.globalId,
    required this.amount,
    required this.currencyIsoCode,
    required this.processorResponseCode,
    required this.processorResponseText,
    required this.processorAuthorizationCode,
    required this.merchantName,
    required this.merchantAddress,
    required this.merchantIdentificationNumber,
    required this.terminalIdentificationNumber,
    required this.type,
    required this.pinVerified,
    required this.processingMode,
    required this.networkIdentificationCode,
    required this.cardType,
    required this.cardLast4,
    required this.accountBalance,
  });

  PaymentReceipt copyWith({
    String? id,
    String? globalId,
    String? amount,
    String? currencyIsoCode,
    String? processorResponseCode,
    String? processorResponseText,
    String? processorAuthorizationCode,
    String? merchantName,
    MerchantAddress? merchantAddress,
    String? merchantIdentificationNumber,
    String? terminalIdentificationNumber,
    String? type,
    bool? pinVerified,
    ProcessingMode? processingMode,
    NetworkIdentificationCode? networkIdentificationCode,
    String? cardType,
    String? cardLast4,
    AccountBalance? accountBalance,
  }) {
    return PaymentReceipt(
      id: id ?? this.id,
      globalId: globalId ?? this.globalId,
      amount: amount ?? this.amount,
      currencyIsoCode: currencyIsoCode ?? this.currencyIsoCode,
      processorResponseCode:
          processorResponseCode ?? this.processorResponseCode,
      processorResponseText:
          processorResponseText ?? this.processorResponseText,
      processorAuthorizationCode:
          processorAuthorizationCode ?? this.processorAuthorizationCode,
      merchantName: merchantName ?? this.merchantName,
      merchantAddress: merchantAddress ?? this.merchantAddress,
      merchantIdentificationNumber:
          merchantIdentificationNumber ?? this.merchantIdentificationNumber,
      terminalIdentificationNumber:
          terminalIdentificationNumber ?? this.terminalIdentificationNumber,
      type: type ?? this.type,
      pinVerified: pinVerified ?? this.pinVerified,
      processingMode: processingMode ?? this.processingMode,
      networkIdentificationCode:
          networkIdentificationCode ?? this.networkIdentificationCode,
      cardType: cardType ?? this.cardType,
      cardLast4: cardLast4 ?? this.cardLast4,
      accountBalance: accountBalance ?? this.accountBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'globalId': globalId,
      'amount': amount,
      'currencyIsoCode': currencyIsoCode,
      'processorResponseCode': processorResponseCode,
      'processorResponseText': processorResponseText,
      'processorAuthorizationCode': processorAuthorizationCode,
      'merchantName': merchantName,
      'merchantAddress': merchantAddress.toMap(),
      'merchantIdentificationNumber': merchantIdentificationNumber,
      'terminalIdentificationNumber': terminalIdentificationNumber,
      'type': type,
      'pinVerified': pinVerified,
      // 'processingMode': processingMode.toMap(),
      // 'networkIdentificationCode': networkIdentificationCode.toMap(),
      'cardType': cardType,
      'cardLast4': cardLast4,
      // 'accountBalance': accountBalance.toMap(),
    };
  }

  // factory PaymentReceipt.fromMap(Map<String, dynamic> map) {
  //   return PaymentReceipt(
  //     id: map['id'] as String,
  //     globalId: map['globalId'] as String,
  //     amount: map['amount'] as String,
  //     currencyIsoCode: map['currencyIsoCode'] as String,
  //     processorResponseCode: map['processorResponseCode'] as String,
  //     processorResponseText: map['processorResponseText'] as String,
  //     processorAuthorizationCode: map['processorAuthorizationCode'] as String,
  //     merchantName: map['merchantName'] as String,
  //     // merchantAddress: MerchantAddress.fromMap(map['merchantAddress'] as Map<String,dynamic>),
  //     merchantIdentificationNumber: map['merchantIdentificationNumber'] as String,
  //     terminalIdentificationNumber: map['terminalIdentificationNumber'] as String,
  //     type: map['type'] as String,
  //     pinVerified: map['pinVerified'] as bool,
  //     // processingMode: ProcessingMode.fromMap(map['processingMode'] as Map<String,dynamic>),
  //     // networkIdentificationCode: NetworkIdentificationCode.fromMap(map['networkIdentificationCode'] as Map<String,dynamic>),
  //     cardType: map['cardType'] as String,
  //     cardLast4: map['cardLast4'] as String,
  //     // accountBalance: AccountBalance.fromMap(map['accountBalance'] as Map<String,dynamic>),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory PaymentReceipt.fromJson(String source) => PaymentReceipt.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentReceipt(id: $id, globalId: $globalId, amount: $amount, currencyIsoCode: $currencyIsoCode, processorResponseCode: $processorResponseCode, processorResponseText: $processorResponseText, processorAuthorizationCode: $processorAuthorizationCode, merchantName: $merchantName, merchantAddress: $merchantAddress, merchantIdentificationNumber: $merchantIdentificationNumber, terminalIdentificationNumber: $terminalIdentificationNumber, type: $type, pinVerified: $pinVerified, processingMode: $processingMode, networkIdentificationCode: $networkIdentificationCode, cardType: $cardType, cardLast4: $cardLast4, accountBalance: $accountBalance)';
  }

  @override
  bool operator ==(covariant PaymentReceipt other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.globalId == globalId &&
        other.amount == amount &&
        other.currencyIsoCode == currencyIsoCode &&
        other.processorResponseCode == processorResponseCode &&
        other.processorResponseText == processorResponseText &&
        other.processorAuthorizationCode == processorAuthorizationCode &&
        other.merchantName == merchantName &&
        other.merchantAddress == merchantAddress &&
        other.merchantIdentificationNumber == merchantIdentificationNumber &&
        other.terminalIdentificationNumber == terminalIdentificationNumber &&
        other.type == type &&
        other.pinVerified == pinVerified &&
        other.processingMode == processingMode &&
        other.networkIdentificationCode == networkIdentificationCode &&
        other.cardType == cardType &&
        other.cardLast4 == cardLast4 &&
        other.accountBalance == accountBalance;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        globalId.hashCode ^
        amount.hashCode ^
        currencyIsoCode.hashCode ^
        processorResponseCode.hashCode ^
        processorResponseText.hashCode ^
        processorAuthorizationCode.hashCode ^
        merchantName.hashCode ^
        merchantAddress.hashCode ^
        merchantIdentificationNumber.hashCode ^
        terminalIdentificationNumber.hashCode ^
        type.hashCode ^
        pinVerified.hashCode ^
        processingMode.hashCode ^
        networkIdentificationCode.hashCode ^
        cardType.hashCode ^
        cardLast4.hashCode ^
        accountBalance.hashCode;
  }
}

class NetworkIdentificationCode {}

class CreditCardDetails {}

class CustomerDetails {}

class BillingDetails {}

class ShippingDetails {}

class SubscriptionDetails {}

extension ContainsEither on String {
  bool containsEither(List<String> other) {
    for (var item in other) {
      if (this.contains(item)) {
        return true;
      }
    }
    return false;
  }
}
