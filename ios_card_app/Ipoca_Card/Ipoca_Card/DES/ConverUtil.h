//
//  ConverUtil.h
//  RootViewController
//
//  Created by XmL on 13-3-19.
//  Copyright (c) 2013年 XmL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConverUtil : NSObject
/**
 64codeing
 */
+(NSString *)base64Encoding:(NSData*) text;

/**
 byte transfor 16binary
 */
+(NSString *) parseByte2HexString:(Byte *) bytes;

/**
 byte array transfor 16binary
 */
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;

/*
 16binarytransfor NSData array
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString;
@end
