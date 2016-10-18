//
//  DesUtil.h
//  RootViewController
//
//  Created by XmL on 13-3-19.
//  Copyright (c) 2013年 XmL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesUtil : NSObject
/**
 DES encrypt
 */
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

/**
 DES decrypt
 */
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key;
@end
