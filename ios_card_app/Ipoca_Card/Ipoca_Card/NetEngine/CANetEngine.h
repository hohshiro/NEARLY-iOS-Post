//
//  CANetEngine.h
//  Ipoca_Card
//
//  Created by iMac on 14-6-20.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CASuccessBlock)(NSDictionary *dictionary);
typedef void (^CAErrorBlock)(NSError *error);

@interface CANetEngine : NSObject<NSURLConnectionDataDelegate>

-(void) requestWithURL:(NSString*)urlStr
                Params:(NSDictionary*)params
            HttpMothed:(NSString*)httpMethod
            isHttpForm:(BOOL)isForm
               Success:(CASuccessBlock)successBlock
                 Error:(CAErrorBlock)errorBlock;
-(void) cancelConnection;
@end
