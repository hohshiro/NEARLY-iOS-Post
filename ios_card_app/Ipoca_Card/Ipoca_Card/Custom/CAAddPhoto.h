//
//  CAAddPhoto.h
//  Ipoca_Card
//
//  Created by iMac on 14-6-20.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAAddPhoto : NSObject<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) NSInteger photoIndex;
-(void)addPhotoChooseIsHasImage:(BOOL)hasImageBool;
@end
