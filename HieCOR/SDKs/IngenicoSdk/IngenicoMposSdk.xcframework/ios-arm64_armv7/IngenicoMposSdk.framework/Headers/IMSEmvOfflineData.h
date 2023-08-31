/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/**
 * This object contains offline emv tag data
 */
@interface IMSEmvOfflineData : NSObject

/*!
 * Application interchange profile
 */
@property (readonly) NSString *aip;

/*!
 * Application cryptogram
 */
@property (readonly) NSString *appCryptogram;

/*!
 * Authorisation Response Code
 */
@property (readonly) NSString *arc;

/*!
 * Application Transaction Counter
 */
@property (readonly) NSString *atc;

/*!
 * Application Usage Control
 */
@property (readonly) NSString *auc;

/*!
 * Cryptogram Information Data
 */
@property (readonly) NSString *cid;

/*!
 * The results of the last CVM performed
 */
@property (readonly) NSString *cvmResults;

/*!
 * Issuer Action Code – Default
 */
@property (readonly) NSString *iacDefault;

/*!
 * Issuer Action Code – Denial
 */
@property (readonly) NSString *iacDenial;

/*!
 * Issuer Action Code – Online
 */
@property (readonly) NSString *iacOnline;

/*!
 * Issuer Application Data
 */
@property (readonly) NSString *iad;

/*!
 * Merchant Identifier
 */
@property (readonly) NSString *mid;

/*!
 * Application Primary Account Number (PAN) Sequence Number
 */
@property (readonly) NSString *panSeqNum;

/*!
 * VISA rewards program name
 */
@property (readonly) NSString *rewards;

/*!
 * Terminal Action Code – Default
 */
@property (readonly) NSString *tacDefault;

/*!
 * Terminal Action Code – Denial
 */
@property (readonly) NSString *tacDenial;

/*!
 * Terminal Action Code – Online
 */
@property (readonly) NSString *tacOnline;

/*!
 * Terminal Country Code
 */
@property (readonly) NSString *tcc;

/*!
 * Terminal Identification
 */
@property (readonly) NSString *tid;

/*!
 * Transaction Currency Code
 */
@property (readonly) NSString *trnCurrencyCode;

/*!
 * Retrieval reference number returned by the processor
 */
@property (readonly) NSString *trnRef;

/*!
 * Transaction Status Information
 */
@property (readonly) NSString *tsi;

/*!
 * Terminal Verification Results
 */
@property (readonly) NSString *tvr;

/*!
 * Unpredictable Number
 */
@property (readonly) NSString *upn;

/*!
 * Validation code returned by the processor
 */
@property (readonly) NSString *valCode;

/*!
 * EMV response code sent to the card
 */
@property (readonly) NSString *declineCode;

/*!
 * Is either "DECLINED BY ISSUER" or "DECLINED BY CARD" for declined transactions, depending on where it was declined
 */
@property (readonly) NSString *declineStatement;

/*!
 * AVS response code
 */
@property (readonly) NSString *avsResults;

- (id) initWithAip:(NSString *)aip
  andAppCryptogram:(NSString *)appCryptogram
            andArc:(NSString *)arc
            andAtc:(NSString *)atc
            andAuc:(NSString *)auc
            andCid:(NSString *)cid
     andCvmResults:(NSString *)cvmResults
     andIacDefault:(NSString *)iacDefault
      andIacDenial:(NSString *)iacDenial
      andIacOnline:(NSString *)iacOnline
            andIad:(NSString *)iad
            andMid:(NSString *)mid
      andPanSeqNum:(NSString *)panSeqNum
        andRewards:(NSString *)rewards
     andTacDefault:(NSString *)tacDefault
      andTacDenial:(NSString *)tacDenial
      andtacOnline:(NSString *)tacOnline
            andTcc:(NSString *)tcc
            andTid:(NSString *)tid
andTrnCurrencyCode:(NSString *)trnCurrencyCode
         andTrnRef:(NSString *)trnRef
            andTsi:(NSString *)tsi
            andTvr:(NSString *)tvr
            andUpn:(NSString *)upn
        andValCode:(NSString *)valCode
    andDeclineCode:(NSString *)declineCode
andDeclineStatement:(NSString *)declineStatement
     andAvsResults:(NSString *)avsResults;

- (NSDictionary*)toNSDictionary;
@end
