/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseSaleTransactionRequest.h"

@interface IMSCreditForceSaleTransactionRequest : IMSBaseSaleTransactionRequest

/*!
 * 6 digits authorization code for credit force sale
 */

@property (nonatomic, strong) NSString * _Nonnull authorizationCode;

/*!
 * 1 to 6 digit systemTraceAuditNumber for credit force sale.
 */

@property (nonatomic) NSInteger systemTraceAuditNumber;

/*!
 * Format to generate Unique Card Identifier for this transaction. (optional)
 */
@property (nonatomic) IMSUCIFormat uciFormat;

/*!
 * Constructs a credit force sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param authorizationCode 6 digits authorization code provided for credit force sale.
 * @param systemTraceAuditNumber 1 to 6 digit systemTraceAuditNumber for credit force sale.
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
          andProducts:(NSArray * _Nullable)products
           andClerkID:(NSString * _Nullable)clerkID
         andLongitude:(NSString * _Nullable)gpsLong
          andLatitude:(NSString * _Nullable)gpsLal
andTransactionGroupID:(NSString * _Nullable)transactionGroupID
 andAuthorizationCode:(NSString * _Nonnull)authorizationCode
andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber;

/*!
 * Constructs a credit force sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param authorizationCode 6 digits authorization code provided for credit force sale.
 * @param systemTraceAuditNumber 1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                           Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
          andProducts:(NSArray * _Nullable)products
           andClerkID:(NSString * _Nullable)clerkID
         andLongitude:(NSString * _Nullable)gpsLong
          andLatitude:(NSString * _Nullable)gpsLal
andTransactionGroupID:(NSString * _Nullable)transactionGroupID
 andAuthorizationCode:(NSString * _Nonnull)authorizationCode
andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
andTransactionNotes:(NSString * _Nullable)transactionNotes
 andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt;

/*!
 * Constructs a credit force sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param authorizationCode 6 digits authorization code provided for credit force sale.
 * @param systemTraceAuditNumber 1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                           Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
          andProducts:(NSArray * _Nullable)products
           andClerkID:(NSString * _Nullable)clerkID
         andLongitude:(NSString * _Nullable)gpsLong
          andLatitude:(NSString * _Nullable)gpsLal
andTransactionGroupID:(NSString * _Nullable)transactionGroupID
 andAuthorizationCode:(NSString * _Nonnull)authorizationCode
andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
  andTransactionNotes:(NSString * _Nullable)transactionNotes
 andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
 andCustomReference:(NSString * _Nullable)customReference;

/*!
 * Constructs a credit force sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param authorizationCode 6 digits authorization code provided for credit force sale.
 * @param systemTraceAuditNumber 1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                           Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
          andProducts:(NSArray * _Nullable)products
           andClerkID:(NSString * _Nullable)clerkID
         andLongitude:(NSString * _Nullable)gpsLong
          andLatitude:(NSString * _Nullable)gpsLal
andTransactionGroupID:(NSString * _Nullable)transactionGroupID
 andAuthorizationCode:(NSString * _Nonnull)authorizationCode
andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
  andTransactionNotes:(NSString * _Nullable)transactionNotes
 andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
   andCustomReference:(NSString * _Nullable)customReference
       andIsCompleted:(bool)isCompleted;

/*!
 * Constructs a credit force sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param authorizationCode 6 digits authorization code provided for credit force sale.
 * @param systemTraceAuditNumber 1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                           Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
                    andProducts:(NSArray * _Nullable)products
                     andClerkID:(NSString * _Nullable)clerkID
                   andLongitude:(NSString * _Nullable)gpsLong
                    andLatitude:(NSString * _Nullable)gpsLal
          andTransactionGroupID:(NSString * _Nullable)transactionGroupID
           andAuthorizationCode:(NSString * _Nonnull)authorizationCode
      andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
            andTransactionNotes:(NSString * _Nullable)transactionNotes
           andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
             andCustomReference:(NSString * _Nullable)customReference
                 andIsCompleted:(bool)isCompleted
                   andUCIFormat:(IMSUCIFormat) uciFormat;

/*!
 * Constructs a credit force sale transaction request.
 * @param amount sale amount
 * @param products list of products
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param authorizationCode 6 digits authorization code provided for credit force sale.
 * @param systemTraceAuditNumber 1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                           Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional)
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
                    andProducts:(NSArray * _Nullable)products
                     andClerkID:(NSString * _Nullable)clerkID
                   andLongitude:(NSString * _Nullable)gpsLong
                    andLatitude:(NSString * _Nullable)gpsLal
          andTransactionGroupID:(NSString * _Nullable)transactionGroupID
           andAuthorizationCode:(NSString * _Nonnull)authorizationCode
      andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
            andTransactionNotes:(NSString * _Nullable)transactionNotes
           andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
             andCustomReference:(NSString * _Nullable)customReference
                 andIsCompleted:(bool)isCompleted
                   andUCIFormat:(IMSUCIFormat) uciFormat
                   andOrderNumber:(NSString * _Nullable)orderNumber;

@end
