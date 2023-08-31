/*
* //////////////////////////////////////////////////////////////////////////////
* //
* // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
* //
* //////////////////////////////////////////////////////////////////////////////
*/

#import <Foundation/Foundation.h>
#import "IMSEnum.h"
/**
* This immutable class contains information about the current SDK capabilities.
*/
@interface IMSCapabilities : NSObject
/*!
 * Returns if the SDK is store and forward capable for the current user.
 * @return true  - if capable
 *         false - otherwise
 */
@property (readonly) bool storeAndForwardCapable;

/*!
 * Returns if the SDK is EMV capable
 * @return true  - if capable
 *         false - otherwise
 */
@property (readonly) bool EMVCapable;

/*!
 * Returns the firmware update action
 * @return IMSFirmwareUpdateAction
 */
@property (readonly) IMSFirmwareUpdateAction firmwareUpdateAction;

/*!
 * Indicates if the EMV configuration of the connected payment device is up to date with the latest configuration on the Ingenico One backend.
 * Unlike checkDeviceSetup() where the response (isSetupRequired = true) will revert the device to MSR only thus mandating a device setup,
 * this flag can be considered as a soft error which indicates that device setup is recommended without affecting the EMV capability of the reader.
 * It is recommended to check this flag after login/refreshUserSession and do a device setup if this method returns false.
 * @return true  - up to date
 *         false - out of date
 */
@property (readonly) bool isEMVConfigUptoDate;

- (id)  initWithStoreAndForwardCapable:(bool)storeAndForwardCapable EMVCapable:(bool)EMVCapable FirmwareUpdateOption:(IMSFirmwareUpdateAction)firmwareUpdateAction AndisEMVConfigUptoDate:(bool)deviceSetupRecommended;

@end

