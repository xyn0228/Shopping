//
//  QrCodeViewController.h
//  Shopping
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QrCodeViewController : UIViewController

@property (nonatomic, copy) void (^QrCodeCancleBlock) (QrCodeViewController *);//扫描取消
@property (nonatomic, copy) void (^QrCodeSuncessBlock) (QrCodeViewController *,NSString *);//扫描结果
@property (nonatomic, copy) void (^QrCodeFailBlock) (QrCodeViewController *);//扫描失败

@property(nonatomic,copy) NSString * name;

@end
