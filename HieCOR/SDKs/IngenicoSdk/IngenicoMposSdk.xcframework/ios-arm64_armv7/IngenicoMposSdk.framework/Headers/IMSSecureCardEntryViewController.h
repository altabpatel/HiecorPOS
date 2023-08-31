/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "IMSSCECreditSaleTransactionRequest.h"
#import "IMSSCECreditAuthTransactionRequest.h"
#import "IMSSCECreditRefundTransactionRequest.h"
#import "IMSPayment.h"

/*!
 *  Invoked when there has been a progress in the secure card entry transaction.
 *
 *  @param progressMessage progress message
 *  @see RoamProgressMessage
 *  @param extraMessage    extra message if exists
 */

typedef void (^UpdateProgress)(IMSProgressMessage progressMessage, NSString * _Nullable extraMessage);

/*!
 *  Invoked when the secure card entry transaction process is complete.
 *
 *  @param response Response for the secure card entry transaction
 *  @see IMSTransactionResponse
 *  @param error  nil if succeed, otherwise the code indicates the reason
 */

typedef void (^TransactionOnDone)(IMSTransactionResponse * _Nullable response, NSError * _Nullable error);

@interface IMSSecureCardEntryViewController : UIViewController

- (id _Nullable)initWithCreditSaleTransactionRequest:(IMSSCECreditSaleTransactionRequest * _Nonnull)creditSaleTransactionrequest
                         andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                 andOnDone:(TransactionOnDone _Nonnull)handler;

- (id _Nullable)initWithCreditAuthTransactionRequest:(IMSSCECreditAuthTransactionRequest * _Nonnull)creditAuthTransactionrequest
                                   andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                           andOnDone:(TransactionOnDone _Nonnull)handler;

- (id _Nullable)initWithCreditRefundTransactionRequest:(IMSSCECreditRefundTransactionRequest * _Nonnull)creditRefundtransactionrequest
                         andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                 andOnDone:(TransactionOnDone _Nonnull)handler;

@end
