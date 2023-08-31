/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This class contains information about the payment device's firmware package
 */
@interface IMSFirmwarePackageInfo : NSObject

/*!
 * The firmware package name.
 */
@property (readonly) NSString *packageName;

/*!
 * The firmware version info of the device as JSON string.
 */
@property (readonly) NSString *versionInfo;

/*!
 * The list of processor profiles that support this firmware version.
 */
@property (readonly) NSArray *compatibleProcessorProfiles;


- (id) initWithPackageName:(NSString *) packageName
                versionInfo:(NSString *) versionInfo
   compatibleProcessorProfiles:(NSArray *) compatibleProcessorProfiles;

@end

