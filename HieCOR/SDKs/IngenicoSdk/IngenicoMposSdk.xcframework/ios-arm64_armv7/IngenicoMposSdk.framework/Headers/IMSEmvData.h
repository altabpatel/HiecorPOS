/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "IMSEmvOfflineData.h"

/*!
 * This object contains EMV tag data
 */
@interface IMSEmvData : NSObject

/*!
 * Application identifier
 */
@property (readonly) NSString *appIdentifier;

/*!
 * Preferred mnemonic associated with the AID
 */
@property (readonly) NSString *appPreferredName;

/*!
 * Mnemonic associated with the AID
 */
@property (readonly) NSString *appLabel;

/*!
 * The type of cryptogram verification performed, can be "AAC" "TC", or "ARQC"
 */
@property (readonly) NSString *cryptogramType;

/*!
 * Returns "PIN Verified" if PIN was collected and verified either locally or online
 */
@property (readonly) NSString *pinStatement;

/*!
 * Offline emv data tags
 */
@property (readonly) IMSEmvOfflineData *emvOfflineData;

-(id) initWithAppIdentifier:(NSString *)appIdentifier
        andAppPreferredName:(NSString *)appPreferredName
                andAppLabel:(NSString *)appLabel
          andCryptogramType:(NSString *)cryptogramType
            andPinStatement:(NSString *)pinStatement
          andEmvOfflineData:(IMSEmvOfflineData *)emvOfflineData;

- (NSDictionary*)toNSDictionary;
@end
