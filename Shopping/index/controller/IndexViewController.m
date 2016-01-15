//
//  IndexViewController.m
//  Shopping
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "IndexViewController.h"
#import "QrCodeViewController.h"

#import "MyNavitaionItem.h"
#import "MyNavigationBar.h"
#import "HeaderView.h"

#import "IndexFirstModel.h"

#import "InterfaceHeader.h"


#define QrCodeWidth 40


@interface IndexViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,HeaderViewDelegate>
/** 获取全局tabbar */
@property(nonatomic,strong) MyNavigationBar * bar;
/** 主界面tableView */
@property(nonatomic,strong) UITableView * tableView;
/** 主界面tableView数据源 */
@property(nonatomic,strong) NSMutableArray * dataSource;
/** 热门搜索的数据源 */
@property(nonatomic,strong) NSMutableArray * hotDataSource;
/** 搜索文本 */
@property(nonatomic,strong) UITextField * searchTextField;
/** 搜索界面 */
@property(nonatomic,strong) UIView * searchView;
/** 设置搜索的回弹效果 */
@property(nonatomic,strong) UIScrollView * scrollView;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadMyNavigationBar];
    [self loadSearchUI];
    [self loadHomePage];
    [self tableView];
}

#pragma mark -- 数据界面懒加载
/** tableView懒加载 */
-(UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"indexCell"];
        [self.view insertSubview:_tableView atIndex:0];
    }
    return _tableView;
}
/** tableView数据懒加载 */
-(NSMutableArray *)dataSource
{
    if(_dataSource == nil)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/** 查询下view的数据懒加载 */
-(NSMutableArray *)hotDataSource
{
    if(_hotDataSource == nil)
    {
        _hotDataSource = [NSMutableArray array];
    }
    return _hotDataSource;
}

#pragma mark -- 加载UI界面
/** 加载导航 */
-(void)loadMyNavigationBar
{
    MyNavitaionItem *leftItem = [[MyNavitaionItem alloc] init];
    leftItem.itemImageName = @"scaner.png";
    
    MyNavitaionItem * rightItem = [[MyNavitaionItem alloc] init];
    rightItem.itemImageName = @"img_search.png";
    
    self.bar = [self createMyNavigationBarWithBgImageName:nil andTitle:@"SECOO" andTitleView:nil andLeftItems:@[leftItem] andRightItems:@[rightItem] andSEL:@selector(btnClick:) andClass:self];
    /** 设置tabbar不显示在屏幕中 */
//    self.bar.frame = CGRectMake( 0, -64, self.bar.bounds.size.width, self.bar.bounds.size.height);
}
/**
 *  加载搜索界面
 */
-(void)loadSearchUI
{
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 20, SCREEN_WIDTH - QrCodeWidth, 44)];
    _searchTextField.backgroundColor = [UIColor whiteColor];
    _searchTextField.placeholder = @"搜索商品和品牌";
    _searchTextField.font = [UIFont systemFontOfSize:15];
    //是否纠错
    _searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //再次编辑是否清空
    _searchTextField.clearsOnBeginEditing = NO;
    //首字母是否大写
    _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    //无输入内容不能搜索
    _searchTextField.enablesReturnKeyAutomatically = YES;
    //添加取消按钮
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 30, 30);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchCancel"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _searchTextField.rightView = searchBtn;
    _searchTextField.rightViewMode = UITextFieldViewModeAlways;

    [self.view addSubview:_searchTextField];
    //添加搜索下的显示view
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _searchView.userInteractionEnabled = YES;
    [self.view addSubview:_searchView];
    [self loadSearchViewUI];
}
/**
 *  加载搜索下方界面
 */
-(void)loadSearchViewUI
{
    //设置scrollView实现回弹效果
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 63);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.delegate = self;
    [_searchView addSubview:_scrollView];
    //添加View上的显示信息
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(QrCodeWidth, 10, SCREEN_WIDTH - QrCodeWidth, 20)];
    label.text = @"热门搜索";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17];
    [_scrollView addSubview:label];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish) name:Index_Search_URL object:nil];
    [[DownLoadManager sharedDownLoadManager] addDownLoadMessageWithRUL:Index_Search_URL andType:Index_Search_URL];
}
/**
 *  网络数据请求完成布局热门搜索内容
 */
-(void)downLoadFinish
{
    self.hotDataSource = [[DownLoadManager sharedDownLoadManager] getDownLoadData:Index_Search_URL];
    //添加热门搜索按钮
    CGFloat spacing = 15.f;
    for (int i = 0; i < self.hotDataSource.count; i++) {
        int x = i / 3;
        int y = i % 3;
        CGFloat btnW = (SCREEN_WIDTH - 2 * (QrCodeWidth + spacing)) / 3;
        CGFloat btnH = 30;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(QrCodeWidth + (spacing + btnW) * y, 30 + (spacing + btnH) * x + 10 , btnW, btnH);
        btn.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.95f alpha:1.00f];
        [btn setTitle:self.hotDataSource[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
    }
}
/**
 *  加载主界面数据
 */
-(void)loadHomePage
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadHomePage) name:Index_Message_URL object:nil];
    [[DownLoadManager sharedDownLoadManager] addDownLoadMessageWithRUL:Index_Message_URL andType:Index_Message_URL];
}
/**
 *  完成主界面数据加载
 */
-(void)downLoadHomePage
{
    self.dataSource = [[DownLoadManager sharedDownLoadManager] getDownLoadData:Index_Message_URL];

    [self loadHeaderView];
//    for (NSArray * arr in self.dataSource) {
//        for (IndexFirstModel * model in arr) {
//            DLog(@"%@---%@---%@",model.imgUrl,model.mytitle,model.pcdate);
//        }
//        DLog(@"%d",self.dataSource.count);
//    }
    //得到数据后在主线程刷新UI界面
//    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

/** tableView头视图 */
-(void)loadHeaderView
{
    //750*560  750/screen.width = 560/x
    CGFloat headerH = SCREEN_WIDTH * 560 / 750;
    NSMutableArray * imageNames = [NSMutableArray array];
    for (IndexFirstModel * model in self.dataSource.firstObject) {
        [imageNames addObject:model.imgUrl];
    }
    HeaderView * header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerH) andWithImageNames:imageNames];
    self.tableView.tableHeaderView = header;
    header.delegate = self;
}

#pragma mark -- headerView代理
/** 头视图滚动图片的点击事件 */
-(void)headerView:(HeaderView *)headerView didSelectImageView:(NSInteger)selectedImageView
{
    DLog(@"%d",selectedImageView);
}

#pragma mark -- tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"indexCell"];
    return cell;
}

#pragma mark -- scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchTextField resignFirstResponder];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark -- tabbar按钮点击
/** navigationBar按钮点击方法 */
-(void)btnClick:(UIButton *)btn
{
    //左按钮--二维码
    if(btn.tag == 1000)
    {
        [self qrCodeBtnClick];
    }
    //右按钮--搜索
    else
    {
        [self searchBtnClick];
    }
}
/**
 *  左按钮点击事件
 */
-(void)qrCodeBtnClick
{
    QrCodeViewController * vc = [[QrCodeViewController alloc] init];
    vc.QrCodeSuncessBlock = ^(QrCodeViewController * qvc,NSString * successStr)
    {
        NSLog(@"%@",successStr);
        [qvc dismissViewControllerAnimated:YES completion:nil];
    };
    vc.QrCodeFailBlock = ^(QrCodeViewController * qvc)
    {
#warning mark -- 扫描失败要进行的操作
        NSLog(@"FILE");
        [qvc dismissViewControllerAnimated:YES completion:nil];
    };
    /** 取消扫描调用 */
    vc.QrCodeCancleBlock = ^(QrCodeViewController * qvc)
    {
        [qvc dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:vc animated:YES completion:nil];

}
/**
 *  右按钮点击事件
 */
-(void)searchBtnClick
{
    CGRect searchFeild = CGRectMake( QrCodeWidth, 20, SCREEN_WIDTH - QrCodeWidth, 44);
    CGRect searchView = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    [UIView animateWithDuration:0.2 animations:^{
        _searchTextField.frame = searchFeild;
        _searchView.frame = searchView;
    }];
    [_searchTextField becomeFirstResponder];

    self.tabBarController.tabBar.hidden = YES;
}
/**
 *  取消搜索，回到主界面
 *
 *  @param btn 取消搜索按钮
 */
-(void)searchCancelBtn:(UIButton *)btn
{
    CGRect searchFeild = CGRectMake( SCREEN_WIDTH, 20, SCREEN_WIDTH - QrCodeWidth, 44);
    CGRect searchView = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    [UIView animateWithDuration:0.2 animations:^{
        _searchTextField.frame = searchFeild;
        _searchView.frame = searchView;
    }];
    [_searchTextField resignFirstResponder];
    self.tabBarController.tabBar.hidden = NO;
}
/** 热门搜索点击事件 */
-(void)searchBtnClick:(UIButton *)btn
{
    NSLog(@"%d",btn.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
