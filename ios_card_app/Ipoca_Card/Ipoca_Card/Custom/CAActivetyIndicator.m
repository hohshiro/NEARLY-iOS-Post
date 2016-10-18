//
//  CAActivetyIndicator.m
//  Ipoca_Card
//
//  Created by iMac on 14-6-25.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import "CAActivetyIndicator.h"

@implementation CAActivetyIndicator
{
    IBOutlet UIActivityIndicatorView *indicatorView;
    IBOutlet UIProgressView *progressView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

+ (instancetype)sharesIntance
{
    static CAActivetyIndicator *activetyIndicator = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        activetyIndicator = [[[NSBundle mainBundle]loadNibNamed:@"CAActivetyIndicator" owner:self options:nil]firstObject];
    });
    return activetyIndicator;
}


+ (void)show
{
    [self showProgress:-1];
}

+ (void)showProgress:(float)progress
{
    [[self sharesIntance] setProgressFloat:progress];
    
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows)
    {
        if (window.windowLevel == UIWindowLevelNormal) {
            [window addSubview:[self sharesIntance]];
            break;
        }
    }
}

+ (void)dismiss
{
    [[self sharesIntance] stopAnimating];
}

- (void)setProgressFloat:(float)progress
{
    [indicatorView startAnimating];
    progressView.progress = progress;
}

- (void)stopAnimating
{
    [indicatorView stopAnimating];
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
