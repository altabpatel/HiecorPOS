/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

/*!
 * This object represents security question.
 */

@interface IMSSecurityQuestion : NSObject

/*!
 * The question id.
 */

@property (nonatomic) NSInteger questionId;

/*!
 * The question.
 */

@property (nonatomic, strong) NSString *question;

/*!
 * Answer to a question.
 */

@property (nonatomic, strong) NSString *answer;



- (id) initWithQuestionId:(NSInteger)questionID andQuestion:(NSString *)question andAnswer:(NSString *)answer;

- (id) initWithQuestionID:(NSInteger)questionID andAnswer:(NSString *)answer;

@end
