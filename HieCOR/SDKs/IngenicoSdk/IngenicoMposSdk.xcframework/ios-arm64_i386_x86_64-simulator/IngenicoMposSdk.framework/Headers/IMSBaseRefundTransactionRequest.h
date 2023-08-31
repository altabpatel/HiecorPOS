/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSRevesalTransactionRequest.h"
#import "IMSAmount.h"

/*!
 * This base object contains basic information required for making a refund.
 */

@interface IMSBaseRefundTransactionRequest : IMSRevesalTransactionRequest

/*!
 * The amount being refunded.
 * @see IMSAmount
 */

@property (nonatomic, strong) IMSAmount *amount;

/*!
 * Constructs a refund request with mandatory fields that are common for all refund transaction requests.
 * @param type transaction type
 * @param originalSaleTransactionID id of the transaction to refund
 * @param amount refund amount
 * @param clerkID ID reference used to associate the transaction with a waiter / clerk / sales associate.
 *                The field can be alphanumeric and length cannot exceed 4 characters.
 * @param gpsLong longitude of the device location
 * @param gpsLal latitude of the device location
 * @param customReference 20 digit merchant order number (optional). Alphanumeric characters and hyphen only. Max length: 20.
 * @param transactionNotes transactionNotes
 * @param orderNumber Optional numeric field up to 9 digits long that indicates the assigned order number
 */
- (id) initWithType:(IMSTransactionType )type andOriginalSaleTransactionID:(NSString *)originalSaleTransactionID andAmount:(IMSAmount *)amount andClerkID:(NSString *)clerkID andLongitude:(NSString *)gpsLong andLatitude:(NSString *)gpsLal andCustomReference:(NSString *)customReference andTransactionNotes:(NSString *)transactionNotes andOrderNumber:(NSString *)orderNumber andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt;

@end
