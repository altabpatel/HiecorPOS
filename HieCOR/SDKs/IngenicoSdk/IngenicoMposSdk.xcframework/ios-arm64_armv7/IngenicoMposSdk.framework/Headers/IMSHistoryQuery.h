/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "IMSEnum.h"
#import "IMSHistoryQueryBuilder.h"

@class IMSHistoryQueryBuilder;

/*!
 * This immutable class is used to query for a list of processed transactions.
 * Use @see IMSTransactionQueryBuilder to define the query.
 */
@interface IMSHistoryQuery : NSObject

/*!
 * Filters the transactions based on the list of transaction types.
 * If nothing is specified all types will be returned.
 */
@property (readonly) NSArray *transactionTypes;

/*!
 * Fetches transactions which are as old as this value. Must be greater than 0.
 * <i>Note:</i> If start date, end date and past days are all set, then past days will
 * have precedence over start/end dates.
 */
@property (readonly) int pastDays;

/*!
 * Indicates number of transactions per page.<br>
 * <b>Important: </b> Max size = 100, if the page size is greater than the max size
 * then by default 50 records will be returned.
 */
@property (readonly) int pageSize;

/*!
 * Indicates the page from which the transactions are retrieved.
 */
@property (readonly) int pageNumber;

/*!
 * Fetches transactions beginning from this date.
 */
@property (readonly) NSString *startDate;

/*!
 * Fetches transactions until this date.
 */
@property (readonly) NSString *endDate;

/*!
 * Filters the transactions based on this clerk id.
 */
@property (readonly) NSString *clerkId;

/*!
 * Filters the transactions based on this invoice id.
 */
@property (readonly) NSString *invoiceId;

/*!
 * Filters the transactions based on the list of transaction statuses.
 * If nothing is specified all statuses will be returned.
 */
@property (readonly) NSArray *transactionStatuses;

/*!
 * Returns data for the provided optional fields. @see IMSOptionalTransactionHistoryField
 */
@property (readonly) NSArray *optionalFields;

/*!
 * Filters the transactions based on this transaction id.
 */
@property (readonly) NSString *transactionID;

/*!
 * Filters the transactions based on this transaction guid.
 */
@property (readonly) NSString *transactionGuid;

/*!
 * Filters the transactions based on this customer name.
 */
@property (readonly) NSString *customerName;

/*!
 * Filters the transactions based on the name of the card holder.
 */
@property (readonly) NSString *cardHolderName;

/*!
 * Filters the transactions based on this customers email address.
 */
@property (readonly) NSString *customerEmail;


/*!
 * Filters the transactions based on this authorized amount specified in cents.
 */
@property (readonly) int authAmountInCents;

/*!
 * Filters the transactions based on the last four digits of the card used.
 */
@property (readonly) NSString *lastFourDigitsOfCard;

/*!
 * Filters the transactions based on the invoice amount specified in cents.
 */
@property (readonly) int invoiceAmountInCents;

/*!
 * Filters the transactions based on this transaction note.
 */
@property (readonly) NSString *transactionNote;

/*!
 * Filters the transactions based on the list of card types.
 * If nothing is specified, transactions with all different card types will be returned.
 */
@property (readonly) NSArray *cardTypes;

/*!
 * Filters the transactions based on this merchant invoice ID.
 * Alphanumeric characters only. Max length: 15 chars
 */
@property (readonly) NSString *merchantInvoiceID;

/*!
 * Filters the transactions based on the the ID of the session user who initiates the transaction.
 */
@property (readonly) NSString *transactedBy;

/*!
 * Filters the transactions based on this auth code.
 */
@property (readonly) NSString *authCode;

/*!
 * Filters the transactions based on the list of payment sources.
 * If nothing is specified, transactions with all kinds of payment sources will be returned.
 */
@property (readonly) NSArray *posEntrySources;

/*!
 * Returns whether or not the query response will also include submerchant transactions.
 */
@property (readonly) BOOL includeSubmerchantTransactions;

/*!
 * Filters the transactions based on this batchNumber.
 */
@property (readonly) NSString *batchNumber;

/*!
 * Filters the transactions based on this orderNumber.
 */
@property (readonly) NSString *orderNumber;

- (id) initWithBuilder:(IMSHistoryQueryBuilder *)builder;

@end
