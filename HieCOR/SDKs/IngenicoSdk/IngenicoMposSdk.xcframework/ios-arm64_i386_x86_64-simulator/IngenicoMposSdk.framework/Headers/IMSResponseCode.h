/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This enum maps response code to appropriate response messages.
 */
typedef NS_ENUM(NSUInteger, IMSResponseCode){

    /*!
     * Code: 0.
     * <br>
     * The request was successful.
     */
    Success = 0,

    /*!
     * Code: 4901.
     * <br>
     * Generic error for a bad response.
     */
    NetworkError = 4901,
    
    /*!
     * Code: 4999.
     * <br>
     * Default value when no mapping exists for a error code.
     */
    UnknownError = 4999,

    /*!
     * Code: 4998.
     * <br>
     * API key is null. 
     * <h5>Validated for:</h5>
     *   [IMSUser loginwithUsername:andPassword:onResponse:]
     *  <br> [IMSUser forgotPassword:andOnDone:]
     *  <br> All transaction APIs in IMSPayment
     */
    MissingAPIKey = 4998,

    /*!
     * Code: 4997.
     * <br>
     * Username is null. 
     * <h5>Validated for:</h5>[IMSUser loginwithUsername:andPassword:onResponse:]
     *    <br>[IMSUser forgotPassword:andOnDone:]
     */
    MissingUserName = 4997,

    /*!
     * Code: 4996.
     * <br>
     * Password is null. 
     * <h5>Validated for:</h5>[IMSUser loginwithUsername:andPassword:onResponse:]
     */
    MissingPassword = 4996,

    /*!
     * Code: 4995.
     * <br>
     * IMSUserProfile is null or
     * Session token gets invalidated because session expired or
     * same credentials were used to login on a different device. 
     * <h5>Validated for:</h5>All APIs
     */
    InvalidSession = 4995,

    /*!
     * Code: 4994.
     * <br>
     * Signature is not a base 64 image.
     * <h5>Validated for:</h5>[IMSUser uploadSignatureForTransactionWithId:andSignature:andOnDone:]
     */
    InvalidSignature = 4994,

    /*!
     * Code: 4993.
     * <br>
     * TransactionRequest is null or internal processing results in a invalid TransactionRequest object.
     * <h5>Validated for:</h5>All transaction APIs in IMSPayment
     */
    InvalidTransactionRequest = 4993,

    /*!
     * Code: 4991.
     * <br>
     * Thrown when any of the following conditions is satisfied 
     *     <h4>For keyed transaction</h4>
     *        1. IMSCard is null<br>
     *        2. Card number or expiration date is null<br>
     *        3. Card type is [IMSEnum CardTypeUnknown]<br>
     *        4. Card number length is not same as expected length for given card type<br>
     *        5. CVV length is not same as expected length for given card type<br>
     *        6. AVS length is not equal to 5<br>
     *        7. Invalid expiration date<br>
     *     <h4>For transactions made using readers</h4>
     *        1. Card reader throws a <b>NonEMVCardOrCardError</b><br>
     *
     * <h5>Validated for:</h5>All transaction APIs in IMSPayment
     */
    InvalidCard = 4991,

    /*!
     * Code: 4990.
     * <br>
     * Thrown when any of the following conditions is satisfied <br>
     *     <h4></h4>
     *     1. IMSAmount is null<br>
     *     2. The fields in Amount do not fall in the range of 0 - 999999999<br>
     *
     * <h5>Validated for:</h5>All transaction APIs in IMSPayment
     * <br>   [IMSPaymentDevice retrieveTipAmount:]
     */
    InvalidAmount = 4990,

    /*!
     * Code: 4987.
     * <br>
     * Original transaction id is null or original transaction status is invalid
     * <h5>Validated for:</h5>All adjust, refund and void transaction APIs in IMSPayment
     */
    InvalidOriginalTransaction = 4987,

    /*!
     * Code: 4984.
     * <br>
     * Client version is null.
     * <h5>Validated for:</h5>[Ingenico initializeWithBaseURL:apiKey:clientVersion:]
     */
    MissingClientVersion = 4984,

    /*!
     * Code: 4983.
     * <br>
     * The AID selected on ApplicationSelectionCallback is null.
     * <h5>Validated for:</h5>All transaction APIs using card reader in IMSPayment
     */
    InvalidApplication = 4983,

    /*!
     * Code: 4981.
     * <br>
     * Not initialized using [Ingenico initializeWithBaseURL:apiKey:clientVersion:]
     * <h5>Validated for:</h5>[IMSUser loginwithUsername:andPassword:onResponse:]
     * <br>[IMSUser logoff:]
     * <br>[IMSPaymentDevice getDeviceBatteryLevel:]
     * <br>[IMSPaymentDevice getDeviceSerialNumber:]
     * <br>[IMSPaymentDevice setup:]
     * <br> All transaction APIs in IMSPayment
     */
    InitializationRequired = 4981,

    /*!
     * Code: 4978.
     * <br>
     * Email address is null
     * <h5>Validated for:</h5>[IMSUser setUserEmail:andOnDone:]
     */
    MissingEmailAddress = 4978,

    /*!
     * Code: 4976.
     * <br>
     * Old password is null.
     * <br>Validated for:[IMSUser changePasswordWithOldPassword:andNewPassword:andOnDone:]
     */
    MissingOldPassword = 4976,

    /*!
     * Code: 4975.
     * <br>
     * New password is null.
     * <h5>Validated for:</h5>[IMSUser changePasswordWithOldPassword:andNewPassword:andOnDone:]
     */
    MissingNewPassword = 4975,

    /*!
     * Code: 4972.
     * <br>
     * The list containing the answers to the security questions is empty.
     * <h5>Validated for:</h5>[IMSUser setSecurityQuestions:andOnDone:]
     */
    MissingSecurityQuestions = 4972,
    
    /*!
     * Code: 4971.
     * <br>
     * IMSEmailReceiptInfo is null.
     * <h5>Validated for:</h5>[IMSUser setEmailReceiptInfo:andOnDone:]
     */
    InvalidMerchantReceiptInfo = 4971,

    /*!
     * Code: 4967.
     * <br>
     * Transaction ID is null.
     * <h5>Validated for:</h5>[IMSUser sendEmailReceipt:andEmailAddress:andOnDone:]
     * <br> [IMSUser uploadSignatureForTransactionWithId:andSignature:andOnDone:]
     * <br> [IMSUser  updateTransactionWithTransactionID:andCardholderInfo:andTransactionNote:andMerchantInvoiceId:andIsCompleted:andDisplayNotesAndInvoice:andOnDone:]
     * <br> [IMSUser getTransactionDetailsWithTransactionID:andOnDone:]
     */
    MissingTransactionID = 4967,

    /*!
     * Code: 4963.
     * <br>
     * Transaction reversal was successful.
     */
    TransactionReversalSuccess = 4963,

    /*!
     * Code: 4962.
     * <br>
     * Transaction reversal failed.
     */
    TransactionReversalFailed = 4962,

    /*!
     * Code: 4961.
     * <br>
     * Pending transactions do not exist.
     */
    NoPendingTransactions = 4961,

    /*!
     * Code: 4960.
     * <br>
     * Only some of the pending transactions got reversed.
     */
    ReversePendingTransactionPartiallyDone = 4960,

    /*!
     * Code: 4959.
     * <br>
     * Reversal of a pending transaction failed.
     */
    ReversePendingTransactionFailed = 4959,

    /*!
     * Code: 4958.
     * <br>
     * Page size is less than zero.
     * <h5>Validated for:</h5>[IMSUser getTransactionHistoryWithQuery:andOnDone:]
     */
    InvalidPageSize = 4958,

    /*!
     * Code: 4957.
     * <br>
     * Page number is less than zero.
     * <h5>Validated for:</h5>[IMSUser getTransactionHistoryWithQuery:andOnDone:]
     */
    InvalidPageNumber = 4957,

    /*!
     * Code: 4956.
     * <br>
     * Start date is not in mm/dd/yyyy format.
     * <h5>Validated for:</h5>[IMSUser getTransactionHistoryWithQuery:andOnDone:]
     */
    InvalidStartDate = 4956,

    /*!
     * Code: 4955.
     * <br>
     * End date is not in mm/dd/yyyy format.
     * <h5>Validated for:</h5>[IMSUser getTransactionHistoryWithQuery:andOnDone:]
     */
    InvalidEndDate = 4955,

    /*!
     * Code: 4954.
     * <br>
     * Past days is less than zero.
     * <h5>Validated for:</h5>[IMSUser getTransactionHistoryWithQuery:andOnDone:]
     */
    InvalidPastDays = 4954,

    /*!
     * Code: 4953.
     * <br>
     * Thrown when any of the following conditions is satisfied <br>
     *     <h4></h4>
     *    1. Start date is null <br>
     *    2. End date is null <br>
     *    3. Past days is zero<br>
     * <h5>Validated for:</h5>[IMSUser getTransactionHistoryWithQuery:andOnDone:]
     */
    InvalidDate = 4953,

    /*!
     * Code: 4952.
     * <br>
     * [IMSUser getTransactionHistoryWithQuery:andOnDone:] failed.
     */
    GetTransactionHistoryFailed = 4952,

    /*!
     * Code: 4951.
     * <br>
     * Fetching EMV parameters from backend while doing [IMSPaymentDevice setup:] failed.
     */
    GetEMVParameterFailed = 4951,

    /*!
     * Code: 4950.
     * <br>
     * Device Setup Required
     */
    DeviceSetupRequired = 4950,

    /*!
     * Code: 4949.
     * <br>
     * Email address has invalid format.
     * <h5>Validated for:</h5>[IMSUser setUserEmail:andOnDone:]
     *  <br>  [IMSUser sendEmailReceipt:andEmailAddress:andOnDone:]
     */
    InvalidEmailAddress = 4949,

    /*!
     * Code: 4948.
     * <br>
     * Any of the answers in the list is null.
     * <h5>Validated for:</h5>[IMSUser setSecurityQuestions:andOnDone:]
     */
    InvalidAnswer = 4948,

    /*!
     * Code: 4947.
     * <br>
     * HTTP response code from backend is 9997.
     */
    NetworkInvalidSSLCertificate =4947,

    /*!
     * Code: 4946.
     * <br>
     * HTTP response code from backend is 9998.
     */
    NetworkMalformedURL =4946,

    /*!
     * Code: 4945.
     * <br>
     * Command send to card reader was cancelled resulting in the transaction being cancelled.
     */
    TransactionCancelled = 4945,

    /*!
     * Code: 4944.
     * <br>
     * [IMSUser loginwithUsername:andPassword:onResponse:]failed.
     */
    LoginFailed = 4944,

    /*!
     * Code: 4942.
     * <br>
     * Error fetching transaction information from local database for reversals.
     */
    TransactionDatabaseError = 4942,

    /*!
     * Code: 4940.
     * <br>
     * Default error when no specific error is returned from the backend when a transaction gets declined.
     */
    TransactionDeclined = 4940,

    /*!
     * Code: 4939.
     * <br>
     * Error in device setup.
     */
    DeviceSetupError = 4939,

    /*!
     * Code: 4938.
     * <br>
     * Signature is null.
     * <h5>Validated for:</h5>[IMSUser uploadSignatureForTransactionWithId:andSignature:andOnDone:]
     */
    MissingSignature = 4938,

    /*!
     * Code: 4937.
     * <br>
     * Transaction reversal succeeded. Reversal reason: Chip decline.
     */
    TransactionReversalChipDeclineSuccess = 4937,

    /*!
     * Code: 4936.
     * <br>
     * Transaction reversal failed. Reversal reason: Chip decline.
     */
    TransactionReversalChipDeclineFailed = 4936,

    /*!
     * Code: 4935.
     * <br>
     * Transaction reversal succeeded. Reversal reason: Network timeout.
     */
    TransactionReversalNetworkTimeoutSuccess = 4935,

    /*!
     * Code: 4934.
     * <br>
     * Transaction reversal failed. Reversal reason: Network timeout.
     */
    TransactionReversalNetworkTimeoutFailed = 4934,

    /*!
     * Code: 4933.
     * <br>
     * Transaction reversal succeeded. Reversal reason: Card removed.
     */
    TransactionReversalCardRemovedSuccess = 4933,

    /*!
     * Code: 4932.
     * <br>
     * Transaction reversal failed. Reversal reason: Card removed.
     */
    TransactionReversalCardRemovedFailed = 4932,

    /*!
     * Code: 4931.
     * <br>
     * Transaction reversal succeeded. Reversal reason: Generic card reader error.
     */
    TransactionReversalPinPadErrorSuccess = 4931,

    /*!
     * Code: 4930.
     * <br>
     * Transaction reversal failed. Reversal reason: Generic card reader error.
     */
    TransactionReversalPinPadErrorFailed = 4930,

    /*!
     * Code: 4929.
     * <br>
     * Transaction reversal succeeded. Reversal reason: Update transaction failed.
     */
    TransactionReversalUpdateFailureSuccess = 4929,

    /*!
     * Code: 4928.
     * <br>
     * Transaction reversal failed. Reversal reason: Update transaction failed.
     */
    TransactionReversalUpdateFailureFailed = 4928,

    /*!
     * Code: 4927.
     * <br>
     * Clerk id length is either 0 or greater than 4.
     * <h5>Validated for:</h5> [IMSUser getTransactionHistoryWithQuery:andOnDone:]
     *  <br>  [IMSUser getInvoiceHistoryWithQuery:andOnDone:]
     *   <br>      All transaction APIs in IMSPayment
     */
    InvalidClerkID = 4927,

    /*!
     * Code: 4925.
     * <br>
     * Refresh user session failed.
     */
    RefreshUserSessionFailed = 4925,

    /*!
     * Code: 4924.
     * <br>
     * Invalid authorization code(Authorization code must be 6 digits).
     */
    InvalidAuthorizationCode = 4924,

    /*!
     * Code: 4923.
     * <br>
     * Invalid SystemTraceAuditNumber(SystemTraceAuditNumber must be 1-6 digits number).
     */
    InvalidSystemTraceAuditNumber = 4923,

    /*!
     * Code: 4922.
     * <br>
     * Check for firmware update failed.
     */
    CheckForFirmwareUpdateFailed = 4922,

    /*!
     * Code: 4921.
     * <br>
     * Transaction cancel failed.
     */
    TransactionCancelFailed = 4921,

    /*!
     * Code: 4920.
     * <br>
     * Check for device setup failed.
     */
    CheckForDeviceSetupFailed = 4920,

    /*!
     * Code: 4919.
     * <br>
     * Firmware update failed.
     */
    FirmwareUpdateError = 4919,

    /*!
     * Code: 4918.
     * <br>
     * Firmware download failed.
     */
    FirmwareDownloadFailed = 4918,

    /*!
     * Code: 4917.
     * <br>
     * Firmware update through AudioJack is not supported(switch to Bluetooth instead).
     */
    FirmwareUpdateNotAllowed = 4917,

    /*!
     * Code: 4916.
     * <br>
     * Invalid MerchantInvoiceId. MerchantInvoiceId must be 1-15 alphanumeric characters.
     */
    InvalidMerchantInvoiceId = 4916,

    /*!
     * Code: 4915.
     * <br>
     * Invalid CustomReference. CustomReference must be 1-20 alphanumeric characters including hyphen.
     */
    InvalidCustomReference = 4915,

    /*!
     * Code: 4914.
     * <br>
     * Invalid InvalidTokenFee. Fee must be in the range of 0 - 999999999
     */
    InvalidTokenFee = 4914,

    /*!
     * Code: 4913.
     * <br>
     * Invalid InvalidTokenReference. TokenReference must be 1-12 ascii characters.
     */
    InvalidTokenReference = 4913,

    /*!
     * Code: 4912.
     * <br>
     * Firmware update interrupted.
     */
    FirmwareUpdateInterrupted = 4912,

    /*!
     * Code: 4911.
     * <br>
     * Device connection lost duing firmware update.
     */
    FirmwareUpdateConnectionError = 4911,
    
    /*!
     * Code: 4910.
     * <br>
     * Store And Forward Database Error
     */
    StoreAndForwardDatabaseError = 4910,
    
    /*!
     * Code: 4909.
     * <br>
     * Stored client transaction ID is null.
     * <h5>Validated for:</h5>
     *  [IMSPayment uploadStoredTransaction:andUpdateProgress:andOnDone:]
     */
    InvalidStoredClientTransactionID = 4909,
    
    /*!
     * Code: 4908.
     * <br>
     * Stored transaction is already completed and cannot be updated further
     */
    StoredTransactionAlreadyCompleted = 4908,
    
    /*!
     * Code: 4907.
     * <br>
     * Invalid transaction Group ID
     */
    InvalidTransactionGroupID = 4907,
    
    /*!
     * Code: 4906.
     * <br>
     * Store and forward is not enabled for the user
     */
    StoreAndForwardNotEnabled = 4906,

    /*!
     * Code: 4905.
     * <br>
     * Get secure card entry page failed
     */
    GetSecureCardEntryPageFailed = 4905,

    /*!
     * Code: 4904.
     * <br>
     * InvalidTokenIdentifier. Token identifer must be 1-30 ascii characters.
     */
    InvalidTokenIdentifier = 4904,

    /*!
     * Code: 4903.
     * <br>
     * read magnetic card data failed
     */
    ReadMagneticCardDataFailed = 4903,

    /*!
     * Code: 4902.
     * <br>
     * Invalid idle shutdown timeout. Timeout must be between 180 - 1800.
     */
    InvalidIdleShutdownTimeout = 4902,
    
    /*!
     * Code: 4900.
     * <br>
     * Invalid Original Transaction Type.
     */
    InvalidOriginalTransactionType = 4900,

    /*!
     * Code: 4899.
     * <br>
     * Invalid EMV Parameter Configuration.
     */
    InvalidEMVParameterConfiguration = 4899,

	/**
	 * Code: 4898.
	 * <br>
	 * Invalid row number for displaying text on the Payment Device
	 */
	InvalidRowNumber = 4898,
	
	/**
	 * Code: 4897.
	 * <br>
	 * Invalid column number for displaying text on the Payment Device
	 */
	InvalidColumnNumber = 4897,
	
	/**
	 * Code: 4896.
	 * <br>
	 * Invalid text for displaying text on the Payment Device
	 */
	InvalidDisplayText = 4896,
    
    /**
     * Code: 4895.
     * <br>
     * Invalid API key was used to initialize mPOS EMV SDK
     */
    InvalidAPIKey = 4895,
    
    /**
     * Code: 4894.
     * <br>
     * Get transactions summary failed due to invalid server response
     */
    GetTransactionsSummaryFailed = 4894,
	
	/**
	 * Code: 4893.
	 * <br>
	 * Get processor info failed due to invalid server response
	 */
	GetProcessorInfoFailed = 4893,
 
    /**
     * Code: 4892.
     * <br>
     * Firmware update cancelled by user
     */
    FirmwareUpdateCancelled = 4892,
    
    /**
     * Code: 4891.
     * <br>
     * Invalid base URL was used to initialize mPOS EMV SDK.
     * Note: Use https URL in production.
     */
    InvalidBaseURL = 4891,
    
    /**
     * Code: 4890.
     * <br>
     * Invalid order number. Order number is numeric only and is up to 9 digits long.
     */
    InvalidOrderNumber = 4890,
	
    /**
    * Code: 4890.
    * <br>
    * Invalid key location index. Valid range 1 - 20.
    */
    InvalidKeyLocationIndex = 4889,
    
    /*!
    * Code: 4888.
    * <br>
    * This error will be returned if no valid public key is found during offline login.
    */
    StoreAndForwardInvalidPublicKey= 4888,
    
    /*!
    * Code: 4887.
    * <br>
    * This error will be returned if the payment device is not in a state to support EMV either due to outdated firmware or EMV configuration.
    */
    EMVNotSupported= 4887,
    
    /*!
     * Code: 4886.
     * <br>
     * Invalid serial number returned from device.
     */
    InvalidSerialNumber = 4886,

    /*!
     * Code: 4885.
     * <br>
     * Invalid reader model returned from device.
     */
    InvalidReaderModel = 4885,

    /*!
     * Code: 4884.
     * <br>
     * Invalid reader firmware returned from device.
     */
    InvalidReaderFirmware = 4884,

    /*!
     * Code: 4883.
     * <br>
     * Invalid AVS zip code sent. Zip is alphanumeric up to 10 digits
     */
    InvalidAvsZip = 4883,

    /*!
     * Code: 4882.
     * <br>
     * Invalid card holder first name sent. First name is alphanumeric + symbols up to 50 digits
     */
    InvalidCardHolderFirstName = 4882,

    /*!
     * Code: 4881.
     * <br>
     * Invalid card holder last name sent. Last name is alphanumeric + symbols up to 50 digits
     */
    InvalidCardHolderLastName = 4881,

    /*!
     * Code: 4880.
     * <br>
     * This error will be returned if the payment device does not support store and forward transactions
     */
    StoreAndForwardNotAllowedForDevice = 4880,
    
    /*!
     * Code: 4879.
     * <br>
     * This error will be returned if the brightness level is invalid. The brightness level must be between 5 - 100.
     */
    InvalidBrightnessLevel = 4879,
    
    /*Device response code*/

    /*!
     * Code: 6001.
     * <br>
     * Payment device disconnected.
     */
    PaymentDeviceNotAvailable = 6001,

    /*!
     * Code: 6002.
     * <br>
     * Payment device timed out.
     */
    PaymentDeviceTimeout = 6002,

    /*!
     * Code: 6003.
     * <br>
     * Transaction type not supported by payment device.
     * Eg: Cannot do debit sale on any device except RP750 because it needs pin entry.
     */
    NotSupportedByPaymentDevice =  6003,

    /*!
     * Code: 6004.
     * <br>
     * Generic payment device error. Thrown by SDK.
     */
    PaymentDeviceError =  6004,

    /*!
     * Code: 6005.
     * <br>
     * Card blocked. Thrown by payment device.
     */
    CardBlocked = 6005,

    /*!
     * Code: 6006.
     * <br>
     * Generic error thrown by payment device at any phase except during card interaction.
     */
    CardReaderGeneralError = 6006,

    /*!
     * Code: 6007.
     * <br>
     * G4x Swiper decode swipe failed or decode crc error.
     */
    BadCardSwipe = 6007,

    /*!
     * Code: 6008.
     * <br>
     * Application on the card is blocked. Thrown by payment device.
     */
    ApplicationBlocked = 6008,

    /*!
     * Code: 6009.
     * <br>
     * Generic error thrown by payment device only during interaction with the card.
     */
    CardInterfaceGeneralError = 6009,

    /*!
     * Code: 6010.
     * <br>
     * Payment device battery very low and is unable to process a transaction.
     */
    BatteryTooLowError = 6010,

    /*!
     * Code: 6011.
     * <br>
     * Payment device error that can occur during card sensitive data encryption.
     */
    P2PEEncryptError = 6011,

    /*!
     * Code: 6012.
     * <br>
     * Payment device error that can occur if application selection is cancelled.
     */
    ApplicationSelectionCancelled = 6012,

    /*!
     * Code: 6013.
     * <br>
     * Card has an AID that is unknown to the card reader.
     */
    UnsupportedCard = 6013,
    
    /*!
     * Code: 6014.
     * <br>
     * Tip entry was aborted on the reader.
     */
    TipEntryAborted = 6014,

	/*!
	 * Code: 6015.
	 * <br>
	 * Chip / Contactless Card is not completely read by the Payment Device.
	 * This error will be returned if chip card is not fully inserted or if the NFC card is removed quickly that Payment Device is not able to completely read the card data.
	 */
	CardNotPresentOrNotFullyInserted = 6015,
	
    /*!
     * Code: 6016.
     * <br>
     * Payment device error that can occur if transaction type selection is cancelled.
     */
    TransactionTypeSelectionCancelled = 6016,
    
    /*!
     * Code: 6017.
     * <br>
     * Payment device error that can occur if invalid parameters are given to the payment device APIs.
     */
     InvalidParameters = 6017,
     
     /*!
     * Code: 6018.
     * <br>
     * Payment device error that can occur if the cancel button is clicked when in menu selection mode.
     */
     CustomMenuSelectionAborted = 6018,
    
    /*!
    * Code: 6019.
    * <br>
    * This error will be returned if the reader determines that a Store and forward EMV transaction is chip declined.
    */
    StoreAndForwardChipDecline = 6019,
    
    /*!
    * Code: 6020.
    * <br>
    * This error will be returned if an expired card is used in a Store and forward transaction with card reader.
    */
    StoreAndForwardCardExpired = 6020,
    
    /*!
     * Code: 6021.
     * <br>
     * This error will be returned if E2E key is not found at the specified key location index.
     */
    E2EKeyNotFound = 6021,
    
    /*!
     * Code: 6022.
     * <br>
     * This error will be returned if VAS transaction was not successful.
     */
    VasError = 6022,
    
    /*!
     * Code: 6025.
     * <br>
     * This error will be returned if the card encounters an issue with contactless interface
     */
    ContactlessApplicationError = 6025,
    
    
    /*MCM response code*/

    /*!
     * Code: 1000.
     * <br>
     *   System error
     */
    SystemError = 1000,

    /*!
     * Code: 1001.
     * <br>
     * 	Unknown system error
     */
    UnknownSystemError = 1001,

    /*!
     * Code: 1002.
     * <br>
     * Connection error
     */
    ConnectionError = 1002,

    /*!
     * Code: 1003.
     * <br>
     * Database error
     */
    DatabaseError = 1003,

    /*!
     * Code: 2001.
     * <br>
     * Request failure
     */
    RequestFailure = 2001,

    /*!
     * Code: 2002.
     * <br>
     * Unknown request failure
     */
    UnknownRequestError = 2002,

    /*!
     * Code: 2003.
     * <br>
     * The IP address is locked and may not make requests
     */
    IPLocked = 2003,

    /*!
     * Code: 2004.
     * <br>
     * Permission error
     */
    PermissionError = 2004,

    /*!
     * Code: 2005.
     * <br>
     * The request format is invalid
     */
    InvalidRequestFormat = 2005,

    /*!
     * Code: 2006.
     * <br>
     * User Account is locked after bad login attempts
     */
    AccountLocked = 2006,

    /*!
     * Code: 2010.
     * <br>
     * The API version provided is invalid
     */
    InvalidApiVersion = 2010,

    /*!
     * Code: 2011.
     * <br>
     * The app token provided is invalid
     */
    InvalidAppToken = 2011,

    /*!
     * Code: 2012.
     * <br>
     * The session token provided is invalid
     */
    InvalidSessionToken = 2012,

    /*!
     * Code: 2013.
     * <br>
     * The credentials (user/pass etc.) provided are invalid
     */
    InvalidCredentials = 2013,

    /*!
     * Code: 2100.
     * <br>
     * A required parameter is missing
     */
    MissingParameter = 2100,

    /*!
     * Code: 2200.
     * <br>
     * A parameter is incorrectly formatted
     */
    ParameterFormatError = 2200,

    /*!
     * Code: 2300.
     * <br>
     * The request contains an input validation error
     */
    ValidationError = 2300,

    /*!
     * Code: 2302.
     * <br>
     * The password is same as previous
     */
    NewPasswordSameAsOldPassword = 2302,

    /*!
     * Code: 2303.
     * <br>
     * Password validation error
     */
    InvalidCharactersOrLengthForNewPassword = 2303,

    /*!
     * Code: 2304.
     * <br>
     * Uploaded image file size validation error
     */
    FileSizeValidationError=2304,

    /*!
     * Code: 2305.
     * <br>
     * User is invalid
     */
    UserNameValidationError=2305,

    /*!
     * Code: 2400.
     * <br>
     * The requested entity was not found
     */
    EntityNotFound = 2400,

    /*!
     * Code: 2500.
     * <br>
     * The entity specified already exists
     */
    EntityAlreadyExists = 2500,

    /*!
     * Code: 3000.
     * <br>
     * An internal administrative error
     */
    InternalAdministrativeError = 3000,

    /*!
     * Code: 3010.
     * <br>
     * The entity is deactivated
     */
    EntityDeactivated = 3010,

    /*!
     * Code: 3020.
     * <br>
     * The entity is suspended
     */
    EntitySuspended = 3020,

    /*!
     * Code: 3030.
     * <br>
     * The entity is terminated
     */
    EntityTerminated = 3030,

    /*!
     * Code: 3040.
     * <br>
     * The entity is locked
     */
    EntityLocked = 3040,

    /*!
     * Code: 3050.
     * <br>
     * An error has occurred in the boarding process
     */
    BoardingError = 3050,

    /*!
     * Code: 3051.
     * <br>
     * User account has not been set up
     */
    AccountNotSetup = 3051,

    /*!
     * Code: 4000.
     * <br>
     * Transaction error
     */
    TransactionError = 4000,

    /*!
     * Code: 4500.
     * <br>
     * Generic risk check error
     */
    RiskCheckError = 4500,

    /*!
     * Code: 4501.
     * <br>
     * Transaction has already been refunded
     */
    TransactionAlreadyRefunded = 4501,

    /*!
     * Code: 4502.
     * <br>
     * Requested amount is larger than Refundable amount.
     */
    RequestedAmountLargerThanRefundableAmount = 4502,

    /*!
     * Code: 4503.
     * <br>
     *     Transaction type is invalid against original transaction. e.g. CreditSaleVoid against AuthCompletion is invalid.
     */
    TransactionTypeInvalid = 4503,

    /*!
     * Code: 4504.
     * <br>
     *     Original transaction is already Completed.
     *     e.g. If an Auth transaction has an AuthCompletion run against it,
     *     the status of it is "Completed" and can not run AuthCompletion/AuthVoid against it.
     */
    TransactionTypeForbidden = 4504,

    /*!
     * Code: 4505.
     * <br>
     *     The original transaction is no longer available for refund.
     */
    RefundExpired = 4505,

    /*!
     * Code: 4506.
     * <br>
     * Requested void amount is smaller than the original sale amount.
     */
    PartialAmountVoidError = 4506,

    /*!
     * Code: 5100.
     * <br>
     * Decryption error
     */
    DecryptionError = 5100,

    /*!
     * Code: 5200.
     * <br>
     * Email error
     */
    EmailError = 5200,

    /*Gateway response code*/

    /*!
     * Code: 4050.
     * <br>
     * mPosSDK version number submitted is not supported with the transaction requested.
     */
    UnsupportedSDKVersion = 4050,

    /*!
     * Code: 4051.
     * <br>
     * Card reader firmware version number submitted is not supported with the transaction requested.
     */
    UnsupportedFirmwareVersion = 4051,

    /*!
     * Code: 7001.
     * <br>
     * Refer to card issuer
     */
    HostRefer = 7001,

    /*!
     * Code: 7002.
     * <br>
     * Refer to card issuer, special condition
     */
    HostReferralSpecial = 7002,

    /*!
     * Code: 7003.
     * <br>
     * Invalid merchant or service provider
     */
    HostInvalidMerchant = 7003,

    /*!
     * Code: 7004.
     * <br>
     * Pickup card
     */
    HostPickupCard = 7004,

    /*!
     * Code: 7005.
     * <br>
     * Do not honor
     */
    HostDoNotHonor = 7005,

    /*!
     * Code: 7006.
     * <br>
     * Error
     */
    HostError = 7006,

    /*!
     * Code: 7007.
     * <br>
     * Pickup card, special condition (other than lost/stolen card)
     */
    HostPickupCardSpecial = 7007,

    /*!
     * Code: 7012.
     * <br>
     * Invalid transaction
     */
    HostInvalidTransaction = 7012,

    /*!
     * Code: 7013.
     * <br>
     * Invalid amount (currency conversion field overflow);or amount exceeds maximum for card program
     */
    HostInvalidAmount = 7013,

    /*!
     * Code: 7014.
     * <br>
     * Invalid account number (no such number)
     */
    HostInvalidAccount = 7014,

    /*!
     * Code: 7015.
     * <br>
     * No such issuer
     */
    HostNoIssuer = 7015,

    /*!
     * Code: 7019.
     * <br>
     * Re-enter transaction
     */
    HostReenter = 7019,

    /*!
     * Code: 7021.
     * <br>
     * No action taken (unable to back out prior transaction)
     */
    HostNoActionTaken = 7021,

    /*!
     * Code: 7025.
     * <br>
     * Unable to locate record in file, or account number is missing from the inquiry
     */
    HostNoRecord = 7025,

    /*!
     * Code: 7028.
     * <br>
     * 	File is temporarily unavailable
     */
    HostFileUnavailable = 7028,

    /*!
     * Code: 7041.
     * <br>
     * Pickup card (lost card)
     */
    HostLostCard = 7041,

    /*!
     * Code: 7043.
     * <br>
     * Pickup card (stolen card)
     */
    HostStolenCard = 7043,

    /*!
     * Code: 7051.
     * <br>
     * Insufficient funds
     */
    HostNSF = 7051,

    /*!
     * Code: 7052.
     * <br>
     * No checking account
     */
    HostNoCheckingAccount = 7052,

    /*!
     * Code: 7053.
     * <br>
     * No savings account
     */
    HostNoSavingsAccount = 7053,

    /*!
     * Code: 7054.
     * <br>
     * Expired card
     */
    HostExpiredCard = 7054,

    /*!
     * Code: 7055.
     * <br>
     * 	Incorrect PIN
     */
    HostIncorrectPIN = 7055,

    /*!
     * Code: 7057.
     * <br>
     * Transaction not permitted to cardholder
     */
    HostNotPermitted = 7057,

    /*!
     * Code: 7058.
     * <br>
     * Transaction not allowed at terminal
     */
    HostNotAllowed = 7058,

    /*!
     * Code: 7059.
     * <br>
     * Suspected fraud
     */
    HostSuspectedFraud = 7059,

    /*!
     * Code: 7061.
     * <br>
     * Activity amount limit exceeded
     */
    HostAmountLimitExceeded = 7061,

    /*!
     * Code: 7062.
     * <br>
     * Restricted card (for example, in Country Exclusion table)
     */
    HostRestrictedCard = 7062,

    /*!
     * Code: 7063.
     * <br>
     * Security violation
     */
    HostSecurityViolation = 7063,

    /*!
     * Code: 7065.
     * <br>
     * Activity count limit exceeded
     */
    HostCountLimitExceeded = 7065,

    /*!
     * Code: 7075.
     * <br>
     * Allowable number of PIN-entry tries exceeded
     */
    HostPINRetryExceeded = 7075,

    /*!
     * Code: 7076.
     * <br>
     * Unable to locate previous message (no match on Retrieval Reference number)
     */
    HostUnableToLocate = 7076,

    /*!
     * Code: 7077.
     * <br>
     * Previous message located for a repeat or reversal, but repeat or reversal data are inconsistent with original message
     */
    HostIncosistentData = 7077,

    /*!
     * Code: 7078.
     * <br>
     * ’Blocked, first used’—The transaction is from a new cardholder, and the card has not been properly unblocked.
     */
    HostCardBlocked = 7078,

    /*!
     * Code: 7080.
     * <br>
     * Visa transactions: credit issuer unavailable. Private label and check acceptance: Invalid date
     */
    HostIssuerUnavailable = 7080,

    /*!
     * Code: 7081.
     * <br>
     * PIN cryptographic error found (error found by VIC security module during PIN decryption)
     */
    HostVICError = 7081,

    /*!
     * Code: 7082.
     * <br>
     * Negative CAM, dCVV, iCVV, or CVV results
     */
    HostCVCError = 7082,

    /*!
     * Code: 7083.
     * <br>
     * Unable to verify PIN
     */
    HostPINVerificationError = 7083,

    /*!
     * Code: 7091.
     * <br>
     * Issuer unavailable or switch inoperative (STIP not applicable or available for this transaction)
     */
    HostSTIPError = 7091,

    /*!
     * Code: 7092.
     * <br>
     * Destination cannot be found for routing
     */
    HostNoRoute = 7092,

    /*!
     * Code: 7093.
     * <br>
     * Transaction cannot be completed; violation of law
     */
    HostUnlawfullTransaction = 7093,

    /*!
     * Code: 7096.
     * <br>
     * System malfunction, System malfunction or certain field error conditions
     */
    HostSystemMalfunction = 7096,

    /*!
     * Code: 7101.
     * <br>
     * Surcharge amount not permitted on Visa cards (U.S. acquirers only)
     */
    HostSurchargeNotPermitted = 7101,

    /*!
     * Code: 7102.
     * <br>
     * Force STIP
     */
    HostForceSTIP = 7102,

    /*!
     * Code: 7103.
     * <br>
     * Cash service not available
     */
    HostCashNotAvailable = 7103,

    /*!
     * Code: 7104.
     * <br>
     * Cashback request exceeds issuer limit
     */
    HostCashbackOverLimit = 7104,

    /*!
     * Code: 7105.
     * <br>
     * Decline for CVV2 failure
     */
    HostCVVFail = 7105,

    /*!
     * Code: 7106.
     * <br>
     * Invalid biller information
     */
    HostInvalidBiller = 7106,

    /*!
     * Code: 7107.
     * <br>
     * PIN Change/Unblock request declined
     */
    HostPINChangeDeclined = 7107,

    /*!
     * Code: 7108.
     * <br>
     * Unsafe PIN
     */
    HostUnsafePIN = 7108,

    /*!
     * Code: 7109.
     * <br>
     * Card Authentication failed
     */
    HostCardAuthenticationFail = 7109,

    /*!
     * Code: 7110.
     * <br>
     * 	Stop Payment Order
     */
    HostStopPaymentOrder = 7110,

    /*!
     * Code: 7111.
     * <br>
     * 	Revocation of Authorization Order
     */
    HostAuthRevoked = 7111,

    /*!
     * Code: 7112.
     * <br>
     * Revocation of All Authorizations Order
     */
    HostAllAuthRevoked = 7112,

    /*!
     * Code: 7113.
     * <br>
     * Forward to issuer
     */
    HostForwardToIssuer = 7113,

    /*!
     * Code: 7115.
     * <br>
     * Unable to go online
     */
    HostOffline = 7115
};
