//
//  CAAddPhoto.m
//  Ipoca_Card
//
//  Created by iMac on 14-6-20.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import "CAAddPhoto.h"

@implementation CAAddPhoto

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)addPhotoChooseIsHasImage:(BOOL)hasImageBool
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:(hasImageBool?CA_IMAGE_EDIT_TIP:CA_IMAGE_ADD) delegate:self cancelButtonTitle:ActionSheet_CancelButton destructiveButtonTitle:nil otherButtonTitles:ActionSheet_LibraryButton, ActionSheet_CameraButton,(hasImageBool?CA_IMAGE_EDIT:nil),(hasImageBool?CA_IMAGE_DELETE:nil), nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == ([actionSheet numberOfButtons] - 1))
    {
        return;
    }
    
    if (buttonIndex == 0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            return;
        }
        [self imagepickercontrollerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else if (buttonIndex == 1)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            return;
        }
        [self imagepickercontrollerWithType:UIImagePickerControllerSourceTypeCamera];
     }
    else if (buttonIndex == 2)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:CAEditImageNotification object:@(_photoIndex)];
    }
    else if (buttonIndex == 3)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:CADeleteImageNotification object:@(_photoIndex)];
    }
    
}

- (void)imagepickercontrollerWithType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    [_viewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (pickImage.size.width >kImageSize|| pickImage.size.height >kImageSize) {
        pickImage = [pickImage TransformtoSize:CGSizeMake(kImageSize, kImageSize)];
    }
    if (pickImage) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CAUpLoadImageNotification object:@[pickImage,@(_photoIndex)]];
    }
    [_viewController dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_viewController dismissViewControllerAnimated:YES completion:nil];
}


@end
