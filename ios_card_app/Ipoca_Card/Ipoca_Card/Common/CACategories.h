//
//  CACategories.h
//  Ipoca_Card
//
//  Created by iMac on 14-6-20.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAAppDelegate.h"
@interface CACategories : NSObject

+ (CAAppDelegate *)sharedAppDelegate;
@end

@interface NSArray (NullReplacement)
- (NSDictionary *)arrayByReplacingNullsWithBlanks;
@end

@interface NSDictionary (JRAdditions)
- (NSDictionary *)dictionaryByReplacingNullsWithStrings;
@end

