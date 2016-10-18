//
//  CAContributeViewController.h
//  Ipoca_Card
//
//  Created by iMac on 14-6-20.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAContributeViewController;
@protocol CAContributeViewControllerDelegate <NSObject>

- (void)onDismissViewController:(UIViewController*)viewController;

@end

@interface CAContributeViewController : UIViewController

@property (nonatomic,weak) id<CAContributeViewControllerDelegate> delegate;
@property (nonatomic,strong) NSDictionary *dataDic;

- (void)setInitData;

@end
