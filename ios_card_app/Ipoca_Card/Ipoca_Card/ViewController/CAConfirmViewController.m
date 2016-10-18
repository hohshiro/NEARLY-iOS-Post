//
//  CAConfirmViewController.m
//  Ipoca_Card
//
//  Created by ipoca_ohshiro on 2015/04/04.
//  Copyright (c) 2015年 ___cxy___. All rights reserved.
//

#import "IACXYpageControl.h"
#import "IACXYUnderLineLabel.h"
#import "CAConfirmViewController.h"
#import "CAContributeViewController.h"

#define loginDataStoreKey @"user_data"

#define kMakeAlertTag 100
#define kMakeDoneAlertTag 200

#define NavbarHeight 70

@interface CAConfirmViewController (){

    IBOutlet UIView *confirmView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIScrollView *imageScrollView;
    IBOutlet UIButton *create;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIView *backView;

    NSMutableDictionary* imagesArray;

    NSInteger page;
    NSInteger fotterAddSize;

    UILabel* validtime;
    IACXYUnderLineLabel* oldPrice;
    UILabel* opl;
    UILabel* npl;
    UILabel* newPrice;
    UILabel* contents;
    
    UIImageView* saleHarImagev;
    UILabel* disHarLable;


    UIButton* nealyBtn;
    
    UIButton* tipL;
    UIButton* tipR;
    
    UIImageView* hurryImage;

    CANetEngine *netEngine;
    NSDictionary *params;
}
@end

@implementation CAConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setConfirmView];
    [self resetFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 *  表示データ設定
 */
-(void)setConfirmView
{
    // スクロールビュー設定
    CGRect frame = scrollView.frame;
    frame.size.height = ScreenHeight;
    scrollView.frame = frame;
    scrollView.contentSize = CGSizeMake(320,ScreenHeight);
    [self.view addSubview:scrollView];
    
    // 記事作成ビュー設定
    confirmView.frame = CGRectMake(0, ScreenHeight-100, 320, 100);
    UIColor *color_ = [UIColor darkGrayColor];
    UIColor *alphaColor_ = [color_ colorWithAlphaComponent:0.90]; //透過率
    confirmView.backgroundColor = alphaColor_;
    
    // 登録用画像データ
    imagesArray = [[NSMutableDictionary alloc]init];
    imagesArray = _data[@"photoDic"];
    
    // 画像ビュー設定
    imageScrollView.frame = CGRectMake(14, 100, 290, 290);
    imageScrollView.contentSize = CGSizeMake(290*imagesArray.count, 290);
    imageScrollView.backgroundColor = [UIColor whiteColor];
    imageScrollView.delegate = self;
    
    for (int i=0; i<imagesArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(290*i,0,290,290)];
        //更新用のバイナリデータ
        imageView.image = [UIImage imageWithData:[imagesArray objectForKey:[NSString stringWithFormat:@"%@",@(i+1)]]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [scrollView addSubview:imageScrollView];
    }
    
    pageControl = [[IACXYpageControl alloc]init];
    pageControl.frame = CGRectMake(120, 365, 80, 20);
    pageControl.numberOfPages = imagesArray.count;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    pageControl.currentPage = 0;
    [scrollView addSubview:pageControl];
    
    // 左右スライドボタン設定
    tipL = [[UIButton alloc]initWithFrame:CGRectMake(17, NavbarHeight+imageScrollView.frame.size.height/2+10, 15, 28)];
    [tipL setBackgroundImage:[UIImage imageNamed:@"tipL.png"] forState:UIControlStateNormal];
    [scrollView addSubview:tipL];
    
    UIButton* l = [[UIButton alloc]initWithFrame:CGRectMake(0, NavbarHeight+imageScrollView.frame.size.height/2, 70,100)];
    l.backgroundColor = [UIColor clearColor];
    [l addTarget:self action:@selector(leftMove) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:l];
    
    tipR = [[UIButton alloc]initWithFrame:CGRectMake(320-36, NavbarHeight+imageScrollView.frame.size.height/2+10, 15, 28)];
    [tipR setBackgroundImage:[UIImage imageNamed:@"tipR.png"] forState:UIControlStateNormal];
    [scrollView addSubview:tipR];
    
    UIButton* r = [[UIButton alloc]initWithFrame:CGRectMake(320-67, NavbarHeight+imageScrollView.frame.size.height/2, 70,100)];
    r.backgroundColor = [UIColor clearColor];
    [r addTarget:self action:@selector(rightMove) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:r];
    
    nealyBtn = [[UIButton alloc]initWithFrame:CGRectMake(260, 350, 35, 35)];
    [nealyBtn setBackgroundImage:[UIImage imageNamed:@"nearly1.png"] forState:UIControlStateNormal];
    [scrollView addSubview:nealyBtn];
    
    if (imagesArray.count <2) {
        tipL.hidden = YES;
        tipR.hidden = YES;
    }
    tipL.hidden = YES;
    
    // 価格設定
    opl = [[UILabel alloc]initWithFrame:CGRectMake(14, 435, 35, 20)];
    opl.backgroundColor = [UIColor clearColor];
    opl.font = [UIFont boldSystemFontOfSize:13];
    opl.text = @"定価:";
    [scrollView addSubview:opl];
    
    oldPrice = [[IACXYUnderLineLabel alloc]initWithFrame:CGRectMake(54, 435, 200, 20)];
    oldPrice.backgroundColor = [UIColor clearColor];
    oldPrice.shouldUnderLine = YES;
    oldPrice.highlightColor = [UIColor clearColor];
    oldPrice.lineLocation = oldPrice.frame.size.height/2;
    oldPrice.font = [UIFont boldSystemFontOfSize:13];
    [scrollView addSubview:oldPrice];
    
    npl = [[UILabel alloc]initWithFrame:CGRectMake(14, 450, 75, 30)];
    npl.backgroundColor = [UIColor clearColor];
    npl.font = [UIFont boldSystemFontOfSize:16];
    npl.text = @"販売価格:";
    [scrollView addSubview:npl];
    
    newPrice = [[UILabel alloc]initWithFrame:CGRectMake(84, 450, 200, 30)];
    newPrice.backgroundColor = [UIColor clearColor];
    newPrice.font = [UIFont boldSystemFontOfSize:16];
    [scrollView addSubview:newPrice];
    
    // コンテンツ設定
    contents = [[UILabel alloc]initWithFrame:CGRectMake(14, 480, 290, 100)];
    contents.backgroundColor = [UIColor clearColor];
    contents.numberOfLines = 0;
    contents.lineBreakMode = NSLineBreakByWordWrapping;
    contents.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:contents];
    
    oldPrice.text = [NSString stringWithFormat:@"¥%@",[self showPrice:_data[@"price"]] ];
    newPrice.text = [NSString stringWithFormat:@"¥%@",[self showPrice:_data[@"selling_price"]]];
    if ([_data[@"price"] isEqualToString:@""] || [_data[@"price"] isEqualToString:@"0"] ||[_data[@"selling_price"] isEqualToString:@""] ||
        [_data[@"selling_price"] isEqualToString:@"0"]) {
        if ([_data[@"price"] isEqualToString:@""] || [_data[@"price"] isEqualToString:@"0"]) {
            [opl removeFromSuperview];
            opl = nil;
            [oldPrice removeFromSuperview];
            oldPrice = nil;
        }
        if ([_data[@"selling_price"] isEqualToString:@""] || [_data[@"selling_price"] isEqualToString:@"0"]) {
            // 販売価格が無い場合
            [opl removeFromSuperview];
            opl = nil;
            [oldPrice removeFromSuperview];
            oldPrice = nil;
            // 定価があれば、販売設定に設定
            newPrice.text = [NSString stringWithFormat:@"¥%@",[self showPrice:_data[@"price"]]];
            
            if ([_data[@"price"] isEqualToString:@""] || [_data[@"price"] isEqualToString:@"0"]) {
                // 定価、販売価格共に設定無しの場合
                [npl removeFromSuperview];
                npl = nil;
                [newPrice removeFromSuperview];
                newPrice = nil;
            }
        }
    }else if ([_data[@"price"] isEqualToString:_data[@"selling_price"]]) {
        // 販売価格のみ表示する場合
        [opl removeFromSuperview];
        opl = nil;
        [oldPrice removeFromSuperview];
        oldPrice = nil;
    }
    
    // ラベル設定
    saleHarImagev = [[UIImageView alloc]init];
    [scrollView addSubview:saleHarImagev];
    
    disHarLable = [[UILabel alloc]init];
    disHarLable.backgroundColor = [UIColor clearColor];
    disHarLable.textColor = [UIColor whiteColor];
    disHarLable.textAlignment = NSTextAlignmentCenter;
    [saleHarImagev addSubview:disHarLable];
    
    hurryImage = [[UIImageView alloc]initWithFrame:CGRectMake(60, NavbarHeight+25, 70, 35)];
    [scrollView addSubview:hurryImage];
    
    NSString* h = _data[@"hurry_label"];
    NSString* discount_label = _data[@"discount_label"];
    
    if([discount_label isEqualToString:@"0"]){
        if (![_data[@"discount_per"] isEqualToString:@""] && ![_data[@"discount_amount"] isEqualToString:@"0"]) {
            saleHarImagev.frame = CGRectMake(scrollView.frame.origin.x+18, NavbarHeight+26, 46, 50);
            saleHarImagev.image = [UIImage imageNamed:@"sale.png"];
            
            disHarLable.frame = CGRectMake(0, 0, 40, 30);
            disHarLable.font = [UIFont systemFontOfSize:30];
            disHarLable.text = _data[@"discount_per"];
        }
    }else if([discount_label isEqualToString:@"1"]){
        if (![_data[@"discount_amount"] isEqualToString:@""]) {
            
            saleHarImagev.frame = CGRectMake(scrollView.frame.origin.x+8, NavbarHeight+40, 80, 50);
            saleHarImagev.image = [UIImage imageNamed:@"IAprice.png"];
            
            disHarLable.frame = CGRectMake(0, 0, 70, 30);
            disHarLable.font = [UIFont systemFontOfSize:18];
            disHarLable.text = [NSString stringWithFormat:@"¥%@",_data[@"discount_amount"]];
        }
    }else if([discount_label isEqualToString:@"3"]){
            saleHarImagev.frame = CGRectMake(scrollView.frame.origin.x+8, NavbarHeight+40, 80, 50);
            saleHarImagev.image = [UIImage imageNamed:@"IAcoupon.png"];
            disHarLable.frame = CGRectMake(0, 0, 40, 30);
    }

    if(![h isEqualToString:@""])
    {
        hurryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"IAx0%ld",(long)[h integerValue]]];
        
        CGRect hRect = hurryImage.frame;
        
        // クーポンラベルとあおりラベルが並存した場合の位置調整
        hRect.origin.x = saleHarImagev.frame.size.width + 20;
        
        hurryImage.frame = hRect;
    }
    
    [self.view addSubview:scrollView];
    [self.view addSubview:confirmView];
    
    self.scshop_name.text =
        [[_data[@"sc_name"] stringByAppendingString:@"/"]stringByAppendingString:_data[@"shop_name"]];
    self.card_title.text = _data[@"title"];

    contents.text = _data[@"contents"];
}

-(void) resetFrame
{
    // 定価、販売価格、コンテンツの表示位置設定
    if(opl != nil && npl != nil){
        fotterAddSize = 150;
    }else if(npl != nil && opl == nil){
        CGRect npl_frame = npl.frame;
        npl_frame.origin.y = 435;
        npl.frame = npl_frame;
        
        CGRect newPrice_frame = newPrice.frame;
        newPrice_frame.origin.y = 435;
        newPrice.frame = newPrice_frame;
        
        // コンテンツ表示位置
        CGRect frame = contents.frame;
        frame.origin.y = 470;
        contents.frame = frame;
        
        fotterAddSize = 150;
    }else{
        // コンテンツ表示位置
        CGRect frame = contents.frame;
        frame.origin.y = 435;
        contents.frame = frame;

        fotterAddSize = 100;
    }
    
    // 本文表示領域設定
    CGSize maximumSize = CGSizeMake(300, CGFLOAT_MAX);
    CGSize size = [contents.text sizeWithFont:contents.font
                                 constrainedToSize:maximumSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
    CGRect textFrame = contents.frame;
    textFrame.size.height = size.height;
    contents.frame = textFrame;

    // 全体の部品をのせるビュー設定
    CGRect backframe = backView.frame;
    backframe.size.height = ScreenHeight+size.height;
    backView.frame = backframe;
    
    // コンテンツスクロールビュー設定
    CGRect frame = scrollView.frame;
    frame.size.height = ScreenHeight;
    scrollView.frame = frame;
    scrollView.contentSize = CGSizeMake(320,ScreenHeight+size.height+100+fotterAddSize);
}

#pragma mark ------make request------------------
- (void)request
{
    params = nil;
    params = @{
               @"card_title":_data[@"title"],
               @"card_content":_data[@"contents"],
               @"card_price":_data[@"price"],
               @"card_baika":_data[@"selling_price"],
               @"start_y_m_d":_data[@"start_y_m_d"],
               @"start_h":_data[@"start_h"],
               @"start_i":_data[@"start_i"],
               @"end_y_m_d":_data[@"end_y_m_d"],
               @"end_h":_data[@"end_h"],
               @"end_i":_data[@"end_i"],
               @"is_news_type":_data[@"is_news_type"],
               @"card_model_number":_data[@"card_model_number"],
               @"discount_label":_data[@"discount_label"],
               @"card_label_priority":_data[@"card_label_priority"],
               @"card_manager_memo":_data[@"card_manager_memo"],
               @"card_status":_data[@"card_status"],
               @"card_hurry_label":_data[@"hurry_label"],
               @"card_discount_per":_data[@"discount_per"],
               @"card_discount_amount":_data[@"discount_amount"],
               @"admin_id":_data[@"admin_id"],
               @"admin_manage_target_id":_data[@"admin_manage_target_id"],
               @"admin_nickname":_data[@"admin_nickname"],
               @"admin_type":_data[@"admin_type"],
               @"sc_name":_data[@"sc_name"],
               @"sc_tag":_data[@"sc_tag"],
               @"shop_name":_data[@"shop_name"],
               @"shop_tag":_data[@"shop_tag"],
               @"card_category_id":_data[@"card_category_id"],
               @"m_sub_business_type":_data[@"sub_business_type_id"],
               @"is_supper_pass":_data[@"is_supper_pass"],
               @"post_type":_data[@"post_type"],
               @"photoImage":_data[@"photoDic"]
            };
    
    netEngine = nil;
    netEngine = [[CANetEngine alloc]init];
    __weak typeof(&*self) weakSelf = self;
    [netEngine requestWithURL:CARD_SAVE
                       Params:params
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

-(NSString*)showPrice:(NSString*)price
{
    NSMutableString* price1 =[[NSMutableString alloc]initWithString: price];
    if (price.length>3)
    {
        for (int i=0; i<(price.length-1)/3; i++)
        {
            [price1 insertString:@"," atIndex:(price.length -(i+1)*3)];
        }
    }
    return price1;
}

- (IBAction)backGesture:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    CGPoint translation = [sender translationInView:sender.view];
//    //閾値を良い感じに調整
//    if (60.0 < translation.x) {
//        [self.navigationController popViewControllerAnimated:YES];
//        [self.view removeGestureRecognizer:sender];
//    }
}

/**
 *  戻るボタン
 */
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  記事作成ボタン
 */
- (IBAction)cardCreate:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CA_MAKE_TIP delegate:self cancelButtonTitle:CA_NO otherButtonTitles:CA_CONFIRM, nil];
    alert.tag = kMakeAlertTag;
    [alert show];
}

-(void) turnPage
{
    int whichPage = (int)pageControl.currentPage;
    page = whichPage;
    [UIView animateWithDuration:0.3 animations:^{
        imageScrollView.contentOffset = CGPointMake(imageScrollView.frame.size.width * whichPage, 0.0f);
    }];
    [pageControl setCurrentPage:whichPage];
    [self tipHide];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = (int)(imageScrollView.contentOffset.x/290);
    pageControl.currentPage = index;
    page = index;
    [self tipHide];
}

-(void) leftMove
{
    if(pageControl.currentPage == 0)
    {
        return;
    }
    int whichPage = (int)pageControl.currentPage - 1;
    page = whichPage;
    [UIView animateWithDuration:0.3 animations:^{
        imageScrollView.contentOffset = CGPointMake(imageScrollView.frame.size.width * whichPage, 0.0f);
    }];
    
    [pageControl setCurrentPage:whichPage];
    [self tipHide];
}

-(void) rightMove
{
    if(pageControl.currentPage == imagesArray.count -1)
    {
        return;
    }
    int whichPage = (int)pageControl.currentPage + 1;
    page = whichPage;
    [UIView animateWithDuration:0.3 animations:^{
        imageScrollView.contentOffset = CGPointMake(imageScrollView.frame.size.width * whichPage, 0.0f);
    }];
    [pageControl setCurrentPage:whichPage];
    [self tipHide];
}

-(void) tipHide
{
    if (page ==0) {
        tipL.hidden = YES;
    }
    else
    {
        tipL.hidden = NO;
    }
    if (page == imagesArray.count - 1) {
        tipR.hidden = YES;
    }
    else
    {
        tipR.hidden = NO;
    }
}

#pragma mark --alert delegate -------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (kMakeAlertTag == alertView.tag && 1 == buttonIndex) {
        [self request];
    }
    if (kMakeDoneAlertTag == alertView.tag && 0 == buttonIndex) {
        CAContributeViewController *contributeVC = [self.navigationController.viewControllers objectAtIndex:1];
        NSDictionary *loginDic = [[NSUserDefaults standardUserDefaults]objectForKey:loginDataStoreKey];
        contributeVC.dataDic = loginDic;
        [contributeVC setInitData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
