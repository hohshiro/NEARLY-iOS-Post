//
//  UIImage+CAScale.m
//  Ipoca_Card
//
//  Created by chen on 14/12/2.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import "UIImage+CAScale.h"

@implementation UIImage (CAScale)

-(UIImage *)TransformtoSize:(CGSize)newSize
{
    CGFloat widthRatio = newSize.width/self.size.width;
    CGFloat heightRatio = newSize.height/self.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(self.size.width*heightRatio,self.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(self.size.width*widthRatio,self.size.height*widthRatio);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
