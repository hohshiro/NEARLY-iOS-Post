//
//  CAUtils.h
//  Ipoca_Card
//
//  Created by chen on 14-10-3.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CAEditImageNotification;
extern NSString *const CAUpLoadImageNotification;
extern NSString *const CADeleteImageNotification;

@interface CAUtils : NSObject

+ (NSString*)devicePlatform;
+ (NSString*)isNullObject:(NSString*)object defaultValue:(NSString*)objectValue;
+ (BOOL)judgeStartDate:(NSArray*)startDateList EndDate:(NSArray*)endDateList;
+ (NSDate*)currentDate;
@end
