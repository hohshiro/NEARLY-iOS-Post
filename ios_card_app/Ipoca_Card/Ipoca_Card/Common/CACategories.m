//
//  CACategories.m
//  Ipoca_Card
//
//  Created by iMac on 14-6-20.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import "CACategories.h"

@implementation CACategories

static CAAppDelegate *sharedAppDelegate = nil;

//
+ (CAAppDelegate *)sharedAppDelegate
{
    if (!sharedAppDelegate) {
        sharedAppDelegate = (CAAppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return sharedAppDelegate;
}
@end


@implementation NSArray (NullReplacement)

- (NSArray *)arrayByReplacingNullsWithBlanks  {
    NSMutableArray *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    for (int idx = 0; idx < [replaced count]; idx++) {
        id object = [replaced objectAtIndex:idx];
        if (object == nul) [replaced replaceObjectAtIndex:idx withObject:blank];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced replaceObjectAtIndex:idx withObject:[object dictionaryByReplacingNullsWithStrings]];
        else if ([object isKindOfClass:[NSArray class]]) [replaced replaceObjectAtIndex:idx withObject:[object arrayByReplacingNullsWithBlanks]];
        else if (![object isKindOfClass:[NSString class]]) [replaced replaceObjectAtIndex:idx withObject:[NSString stringWithFormat:@"%@",object]]; //cast to string type
    }
    return [replaced copy];
}

@end

@implementation NSDictionary (JRAdditions)

- (NSDictionary *)dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if (object == nul) [replaced setObject:blank forKey:key];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced setObject:[object dictionaryByReplacingNullsWithStrings] forKey:key];
        else if ([object isKindOfClass:[NSArray class]]) [replaced setObject:[object arrayByReplacingNullsWithBlanks] forKey:key];
        else if (![object isKindOfClass:[NSString class]]) [replaced setObject:[NSString stringWithFormat:@"%@",object] forKey:key]; //cast to string type
    }
    return [NSDictionary dictionaryWithDictionary:[replaced copy]];
}

@end

