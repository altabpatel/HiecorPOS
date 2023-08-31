/*
 * //////////////////////////////////////////////////////////////////////////////
 * //
 * // Copyright © 2015-2021 Worldline SMB US Inc. All Rights Reserved.
 * //
 * //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

@interface IMSProcessor : NSObject

/*!
 * The name of processor.
 */

@property (readonly) NSString *processorName;

/*!
 * The name of processor profile.
 */

@property (readonly) NSString *processorProfile;

/*!
 * The last modified timestamp of processor profile.
 */

@property (readonly) NSString *processorProfileLastModified;

- (id) initWithProcessorName:(NSString *)processorName
         andProcessorProfile:(NSString *)processorProfile
andProcessorProfileLastModified:(NSString *)processorProfileLastModified;

@end
