/*
 * Copyright (c) 2015 - 2018 All Rights Reserved, Ingenico Inc.
 *
 */

#import <Foundation/Foundation.h>
#import "IMSBaseTokenTransactionRequest.h"
#import "IMSAmount.h"

/*!
 * This class constructs the request for processing token sale transaction
 */

@interface IMSTokenSaleTransactionRequest : IMSBaseTokenTransactionRequest

/*!
 * Constructs a Token sale transaction request with only mandatory fields
 *
 * @param amount               sale amount
 * @param tokenReferenceNumber account reference number for tokenization service. [IMSTokenRequestParameters tokenReferenceNumber]
 * @param tokenIdentifier      token identifier. [IMSTokenResponseParameters tokenIdentifier]
 * @param isCompleted          indicates whether the transaction is completed,
 *                             if true the transaction cannot be updated later
 */
- (id _Nullable) initWithTokenReferenceNumber:(NSString * _Nonnull)tokenReferenceNumber
                           andTokenIdentifier:(NSString * _Nonnull)tokenIdentifier
                                    andAmount:(IMSAmount * _Nonnull)amount
                               andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a Token sale transaction request
 *
 * @param amount                       sale amount
 * @param tokenReferenceNumber         account reference number for tokenization service. [IMSTokenRequestParameters tokenReferenceNumber]
 * @param tokenIdentifier              token identifier. [IMSTokenResponseParameters tokenIdentifier]
 * @param products                     list of products
 * @param clerkID                      ID reference used to associate the transaction with a
 *                                     waiter
 *                                     / clerk /
 *                                     sales associate.
 *                                     The field can be alphanumeric and length cannot exceed 4
 *                                     characters.
 * @param gpsLong                      longitude of the device location
 * @param gpsLat                       latitude of the device location
 * @param transactionGroupID           a unique identifier for a group of transactions, used to link
 *                                     transactions which are related (like split-tender).
 *                                     If not specified in the request, it will be generated and returned in the response.
 *                                     For linked transactions, the value generated from the first response
 *                                     should be submitted with all related transactions.
 * @param transactionNotes             transactionNotes
 * @param merchantInvoiceID            The invoice id from a third party inventory management
 *                                     tool linked to this transaction.
 *                                     Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id
 *                                     should be
 *                                     part of receipt
 * @param customReference              20 digit merchant order number (optional)
 * @param isCompleted                  indicates whether the transaction is completed,
 *                                     if true the transaction cannot be updated later
 */
- (id _Nullable) initWithTokenReferenceNumber:(NSString * _Nonnull)tokenReferenceNumber
                           andTokenIdentifier:(NSString * _Nonnull)tokenIdentifier
                                    andAmount:(IMSAmount * _Nonnull)amount
                                  andProducts:(NSArray * _Nullable)products
                                   andClerkID:(NSString * _Nullable)clerkID
                                 andLongitude:(NSString * _Nullable)gpsLong
                                  andLatitude:(NSString * _Nullable)gpsLat
                        andTransactionGroupID:(NSString * _Nullable)transactionGroupID
                          andTransactionNotes:(NSString * _Nullable)transactionNotes
                         andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
              andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
                           andCustomReference:(NSString * _Nullable)customReference
                               andIsCompleted:(bool) isCompleted;

/*!
 * Constructs a Token sale transaction request
 *
 * @param amount                       sale amount
 * @param tokenReferenceNumber         account reference number for tokenization service. [IMSTokenRequestParameters tokenReferenceNumber]
 * @param tokenIdentifier              token identifier. [IMSTokenResponseParameters tokenIdentifier]
 * @param products                     list of products
 * @param clerkID                      ID reference used to associate the transaction with a
 *                                     waiter
 *                                     / clerk /
 *                                     sales associate.
 *                                     The field can be alphanumeric and length cannot exceed 4
 *                                     characters.
 * @param gpsLong                      longitude of the device location
 * @param gpsLat                       latitude of the device location
 * @param transactionGroupID           a unique identifier for a group of transactions, used to link
 *                                     transactions which are related (like split-tender).
 *                                     If not specified in the request, it will be generated and returned in the response.
 *                                     For linked transactions, the value generated from the first response
 *                                     should be submitted with all related transactions.
 * @param transactionNotes             transactionNotes
 * @param merchantInvoiceID            The invoice id from a third party inventory management
 *                                     tool linked to this transaction.
 *                                     Alphanumeric characters only. Max length: 15 chars
 * @param showNotesAndInvoiceOnReceipt true - if transaction notes and merchant invoice id
 *                                     should be
 *                                     part of receipt
 * @param customReference              20 digit merchant order number (optional)
 * @param isCompleted                  indicates whether the transaction is completed,
 *                                     if true the transaction cannot be updated later
 * @param orderNumber                  Optional numeric field up to 9 digits long that indicates the assigned order number
 */
- (id _Nullable) initWithTokenReferenceNumber:(NSString * _Nonnull)tokenReferenceNumber
                           andTokenIdentifier:(NSString * _Nonnull)tokenIdentifier
                                    andAmount:(IMSAmount * _Nonnull)amount
                                  andProducts:(NSArray * _Nullable)products
                                   andClerkID:(NSString * _Nullable)clerkID
                                 andLongitude:(NSString * _Nullable)gpsLong
                                  andLatitude:(NSString * _Nullable)gpsLat
                        andTransactionGroupID:(NSString * _Nullable)transactionGroupID
                          andTransactionNotes:(NSString * _Nullable)transactionNotes
                         andMerchantInvoiceID:(NSString * _Nullable)merchantInvoiceID
              andShowNotesAndInvoiceOnReceipt:(bool)showNotesAndInvoiceOnReceipt
                           andCustomReference:(NSString * _Nullable)customReference
                               andIsCompleted:(bool) isCompleted
                               andOrderNumber:(NSString * _Nullable)orderNumber;

@end
