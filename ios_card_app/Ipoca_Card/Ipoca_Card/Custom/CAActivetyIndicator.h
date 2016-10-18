//
//  CAActivetyIndicator.h
//  Ipoca_Card
//
//  Created by iMac on 14-6-25.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAActivetyIndicator : UIView

+ (void)show;
+ (void)showProgress:(float)progress;
+ (void)dismiss;
@end
