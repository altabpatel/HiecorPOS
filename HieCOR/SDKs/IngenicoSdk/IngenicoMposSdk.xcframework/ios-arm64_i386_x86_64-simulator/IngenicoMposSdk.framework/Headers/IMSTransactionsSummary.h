/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This object contains information about the summary of all transactions that occurred
 * for the queried date range
 */
@interface IMSTransactionsSummary : NSObject

/*!
 * Total number of transactions included in the summary period
 */
@property (readonly) NSInteger totalNumberOfTransactions;

/*!
 * Net transaction amount in cents for all transactions in the summary period
 */
@property (readonly) long netTransactionAmount;

- (id) initWithTotalNumberOfTransactions:(NSInteger)totalNumberOfTransactions
                 andNetTransactionAmount:(long)netTransactionAmount;

@end

