/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseTransactionRequest.h"
#import "IMSAmount.h"

/*!
 * This base object contains basic information required for a sale transaction.
 */

@interface IMSBaseSaleTransactionRequest : IMSBaseTransactionRequest

/*!
 * The list of products.
 * @see IMSProduct
 */

@property (nonatomic, strong) NSArray *products;

/*!
 * Reference for the Transaction generated by processor.
 */

@property (nonatomic, strong) NSString *transactionGroupID;

/*!
 * Amount being collected.
 * @see IMSAmount
 */

@property (nonatomic, strong) IMSAmount *amount;

/*!
 * Indicates whether the transaction is completed, if true the transaction cannot be updated later
 */

@property (nonatomic) BOOL isCompleted;

/*!
 * Constructs a sale request with mandatory fields that are common for all sale transaction requests.
 * @param type transaction type
 * @param amount sale amount
 * @param products list of products
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionGroupID a unique identifier for a group of transactions, used to link
 *                           transactions which are related (like split-tender).
 *                           If not specified in the request, it will be generated and returned in the response.
 *                           For linked transactions, the value generated from the first response
 *                           should be submitted with all related transactions.
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andIsCompleted:(BOOL)isCompleted;

/*!
 * Constructs a sale request with mandatory fields that are common for all sale transaction requests.
 * @param type transaction type
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
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andIsCompleted:(BOOL)isCompleted;

/*!
 * Constructs a sale request with mandatory fields that are common for all sale transaction requests.
 * @param type transaction type
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
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andIsCompleted:(BOOL)isCompleted;

/*!
 * Constructs a sale request with mandatory fields that are common for all sale transaction requests.
 * @param type transaction type
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
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *)customReference andIsCompleted:(BOOL)isCompleted;

/*!
 * Constructs a sale request with mandatory fields that are common for all sale transaction requests.
 * @param type transaction type
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
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *)customReference andIsCompleted:(BOOL)isCompleted andOrderNumber:(NSString *)orderNumber;

/*!
 * Constructs a sale request with mandatory fields that are common for all sale transaction requests.
 * @param type transaction type
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
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param isCompleted indicates whether the transaction is completed,
 *                    if true the transaction cannot be updated later
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 * @param locale Transaction locale
 */

- (id) initWithType:(IMSTransactionType )type andAmount:(IMSAmount *)amount andProducts:(NSArray *)products andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionGroupID:(NSString *)transactionGroupID andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *)customReference andIsCompleted:(BOOL)isCompleted andOrderNumber:(NSString *)orderNumber andLocale:(NSLocale *)locale;

@end
