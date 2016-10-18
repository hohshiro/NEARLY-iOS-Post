//
//  CAAviarySDK.h
//  Ipoca_Card
//
//  Created by chen on 14-10-7.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AviarySDK/AviarySDK.h>

@interface CAAviarySDK : NSObject<UINavigationControllerDelegate>

@property (nonatomic,weak)id delegate;
@property (nonatomic,assign)NSInteger photoIndex;

- (void)launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage;
@end
