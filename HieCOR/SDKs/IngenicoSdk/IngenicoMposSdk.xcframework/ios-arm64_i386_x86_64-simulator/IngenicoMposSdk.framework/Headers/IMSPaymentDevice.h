/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "Ingenico.h"

/*!
 *  Handler to be invoked after the device setup request is processed.
 *  @param current current step of the set up process
 *  @param total   total number of steps in the setup process
 */

typedef void (^SetupProgressHandler)(NSInteger current, NSInteger total);

/*!
 *  Handler to be invoked after the device setup request is processed.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^SetupHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after receiving the card reader's serial number.
 *  @param serialNumber    serial number of connected device
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^GetDeviceSerialNumberHandler)(NSString * _Nullable serialNumber,NSError * _Nullable error);

/*!
 *  Hanlder to be invoked after receiving the card reader's battery level.
 *  @param batteryLevel    battery level of connected device
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^BatteryLevelHanlder)(NSInteger batteryLevel, NSError * _Nullable error);

/*!
 *  Hanlder to be invoked after the card is removed from card reader or the timeout expires.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^WaitForCardRemovalHanlder)(NSError * _Nullable error);

/*!
 *  Hanlder to be invoked after checking if there is firmware update is available.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param action    enum indicating if there is a firmware update available or not
 *  @param firmwareInfo    contains information about the firmware
 */

typedef void (^CheckFirmwareUpdateHanlder)(NSError * _Nullable error, IMSFirmwareUpdateAction action,IMSFirmwareInfo * _Nullable firmwareInfo);

/*!
 *  Invoked when there has been a progress in the firmware download.
 *
 *  @param downloadedSize  bytes downloaded
 *  @param totalFileSize    total file size
 */

typedef void (^FirmwareDownloadProgress)(long downloadedSize,long totalFileSize);

/*!
 *  Invoked when there has been a progress in the firmware update.
 *
 *  @param current current step of the firmware update process
 *  @param total   total number of steps in the firmware update process
 */

typedef void (^FirmwareUpdateProgress)(NSInteger current, NSInteger total);

/*!
 *  Hanlder to be invoked when the firmware update process is finished.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^FirmwareUpdateHandler)(NSError * _Nullable error);

/*!
 *  Hanlder to be invoked after checking if device setup is available.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param isSetupRequired    true if device setup is required, false otherwise
 */

typedef void (^CheckDeviceSetupHandler)(NSError * _Nullable error,bool isSetupRequired);

/*!
 *  Hanlder to be invoked when the configure beep is finished.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^ConfigureBeepHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked after decrypting the magnetica card data.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param decryptedTrackData    decryptedTrackData if exists
 */
typedef void (^ReadMagneticCardDataHanlder) (NSString * _Nullable decryptedTrackData, NSError * _Nullable error);

/*!
 *  Hanlder to be invoked when the configure idle shutdown timeout is finished.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^ConfigureIdleShutdownTimeoutHandler)(NSError * _Nullable error);

/*!
 *  Hanlder to be invoked after display text is processed by the payment device
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^DisplayTextHandler)(NSError * _Nullable error);

/*!
 *  Hanlder to be invoked after the home screen is displayed by the payment device
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^ShowHomeScreenHandler)(NSError * _Nullable error);

/*!
 *  Hanlder to be invoked after tip amount is collected on the reader
 *  @param error    nil if success, otherwise the code indicates the reason <br>
 *                  Returns TipEntryAborted(6014), if tip entry is aborted on the reader. <br>
 *                  Returns InvalidAmount(4990), if tip entered is outside the valid range.
 *  @param tipAmount    Tip amount in cents. (0 - 999999999) <br>
 *                      Returns 0 for failure.
 */

typedef void (^RetrieveTipAmountHandler)(NSError * _Nullable error, NSInteger tipAmount);

/*!
 *  Hanlder to be invoked after configure application selection is finished
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^ConfigureApplicationSelectionHandler)(NSError * _Nullable error);

/*!
 *  Hanlder to be invoked when reset device command is sent to the payment device
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^ResetDeviceHandler)(NSError * _Nullable error);

/*!
 *  Hanlder to be invoked after get firmware package info is finished
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param firmwarePackageInfo    firmware package information of the connected device.
 *                                Returns nil for failure.
 */
typedef void (^GetFirmwarePackageInfoHandler) (NSError * _Nullable error, IMSFirmwarePackageInfo * _Nullable firmwarePackageInfo);

/*!
 *  Hanlder to be invoked after receiving the card reader's battery level as well as charging status.
 *  @param batteryLevel    battery level of connected device
 *  @param isCharging    indicates if the device is being charged
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */
typedef void (^BatteryLevelWithChargingStatusHanlder)(NSInteger batteryLevel, bool isCharging, NSError * _Nullable error);

/*!
*   Hanlder to be invoked after user has selected a menu option from the custom menu options.
*   @param menuOptionSelected    The custom menu option selected, starting with an index of 1
*                                Returns -1 for failure when there is error.
*   @param error    nil if succeed, otherwise the code indicates the reason.
*                   Returns CustomMenuSelectionAborted(6018), if menu selection is aborted on the reader.
*                   Returns InvalidParameters(6017), if no menu options are given.
*/
typedef void (^ShowMenuOptionsHandler)(NSError * _Nullable error, NSInteger menuOptionSelected);

/*!
*   Hanlder to be invoked after receiving device log from the card reader.
*   @param error       nil if succeed, otherwise the code indicates the reason
*   @param deviceLog   device log retrieved from the card reader, returns nil if there is no device log
*/
typedef void (^RetrieveDeviceLogHandler)(NSError * _Nullable error, NSString * _Nullable deviceLog);

/*!
*   Hanlder to be invoked when there is a progress in retrieving device log.
*   @param progressMessage      progress message
*   @param extraMessage         extra message if exists
*/
typedef void (^RetrieveDeviceLogProgressHandler)(IMSProgressMessage progressMessage, NSString * _Nullable extraMessage);

/*!
*   Hanlder to be invoked after enabling device logging.
*   @param error       nil if succeed, otherwise the code indicates the reason
*/
typedef void (^EnableDeviceLoggingHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked when the E2E key selection is finished.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */

typedef void (^SelectE2EKeyHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked when the card details are returned.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 *  @param cardDetails card details, nil if there is an error
 */
typedef void (^GetCardDetailsHandler)(NSError * _Nullable error, IMSCardDetails * _Nullable cardDetails);

/*!
 *  Handler to be invoked when setVasMerchant is finished.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */
typedef void (^SetVasMerchantHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked when updateWorkingKeys is finished.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */
typedef void (^UpdateWorkingKeysHandler)(NSError * _Nullable error);

/*!
 *  Handler to be invoked when setBrightnessLevel is finished.
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */
typedef void (^SetBrightnessLevelHandler)(NSError * _Nullable error);

/*!
 *  This class contains methods to handle device setup, device communication
 *  and device status.
 */

@interface IMSPaymentDevice : NSObject

/*!
 *  Sets the supported device type.
 *  <b>Note:</b> Starting v3.1.0 this API no longer supports G4x and RP350x device types. If used, PaymentDevice.initialize() method will result in RUADeviceStatusHandler.onError() to be called back.
 *  @param deviceType device type
 */

- (void) setDeviceType:(RUADeviceType) deviceType;

/*!
 *  Sets the list of supported audio jack device types.
 *  <b>Note:</b> Starting v3.1.0 this API no longer supports G4x and RP350x device types. If the list contains only G4x and RP350x, PaymentDevice.initialize() method will result in RUADeviceStatusHandler.onError() to be called back.
 *
 *  @param deviceList list of audio jack device types
 */

- (void) setDeviceTypes:(NSArray * _Nonnull)deviceList;

/*!
 *  Searches for available bluetooth devices.
 *
 *  @param searchListener search listener
 */

- (void)search:(id <RUADeviceSearchListener>  _Nonnull)searchListener;

/*!
 *  Searches for available bluetooth devices for duration.
 *
 *  @param duration duration of the bluetooth discovery in milliseconds
 *  @param searchListener search listener
 */

- (void)searchForDuration:(long)duration andListener:(id <RUADeviceSearchListener>  _Nonnull)searchListener;

/*!
 * Searches for available devices based on the list of communication interfaces.
 * Eg: If commInterfaces contains Bluetooth, only Bluetooth devices are returned.
 *
 * @param duration             duration of the bluetooth discovery in milliseconds.
 *                             Applicable only if communicationTypes contain Bluetooth
 * @param commInterfaces       list of communication interfaces based on which the search will be performed.
 *                             {@see RUACommunicationInterface}
 *                             Note: If a particular device type does not support a communication type.
 *                             Important: USB interface is not supported
 *                             it will not be part of search results even if its present in this list.
 * @param searchListener       RUA SearchListener object
 */
- (void)searchForCommunicationInterfaces:(NSArray * _Nonnull)commInterfaces andDuration:(long)duration andListener:(id <RUADeviceSearchListener>  _Nonnull)searchListener;

/*!
 *  Stops searching for bluetooth devices.
 */

- (void)stopSearch;

/*!
 *  Sets up the connection with the selected bluetooth device.
 *
 *  @param device Device object
 */

- (void)select:(RUADevice * _Nonnull)device;

/*!
 *  Initializes the SDK to work with the device types specified.
 *  Also sets up a DeviceStatusHandler to handle the device connection status.
 *
 *  @param deivceStatusHanlder device status handler
 */

- (void)initialize:(id<RUADeviceStatusHandler> _Nonnull) deivceStatusHanlder;

/*!
 *  Gets the connected payment device's serial number
 *
 *  @param hanlder The callback used to indicate that the
 *                 get serial number request has been processed.
 */

- (void)getDeviceSerialNumber:(GetDeviceSerialNumberHandler _Nonnull)hanlder;

/*!
 *  Returns the type of the connected device.
 */

- (RUADeviceType)getType;

/*!
 *  Get battery level of the connected device
 *
 *  @param handler The callback used to indicate that the
 *                 get battery level request has been processed.
 */

- (void)getDeviceBatteryLevel:(BatteryLevelHanlder _Nonnull)handler;

/*!
 *  Sets up the card reader with public keys and Application identifiers based 
 *  on the response of checkDeviceSetup.
 *
 *  @param setupHandler The callback used to indicate that the
 *                      the device setup request has been processed.
 */

- (void)setup:(SetupHandler _Nonnull)setupHandler;

/*!
 *  Sets up the card reader with public keys and Application identifiers based
 *  on the response of checkDeviceSetup.
 *
 *  @param progressHandler    progress handler
 *  @param setupHandler The callback used to indicate that the
 *                      the device setup request has been processed.
 */

- (void)setupWithProgressHandler:(SetupProgressHandler _Nonnull)progressHandler
                       andOnDone:(SetupHandler _Nonnull)setupHandler;

/*!
 * Asynchronous method that will start the process of pairing with
 * a Bluetooth card reader via AudioJack or USB.
 * Currently only supported by the RP450c and Moby8500 devices.
 *
 * @param pairListener device pairing listener
 * @see RUAPairingListener
 */
- (void)requestPairing:(id <RUAPairingListener>  _Nonnull) pairListener;

/*!
 *  Get allowed pos entry modes of the connected device
 *
 *  @return list of allowed pos entry modes of the connected device.
 */
- (NSArray * _Nullable)allowedPOSEntryModes;

/*!
 * Releases all the card reader resources.
 * Calls RUA RUADeviceStatusHandler onDisconnected() when complete.
 */
- (void)releaseDevice;

/*!
 * Releases all the card reader resources.
 * Calls RUA RUAReleaseHandler done() when complete.
 */
- (void)releaseDevice:(id <RUAReleaseHandler> _Nonnull)releaseHandler;

/*!
 * Asynchronous method that will make the card reader wait until the card is fully 
 * removed or if the timeout expires before returning a response
 *
 * @param cardRemovalTimeout timeout period for card removal in seconds.<br> Range 1 - 65 <br> 0 - indefinite wait
 * @param handler The callback used to indicate that the card is removed from card reader or the timeout expires.
 */
- (void)waitForCardRemoval:(NSInteger)cardRemovalTimeout andOnDone:(WaitForCardRemovalHanlder _Nonnull)handler;

/*!
 *  Indicates the connection status of the device
 *
 *  @return True - if it is connected, 
 *          False - otherwise
 */
-(bool)isConnected;

/*!
 * Asynchronous method that will remotely turn on the device connected via audio jack.
 * Ensure that an audio jack device is plugged in before invoking this method.
 *
 * @param turnOnDeviceCallback The callback used to return the result if the device was successfully turned on or not.
 * @see RUATurnOnDeviceCallback
 */
- (void)turnOnDeviceViaAudioJack:(id <RUATurnOnDeviceCallback>  _Nonnull) turnOnDeviceCallback;

/*!
 * Asynchronous method that will check if the card reader requires a firmware update or not.
 *
 * @param checkFirmwareUpdateHandler The callback used to provide the result if firmware update is required
 */
- (void)checkFirmwareUpdate:(CheckFirmwareUpdateHanlder _Nonnull)checkFirmwareUpdateHandler;

/*!
 * Asynchronous method that will update the firmware of the connected reader to the provided version
 *
 * @param firmwareDownloadProgress Indicates the download progress
 * @param firmwareUpdateProgress Indicates the update progress
 * @param handler The callback used to provide the result of the firmware update
 */
- (void)updateFirmwareWithDownloadProgress:(FirmwareDownloadProgress _Nonnull)firmwareDownloadProgress
                           andFirmwareUpdateProgress:(FirmwareUpdateProgress _Nonnull)firmwareUpdateProgress
                                           andOnDone:(FirmwareUpdateHandler _Nonnull)handler;

/*!
 * Asynchronous method that will check if connected device is required to be setup before processing transactions.
 *
 * @param checkDeviceSetupHandler The callback used to provide the result if setup is required
 */
- (void)checkDeviceSetup:(CheckDeviceSetupHandler _Nonnull)checkDeviceSetupHandler;

/**
 * Returns the active communication type of connected device.
 * E.g RP450c that is plugged in via audio jack and can have active bluetooth connection.
 * @return {@see RUACommunicationInterface}
 */
- (RUACommunicationInterface)getActiveCommunicationType;

/*!
 * Asynchronous method that will configure the card reader beeps
 *
 * @param disableCardRemovalBeep                 indicates whether the reader should disable beep when card is ready to be removed
 * @param disableCardPresentmentBeep             indicates whether the reader should disable beep when reader is ready for card to be presented (Insert / Swipe / Tap)
 * @param handler                                callback used to provide the result of the configure beep
 */
- (void)configureCardRemovalBeep:(bool)disableCardRemovalBeep
          andCardPresentmentBeep:(bool)disableCardPresentmentBeep
                       andOnDone:(ConfigureBeepHandler _Nonnull)handler;

/*!
 * Reads magnetic card data from the connected card reader and returns the decrypted track data.
 *
 * @param handler            The callback used to indicate that the
 *                           readMagneticCardData request has been processed
 */
- (void)readMagneticCardData:(ReadMagneticCardDataHanlder _Nonnull)handler;

/*!
 * Reads magnetic card data from the connected card reader and returns the decrypted track data.
 * Also displays the amount total on the display of the connected card reader.
 * Will result in NotSupportedByPaymentDevice if the connected card reader does not have a display.
 *
 * @param amount             amount to display. The value of total field in IMSAmount will be displayed
 * @param handler            The callback used to indicate that the
 *                           readMagneticCardData request has been processed
 */
- (void)readMagneticCardDataWithAmountDisplay:(IMSAmount * _Nonnull)amount andOnDone:(ReadMagneticCardDataHanlder _Nonnull)handler;

/*!
 * Aborts read magnetic card data.
 * Note: Abort can happen only when card reader is waiting for swipe
 */
- (void)abortReadMagneticCardData;

/*!
 * Asynchronous method that will configure the duration that the device remains active before shutting down.
 * <b>Note:</b> This API is not supported for audiojack only devices i.e. G4x, RP350x
 *
 * @param idleShutdownTimeoutInSeconds timeout period in seconds.<br> Range 180 - 1800 <br>
 * @param handler The callback used to indicate that configuration was completed.
 */
- (void)configureIdleShutdownTimeout:(NSInteger)idleShutdownTimeoutInSeconds andOnDone:(ConfigureIdleShutdownTimeoutHandler _Nonnull)handler;

/*!
 * Asynchronous method that displays the text on the payment device.
 * Note: The currently supported devices with LCD display are RP750 and MOBY/8500.
 * RP750 supports displaying characters upto 4 lines and 21 characters in each line.
 * Moby8500 supports displaying characters upto 3 lines and 21 characters in each line.
 *
 * @param row integer representing the row where the text needs to be displayed.
 * @param column integer representing the column where the text needs to be displayed.
 * @param text text that needs to be displayed. For RP750 and MOBY/8500, if text is more than 21 characters then it will wrap to the second row.
 * @param displayTextHandler The callback used to indicate that text is displayed.
 */
- (void)displayText:(NSString *_Nonnull)text atRow:(NSInteger)row andColumn:(NSInteger)column andOnDone:(DisplayTextHandler _Nonnull)displayTextHandler;

/*!
 * Asynchronous method that shows the home screen on the payment device.
 *
 * @param showHomeScreenHandler The callback used to indicate that display is cleared.
 */
- (void)showHomeScreen:(ShowHomeScreenHandler _Nonnull)showHomeScreenHandler;

/*!
 * Asynchronous method that configures application selection on the card reader.
 * Note: The currently supported devices with pin pad are RP750 and MOBY/8500.
 *
 * @param option The enum value IMSApplicationSelectionOption.
 * @param handler The callback used to indicate that configuration was completed.
 *
 * @see IMSApplicationSelectionOption
 * @see ConfigureApplicationSelectionHandler
 */
- (void)configureApplicationSelection:(IMSApplicationSelectionOption) option
                            andOnDone:(ConfigureApplicationSelectionHandler _Nonnull) handler;

/*!
 * Asynchronous method that lets tip entry on the reader.
 * Note: The currently supported devices with pin pad are RP750 and MOBY/8500.
 * @param retrieveTipAmountHandler The callback used to provide the result of tip entry.
 *
 * @see RetrieveTipAmountHandler
 */
- (void)retrieveTipAmount:(RetrieveTipAmountHandler _Nonnull)retrieveTipAmountHandler;

/*!
 * Synchronous method that will cancel the firmware update process and force the reader to exit the firmware update mode
 */
- (void)cancelFirmwareUpdate;

/*!
 * Asynchronous method that resets the payment device.
 *
 * @param resetDeviceHandler The callback used to indicate that reset device command is sent to the payment device
 */
- (void)resetDevice:(ResetDeviceHandler _Nonnull)resetDeviceHandler;

/*!
 * Asynchronous method that retrieves firmware package information of the connected device.
 * @param getFirmwarePackageInfoHandler The callback used to provide the firmware package info.
 *
 * @see GetFirmwarePackageInfoHandler
 */
- (void) getFirmwarePackageInfo:(GetFirmwarePackageInfoHandler _Nonnull) getFirmwarePackageInfoHandler;

/*!
 *  Initializes the SDK to work with MOBY5500. This method will also attempt to pair only if the device is unpaired.
 *  Handle LED pairing for Moby5500
 *  Also sets up a DeviceStatusHandler to handle the device connection status.
 *
 *  @param deviceStatusHandler device status handler
 *  @param ledPairingListener LED pairing callback
 */
- (void)initialize:(id<RUADeviceStatusHandler>_Nonnull) deviceStatusHandler ledPairingListener:(id<RUAPairingListener>_Nonnull) ledPairingListener;

/*!
 *  Get battery level of the connected device as well as an indicator of whether the device is being charged or not.
 *  When device is being charged, the battery level returned will be -1.
 *  Note: This API works with reader that has 8.18 firmware version and above.
 *  @param handler The callback used to indicate that the
 *                 get battery level request has been processed.
 */

- (void)getDeviceBatteryLevelWithChargingStatus:(BatteryLevelWithChargingStatusHanlder _Nonnull)handler;

/*
 *  This method displays a custom menu screen and allows the user to select an option.
 *
 *  @param menuTitle             title for the custom menu screen
 *  @param menuOptions           a list of options to be shown on the device screen (max of 9 options)
 *  @param showMenuOptionsHandler   The callback used to provide the result of the menu selection
 *
 *  @see ShowMenuOptionsHandler
 */
- (void)showMenuOptions:(NSString *_Nonnull)menuTitle andMenuOptions:(NSArray *_Nonnull)menuOptions andOnDone:(ShowMenuOptionsHandler _Nonnull)showMenuOptionsHandler;

/*
 *  Asynchronous method that enables or disables device logging.
 *
 *  @param enableDeviceLogging          Enable or disable device logging
 *  @param enableDeviceLoggingHandler   The callback used to provide the result of enabling or disabling device logging
 *
 *  @see EnableDeviceLoggingHandler
 */
- (void)enableDeviceLogging:(bool)enableDeviceLogging andOnDone:(EnableDeviceLoggingHandler _Nonnull)enableDeviceLoggingHandler;

/*
 *  Asynchronous method that retrieves the device log captured from the reader.
 *
 *  @param retrieveDeviceLogProgressHandler The callback used to provide the progress of log retrieved
 *  @param retrieveDeviceLogHandler The callback used to provide the result of log retrieved
 */
- (void)retrieveDeviceLog:(RetrieveDeviceLogProgressHandler _Nonnull)retrieveDeviceLogProgressHandler andOnDone:(RetrieveDeviceLogHandler _Nonnull)retrieveDeviceLogHandler;

/*!
 * This is an aynchronous method that allows switching between multiple E2E keys in the payment device's secret area if present.
 * The payment device will keep selected key configuration after reboot.
 *
 * @param keyLocationIndex  points to the location of key to be made active for encryption. Range 1 - 20.
 * @param handler The callback used to indicate that key selection was completed.
 */
- (void)selectE2EKey:(NSInteger)keyLocationIndex andOnDone:(SelectE2EKeyHandler _Nonnull)handler;
/*!
 * This is an asynchronous method that gets the card details.
 * Please note: This is not a transaction, and it will accept SWIPE only.
 *
 * @param progressHandler  The callback used to provide the progress of getting card details.
 * @param handler The callback used to provide the card details.
 */
- (void)getCardDetails:(UpdateProgress _Nonnull) progressHandler andCardDetails:(GetCardDetailsHandler _Nonnull)handler;

/*!
 * Aborts getting card details.
 */
- (void)abortGetCardDetails;
/**
 * This is an aynchronous method that sets the VAS merchant on the reader.
 * @param merchantID NSString merchant id to add VAS Merchant
 * @param merchantURL NSString merchant url to add VAS Merchant
 * @param handler OnResponse block
 */
-(void)setVasMerchant:(NSString* _Nonnull)merchantID
          merchantURL:(NSString* _Nonnull)merchantURL
            andOnDone:(SetVasMerchantHandler _Nonnull)handler;

/*!
 * Asynchronous method that will update the master-session working keys on the reader.
 *
 * @param updateWorkingKeysHandler The callback used to indicate that working key update is completed.
 */
- (void)updateWorkingKeys:(UpdateWorkingKeysHandler _Nonnull)updateWorkingKeysHandler;

/*!
 * Asynchronous method that adjusts the brightness level of the payment device. Please note that this is only supportd for Moby8500.
 *
 * @param brightnessLevel Brightness level (5 - 100).
 * @param setBrightnessLevelHandler The callback used to indicate that brightness has been adjusted.
 */
- (void)setBrightnessLevel:(NSUInteger)brightnessLevel andOnDone:(SetBrightnessLevelHandler _Nonnull)setBrightnessLevelHandler;

@end
