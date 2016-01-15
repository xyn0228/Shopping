//
//  RootViewController.m
//  Shopping
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "RootViewController.h"
#import "MyNavigationBar.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (MyNavigationBar *)createMyNavigationBarWithBgImageName:(NSString *)bgImageName andTitle:(NSString *)title andTitleView:(UIImageView *)view andLeftItems:(NSArray *)leftItems andRightItems:(NSArray *)rightItems andSEL:(SEL)sel andClass:(id)classObject
{
    MyNavigationBar * myNavigationBar = [[MyNavigationBar alloc] initWithBgImageName:bgImageName andClass:classObject andSEL:sel];
    myNavigationBar.navigationTitle = title;
    myNavigationBar.navigationTitleView = view;
    myNavigationBar.leftItems = leftItems;
    myNavigationBar.rightItems = rightItems;
    [self.view addSubview:myNavigationBar];
    return myNavigationBar;
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
