//
//  CALoginViewController.m
//  Ipoca_Card
//
//  Created by iMac on 14-6-20.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import "CALoginViewController.h"
#import "CAContributeViewController.h"

#define kEmailStoreKey @"user_email"
#define loginDataStoreKey @"user_data"

@interface CALoginViewController ()<UITextFieldDelegate,CAContributeViewControllerDelegate>
{
    IBOutlet UITextField *emailTextf;
    IBOutlet UITextField *passwordTextf;
    CANetEngine *netEngine;
}
@end

@implementation CALoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *emailString = [[NSUserDefaults standardUserDefaults]objectForKey:kEmailStoreKey];
    emailTextf.text = [CAUtils isNullObject:emailString defaultValue:@""];
    passwordTextf.text = @"";
    [emailTextf becomeFirstResponder];
    
//    emailTextf.text = @"bp@bp.nearly.jp";
//    emailTextf.text = @"media_bar@bp.nearly.jp";
//    passwordTextf.text = @"ipoca_0707";
}

-(IBAction)login:(id)sender
{
    if (!emailTextf.text || [emailTextf.text isEqualToString:@""]) {
        [emailTextf becomeFirstResponder];
        return;
    }else if (!passwordTextf.text || [passwordTextf.text isEqualToString:@""]){
        [passwordTextf becomeFirstResponder];
        return;
    }
    
    [emailTextf resignFirstResponder];
    [passwordTextf resignFirstResponder];
    
    __weak __typeof(&*self)weakSelf = self;
    netEngine = nil;
    netEngine = [[CANetEngine alloc]init];
    [netEngine requestWithURL:LOGIN_URL
                       Params:@{@"email":emailTextf.text,@"password":passwordTextf.text}
                   HttpMothed:CA_GET
                   isHttpForm:NO
                      Success:^(NSDictionary *dictionary) {
                              __strong __typeof(weakSelf)strongSelf = weakSelf;
                             if ([[dictionary objectForKey:@"is_success"] isEqualToString:@"1"]) {
                                 CAContributeViewController *conVC = [[CAContributeViewController alloc]initWithNibName:@"CAContributeViewController" bundle:nil];
                                 conVC.dataDic = dictionary;
                                 conVC.delegate = strongSelf;
//                                 [strongSelf presentViewController:conVC animated:YES completion:nil];
                                 [strongSelf.navigationController pushViewController:conVC animated:YES];
                                 [[NSUserDefaults standardUserDefaults]setObject:dictionary forKey:loginDataStoreKey];
                                 [[NSUserDefaults standardUserDefaults]setObject:emailTextf.text forKey:kEmailStoreKey];
                                 [[NSUserDefaults standardUserDefaults]synchronize];
                             }else{
                                 CAALERT(CA_LOGIN_ACCOUNT_ERROR);
                             }
                        }
                        Error:^(NSError *error) {
                                 CAALERT(CA_LOGIN_ACCOUNT_ERROR);
                        }
     ];
}


#pragma mark-------textfield delegate-------------

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 2;
    textField.layer.borderColor = [UIColor orangeColor].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 0;
    textField.layer.borderColor = [UIColor clearColor].CGColor;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == emailTextf) {
        return [passwordTextf becomeFirstResponder];
    }
    return [passwordTextf resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [emailTextf resignFirstResponder];
    [passwordTextf resignFirstResponder];
}

#pragma mark --CAContributeViewControllerDelegate------
- (void)onDismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [netEngine cancelConnection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
