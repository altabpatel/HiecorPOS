/*
* //////////////////////////////////////////////////////////////////////////////
* //
* // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
* //
* //////////////////////////////////////////////////////////////////////////////
*/
 
#import <RUA_MFI/RUA.h>
#import "IMSEnum.h"

#ifndef DeviceStatusAndEMVConfigurationHandler_h
#define DeviceStatusAndEMVConfigurationHandler_h

/*
 * Callback to be invoked to let mPOS EMV SDK know if it can proceed with the action it needs user intervention
 */
typedef void (^UserActionHandler)(bool canContinue);

@protocol DeviceStatusAndEMVConfigurationHandler <RUADeviceStatusHandler>

/*
 * Invoked when SDK cannot automatically proceed with device setup and requires external input. Can happen when ConfigMode is Manual.
 * @param handler  user action response callback
 */
- (void)performSetup:(UserActionHandler)handler;

/*
 * Invoked when SDK cannot automatically proceed with firmware update and requires external input. Can happen when ConfigMode is Manual/Optimal.
 * @param action  firmware update action
 * @param handler  user action response callback
 */
- (void)performFirmwareUpdate:(IMSFirmwareUpdateAction)action andUserActionHandler:(UserActionHandler)handler;

/*
 * Invoked when mPOS EMV SDK has completed its implicit configuration process to be EMV capable
 *
 * @param error  nil if succeed, otherwise the code indicates the reason
 * @param capabilities  current SDK capabilities
 */
- (void)onConfigured:(NSError *)error andCapabilities:(IMSCapabilities *)capabilities;

/*
 * Invoked when there is progress in the implicit configuration process
 * @param progressMessage  progress message
 * @param additionalMessage  additional message that indicates current progress during the firmware update/device set up progress, E.g., 10/20
 */
- (void)onProgress:(IMSProgressMessage)message andAdditionalMessage:(NSString *_Nullable)additionalMessage;

@end

#endif /* DeviceStatusAndEMVConfigurationHandler_h */
