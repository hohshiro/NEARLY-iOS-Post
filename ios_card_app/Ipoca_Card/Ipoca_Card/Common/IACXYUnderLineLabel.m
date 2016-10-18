//
//  IACXYUnderLineLabel.m
//  ipoca
//
//  Created by cxy on 13-9-24.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import "IACXYUnderLineLabel.h"

@implementation IACXYUnderLineLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeBottomLeft;
        _lineLocation = self.frame.size.height;
    }
    return self;
}

-(void) setUnderlineColor:(UIColor *)underlineColor
{
   _underlineColor = underlineColor; 
}
-(void) setShouldUnderLine:(BOOL)shouldUnderLine
{
    _shouldUnderLine = shouldUnderLine;
    if (_shouldUnderLine) {
        [self setup];
    }
}
-(void) setHighlightColor:(UIColor *)highlightColor
{
    _highlightColor = highlightColor;
}
- (void)setup
{
    [self setUserInteractionEnabled:TRUE];
    _actionView = [[UIControl alloc] initWithFrame:self.bounds];
    [_actionView setBackgroundColor:[UIColor clearColor]];
    [_actionView addTarget:self action:@selector(appendHighlightedColor) forControlEvents:UIControlEventTouchDown];
    [_actionView addTarget:self
                    action:@selector(removeHighlightedColor)
          forControlEvents:UIControlEventTouchCancel |
     UIControlEventTouchUpInside |
     UIControlEventTouchDragOutside |
     UIControlEventTouchUpOutside];
    [self addSubview:_actionView];
    [self sendSubviewToBack:_actionView];
}
- (void)drawRect:(CGRect)rect
{

    [super drawRect:rect];
    if (_shouldUnderLine) {
     
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGSize fontSize =[self.text sizeWithFont:self.font
                                        forWidth:self.frame.size.width
                                   lineBreakMode:NSLineBreakByTruncatingTail];
        
        CGContextSetStrokeColorWithColor(ctx, _underlineColor.CGColor);  // set as the text's color
        CGContextSetLineWidth(ctx, 2.0f);
        
        CGPoint leftPoint = CGPointMake(0,
                                        _lineLocation);
        CGPoint rightPoint = CGPointMake(fontSize.width,
                                         _lineLocation);
        CGContextMoveToPoint(ctx, leftPoint.x, leftPoint.y);
        CGContextAddLineToPoint(ctx, rightPoint.x, rightPoint.y);
        CGContextStrokePath(ctx);
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    [_actionView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)appendHighlightedColor
{
    self.backgroundColor = _highlightColor;
}

- (void)removeHighlightedColor
{
    self.backgroundColor = [UIColor clearColor];
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
