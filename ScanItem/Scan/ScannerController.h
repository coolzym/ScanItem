//
//  ScannerController.h
//  qeekashop
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 Pan hong wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScannerControllerDelegate <NSObject>

-(void)returnCode:(NSString *)strCode;

@end

@interface ScannerController : UIViewController

@property (weak,nonatomic) id<ScannerControllerDelegate> delegate;

@end
