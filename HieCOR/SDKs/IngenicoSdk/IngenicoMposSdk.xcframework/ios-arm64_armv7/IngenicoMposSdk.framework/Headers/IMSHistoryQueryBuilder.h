/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSEnum.h"
#import <Foundation/Foundation.h>

@class IMSHistoryQuery;

/*!
 * This class can be used to build a transaction query (@see IMSHistoryQuery) to retrieve
 * history.
 */
@interface IMSHistoryQueryBuilder : NSObject

@property (nonatomic, strong) NSArray *transactionTypes;
@property (nonatomic) int pastDays;
@property (nonatomic) int pageSize;
@property (nonatomic) int pageNumber;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *clerkId;
@property (nonatomic, strong) NSString *invoiceId;
@property (nonatomic, strong) NSArray *transactionStatuses;
@property (nonatomic, strong) NSArray *optionalFields;
@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *transactionGuid;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *cardHolderName;
@property (nonatomic, strong) NSString *customerEmail;
@property (nonatomic) int authAmountInCents;
@property (nonatomic, strong) NSString *lastFourDigitsOfCard;
@property (nonatomic) int invoiceAmountInCents;
@property (nonatomic, strong) NSString *transactionNote;
@property (nonatomic, strong) NSArray *cardTypes;
@property (nonatomic, strong) NSString *merchantInvoiceID;
@property (nonatomic, strong) NSString *transactedBy;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSArray *posEntrySources;
@property (nonatomic) BOOL includeSubmerchantTransactions;
@property (nonatomic, strong) NSString *batchNumber;
@property (nonatomic, strong) NSString *orderNumber;
/*!
 * Builds and returns the history query.
 * @return (@see IMSHistoryQuery) object
 */
- (IMSHistoryQuery *)createQueryCriteria;

@end
