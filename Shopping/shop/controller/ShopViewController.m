//
//  ShopViewController.m
//  Shopping
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "ShopViewController.h"
#import "MyNavitaionItem.h"
#import "MyNavigationBar.h"

@interface ShopViewController ()
@property(nonatomic,strong) MyNavigationBar * bar;
@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMyNavigationBar];
}

/** 加载导航 */
-(void)loadMyNavigationBar
{
   self.bar = [self createMyNavigationBarWithBgImageName:nil andTitle:@"购物袋" andTitleView:nil andLeftItems:nil andRightItems:nil andSEL:@selector(btnClick:) andClass:self];
}
/** navigationBar按钮点击方法 */
-(void)btnClick:(UIButton *)btn
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
