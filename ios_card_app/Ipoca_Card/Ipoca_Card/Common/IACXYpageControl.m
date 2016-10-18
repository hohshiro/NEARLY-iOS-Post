//
//  IACXYpageControl.m
//  ipoca
//
//  Created by cxy on 13-9-24.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "IACXYpageControl.h"

@implementation IACXYpageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _currentImage = [UIImage imageNamed:@"page1.png"];
        _defaultImage = [UIImage imageNamed:@"page2.png"];
    }
    return self;
}

-(void) updateDots

{
       for (int i=0; i<[self.subviews count]; i++) {
        
        UIView* bgView = [self.subviews objectAtIndex:i];
        
        UIImageView* dot = [[UIImageView alloc]initWithFrame:CGRectMake(-2,-2, 12, 12)];
        dot.tag = 100+i;
        [bgView addSubview:dot];
        
        if (i==self.currentPage)
            dot.image=_currentImage;
        else
            dot.image=_defaultImage;
     }
    
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
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
