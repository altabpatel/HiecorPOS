/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseSaleTransactionRequest.h"
#import "IMSCard.h"

@interface IMSKeyedCreditForceSaleTransactionRequest : IMSBaseSaleTransactionRequest

/*!
 * 6 digits authorization code for credit force sale
 */

@property (nonatomic, strong) NSString * _Nonnull authorizationCode;

/*!
 * Information of card used to make the keyed credit force sale.
 * @see IMSCard
 */

@property (nonatomic, strong) IMSCard * _Nonnull card;

/*!
 * 1 to 6 digit systemTraceAuditNumber for credit force sale.
 */

@property (nonatomic) NSInteger systemTraceAuditNumber;

/*!
 * Format to generate Unique Card Identifier for this transaction. (optional)
 */
@property (nonatomic) IMSUCIFormat uciFormat;

/*!
 * Indicates whether card was present for this transaction
 */
@property (nonatomic) bool isCardPresent;

/*!
 * Constructs a keyed credit force sale transaction request.
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param authorizationCode                 6 digits authorization code for credit force sale.
 * @param systemTraceAuditNumber            1 to 6 digit systemTraceAuditNumber for credit force sale.
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
          andProducts:(NSArray * _Nullable)products
              andCard:(IMSCard * _Nonnull)card
           andClerkID:(NSString * _Nullable)clerkID
         andLongitude:(NSString * _Nullable)gpsLong
          andLatitude:(NSString * _Nullable)gpsLat
andTransactionGroupID:(NSString * _Nullable)transactionGroupID
 andAuthorizationCode:(NSString * _Nonnull)authorizationCode
andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber;

/*!
 * Constructs a keyed credit force sale transaction request.
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param authorizationCode                 6 digits authorization code for credit force sale.
 * @param systemTraceAuditNumber            1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
          andProducts:(NSArray * _Nullable)products
              andCard:(IMSCard * _Nonnull)card
           andClerkID:(NSString * _Nullable)clerkID
         andLongitude:(NSString * _Nullable)gpsLong
          andLatitude:(NSString * _Nullable)gpsLat
andTransactionGroupID:(NSString * _Nullable)transactionGroupID
 andAuthorizationCode:(NSString * _Nonnull)authorizationCode
andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
andTransactionNotes:(NSString * _Nullable)transactionNotes
 andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt;

/*!
 * Constructs a keyed credit force sale transaction request.
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param authorizationCode                 6 digits authorization code for credit force sale.
 * @param systemTraceAuditNumber            1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference                   20 digit merchant order number (optional)
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
          andProducts:(NSArray * _Nullable)products
              andCard:(IMSCard * _Nonnull)card
           andClerkID:(NSString * _Nullable)clerkID
         andLongitude:(NSString * _Nullable)gpsLong
          andLatitude:(NSString * _Nullable)gpsLat
andTransactionGroupID:(NSString * _Nullable)transactionGroupID
 andAuthorizationCode:(NSString * _Nonnull)authorizationCode
andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
  andTransactionNotes:(NSString * _Nullable)transactionNotes
 andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
 andCustomReference:(NSString * _Nullable)customReference;

/*!
 * Constructs a keyed credit force sale transaction request.
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param authorizationCode                 6 digits authorization code for credit force sale.
 * @param systemTraceAuditNumber            1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference                   20 digit merchant order number (optional)
 * @param isCompleted                       indicates whether the transaction is completed,
 *                                          if true the transaction cannot be updated later
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
          andProducts:(NSArray * _Nullable)products
              andCard:(IMSCard * _Nonnull)card
           andClerkID:(NSString * _Nullable)clerkID
         andLongitude:(NSString * _Nullable)gpsLong
          andLatitude:(NSString * _Nullable)gpsLat
andTransactionGroupID:(NSString * _Nullable)transactionGroupID
 andAuthorizationCode:(NSString * _Nonnull)authorizationCode
andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
  andTransactionNotes:(NSString * _Nullable)transactionNotes
 andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
   andCustomReference:(NSString * _Nullable)customReference
       andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a keyed credit force sale transaction request.
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param authorizationCode                 6 digits authorization code for credit force sale.
 * @param systemTraceAuditNumber            1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference                   20 digit merchant order number (optional)
 * @param isCompleted                       indicates whether the transaction is completed,
 *                                          if true the transaction cannot be updated later
 * @param uciFormat                         Format to generate Unique Card Identifier for this transaction. (optional)
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
                    andProducts:(NSArray * _Nullable)products
                        andCard:(IMSCard * _Nonnull)card
                     andClerkID:(NSString * _Nullable)clerkID
                   andLongitude:(NSString * _Nullable)gpsLong
                    andLatitude:(NSString * _Nullable)gpsLat
          andTransactionGroupID:(NSString * _Nullable)transactionGroupID
           andAuthorizationCode:(NSString * _Nonnull)authorizationCode
      andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
            andTransactionNotes:(NSString * _Nullable)transactionNotes
           andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
             andCustomReference:(NSString * _Nullable)customReference
                 andIsCompleted:(bool) isCompleted
                   andUCIFormat:(IMSUCIFormat) uciFormat;

/*!
 * Constructs a keyed credit force sale transaction request.
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param authorizationCode                 6 digits authorization code for credit force sale.
 * @param systemTraceAuditNumber            1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference                   20 digit merchant order number (optional)
 * @param isCompleted                       indicates whether the transaction is completed,
 *                                          if true the transaction cannot be updated later
 * @param uciFormat                         Format to generate Unique Card Identifier for this transaction. (optional)
 * @param isCardPresent                     indicate if this transaction was done manually because
 *                                          prior swipe attempts have failed. <br>
 *                                          true - if card is present <br>
 *                                          false - if card is not present
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
                    andProducts:(NSArray * _Nullable)products
                        andCard:(IMSCard * _Nonnull)card
                     andClerkID:(NSString * _Nullable)clerkID
                   andLongitude:(NSString * _Nullable)gpsLong
                    andLatitude:(NSString * _Nullable)gpsLat
          andTransactionGroupID:(NSString * _Nullable)transactionGroupID
           andAuthorizationCode:(NSString * _Nonnull)authorizationCode
      andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
            andTransactionNotes:(NSString * _Nullable)transactionNotes
           andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
             andCustomReference:(NSString * _Nullable)customReference
                 andIsCompleted:(bool) isCompleted
                   andUCIFormat:(IMSUCIFormat) uciFormat
               andIsCardPresent:(bool)isCardPresent;

/*!
 * Constructs a keyed credit force sale transaction request.
 * @param amount                            sale amount
 * @param products                          list of products
 * @param clerkID                           ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                                          The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong                           longitude of the device location
 * @param gpsLat                            latitude of the device location
 * @param transactionGroupID                a unique identifier for a group of transactions, used to link
 *                                          transactions which are related (like split-tender).
 *                                          If not specified in the request, it will be generated and returned in the response.
 *                                          For linked transactions, the value generated from the first response
 *                                          should be submitted with all related transactions.
 * @param authorizationCode                 6 digits authorization code for credit force sale.
 * @param systemTraceAuditNumber            1 to 6 digit systemTraceAuditNumber for credit force sale.
 * @param transactionNotes                  transactionNotes
 * @param merchantInvoiceID                 The invoice id from a third party inventory management tool linked to this transaction.
 *                                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt      true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference                   20 digit merchant order number (optional)
 * @param isCompleted                       indicates whether the transaction is completed,
 *                                          if true the transaction cannot be updated later
 * @param uciFormat                         Format to generate Unique Card Identifier for this transaction. (optional)
 * @param isCardPresent                     indicate if this transaction was done manually because
 *                                          prior swipe attempts have failed. <br>
 *                                          true - if card is present <br>
 *                                          false - if card is not present
 * @param orderNumber                       Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id _Nullable) initWithAmount:(IMSAmount * _Nonnull)amount
                    andProducts:(NSArray * _Nullable)products
                        andCard:(IMSCard * _Nonnull)card
                     andClerkID:(NSString * _Nullable)clerkID
                   andLongitude:(NSString * _Nullable)gpsLong
                    andLatitude:(NSString * _Nullable)gpsLat
          andTransactionGroupID:(NSString * _Nullable)transactionGroupID
           andAuthorizationCode:(NSString * _Nonnull)authorizationCode
      andSystemTraceAuditNumber:(NSInteger)systemTraceAuditNumber
            andTransactionNotes:(NSString * _Nullable)transactionNotes
           andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
             andCustomReference:(NSString * _Nullable)customReference
                 andIsCompleted:(bool) isCompleted
                   andUCIFormat:(IMSUCIFormat) uciFormat
               andIsCardPresent:(bool)isCardPresent
               andOrderNumber:(NSString * _Nullable)orderNumber;
@end
