/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This object contains information about the processor configuration
 * that was done at the time of boarding the merchant.
 */
@interface IMSProcessorInfo : NSObject

/*!
 * Processor Name, if available for the configured processor
 */
@property (readonly) NSString * _Nonnull processorName;

/*!
 * Terminal Id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable terminalId;

/*!
 * Merchant Id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable merchantId;

/*!
 * Api login id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable apiLoginId;

/*!
 * Bank id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable bankId;

/*!
 * Transaction key, if available for the configured processor
 */
@property (readonly) NSString * _Nullable transactionKey;

/*!
 * Auto close, if available for the configured processor
 */
@property (readonly) NSString * _Nullable autoClose;

/*!
 * Group id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable groupId;

/*!
 * Device id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable deviceId;

/*!
 * Licence id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable licenseId;

/*!
 * Site id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable siteId;

/*!
 * Software user id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable softwareUserId;

/*!
 * Profile id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable profileId;

/*!
 * Vendor id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable vendorId;

/*!
 * Unique identifier, if available for the configured processor
 */
@property (readonly) NSString * _Nullable uniqueIdentifier;

/*!
 * Network International identifier, if available for the configured processor
 */
@property (readonly) NSString * _Nullable nii;

/*!
 * Merchant key, if available for the configured processor
 */
@property (readonly) NSString * _Nullable merchantKey;

/*!
 * Authentication code, if available for the configured processor
 */
@property (readonly) NSString * _Nullable authenticationCode;

/*!
 * Password, if available for the configured processor
 */
@property (readonly) NSString * _Nullable password;

/*!
 * PNS number, if available for the configured processor
 */
@property (readonly) NSString * _Nullable pnsNumber;

/*!
 * POS id, if available for the configured processor
 */
@property (readonly) NSString * _Nullable posId;

/*!
 * V number, if available for the configured processor
 */
@property (readonly) NSString * _Nullable vNumber;

- (id _Nullable) initWithProcessorName:(NSString * _Nonnull)processorName
               andTerminalId:(NSString * _Nullable)terminalId
               andMerchantId:(NSString * _Nullable)merchantId
               andApiLoginId:(NSString * _Nullable)apiLoginId
                   andbankId:(NSString * _Nullable)bankId
           andTransactionKey:(NSString * _Nullable)transactionKey
                andAutoClose:(NSString * _Nullable)autoClose
                  andGroupId:(NSString * _Nullable)groupId
                 andDeviceId:(NSString * _Nullable)deviceId
                andLicenseId:(NSString * _Nullable)licenseId
                   andSiteId:(NSString * _Nullable)siteId
           andSoftwareUserId:(NSString * _Nullable)softwareUserId
                andProfileId:(NSString * _Nullable)profileId
                 andVendorId:(NSString * _Nullable)vendorId
         andUniqueIdentifier:(NSString * _Nullable)uniqueIdentifier
                      andNii:(NSString * _Nullable)nii
              andMerchantKey:(NSString * _Nullable)merchantKey
       andAuthenticationCode:(NSString * _Nullable)authenticationCode
                 andPassword:(NSString * _Nullable)password
                andPnsNumber:(NSString * _Nullable)pnsNumber
                    andPosId:(NSString * _Nullable)posId
                  andVNumber:(NSString * _Nullable)vNumber;

@end
