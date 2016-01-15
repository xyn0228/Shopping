//
//  ViewController.m
//  Shopping
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "MyTabBar.h"

@interface ViewController ()<MyTabBarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 添加实体控制器 */
    self.viewControllers = [self addViewControllers];
    /** 将自定义tabbar加在系统的tabbar中 */
    MyTabBar * tab = [MyTabBar sharedMyTabBar];
    tab.delegate = self;
    [self.tabBar addSubview:tab];
    
}
/** tabbar代理 */
-(void)tabBarDidSelectBtnFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
}

/** 得到实体控制器 */
-(NSArray *)addViewControllers
{
    NSArray * titles = @[@"IndexViewController",@"GuangViewController",@"ListViewController",@"ShopViewController",@"UserViewController"];
    NSMutableArray * array = [NSMutableArray array];
    for (NSString * str in titles) {
        UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(str) alloc] init]];
        [array addObject:nvc];
    }
    return array;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
