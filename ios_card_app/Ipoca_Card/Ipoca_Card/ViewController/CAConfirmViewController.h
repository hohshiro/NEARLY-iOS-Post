//
//  CAConfirmViewController.h
//  Ipoca_Card
//
//  Created by ipoca_ohshiro on 2015/04/04.
//  Copyright (c) 2015年 ___cxy___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAConfirmViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet NSMutableDictionary *data;

@property (strong, nonatomic) IBOutlet UILabel *card_title;
@property (strong, nonatomic) IBOutlet UILabel *scshop_name;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
