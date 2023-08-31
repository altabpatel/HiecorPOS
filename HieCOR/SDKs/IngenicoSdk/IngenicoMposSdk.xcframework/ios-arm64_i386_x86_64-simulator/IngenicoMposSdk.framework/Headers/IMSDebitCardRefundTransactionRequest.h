/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseTransactionRequest.h"
#import "IMSAmount.h"

@interface IMSDebitCardRefundTransactionRequest: IMSBaseTransactionRequest

/*!
 * Amount being collected.
 * @see IMSAmount
 */

@property (nonatomic, strong) IMSAmount *amount;

/*!
 * Format to generate Unique Card Identifier for this transaction. (optional)
 */

@property (nonatomic) IMSUCIFormat uciFormat;

/*!
 * Constructs a card refund transaction request.
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 */

- (id) initWithAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal;

/*!
 * Constructs a card refund transaction request.
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 */

- (id) initWithAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt;

/*!
 * Constructs a card refund transaction request.
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 */

- (id) initWithAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *)customReference;

/*!
 * Constructs a card refund transaction request.
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 */

- (id) initWithAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *)customReference andUCIFormat:(IMSUCIFormat) uciFormat;

/*!
 * Constructs a card refund transaction request.
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param uciFormat Format to generate Unique Card Identifier for this transaction. (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id) initWithAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andTransactionNotes:(NSString *)transactionNotes andMerchantInvoiceID:(NSString *)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *)customReference andUCIFormat:(IMSUCIFormat) uciFormat andOrderNumber:(NSString *) orderNumber;

@end
