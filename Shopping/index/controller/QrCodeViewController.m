//
//  QrCodeViewController.m
//  Shopping
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "QrCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

#define QrViewSize 240
/** 扫描框距离屏幕顶部的高度 */
#define TopWidth (SCREEN_HEIGHT - QrViewSize) * 0.5

@interface QrCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,copy) NSString * qrResult;
/** 回话 */
@property(nonatomic,strong) AVCaptureSession * session;
/** 扫描线定时 */
@property(nonatomic,strong) NSTimer * timer;
/** 扫描线 */
@property(nonatomic,strong) UIImageView * scanLine;
/** 读取 */
@property(nonatomic,strong) AVCaptureVideoPreviewLayer * layer;


@end

@implementation QrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareCapture];
    [self PrepareUI];
    [self startScanLineTimer];
    
}
#pragma mark -- 加载界面
/**
 *  添加二维码扫描相关信息
 */
-(void)prepareCapture
{
    NSError * error;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input =[AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if(error)
    {
        DLog(@"%@",error.localizedDescription);
        return;
    }
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描范围
    output.rectOfInterest = CGRectMake((SCREEN_WIDTH - QrViewSize) * 0.5 /SCREEN_WIDTH , TopWidth /SCREEN_HEIGHT, QrViewSize / SCREEN_WIDTH, QrViewSize / SCREEN_HEIGHT);
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率(可选择不同采集率)
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    //添加输入输出流
    if ([_session canAddInput:input])
    {
        [_session addInput:input];
    }
    if([_session canAddOutput:output])
    {
        [_session addOutput:output];
    }
    //设置扫码支持的编码格式（下面为条形码和二维码兼容）
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code];
    //实例化预览图层
    _layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    //设置预览图层的填充方式
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //设置图层大小
    _layer.frame = self.view.layer.bounds;
    //添加到View图层
    [self.view.layer insertSublayer:_layer atIndex:0];
}
/**
 *  加载UI界面
 */
-(void)PrepareUI
{
    //扫描线
    _scanLine = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - QrViewSize) * 0.5, TopWidth, QrViewSize, 10)];
    _scanLine.image = [UIImage imageNamed:@"codeScanLine"];
    [self.view addSubview:_scanLine];
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopWidth)];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //取消按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setFrame:CGRectMake(20, 30, 50, 30)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleBtnlick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, TopWidth, (SCREEN_WIDTH - QrViewSize) * 0.5, (SCREEN_HEIGHT + QrViewSize) * 0.5)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH + QrViewSize) * 0.5, TopWidth, (SCREEN_WIDTH - QrViewSize) * 0.5, (SCREEN_HEIGHT + QrViewSize) * 0.5)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - QrViewSize) * 0.5, (SCREEN_HEIGHT + QrViewSize) * 0.5, QrViewSize, TopWidth)];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"scanTopLeft"];
    
    //左侧的view
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    leftView_image.image = cornerImage;
    [self.view addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"scanTopRight"];
    
    //右侧的view
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    rightView_image.image = cornerImage;
    [self.view addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"scanBottomLeft"];
    
    //底部view
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downView_image.image = cornerImage;
    [self.view addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"scanBottomRight"];
    
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.image = cornerImage;
    [self.view addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, QrViewSize + 20, 60);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:13.0];
    labIntroudction.numberOfLines = 0;
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0,QrViewSize , QrViewSize)];
    scanCropView.center = self.view.center;
    scanCropView.layer.borderColor = [UIColor greenColor].CGColor;
//    scanCropView.layer.borderWidth = 2.0;
    [self.view addSubview:scanCropView];
    
}
/**
 *  开启扫描线的定时器
 */
-(void)startScanLineTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moveScanLine:) userInfo:nil repeats:YES];
    //开始捕获
    [self.session startRunning];
}

#pragma mark -- 计时器方法
/** 定时器扫描线移动 */
-(void)moveScanLine:(NSTimer *)timer
{
    __block CGRect frame = _scanLine.frame;
    
    static BOOL flag = YES;
    
    if (flag)
    {
        
        frame.origin.y = TopWidth;
        
        flag = NO;
        
        [UIView animateWithDuration:0.05 animations:^{
            
            frame.origin.y += 5;

            _scanLine.frame = frame;

        }];
    }
    else
    {
        if (_scanLine.frame.origin.y >= TopWidth)
        {
            if (_scanLine.frame.origin.y >= 385 - 12)
            {
                frame.origin.y = TopWidth;

                _scanLine.frame = frame;
                
                flag = YES;
            }
            else
            {
                
                [UIView animateWithDuration:0.05 animations:^{
                    
                    frame.origin.y += 5;
                    _scanLine.frame = frame;

  
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }

}

#pragma mark -- 取消扫描事件
/** 取消扫描 */
-(void)cancleBtnlick:(UIButton *)btn
{
    [self stopScan];
    if(self.QrCodeCancleBlock)
    {
        self.QrCodeCancleBlock(self);
    }
}
/** 停止定时器和扫描 */
-(void)stopScan
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    [self.session stopRunning];
}

#pragma mark -- 二维码扫描代理
//识别到qrCode并且完成转换调用
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    if(metadataObjects.count > 0)
    {
        [self stopScan];
        AVMetadataMachineReadableCodeObject * code = [metadataObjects objectAtIndex:0];
        if (code.stringValue && ![code.stringValue isEqualToString:@""] &&code.stringValue.length)
        {
            //带有http字样的结果
            if([code.stringValue containsString:@"http"])
            {
                //如果扫描成功，并且得到的扫描结果带有http字符串，回调成功
                if(self.QrCodeSuncessBlock)
                {
                    self.QrCodeSuncessBlock(self,code.stringValue);
                }
            }
            //不带有http字样
            else
            {
                if(self.QrCodeFailBlock)
                {
                    self.QrCodeFailBlock(self);
                }
            }
        }
        //扫描无结果或为空
        else
        {
            if(self.QrCodeFailBlock)
            {
                self.QrCodeFailBlock(self);
            }
        }
        
    }
    //扫描失败
    else
    {
        if(self.QrCodeFailBlock)
        {
            self.QrCodeFailBlock(self);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
