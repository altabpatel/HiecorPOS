/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSBaseRefundTransactionRequest.h"

/*!
 * This object contains information required for requesting refund for a card sale.
 */

@interface IMSCreditRefundTransactionRequest : IMSBaseRefundTransactionRequest

/*!
 * Constructs a card refund request.
 * @param originalSaleTransactionID id of the credit sale transaction to refund
 * @param amount refund amount
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 */

- (id) initWithOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andAmount:(IMSAmount *)amount andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal;

/*!
 * Constructs a card refund request.
 * @param originalSaleTransactionID id of the credit sale transaction to refund
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 */

- (id) initWithOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal;

/*!
 * Constructs a card refund request.
 * @param originalSaleTransactionID id of the credit sale transaction to refund
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 */

- (id) initWithOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andCustomReference:(NSString *)customReference;

/*!
 * Constructs a card refund request.
 * @param originalSaleTransactionID id of the credit sale transaction to refund
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param transactionNotes transactionNotes
 */
- (id) initWithOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andCustomReference:(NSString *)customReference andTransactionNotes:(NSString *)transactionNotes;

/*!
 * Constructs a card refund request.
 * @param originalSaleTransactionID id of the credit sale transaction to refund
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param transactionNotes transactionNotes
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */
- (id) initWithOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andCustomReference:(NSString *)customReference andTransactionNotes:(NSString *)transactionNotes andOrderNumber:(NSString *)orderNumber;

/*!
 * Constructs a card refund request.
 * @param originalSaleTransactionID id of the credit sale transaction to refund
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param transactionNotes transactionNotes
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id should be part of receipt
 */
- (id) initWithOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andCustomReference:(NSString *)customReference andTransactionNotes:(NSString *)transactionNotes andOrderNumber:(NSString *)orderNumber andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt;


@end
