//
//  IACXYUnderLineLabel.h
//  ipoca
//
//  Created by cxy on 13-9-24.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IACXYUnderLineLabel : UILabel
@property (nonatomic,strong) UIControl *actionView;
@property (nonatomic,strong)UIColor* highlightColor;
@property (nonatomic,strong)UIColor* underlineColor;
@property (nonatomic,assign)BOOL shouldUnderLine;
@property (nonatomic,assign)float lineLocation;
- (void)addTarget:(id)target action:(SEL)action;
@end
