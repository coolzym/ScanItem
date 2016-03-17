//
//  ViewController.m
//  ScanItem
//
//  Created by zhang min on 16/3/16.
//  Copyright © 2016年 zhang min. All rights reserved.
//

#import "ViewController.h"
#import "ScannerController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<ScannerControllerDelegate>
{
    ScannerController *scanner;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)click:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textField setEnabled:NO];
}

- (IBAction)click:(UIButton *)sender {
    
    BOOL isCanOpen = [self isRearCameraAvailable];
    
    if (isCanOpen) {
        scanner = [[ScannerController alloc]init];
        [scanner setDelegate:self];
        
        [self presentViewController:scanner animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在隐私-相机中开启摄像头使用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
}

#pragma mark -后面的摄像头是否可用
/**
 *  后面的摄像头是否可用
 *
 *  @return BOOL
 */
- (BOOL) isRearCameraAvailable{
    
    BOOL isflag = YES;
    
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        isflag = NO;
    }
    
    return isflag;
}

/**
 *  得到扫描的数据
 *
 *  @param strCode 二维码或者条形码
 */
-(void)returnCode:(NSString *)strCode
{
    if (strCode) {
        [self.textField setText:strCode];
    }
}

@end
