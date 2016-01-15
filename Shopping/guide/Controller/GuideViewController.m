//
//  GuideViewController.m
//  Shopping
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

#define imageCounts 5

@interface GuideViewController ()<UIScrollViewDelegate>

@end

@implementation GuideViewController
{
    
    UIScrollView * _scrollView;
    UIPageControl * _pageControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackgroundImage];
    [self loadScrollView];
    [self loadPageControl];
}
/**
 *  添加背景图
 */
-(void)loadBackgroundImage
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"guid-background"];
    [self.view addSubview:imageView];
}

#pragma mark --- LoadUI
/**
 *  加载滚动视图
 */
-(void)loadScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * imageCounts, 0);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    for (int i = 0; i<imageCounts;i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"guid-%d.jpg",i+1]];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = image;
        [_scrollView addSubview:imageView];
    }
    
    [self.view addSubview:_scrollView];
}
/**
 *  加载tabbar
 */
-(void)loadTabBar
{
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.tabBar = [[ViewController alloc] init];
    appDelegate.window.rootViewController = appDelegate.tabBar;}

/**
 *  加载pageControl
 */
-(void)loadPageControl
{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 80, SCREEN_WIDTH - 20, 30)];
    _pageControl.numberOfPages = _scrollView.subviews.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.enabled = NO;
    [self.view addSubview:_pageControl];
}
/**
 *  滚动事件
 *
 *  @param scrollView 滚动视图
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = _scrollView.contentOffset.x/SCREEN_WIDTH;
    _pageControl.currentPage = page;
}
/** 超出滚动范围加载tabbar */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_scrollView.contentOffset.x > SCREEN_WIDTH * (imageCounts - 1))
    {
        [self loadTabBar];
    }
}
@end
