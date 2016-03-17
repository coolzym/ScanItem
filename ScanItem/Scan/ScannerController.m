//
//  ScannerController.m
//  qeekashop
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 Pan hong wei. All rights reserved.
//

#import "ScannerController.h"
#import "FourCornerView.h"
#import <AVFoundation/AVFoundation.h>

#define kSquareX 50
@interface ScannerController ()<AVCaptureMetadataOutputObjectsDelegate>//用于处理采集信息的代理
{
    AVCaptureSession * session;//输入输出的中间桥梁
}

//中间矩形的位置和尺寸
@property (assign,nonatomic) CGRect rectangleRect;
//界面尺寸
@property (assign,nonatomic) CGSize pageSize;
//0扫描线往上走，1扫描线往下走
@property (assign,nonatomic) NSInteger flag;

@property (strong,nonatomic) NSTimer *timer;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ScannerController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGSize size = [UIScreen mainScreen].applicationFrame.size;
    size.height += 20;
    self.rectangleRect = CGRectMake(50, (size.height - size.width) / 2 + 50, size.width - 2 * 50, size.width - 2 * 50);
    self.pageSize = size;
    
//    [self.view setUserInteractionEnabled:YES];
    
    [self runScanner];
    
    [self addCoverView];
    [self addScanLine];
    [self addFourCorner];
    
    [self addTimer]; //这个功能就是让在扫描区域中的红线上下移动的功能
}

-(void)runScanner
{
    // Do any additional setup after loading the view, typically from a nib.
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    
    NSError *error;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    NSLog(@"%@",[error localizedDescription]);
    
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode39Code];
    
    output.metadataObjectTypes=@[AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];

    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [session startRunning];
}

#pragma mark -在扫描的上面增加一个view,并且在这个view上空出一个扫描口
-(void)addCoverView
{
    CGSize size = [UIScreen mainScreen].applicationFrame.size;
    size.height += 20;
    
    UIView *v1 = [[UIView alloc]initWithFrame:self.view.bounds];
    
    [v1 setBackgroundColor:[UIColor blackColor]];
    
    [v1 setAlpha:0.8f];
    
    [self.view addSubview:v1];
    
    //通过贝赛尔曲线来切出这个口
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,size.width,size.height)];
    
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kSquareX, (size.height - size.width) / 2 + kSquareX, size.width - 2 * kSquareX, size.width - 2 * kSquareX) cornerRadius:1] bezierPathByReversingPath ]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.path = path.CGPath;
    
    [v1.layer setMask:shapeLayer];
    

    //返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@" 返 回 " forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    
    [button addTarget:self action:@selector(returnpage) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat w = self.pageSize.width - 2 * 20;
    CGFloat h = 40;
    CGFloat x = 20;
    CGFloat y = self.pageSize.height - 40 - 20;
    
    [button setFrame:CGRectMake(x, y, w, h)];
    
    [self.view addSubview:button];
}

#pragma mark -增加扫描线
-(void)addScanLine
{
    UIView *lineView = [[UIView alloc]init];
    
    [lineView setBackgroundColor:[UIColor redColor]];
    
    
    CGFloat w = self.pageSize.width - 2 * kSquareX - 2 * 20;
    CGFloat h = 1;
    CGFloat x = (self.pageSize.width - w) / 2;
    CGFloat y = (self.pageSize.height - h) / 2;
    
    [lineView setFrame:CGRectMake(x, y, w, h)];
    
    [self.view addSubview:lineView];
    
    self.lineView = lineView;
}

#pragma mark -设定timer
-(void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(timerControl) userInfo:nil repeats:YES];
    
    self.flag = 1;
}

#pragma mark -对扫描线的控制
-(void)timerControl
{
    CGPoint point = self.lineView.frame.origin;
    CGSize size = self.lineView.frame.size;
    
    if (self.flag == 1) {
        
        if (point.y >= CGRectGetMaxY(self.rectangleRect) - 16) {
            self.flag = 0;
        }
        else{
            point.y += 2;
        }
    }
    
    if (self.flag == 0) {
        if (point.y <= self.rectangleRect.origin.y + 16) {
            self.flag = 1;
        }
        else {
            point.y -= 2;
        }
    }
    
    [self.lineView setFrame:CGRectMake(point.x,point.y,size.width,size.height)];
}

#pragma mark -添加扫描框中的四个角
-(void)addFourCorner
{
    FourCornerView *corner = [[FourCornerView alloc]init];
    corner.rect = self.rectangleRect;
    
    [corner setFrame:self.rectangleRect];
    
    [corner setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:corner];
}

-(void)returnpage
{
    //关闭扫描，否则再次进入会是黑屏
    [session stopRunning];
    
    session = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -得到扫描的数据
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
//        NSLog(@"%@",metadataObject.stringValue);
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [session stopRunning];
        
        [_delegate returnCode:metadataObject.stringValue];
    }
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
