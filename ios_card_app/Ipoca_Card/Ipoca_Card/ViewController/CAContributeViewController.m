//
//  CAContributeViewController.m
//  Ipoca_Card
//
//  Created by iMac on 14-6-20.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#import "CAContributeViewController.h"
#import "CAAddPhoto.h"
#import <AviarySDK/AviarySDK.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CAAviarySDK.h"
#import "CAConfirmViewController.h"

#define kEditAlertTag 10000
#define kMakeAlertTag 100
#define kMakeDoneAlertTag 200
#define kDATEINTERVALAlertTag 300
#define kMaxPriceBit 12

static NSInteger pickerIndex = -1;

@interface CAContributeViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,AFPhotoEditorControllerDelegate>
{
    IBOutlet UIView *infoAlertView;
    IBOutlet UIView *infoSubView;
    IBOutlet UILabel *infoAlertLabel;
    
    IBOutlet UIScrollView *scrollView;
    //
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *campaignLabel;
    
    //
    IBOutlet UIButton *photoBtn0;
    IBOutlet UIButton *photoBtn1;
    IBOutlet UIButton *photoBtn2;
    IBOutlet UIButton *photoBtn3;
    
    //
    IBOutlet UIButton *productTypeRadio;
    IBOutlet UIButton *newsTypeRadio;
    
    //
    IBOutlet UIView *bgView1;
    IBOutlet UILabel *bussLabel0;
    IBOutlet UILabel *bussLabel1;
    IBOutlet UILabel *bussLabel2;
    IBOutlet UITextField *bussTextf0;
    IBOutlet UITextField *bussTextf1;
    IBOutlet UITextField *bussTextf2;
    IBOutlet UIButton *bussBtn0;
    IBOutlet UIButton *bussBtn1;
    IBOutlet UIButton *bussBtn2;
    IBOutlet UIImageView *arrowImageView0;
    IBOutlet UIImageView *arrowImageView1;
    IBOutlet UIImageView *arrowImageView2;
    //
    IBOutlet UITextView *infoTextf0;
    IBOutlet UITextView *infoTextf1;
    
    //
    IBOutlet UITextField *infoTextf2;
    IBOutlet UITextField *infoTextf3;
    
    //
    IBOutlet UITextField *dateTextf0;
    IBOutlet UITextField *dateTextf1;
    IBOutlet UIButton *dateBtn0;
    IBOutlet UIButton *dateBtn1;
    
    //
    IBOutlet UIButton *cardNullRadio;
    IBOutlet UIButton *percentRadio;
    IBOutlet UIButton *discountRadio;
    IBOutlet UIButton *couponRadio;
    
    IBOutlet UILabel  *percentLabel;
    IBOutlet UILabel  *discountLabel;
    IBOutlet UILabel  *couponLabel;
    
    //
    IBOutlet UIButton *tagBtn9;
    
    //
    IBOutlet UIButton *cardDiscountRadio;
    IBOutlet UIButton *hurryRadio;
    
    IBOutlet UIButton *makeBtn;
    
    IBOutlet UIView *productLaterBgView;
    
    UIButton *typeLastRadio;
    UIButton *priceLastRadio;
    UIButton *tagLastBtn;
    UIButton *hurryLastRadio;
    
    NSString *typeScOrShop;
    CGFloat offset;
    
    UIPickerView  *pickerView;
    UIDatePicker *datePicker;
    UIToolbar *toolbar;
    
    CAAddPhoto *caPhoto;
    
    NSInteger pickerComponent;
    
    NSMutableArray *hoursList;
    NSMutableArray *minsList;
    
    NSDate *startDate;
    NSDate *endDate;
    
    NSString *startYMD;
    NSString *startHour;
    NSString *startMin;
    
    NSString *endYMD;
    NSString *endHour;
    NSString *endMin;
    
    NSDictionary *dataDictionary;
    NSArray *mainBussList;
    NSArray *subBussList;
    NSArray *categoriesList;
    
    NSString *mainBuss_id;
    NSString *subBuss_id;
    NSString *categories_id;
    
    NSMutableDictionary *photoDic;
    
    CANetEngine *netEngine;
    NSDictionary *params;
    
    NSDate *date1;
    
    
    UIButton *category0Btn;
    UIButton *categoryLastBtn;
}

@end

@implementation CAContributeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pickerComponent = 0;
        date1 = [CAUtils currentDate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    photoBtn0.imageView.contentMode = UIViewContentModeScaleAspectFit;
    photoBtn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    photoBtn2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    photoBtn3.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    infoAlertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    infoSubView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    [[UIApplication sharedApplication].keyWindow addSubview:infoAlertView];
    infoAlertLabel.text = INFO_DESCRIPTION_TEXT;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upLoadImage:) name:CAUpLoadImageNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editImage:) name:CAEditImageNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteImage:) name:CADeleteImageNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    photoDic = [[NSMutableDictionary alloc]init];
    
    hoursList = [[NSMutableArray alloc]init];
    minsList = [[NSMutableArray alloc]init];
    
    for (int i=0; i<24; i++) {
        [hoursList addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    for (int i=0; i<60; i++) {
        [minsList addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    [self addPickerAndToorBar];
    [self setInitData];
    [self reSetFrame];
}

#pragma -mark  IBAction

- (IBAction)onDismiss:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    // 通知センターの削除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CAUpLoadImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CAEditImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CAUpLoadImageNotification object:nil];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(onDismissViewController:)]) {
//        [self.delegate onDismissViewController:self];
//    }
}

- (IBAction)onTypeRadio:(UIButton*)sender
{
    if (typeLastRadio == productTypeRadio){
        couponRadio.enabled = NO;
        [self onPriceRadio:cardNullRadio];
    } else {
        couponRadio.enabled = YES;
    }
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    typeLastRadio.selected = NO;
    typeLastRadio = sender;
}

- (IBAction)onPriceRadio:(UIButton*)sender
{
    if (sender.selected) {
        return;
    }
    
    sender.selected = !sender.selected;
    priceLastRadio.selected = NO;
    priceLastRadio = sender;
    
    // 優先ラベル設定
    if(cardNullRadio.selected == YES){
        [self onHurryRadio:hurryRadio];
    }else{
        
        if(couponRadio.selected || percentRadio.selected || discountRadio.selected == YES){
            [self onHurryRadio:cardDiscountRadio];
            hurryRadio.enabled = NO;
        } else {
            [self onHurryRadio:cardDiscountRadio];
        }
    }
    
}

- (IBAction)onHurryRadio:(UIButton*)sender
{
    // 優先ラベル表示設定
    [self setPriorityRadio];

    if (sender.selected) {
        return;
    }
    
    sender.selected = !sender.selected;
    hurryLastRadio.selected = NO;
    hurryLastRadio = sender;
}

- (IBAction)onHideInfoView:(id)sender
{
    infoAlertView.hidden = YES;
}

- (IBAction)onInfoDescription:(id)sender
{
    
    infoAlertView.hidden = NO;
//     infoAlertView
    CAALERT(INFO_DESCRIPTION_TEXT);
}

-(IBAction)tagBtnClick:(UIButton*)sender
{
    if (sender.selected) {
        return;
    }
    
    sender.selected = !sender.selected;
    tagLastBtn.selected = NO;
    tagLastBtn = sender;
    
    // 優先ラベル設定
    if(tagBtn9.selected == YES){
        [self onHurryRadio:cardDiscountRadio];
    }else{
        if(priceLastRadio != cardNullRadio){
            hurryRadio.enabled = NO;
        } else {
            [self onHurryRadio:cardDiscountRadio];
            hurryRadio.selected = YES;
        }
        
    }
}

-(IBAction)dateBtnClick:(UIButton*)sender
{
    pickerComponent = 2;
    if (sender == dateBtn0) {
        pickerIndex = 3;
        [self showPickerToolBar];
    }
    if (sender == dateBtn1) {
        pickerIndex = 4;
        [self showPickerToolBar];
    }
    
    [pickerView reloadAllComponents];
    
    NSInteger row0 = [hoursList indexOfObject:pickerIndex == 3?startHour:endHour];
    NSInteger row1 = [minsList indexOfObject:pickerIndex == 3?startMin:endMin];
    [pickerView selectRow:row0 inComponent:0 animated:YES];
    [pickerView selectRow:row1 inComponent:1 animated:YES];
}

-(IBAction)photoBtnClick:(UIButton*)sender
{
    [self hideFirstResponder:nil];
    caPhoto = [[CAAddPhoto alloc]init];
    caPhoto.viewController = self;
    caPhoto.photoIndex = sender.tag - 10;
    BOOL isHasImageBool = YES;
    if ([UIImagePNGRepresentation(sender.currentImage) isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"addphoto.png"])]) {
        isHasImageBool = NO;
    }
    [caPhoto addPhotoChooseIsHasImage:isHasImageBool];
}

-(IBAction)bussBtnClick:(UIButton*)sender
{
    if (sender == bussBtn0) {
        pickerIndex = 0;
    }
    if (sender == bussBtn1) {
        pickerIndex = 1;
    }
    if (sender == bussBtn2) {
        pickerIndex = 2;
    }
    pickerComponent = 1;
    [self showPickerToolBar];
    [pickerView reloadAllComponents];
}

-(IBAction)hideFirstResponder:(id)sender
{
    [self hidePickerToolBar];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

-(IBAction)makeBtnClick:(id)sender
{
    // date
    NSString *start_y_m_d  = [dateTextf0.text substringToIndex:10];
    NSString *start_h      = [dateTextf0.text substringWithRange:NSMakeRange(11, 2)];
    NSString *start_i      = [dateTextf0.text substringFromIndex:14];
    
    NSString *end_y_m_d    = [dateTextf1.text substringToIndex:10];
    NSString *end_h        = [dateTextf1.text substringWithRange:NSMakeRange(11, 2)];
    NSString *end_i        = [dateTextf1.text substringFromIndex:14];
    
    // adminデータ
    NSDictionary *adminDic = [_dataDic objectForKey:@"admin_data"];
    NSString *admin_id = [CAUtils isNullObject:[adminDic objectForKey:@"admin_id"] defaultValue:@"0"];
    NSString *admin_manage_target_id = [CAUtils isNullObject:[adminDic objectForKey:@"admin_manage_target_id"] defaultValue:@""];
    NSString *admin_nickname = [CAUtils isNullObject:[adminDic objectForKey:@"admin_nickname"] defaultValue:@""];
    NSString *admin_type =  [CAUtils isNullObject:[adminDic objectForKey:@"admin_type"] defaultValue:@""];
    NSString *sc_name = [CAUtils isNullObject:[adminDic objectForKey:@"sc_name"] defaultValue:@""];
    NSString *sc_tag  = [CAUtils isNullObject:[adminDic objectForKey:@"sc_tag"] defaultValue:@"0"];
    NSString *shop_name = [CAUtils isNullObject:[adminDic objectForKey:@"shop_name"] defaultValue:@""];
    NSString *shop_tag = [CAUtils isNullObject:[adminDic objectForKey:@"shop_tag"] defaultValue:@"0"];
    NSString *is_supper_pass = [CAUtils isNullObject:[adminDic objectForKey:@"is_supper_pass"] defaultValue:@"0"];

    NSString *sub_business_type = [_dataDic objectForKey:@"sub_business_type_id"];
    NSString *card_hurry_label = [NSString stringWithFormat:@"%@",@(tagLastBtn.tag)];
    // 記事種類
    NSString *is_news_type = @"0";
    if (typeLastRadio == productTypeRadio) {
        is_news_type  = @"0";
    } else {
        is_news_type  = @"1";
    }
    
    // ラベルの優先度
    NSString *card_label_priority = @"1";
    if (hurryLastRadio == hurryRadio) {
        card_label_priority = @"1";
    }else{
        card_label_priority = @"0";
    }
    
    // お得ラベルの表示
    NSString *discount_label = @"2";
    if (priceLastRadio == percentRadio) {
        discount_label = @"0";
    }else if(priceLastRadio == discountRadio){
        discount_label = @"1";
    }else if(priceLastRadio == couponRadio){
        discount_label = @"3";
    }else{
        discount_label = @"2";
    }
    
    NSString *card_category_id  = [CAUtils isNullObject:categories_id defaultValue:@"0"];
    NSString *sub_business_type_id = [CAUtils isNullObject:subBuss_id defaultValue:@"0"];
    if([admin_type isEqualToString:@"3"] || [admin_type isEqualToString:@"4"]){
        sub_business_type_id =sub_business_type;
    }
    
    // タイトル
    NSString *title = [infoTextf0.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // 本文
    NSString *contents = [infoTextf1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 金額項目
    NSString *card_price   = infoTextf2.text;
    NSString *card_baika   = infoTextf3.text;

    // 割引額
    NSString *discount_amount = @"";
    
    // 割引率
    NSString *discount_per = @"";

    if (card_price.length > 0 && card_baika.length > 0 && [card_price doubleValue] > [card_baika doubleValue]) {
        discount_amount  = [NSString stringWithFormat:@"%@",@([card_price longLongValue] - [card_baika longLongValue])];
        discount_per  = [NSString stringWithFormat:@"%@",@((NSInteger)(100*([card_price doubleValue] - [card_baika doubleValue])/[card_price doubleValue]))];
    }
    
    // 販売価格
    NSString *price = [card_price stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // 売価
    NSString *selling_price = [card_baika stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *card_model_number = @"";
    NSString *card_manager_memo = @"";
    NSString *card_status = @"1";
    
    // Post_type の内容をversionCodeと同じな値に設定する。
    NSString *post_type = kLOCALVERSION;
    
    // データ設定
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"admin_id"] = admin_id;
    dic[@"admin_manage_target_id"] = admin_manage_target_id;
    dic[@"admin_nickname"] = admin_nickname;
    dic[@"admin_type"] = admin_type;
    dic[@"sc_name"] = sc_name;
    dic[@"sc_tag"] = sc_tag;
    dic[@"shop_name"] = shop_name;
    dic[@"shop_tag"] = shop_tag;
    dic[@"is_supper_pass"] = is_supper_pass;
    dic[@"start_y_m_d"] = start_y_m_d;
    dic[@"start_h"] = start_h;
    dic[@"start_i"] = start_i;
    dic[@"end_y_m_d"] = end_y_m_d;
    dic[@"end_h"] = end_h;
    dic[@"end_i"] = end_i;
    dic[@"is_news_type"] = is_news_type;
    dic[@"title"] = title;
    dic[@"contents"] = contents;
    dic[@"price"] = price;
    dic[@"selling_price"] = selling_price;
    dic[@"card_label_priority"] = card_label_priority;
    dic[@"discount_label"] = discount_label;
    dic[@"discount_amount"] = [discount_amount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dic[@"discount_per"] = [discount_per stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dic[@"hurry_label"] = card_hurry_label;
    dic[@"card_category_id"] = card_category_id;
    dic[@"sub_business_type_id"] = sub_business_type_id;
    dic[@"photoDic"] = photoDic;
    dic[@"card_model_number"] = card_model_number;
    dic[@"card_manager_memo"] = card_manager_memo;
    dic[@"card_status"] = card_status;
    dic[@"post_type"] = post_type;
    
    // 入力チェック後
    if(![self validate:dic]){
        // 確認画面へ遷移
        CAConfirmViewController *confirmVC = [[CAConfirmViewController alloc]initWithNibName:@"CAConfirmViewController" bundle:nil];
        confirmVC.data = dic;
        [self.navigationController pushViewController:confirmVC animated:YES];
    };

}

-(BOOL)validate:(NSDictionary *)dic
{
    // ログイン時間チェック
    if (ABS([date1 timeIntervalSinceDate:[CAUtils currentDate]]) >  kDATEINTERVAL) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CA_LOGIN_OUTTIME delegate:self cancelButtonTitle:CA_OK otherButtonTitles:nil, nil];
        alert.tag = kDATEINTERVALAlertTag;
        [alert show];
        return true;
    }
    
    BOOL titleBool = (!dic[@"title"] || [dic[@"title"] isEqualToString:@""]);
    BOOL dateBool  = [CAUtils judgeStartDate:@[[dic[@"start_y_m_d"] substringToIndex:4],
                                                [dic[@"start_y_m_d"] substringWithRange:NSMakeRange(5,2)],
                                                [dic[@"start_y_m_d"] substringFromIndex:8],
                                                dic[@"start_h"],
                                                dic[@"start_i"]]
                                        EndDate:@[[dic[@"end_y_m_d"] substringToIndex:4],
                                                [dic[@"end_y_m_d"] substringWithRange:NSMakeRange(5, 2)],
                                                [dic[@"end_y_m_d"] substringFromIndex:8],
                                                dic[@"end_h"],
                                                dic[@"end_i"]]];
    NSString *alert0 = @"";
    NSString *alert1 = @"";
    NSString *alert2 = @"";

    if (0 == photoDic.count) {
        alert0 = CA_NO_IMAGE;
    }
    
    if (titleBool) {
        alert1 = CA_NO_TITLE;
    }
    
    if (!dateBool) {
        alert2 = CA_DATE_ALERT;
    }
    if (0 == photoDic.count || titleBool || !dateBool) {
        NSString *alertStr = [NSString stringWithFormat:@"%@%@%@",alert0,alert1,alert2];
        CAALERT(alertStr);
        return true;
    }
    
    return false;
}

#pragma mark --alert delegate -------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (kDATEINTERVALAlertTag == alertView.tag && 0 == buttonIndex) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onDismissViewController:)]) {
            date1 = [CAUtils currentDate];
            [self.delegate onDismissViewController:self];
        }
    }
    if (kMakeDoneAlertTag == alertView.tag && 0 == buttonIndex) {
         date1 = [CAUtils currentDate];
         [self setInitData];
    }
    if (kMakeAlertTag == alertView.tag && 1 == buttonIndex) {
        [self request:params];
    }
    if ((alertView.tag - kEditAlertTag) >=0 && (alertView.tag - kEditAlertTag) <4   && 1 == buttonIndex) {
        NSInteger photoIndex = alertView.tag - kEditAlertTag;
        [[NSNotificationCenter defaultCenter]postNotificationName:CAEditImageNotification object:@(photoIndex)];
    }
}

#pragma mark ------make request------------------
- (void)request:(NSDictionary*)param
{
    netEngine = nil;
    netEngine = [[CANetEngine alloc]init];
    __weak typeof(&*self) weakSelf = self;
    [netEngine requestWithURL:CARD_SAVE
                       Params:param
                   HttpMothed:CA_POST
                   isHttpForm:YES
                      Success:^(NSDictionary *dictionary) {
                              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CA_CARD_MADE_SUCCESS delegate:weakSelf cancelButtonTitle:CA_OK otherButtonTitles:nil, nil];
                              alert.tag = kMakeDoneAlertTag;
                              [alert show];
                        }
                        Error:^(NSError *error) {
                              CAALERT(CA_CARD_MADE_FAILED);
                        }
     ];
}

-(void)setInitData
{
    dataDictionary = nil;
    dataDictionary = [[NSDictionary alloc]initWithDictionary:_dataDic];
   
    mainBussList = [dataDictionary objectForKey:@"main_business_types"];
    subBussList = [dataDictionary objectForKey:@"sub_business_types"];
    categoriesList = [dataDictionary objectForKey:@"categories"];
    
    mainBuss_id = @"0";
    subBuss_id  = @"0";
    categories_id = @"0";

    
    typeScOrShop = [[dataDictionary objectForKey:@"admin_data"]objectForKey:@"admin_type"];
    if ([typeScOrShop isEqualToString:@"2"]) { //sc
        titleLabel.text = [[dataDictionary objectForKey:@"admin_data"]objectForKey:@"sc_name"];
    }else{
        titleLabel.text = [[dataDictionary objectForKey:@"admin_data"]objectForKey:@"shop_name"];
        [self categorieBtnClick:category0Btn];
    }
    campaignLabel.text = [NSString stringWithFormat:@"%@%@",[[dataDictionary objectForKey:@"admin_data"]objectForKey:@"admin_nickname"],CAMPAIGN_TEXT];
    
    for (int i=0; i<4; i++) {
        UIButton *photoBtn = (UIButton*)[scrollView viewWithTag:10+i];
        [photoBtn setImage:[UIImage imageNamed:@"addphoto.png"] forState:UIControlStateNormal];
    }
    [photoDic removeAllObjects];
    
    
    if (mainBussList.count > 0) {
         mainBuss_id = [[mainBussList lastObject]objectForKey:@"main_business_type_id"];
         bussTextf0.text = [[mainBussList lastObject]objectForKey:@"main_business_type_name"];
    }
    if (subBussList.count > 0) {
        subBuss_id  = [[subBussList  objectAtIndex:0]objectForKey:@"sub_business_type_id"];
        bussTextf1.text = [[subBussList  objectAtIndex:0]objectForKey:@"sub_business_type_name"];
    }
    if (categoriesList.count > 0) {
        categories_id = [[categoriesList objectAtIndex:0]objectForKey:@"category_id"];
        bussTextf2.text = [[categoriesList objectAtIndex:0]objectForKey:@"category_name"];
    }
    
    [self onTypeRadio:productTypeRadio];
//    [self onHurryRadio:hurryRadio];
    [self onPriceRadio:cardNullRadio];
    [self tagBtnClick:tagBtn9];
    
    discountRadio.enabled = NO;
    percentRadio.enabled = NO;
    couponRadio.enabled = YES;
    discountLabel.text = @"値引き金額： --- 円";
    percentLabel.text = @"割引率：--- ％";
    
    infoTextf0.text = @"";
    infoTextf1.text = @"";
    infoTextf2.text = @"";
    infoTextf3.text = @"";
    
    infoTextf0.layer.borderColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    infoTextf0.layer.borderWidth  = 1.0;
    infoTextf0.layer.cornerRadius = 5.0;
    
    infoTextf1.layer.borderColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    infoTextf1.layer.borderWidth  = 1.0;
    infoTextf1.layer.cornerRadius = 5.0;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    startDate = [NSDate date];
    endDate = [NSDate dateWithTimeIntervalSinceNow:kENDDATEINTERVAL];
    
    dateTextf0.text = [formatter stringFromDate:startDate];;
    dateTextf1.text = [formatter stringFromDate:endDate];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    startYMD = [formatter stringFromDate:startDate];
    endYMD = [formatter stringFromDate:endDate];
    
    [formatter setDateFormat:@"HH"];
    startHour = [NSString stringWithFormat:@"%@",[formatter stringFromDate:startDate]];
    endHour   = [NSString stringWithFormat:@"%@",[formatter stringFromDate:endDate]];
    
    [formatter setDateFormat:@"mm"];
    startMin = [NSString stringWithFormat:@"%@",[formatter stringFromDate:startDate]];
    endMin  = [NSString stringWithFormat:@"%@",[formatter stringFromDate:endDate]];
    
    [scrollView scrollRectToVisible:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
}



-(void)addPickerAndToorBar
{
    pickerView = [[UIPickerView alloc]init];
    pickerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, kKeyboardHeight);
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pickerView];
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.frame = CGRectMake(0, ScreenHeight, 230, kKeyboardHeight);
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja-JP"]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setDate:[NSDate date]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIBarButtonItem *cancelBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChoose)];
    UIBarButtonItem *spaceBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
     UIBarButtonItem *doneBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChoose)];
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 30)];
    toolbar.backgroundColor = [UIColor whiteColor];
    toolbar.items = @[cancelBar,spaceBar,doneBar];
    [self.view addSubview:toolbar];
}

-(void)datePickerValueChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if (3 == pickerIndex) {
        startDate = [datePicker date];
        startYMD = [dateFormatter stringFromDate:[datePicker date]];
    }
    if (4 == pickerIndex) {
        endDate = [datePicker date];
        endYMD = [dateFormatter stringFromDate:[datePicker date]];
    }
}

-(void)doneChoose
{
    NSInteger row0 = [pickerView selectedRowInComponent:0];
    if (0 == pickerIndex || 1 == pickerIndex) {
        NSDictionary *param;
        if (0 == pickerIndex) {
            mainBuss_id = [[mainBussList objectAtIndex:row0]objectForKey:@"main_business_type_id"];
            bussTextf0.text = [[mainBussList objectAtIndex:row0]objectForKey:@"main_business_type_name"];
            param = @{@"main_business_type_id":mainBuss_id,@"sub_business_type_id":@"0"};
        }else{
            subBuss_id = [[subBussList objectAtIndex:row0] objectForKey:@"sub_business_type_id"];
            bussTextf1.text = [[subBussList objectAtIndex:row0]objectForKey:@"sub_business_type_name"];
             param = @{@"main_business_type_id":@"0",@"sub_business_type_id":subBuss_id};
        }
        netEngine = nil;
        netEngine = [[CANetEngine alloc]init];
        [netEngine requestWithURL:CHANGE_BUESSINE Params:param HttpMothed:CA_GET isHttpForm:NO Success:^(NSDictionary *dictionary) {
            dataDictionary = dictionary;
            if (0 == pickerIndex) {
                subBussList = [dataDictionary objectForKey:@"sub_business_types"];
                if (subBussList.count > 0) {
                    subBuss_id  = [[subBussList objectAtIndex:0]objectForKey:@"sub_business_type_id"];
                    bussTextf1.text = [[subBussList objectAtIndex:0]objectForKey:@"sub_business_type_name"];
                }else{
                    subBuss_id = @"0";
                    bussTextf1.text = @"";
                }
               
            }
            categoriesList = [dataDictionary objectForKey:@"categories"];
            if (categoriesList.count > 0) {
                categories_id  = [[categoriesList objectAtIndex:0]objectForKey:@"category_id"];
                bussTextf2.text = [[categoriesList objectAtIndex:0]objectForKey:@"category_name"];
            }else{
                bussTextf2.text = @"";
                categories_id = @"0";
            }
            
        } Error:^(NSError *error) {
            
        }];
    }else if (2 == pickerIndex){
        categories_id = [[categoriesList objectAtIndex:row0]objectForKey:@"category_id"];
        bussTextf2.text = [[categoriesList objectAtIndex:row0]objectForKey:@"category_name"];
    }else if (3 == pickerIndex){
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        startHour = [hoursList objectAtIndex:row0];
        startMin = [minsList objectAtIndex:row1];
        dateTextf0.text = [NSString stringWithFormat:@"%@ %@:%@",startYMD,startHour,startMin];
    }else if(4 == pickerIndex){
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        endHour = [hoursList objectAtIndex:row0];
        endMin = [minsList objectAtIndex:row1];
        dateTextf1.text = [NSString stringWithFormat:@"%@ %@:%@",endYMD,endHour,endMin];
    }
    [self hidePickerToolBar];
}

-(void)cancelChoose
{
    [self hidePickerToolBar];
}

-(void)showPickerToolBar;
{
    CGRect dframe = datePicker.frame;
    CGRect vframe = pickerView.frame;
   
    if (1 == pickerComponent) {
        [scrollView scrollRectToVisible:CGRectMake(0, offset-300 + pickerIndex*60, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
        dframe.origin.y = ScreenHeight;
        vframe.origin.x = 0;
        vframe.size.width = ScreenWidth;
    }else if(2 == pickerComponent){
        [scrollView scrollRectToVisible:CGRectMake(0, offset+610, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
        dframe.origin.y = ScreenHeight - kKeyboardHeight;
        vframe.origin.x  = datePicker.frame.size.width-10;
        vframe.size.width = ScreenWidth - datePicker.frame.size.width+10;
        
        if (3 == pickerIndex) {
            [datePicker setDate:startDate];
        }else if(4 == pickerIndex){
            [datePicker setDate:endDate];
        }
    }
    
    CGRect tframe = toolbar.frame;
    tframe.origin.y = ScreenHeight - kKeyboardHeight - tframe.size.height;
    vframe.origin.y = ScreenHeight - kKeyboardHeight;
    [UIView animateWithDuration:0.3 animations:^{
        datePicker.frame = dframe;
        pickerView.frame = vframe;
        toolbar.frame = tframe;
    }];
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

-(void)hidePickerToolBar
{
    CGRect dframe = datePicker.frame;
    CGRect vframe = pickerView.frame;
    CGRect tframe = toolbar.frame;
    
    dframe.origin.y = ScreenHeight;
    vframe.origin.x = 0;
    vframe.origin.y = ScreenHeight;
    vframe.size.width = ScreenWidth;
    tframe.origin.y = ScreenHeight;
    
    [UIView animateWithDuration:0.3 animations:^{
        datePicker.frame = dframe;
        pickerView.frame = vframe;
        toolbar.frame = tframe;
    }];
}

-(void)setPriorityRadio
{
    cardDiscountRadio.enabled = YES;
    hurryRadio.enabled = YES;
    
    if(cardNullRadio.selected == YES){
        // お得ラベル=なし
        cardDiscountRadio.enabled = NO;
        
        if(tagBtn9.selected == YES){
            // あおりラベル=なし、お得ラベル=なし
            hurryRadio.enabled = NO;
        }else{
            // あおりラベル!=なし、お得ラベル=なし
        }
    }else{
        if(tagBtn9.selected == YES){
            // お得ラベル!=なし、あおりラベル=なし
            hurryRadio.enabled = NO;
        }else{
            // お得ラベル!=なし、あおりラベル!=なし
        }
    }
}

-(void)reSetFrame
{
    AdaptionIOS7;
    float margin = 20;
    if (IOS7Later) {
        margin = 0;
    }

    CGRect frame = scrollView.frame;
    frame.size.height = ScreenHeight - 64 - margin;
    scrollView.frame = frame;
    
    
    if ([typeScOrShop isEqualToString:@"2"]) {  //sc
        offset = 630;
    }else{ //shop
        
        offset = 630-bgView1.frame.size.height+((categoriesList.count+1)/2 * (30+12)+ 50);
        frame = bgView1.frame;
        frame.size.height = [self bgView1HeightForCategories:categoriesList];;
        bgView1.frame = frame;
        
        frame = productLaterBgView.frame;
        frame.origin.y = bgView1.frame.origin.y + bgView1.frame.size.height;
        productLaterBgView.frame = frame;
    }
    scrollView.contentSize = CGSizeMake(ScreenWidth,productLaterBgView.frame.origin.y +productLaterBgView.frame.size.height);
}

- (CGFloat)bgView1HeightForCategories:(NSArray*)categories
{
    bussLabel0.hidden = YES;
    bussTextf0.hidden = YES;
    bussBtn0.hidden   = YES;
    bussLabel1.hidden = YES;
    bussTextf1.hidden = YES;
    bussBtn1.hidden   = YES;
    bussLabel2.hidden = YES;
    bussTextf2.hidden = YES;
    bussBtn2.hidden   = YES;

    arrowImageView0.hidden = YES;
    arrowImageView1.hidden = YES;
    arrowImageView2.hidden = YES;
    
    UIButton *category_btn;
    for (int i=0; i<categories.count; i++) {
        category_btn = [[UIButton alloc]initWithFrame:CGRectMake(12+(i%2)*(144+12), 40+12+(i/2)*(30+12), 144, 30)];
        [category_btn setBackgroundImage:[UIImage imageNamed:@"btn_off.png"] forState:UIControlStateNormal];
        [category_btn setBackgroundImage:[UIImage imageNamed:@"btn_on.png"] forState:UIControlStateSelected];
        [category_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [category_btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [category_btn setTitle:categories[i][@"category_name"] forState:UIControlStateNormal];
        category_btn.tag = [categories[i][@"category_id"] integerValue];
        [category_btn addTarget:self action:@selector(categorieBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView1 addSubview:category_btn];
        
        if (0 == i) {
            category0Btn = category_btn;
            [self categorieBtnClick:category0Btn];
        }
    }
    
    return category_btn.frame.origin.y + category_btn.frame.size.height + 12;
}

- (void)categorieBtnClick:(UIButton*)sender
{
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    categoryLastBtn.selected = NO;
    categoryLastBtn = sender;
    categories_id = [NSString stringWithFormat:@"%@",@(categoryLastBtn.tag)];
}

#pragma mark ----notification functions---------------------

-(void)upLoadImage:(NSNotification*)noti
{
    NSArray *notiArr = [noti object];
    UIImage *photoImage = (UIImage*)notiArr[0];
    NSInteger photoIndex = [notiArr[1]integerValue];
    
    UIButton *photoBtn = (UIButton*)[scrollView viewWithTag:10+photoIndex];
    [photoBtn setImage:photoImage forState:UIControlStateNormal];
    
//    NSData  *photoData = UIImagePNGRepresentation(photoBtn.currentBackgroundImage);
    NSData  *photoData = UIImageJPEGRepresentation(photoImage, kPresentation);

    if (photoData) {
        [photoDic setObject:photoData forKey:[NSString stringWithFormat:@"%@",@(photoIndex+1)]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CA_IMAGE_PS_MESSAGE delegate:self cancelButtonTitle:CA_CANCEL otherButtonTitles:CA_OK, nil];
        alert.tag = kEditAlertTag + photoIndex;
        [alert show];
    }
    
}

- (void)editImage:(NSNotification*)noti
{
    NSInteger photoIndex = [[noti object]integerValue];
    UIButton *photoBtn = (UIButton*)[scrollView viewWithTag:10+photoIndex];
    UIImage  *photoImage = photoBtn.currentImage;
    CAAviarySDK *aviarySDK = [[CAAviarySDK alloc]init];
    aviarySDK.delegate = self;
    aviarySDK.photoIndex = photoIndex;
    [aviarySDK launchPhotoEditorWithImage:photoImage highResolutionImage:nil];
}

- (void)deleteImage:(NSNotification*)noti
{
    NSInteger photoIndex = [[noti object]integerValue];
    UIButton *photoBtn = (UIButton*)[scrollView viewWithTag:10+photoIndex];
    [photoBtn setImage:[UIImage imageNamed:@"addphoto.png"] forState:UIControlStateNormal];
    [photoDic removeObjectForKey:[NSString stringWithFormat:@"%@",@(photoIndex+1)]];
}

#pragma mark----------picker delegate--------------

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return pickerComponent;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (2 == pickerComponent) {
        if (0 == component) {
            return hoursList.count;
        }
        return minsList.count;
    }
    if (0 == pickerIndex) {
        return mainBussList.count;
    }else if (1 == pickerIndex){
        return subBussList.count;
    }else if (2 == pickerIndex){
        return categoriesList.count;
    }
    return 0;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (2 == pickerComponent) {
        if (0 == component) {
            return [hoursList objectAtIndex:row];
        }
        return [minsList objectAtIndex:row];
    }
    
    if (0 == pickerIndex) {
        return [[mainBussList  objectAtIndex:row] objectForKey:@"main_business_type_name"];
    }else if (1 == pickerIndex){
        return [[subBussList  objectAtIndex:row] objectForKey:@"sub_business_type_name"];
    }else if (2 == pickerIndex){
        return [[categoriesList  objectAtIndex:row] objectForKey:@"category_name"];
    }
    return @"";
}


#pragma mark------textview delegate ---------

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.layer.borderWidth = 3;
    textView.layer.borderColor = [UIColor orangeColor].CGColor;
    if (textView == infoTextf0) {
        [scrollView scrollRectToVisible:CGRectMake(0, offset, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
    }else if(textView == infoTextf1){
        [scrollView scrollRectToVisible:CGRectMake(0, offset+100, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.layer.borderWidth = 0;
    textView.layer.borderColor = [UIColor clearColor].CGColor;
}
#pragma mark------textfield delegate--------

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 2;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = [UIColor orangeColor].CGColor;
    [self hidePickerToolBar];
    [scrollView scrollRectToVisible:CGRectMake(0, offset+350, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 0;
    textField.layer.cornerRadius = 0;
    textField.layer.borderColor = [UIColor clearColor].CGColor;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   if(textField == infoTextf2) {
        return [infoTextf3 becomeFirstResponder];
    }else if(textField == infoTextf3) {
        return [infoTextf3 resignFirstResponder];
    }
    return NO;
}

- (void)TextFieldTextDidChange:(NSNotification*)noti
{
    UITextField *textField = noti.object;
    if (textField == infoTextf2 || textField == infoTextf3) {
//        cardDiscountRadio.selected = YES;
//        hurryRadio.selected = NO;
        if (infoTextf2.text.length >0 && infoTextf3.text.length >0 && ([infoTextf2.text floatValue] > [infoTextf3.text floatValue])) {
            discountRadio.enabled = YES;
            percentRadio.enabled = YES;
            
            NSInteger subPrice = [infoTextf2.text integerValue] - [infoTextf3.text integerValue];
            CGFloat percent = 100 * subPrice / [infoTextf2.text floatValue];
            discountLabel.text = [NSString stringWithFormat:@"値引き金額：%@ 円",@(subPrice)];
            percentLabel.text = [NSString stringWithFormat:@"割引率：%@ ％",@((NSInteger)percent)];
        }else{
            [self onPriceRadio:cardNullRadio];
            discountRadio.enabled = NO;
            percentRadio.enabled = NO;
            discountLabel.text = @"値引き金額： --- 円";
            percentLabel.text = @"割引率：--- ％";
        }
    }else{
//        cardDiscountRadio.selected = NO;
//        hurryRadio.selected = NO;
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if (textField == infoTextf2 || textField == infoTextf3) {
        NSInteger strLength = textField.text.length - range.length + string.length;
    
        NSString* str = NUMBERS_DOT;
        if (strLength == 1) {
             str = PURE_NUMBERS;
        }
         NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:str] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest || strLength >= kMaxPriceBit || (([textField.text rangeOfString:@"."]).length>0 && [string isEqualToString:@"."])) {
            return NO;
        }
    }
    return YES;
}

#pragma mark Photo Editor Delegate Methods
// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    NSInteger photoIndex = editor.view.tag;
    UIButton *photoBtn = (UIButton*)[scrollView viewWithTag:10+photoIndex];
    [photoBtn setImage:image forState:UIControlStateNormal];
    NSData  *photoData = UIImageJPEGRepresentation(image, kPresentation);
    
    if (image.size.width >kImageSize|| image.size.height >kImageSize) {
        image = [image TransformtoSize:CGSizeMake(kImageSize, kImageSize)];
    }
    if (photoData) {
        [photoDic setObject:photoData forKey:[NSString stringWithFormat:@"%@",@(photoIndex+1)]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
