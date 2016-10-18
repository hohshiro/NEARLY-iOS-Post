//
//  CADefines.h
//  Ipoca_Card
//
//  Created by iMac on 14-6-20.
//  Copyright (c) 2014年 ___cxy___. All rights reserved.
//

#ifndef Ipoca_Card_CADefines_h
#define Ipoca_Card_CADefines_h

// header file
#import "CANetEngine.h"
#import "CACategories.h"
#import "CAActivetyIndicator.h"
#import "UIImage+CAScale.h"

// httpMethod
#define CA_POST @"POST"
#define CA_GET @"GET"
#define CA_DESKEY @"ipocaipo"

// ios local version number
#define kLOCALVERSION @"ios_3"

// date interval 5 hours
#define kDATEINTERVAL 5*60*60

// date intercal two week
#define kENDDATEINTERVAL 14*24*60*60

// url
//#define ServerIP @"192.168.100.100"
//#define ServerIP @"192.168.11.19"
#define ServerIP @"nearly.at"
//#define ServerIP @"ec2-23-21-66-21.compute-1.amazonaws.com"
//#define ServerIP @"ec2-54-163-254-180.compute-1.amazonaws.com"
//#define ServerIP @"192.168.11.24:9888"
#define IS_SSL YES
#define ServerURL [NSString stringWithFormat:@"%@://%@",IS_SSL?@"https":@"http",ServerIP]
#define LOGIN_URL [NSString stringWithFormat:@"%@/%@",ServerURL,@"api/cms_app/login?param="]
#define CHANGE_BUESSINE [NSString stringWithFormat:@"%@/%@",ServerURL,@"api/cms_app/get_categories?param="]
#define CARD_SAVE [NSString stringWithFormat:@"%@/%@",ServerURL,@"api/cms_app/save_new_card?param="]

// size
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define UserImageSize_Width 65
#define kKeyboardHeight 216
#define kImageSize 800
#define kPresentation 0.001
// number
#define NUMBERS_DOT @"0123456789."
#define PURE_NUMBERS @"0123456789"

//color
#define IABackground [UIColor colorWithRed:0.91f green:0.90f blue:0.89f alpha:1.00f]

// debug
#ifdef DEBUG
#    define CALog(...) NSLog(__VA_ARGS__)
#else
#    define CALog(...) /* */
#endif
//#define ALog(...) NSLog(__VA_ARGS__)

// alert
#define CAALERT(theMessage) [[[UIAlertView alloc]initWithTitle:@"" message:theMessage delegate:nil cancelButtonTitle:CA_OK otherButtonTitles:nil, nil]show]

// alert  message
#define CA_OK @"OK"
#define CA_CANCEL @"キャンセル"
#define CA_CARD_MADE @"記事作成"
#define CA_CONFIRM @"はい"
#define CA_NO @"いいえ"

#define CA_DATE_ALERT @"※開始日を終了日の前の日付に設定してください。"
#define CA_NO_TITLE   @"※タイトルを入力してください。\n"
#define CA_NO_IMAGE   @"※写真を一枚以上設定してください。\n"
#define CA_MAKE_TIP   @"記事を作成してよろしいですか？"

#define CA_IMAGE_EDIT_TIP @"操作選択\n画像の添付・編集や削除ができます。以下の操作を選択してください。"
#define CA_IMAGE_ADD @"画像の添付"
#define CA_IMAGE_EDIT @"編集"
#define CA_IMAGE_DELETE @"削除"
#define CA_IMAGE_PS_TITLE @"画像加工"
#define CA_IMAGE_PS_MESSAGE @"この画像の加工処理ができます。加工処理を行いますか？"

#define CA_CARD_MADE_SUCCESS @"記事を作成しました!"
#define CA_CARD_MADE_FAILED @"記事の作成を失敗しました!"

#define CA_NET_ERROR @"ネットワークの状態を再確認した上で、再ログインしてください。 E番号：0000" //code 0000
#define CA_LOGIN_ACCOUNT_ERROR @"\nログインできませんでした。\nE-Mail/パスワードを確認してください。"
#define CA_CONNECT_ERROR @"通信エラーが発生しました。エラー番号：0004" //code 0004
#define CA_LOGIN_OUTTIME @"5時間以上の未使用の状態があるため、再ログインする必要があります。「OK」ボタンをクリックして、再ログインしてください。"
#define CA_MAINTAIN @"ただいまサーバーのメインテナンスを行っています。"


// text
#define INFO_DESCRIPTION_TEXT @"・入力必須項目について\n入力項目に＊がついているものは入力必須となります。\n\n・再ログインについて\nログインして【５時間以上】未使用のままの状態が続きますと、再ログインする必要がありますのでご注意ください。\n\n・価格入力でのSALE扱いについて\n定価より販売価格が低い場合（お値引き販売）は自動的にSALEのタグが付与されます。\n\n・ラベルについて\nSALEラベルは定価より値引き販売した時のみ付けられます。\n\n\n"
#define CAMPAIGN_TEXT @"さんがログイン中"
#define ActionSheet_CancelButton @"キャンセル"
#define ActionSheet_LibraryButton @"ライブラリ"
#define ActionSheet_CameraButton @"カメラ"


// other
#define IOS7Later [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0
#define AdaptionIOS7 if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {\
self.edgesForExtendedLayout = UIRectEdgeNone;\
}
#endif
