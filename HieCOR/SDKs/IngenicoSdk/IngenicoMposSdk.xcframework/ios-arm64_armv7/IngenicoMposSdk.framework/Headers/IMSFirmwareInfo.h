/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This class contains information about the payment device's firmware
 */
@interface IMSFirmwareInfo : NSObject

/*!
 * The name of the processor profile.
 */
@property (readonly) NSString *processorProfileName;

/*!
 * The version of the processor profile.
 */
@property (readonly) NSString *processorProfileVersion;

/*!
 * The version of the firmware.
 */
@property (readonly) NSString *firmwareVersion;

/*!
 * The description of the firmware.
 */
@property (readonly) NSString *firmwareDescription;

/*!
 * The size of the firmware file in bytes.
 */
@property (readonly) long firmwareFileSize;

- (id) initWithProcessorProfileName:(NSString *)processorProfileName
         andProcessorProfileVersion:(NSString *)processorProfileVersion
                 andFirmwareVersion:(NSString *)firmwareVersion
             andFirmwareDescription:(NSString *)firmwareDescription
                andFirmwareFileSize:(long)firmwareFileSize;

@end
