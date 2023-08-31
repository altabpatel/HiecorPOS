//
//  iMagRead.h
//  iMagRead
//
//  Created by wwq on 13-6-10.
//  Copyright (c) 2013年 QunHua. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * CARREAD_MSG_ByteUpdate ; 
extern NSString * CARREAD_MSG_BitUpdate  ;
extern NSString * CARREAD_MSG_Err ;


@interface iMagRead : NSObject

-(void) Start;
-(void) Stop;
@end

