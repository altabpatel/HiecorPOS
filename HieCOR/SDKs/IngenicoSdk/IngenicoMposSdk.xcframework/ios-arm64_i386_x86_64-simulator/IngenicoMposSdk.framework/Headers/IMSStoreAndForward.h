/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import "IMSStoreAndForwardCreditSaleTransactionRequest.h"
#import "IMSStoreAndForwardKeyedCardSaleTransactionRequest.h"
#import "IMSStoreAndForwardCreditAuthTransactionRequest.h"
#import "IMSStoreAndForwardCashSaleTransactionRequest.h"
#import "IMSStoreAndForwardVoidTransactionRequest.h"
#import "IMSStoreAndForwardTokenEnrollmentTransactionRequest.h"
#import "IMSStoreAndForwardKeyedTokenEnrollmentTransactionRequest.h"
#import "IMSStoredTransactionSummary.h"

/**
 *  Hanlder to be invoked after the offline login request is processed.
 *
 *  @param error nil if succeed, otherwise the code indicates the reason
 *  @see IMSUserProfile
 */
typedef void (^LoginOfflineCallback)(NSError * _Nullable error);

/**
 *  Hanlder to be invoked after the store receipt for stored transaction ID request is processed.
 *
 *  @param error nil if succeed, otherwise the code indicates the reason
 */
typedef void (^StoreReceiptForStoredTransactionHandler)(NSError * _Nullable error);



/**
 * Handler to be invoked after retrieving stored transaction for a given client transaction id
 *
 * @param storedTransactionSummary transaction summary for a given client transaction id
 * @param error                    response code <br>
 *                                 See IMSResponseCode
 * @see IMSStoredTransactionSummary
 */
typedef void (^GetStoredTransactionHandler)(IMSStoredTransactionSummary*  _Nullable storedTransactionSummary, NSError*  _Nullable error);

/**
 * Handler to be invoked after retrieving the list of stored transactions
 *
 * @param error server response <br>
 *                     See {@link com.ingenico.mpos.sdk.constants.ResponseCode}
 * @param totalMatches number of matches
 * @param transactions list of stored transactions
 * @see IMSStoredTransactionSummary
 */
typedef void (^GetStoredTransactionsHandler)(NSArray*  _Nullable transactions, int totalMatches, NSError*  _Nullable error);

/*!
 *  Handler to be invoked after delete stored transaction request is processed.
 *
 *  @param error    nil if succeed, otherwise the code indicates the reason
 */
typedef void (^DeleteStoredTransactionHandler)(NSError * _Nullable error);

/**
 * This class contains methods to perform store and forward related actions.
 * All the methods accept a callback pertaining to that action
 * to capture the response.
 */

@interface IMSStoreAndForward : NSObject


/*!
 *  Authenticates the user offline to enable the user for performing store and forward transactions
 *
 *  @param userName  merchant's username
 *  @param password  password
 *  @param handler   the callback used to indicate that the
 *                   login request has been processed
 */
- (void)loginOffline:(NSString * _Nonnull)userName andPassword:(NSString * _Nonnull)password onResponse:(LoginOfflineCallback  _Nonnull)handler;

/*!
 * Processes the credit payment by getting card information from the card reader
 * and then storing it in the local database for authorization later. (Swipe only)
 *  @param transactionRequest IMSStoreAndForwardCreditSaleTransactionRequest object.
 *  @param progressHandler progress handler
 *  @param handler            the callback used to indicate that the
 *                            credit card sale transaction request has been processed
 *  @see IMSStoreAndForwardCreditSaleTransactionRequest
 */
-(void)processStoreAndForwardCreditSaleTransactionWithCardReader:(IMSStoreAndForwardCreditSaleTransactionRequest* _Nonnull) transactionRequest
                                               andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                                       andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the credit payment by geting card information by asking the user to enter it directly 
 * on the reader and then storing it in the local database for authorization later.
 *  @param transactionRequest IMSStoreAndForwardKeyedCardSaleTransactionRequest object.
 *  @param progressHandler progress handler
 *  @param handler            the callback used to indicate that the
 *                            keyed card sale transaction request has been processed
 *  @see IMSStoreAndForwardCreditSaleTransactionRequest
 */
-(void)processStoreAndForwardKeyedCardSaleTransactionWithCardReader:(IMSStoreAndForwardKeyedCardSaleTransactionRequest* _Nonnull) transactionRequest
                                               andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                                       andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the credit auth payment by getting card information from the card reader
 * and then storing it in the local database for authorization later. (Swipe Only)
 *  @param transactionRequest IMSStoreAndForwardCreditAuthTransactionRequest object
 *  @param progressHandler progress handler
 *  @param handler            the callback used to indicate that the
 *                            credit card auth transaction request has been processed
 *  @see IMSStoreAndForwardCreditAuthTransactionRequest
 */
-(void)processStoreAndForwardCreditAuthTransactionWithCardReader:(IMSStoreAndForwardCreditAuthTransactionRequest* _Nonnull) transactionRequest
                                               andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                                       andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Forwards the stored transaction to gateway for Authorization
 * Please ensure the you have good internet connectivity before executing the API
 *  @param storedClientTransactionID referenceID.
 *  @param progressHandler progress handler
 *  @param handler the callback used to indicate that the
 *                            credit card sale transaction request has been processed
 */
-(void)uploadStoredTransaction:(NSString* _Nonnull)storedClientTransactionID
             andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                     andOnDone:(TransactionOnDone _Nonnull)handler;

/**
 * Voids the stored credit transaction
 * @param storeAndForwardVoidTransactionRequest  IMSStoreAndForwardVoidTransactionRequest object
 * @param handler                                the callback used to indicate that the
 *                                               void transaction request has been processed
 *  @see IMSStoreAndForwardVoidTransactionRequest
 */
-(void)processVoidStoredTransaction:(IMSStoreAndForwardVoidTransactionRequest * _Nonnull)storeAndForwardVoidTransactionRequest
                          andOnDone:(TransactionOnDone _Nonnull)handler;

/**
 *  Returns a stored transactions for a stored client transaction ID.
 *  @param storedClientTransactionID referenceID.
 *  @param handler          the callback used to indicate that the
 *                          get transaction request has been processed
 *  @see IMSStoredTransactionSummary
 */
-(void)getStoredTransactionWithClientTransactionID:(NSString* _Nonnull)storedClientTransactionID
                                         andOnDone:(GetStoredTransactionHandler _Nonnull) handler;

/**
 * Returns a list of stored transactions.
 *  @param includeDeclines              indicates if the declined transactions are to be returned
 *  @param handler          the callback used to indicate that the
 *                          get transactions request has been processed
 *  @see IMSStoredTransactionSummary
 */
-(void)getStoredTransactions:(BOOL)includeDeclines
                   andOnDone:(GetStoredTransactionsHandler _Nonnull) handler;

/**
 * Returns a list of stored transactions.
 *  @param includeDeclines              indicates if the declined transactions are to be returned
 *  @param includeGroupTransactions     indicates if the transactions for all users in the group
                                        are to be returned
 *  @param handler                      the callback used to indicate that the
 *                                      get transactions request has been processed
 *  @see IMSStoredTransactionSummary
 */
-(void)getStoredTransactions:(BOOL)includeDeclines
 andIncludeGroupTransactions:(BOOL)includeGroupTransactions
                   andOnDone:(GetStoredTransactionsHandler _Nonnull) handler;

/*!
 *  Updates the transaction with the given parameters. A transaction can be updated in steps with a varying combination of optional parameters as and when
 *  they are available, in such case the last update needs to have the flag isComplete set to true.
 *
 *  @param clientTransactionID    the clientTransactionID of the transaction to update
 *  @param cardholderInfo         (optional) cardholder info
 *  @param transactionNote        (optional) custom notes for the transaction
 *  @param isCompleted            indicates whether the transaction is completed
 *  @param displayNotesAndInvoice indicates whether to display transaction notes and merchant invoice ID in email receipt
 *  @param signatureImage         BASE64 encoded string representing the image
 *  @param handler                the callback used to indicate that update to the
 *                                transaction has been processed
 *  @see  IMSCardholderInfo
 */
- (void)updateStoredTransactionWithClientTransactionID:(NSString * _Nonnull)clientTransactionID
                                     andCardholderInfo:(IMSCardholderInfo *_Nullable)cardholderInfo
                                    andTransactionNote:(NSString *_Nullable)transactionNote
                                        andIsCompleted:(bool)isCompleted
                             andDisplayNotesAndInvoice:(bool)displayNotesAndInvoice
                                     andSignatureImage:(NSString* _Nullable)signatureImage
                                             andOnDone:(UpdateTransactionHandler _Nonnull)handler;

/**
 * Deletes the Stored transaction corresponding to the stored client transaction ID that sent as a parameter
 *
 *  @param storedClientTransactionID referenceID.
 *  @param handler          the callback used to indicate that the
 *                          delete stored transaction request is processed
 */
-(void)deleteStoredTransactionWithClientTransactionID:(NSString* _Nonnull)storedClientTransactionID
                                            andOnDone:(DeleteStoredTransactionHandler _Nonnull) handler;

/*!
 *  Indicates if store and forward is enabled for the user
 *
 *  @return True - if it is enabled,
 *          False - otherwise
 */
-(bool)isEnabled;

/*!
 * Processes the cash payment by storing it in the local database for reporting later.
 * Note: Cash transaction cannot be voided, use delete instead (deleteStoredTransactionWithClientTransactionID: andOnDone:)
 *
 *  @param transactionRequest CashSaleTransactionRequest object
 *  @param handler            the callback used to indicate that the
 *                            cash sale transaction request has been processed
 *  @see IMSCashSaleTransactionRequest
 */
- (void)processStoreAndForwardCashTransaction:(IMSStoreAndForwardCashSaleTransactionRequest * _Nonnull)transactionRequest andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 *  Stores the customer's email address for a specific stored transaction ID (passed in as a parameter), so that
 *  the receipt automatically gets sent to the customer's email, when the transaction is uploaded.
 *  @param clientTransactionID  referenceID
 *  @param emailAddress                customer's email address at which receipt needs to be sent
 *  @param handler              the callback used to indicate that the
 *                              store receipt for stored transaction request has been processed
 */
- (void)storeReceiptForStoredTransaction:(NSString * _Nonnull)clientTransactionID andEmail:(NSString * _Nonnull)emailAddress andOnDone:(StoreReceiptForStoredTransactionHandler  _Nonnull)handler;

/*!
 * Processes the token enrollement by getting card information from the card reader
 * and then storing it in the local database for authorization later.
 *
 *  @param transactionRequest IMSStoreAndForwardTokenEnrollmentTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param handler            the callback used to indicate that the
 *                            token enrollment request has been processed
 *  @see IMSStoreAndForwardTokenEnrollmentTransactionRequest
 */
- (void)processStoreAndForwardTokenEnrollmentWithCardReader:(IMSStoreAndForwardTokenEnrollmentTransactionRequest * _Nonnull)transactionRequest
                                          andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                                  andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the token enrollment by geting card information by asking the user to enter it directly
 * on the reader and then storing it in the local database for authorization later.
 *  @param transactionRequest IMSStoreAndForwardKeyedTokenEnrollmentTransactionRequest object.
 *  @param progressHandler progress handler
 *  @param handler            the callback used to indicate that the
 *                            keyed token enrollment transaction request has been processed
 *  @see IMSStoreAndForwardKeyedTokenEnrollmentTransactionRequest
 */
-(void)processStoreAndForwardKeyedTokenEnrollmentWithCardReader:(IMSStoreAndForwardKeyedTokenEnrollmentTransactionRequest* _Nonnull) transactionRequest
                                              andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                                      andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
* Processes the credit payment by getting card information from the card reader
* and then storing it in the local database for authorization later.
* Supports EMV transactions if allowed in the processor profile.
 *  @param transactionRequest            IMSStoreAndForwardCreditSaleTransactionRequest object.
 *  @param progressHandler               progress handler
 *  @param applicationSelectionHandler   application selection handler
 *  @param handler                       the callback used to indicate that the
*                                       credit card sale transaction request has been processed
 *  @see IMSStoreAndForwardCreditSaleTransactionRequest
*/
-(void)processEmvStoreAndForwardCreditSaleTransactionWithCardReader:(IMSStoreAndForwardCreditSaleTransactionRequest* _Nonnull) transactionRequest
                                               andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                            andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                                       andOnDone:(TransactionOnDone _Nonnull)handler;


/*!
 * Processes the credit auth payment by getting card information from the card reader
 * and then storing it in the local database for authorization later.
 * Supports EMV transactions if allowed in the processor profile.
 *  @param transactionRequest           IMSStoreAndForwardCreditAuthTransactionRequest object
 *  @param progressHandler              progress handler
 *  @param applicationSelectionHandler  application selection handler
 *  @param handler                      the callback used to indicate that the
 *                                      credit card auth transaction request has been processed
 *  @see IMSStoreAndForwardCreditAuthTransactionRequest
 */
-(void)processEmvStoreAndForwardCreditAuthTransactionWithCardReader:(IMSStoreAndForwardCreditAuthTransactionRequest* _Nonnull) transactionRequest
                                               andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                            andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                                       andOnDone:(TransactionOnDone _Nonnull)handler;

/*!
 * Processes the token enrollement by getting card information from the card reader
 * and then storing it in the local database for authorization later.
 * Supports EMV transactions if allowed in the processor profile.
 *
 *  @param transactionRequest IMSStoreAndForwardTokenEnrollmentTransactionRequest object
 *  @param progressHandler    progress handler
 *  @param applicationSelectionHandler  application selection handler
 *  @param handler            the callback used to indicate that the
 *                            token enrollment request has been processed
 *  @see IMSStoreAndForwardTokenEnrollmentTransactionRequest
 */
- (void)processEmvStoreAndForwardTokenEnrollmentWithCardReader:(IMSStoreAndForwardTokenEnrollmentTransactionRequest * _Nonnull)transactionRequest
                                          andUpdateProgress:(UpdateProgress _Nonnull)progressHandler
                                       andSelectApplication:(ApplicationSelectionHandler _Nonnull)applicationSelectionHandler
                                                  andOnDone:(TransactionOnDone _Nonnull)handler;
@end
