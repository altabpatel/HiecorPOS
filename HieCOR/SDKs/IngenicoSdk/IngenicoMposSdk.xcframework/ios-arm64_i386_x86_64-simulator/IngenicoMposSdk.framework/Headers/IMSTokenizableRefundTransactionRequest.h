/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseTransactionRequest.h"
#import "IMSTokenRequestParameters.h"

@interface IMSTokenizableRefundTransactionRequest : IMSBaseTransactionRequest

@property (nonatomic, strong) IMSTokenRequestParameters * _Nullable tokenRequestParameters;

/*!
 * Constructs a card refund transaction request.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 */

- (id _Nullable ) initWithType:(IMSTransactionType )type andLongitude:(NSString *_Nullable)gpsLong andLatitude:(NSString *_Nullable)gpsLal;

/*!
 * Constructs a card refund transaction request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 */

- (id _Nullable) initWithType:(IMSTransactionType )type andClerkID:(NSString *_Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString *_Nullable)gpsLal;

/*!
 * Constructs a card refund transaction request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 */

- (id _Nullable) initWithType:(IMSTransactionType )type andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionNotes:(NSString * _Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt;

/*!
 * Constructs a card refund transaction request.
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

- (id _Nullable) initWithType:(IMSTransactionType )type andClerkID:(NSString * _Nullable)clerkID andLongitude:(NSString * _Nullable)gpsLong andLatitude:(NSString * _Nullable)gpsLal andTransactionNotes:(NSString *_Nullable)transactionNotes andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString * _Nullable)customReference;

/*!
 * Constructs a card refund transaction request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param tokenRequestParameters Request to enroll for a token.
 *                               Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional) */

- (id _Nullable) initWithType:(IMSTransactionType )type andClerkID:(NSString *_Nullable)clerkID andLongitude:(NSString *_Nullable)gpsLong andLatitude:(NSString *_Nullable)gpsLal andTransactionNotes:(NSString *_Nullable)transactionNotes andMerchantInvoiceID:(NSString *_Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *_Nullable)customReference andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters;

/*!
 * Constructs a card refund transaction request.
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param transactionNotes transactionNotes
 * @param merchantInvoiceID The invoice id from a third party inventory management tool linked to this transaction.
 *                          Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param tokenRequestParameters Request to enroll for a token.
 *                               Use (@see IMSTokenRequestParametersBuilder) to construct token request parameters. (optional)
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */

- (id _Nullable) initWithType:(IMSTransactionType )type andClerkID:(NSString *_Nullable)clerkID andLongitude:(NSString *_Nullable)gpsLong andLatitude:(NSString *_Nullable)gpsLal andTransactionNotes:(NSString *_Nullable)transactionNotes andMerchantInvoiceID:(NSString *_Nullable)merchantInvoiceID andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt andCustomReference:(NSString *_Nullable)customReference andTokenRequestParameters:(IMSTokenRequestParameters * _Nullable)tokenRequestParameters andOrderNumber:(NSString * _Nullable)orderNumber;
@end
