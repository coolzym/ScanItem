//
//  FourCornerView.m
//  qeekashop
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 Pan hong wei. All rights reserved.
//

#import "FourCornerView.h"

//单个角的两线间距
#define klineDistance 5
//角的宽度
#define cornerWith 20
//角的高度
#define cornerHeight 20
@implementation FourCornerView

-(void)drawRect:(CGRect)rect
{
    [self leftUpCorner];
    [self rightUpCorner];
    [self rightBottonCorner];
    [self leftBottonCorner];
}

#pragma mark -左上角
-(void)leftUpCorner
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat x = 2;
    CGFloat y = 2;
    
    [path moveToPoint:CGPointMake(x, y)]; //起始点
    [path addLineToPoint:CGPointMake(cornerWith + x, y)];
    [path addLineToPoint:CGPointMake(cornerWith + x, y + klineDistance)];
    [path addLineToPoint:CGPointMake(klineDistance + x, y + klineDistance)];
    [path addLineToPoint:CGPointMake(klineDistance + x,cornerHeight + y)];
    [path addLineToPoint:CGPointMake(x, cornerHeight + y)];
    [path closePath];
    
    //获取当前环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    //保存当前环境，便于以后恢复
    CGContextSaveGState(context);
    
    //将坐标的起点
    CGContextTranslateCTM(context, 0, 0);
    //将当前的颜色变成黄色
    UIColor* fillColor = [UIColor redColor];
    [fillColor setFill];
    //五角星填充为黄色
    [path fill];
    
    CGContextRestoreGState(context);
}

#pragma mark -右上角
-(void)rightUpCorner
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGSize size = self.rect.size;
    
    CGFloat x = size.width - cornerWith - 2;
    CGFloat y = 2;
    
    [path moveToPoint:CGPointMake(x, y)]; //起始点
    [path addLineToPoint:CGPointMake(x + cornerWith, y)];
    [path addLineToPoint:CGPointMake(x + cornerWith , y + cornerHeight)];
    [path addLineToPoint:CGPointMake(x + cornerWith - klineDistance , y + cornerHeight)];
    [path addLineToPoint:CGPointMake(x + cornerWith - klineDistance , y + klineDistance)];
    [path addLineToPoint:CGPointMake(x , y + klineDistance)];
    [path closePath];
    
    //获取当前环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    //保存当前环境，便于以后恢复
    CGContextSaveGState(context);
    
    //将坐标的起点变成（100，100）
    CGContextTranslateCTM(context, 0, 0);
    //将当前的颜色变成黄色
    UIColor* fillColor = [UIColor redColor];
    [fillColor setFill];
    //五角星填充为黄色
    [path fill];
    
    CGContextRestoreGState(context);
}

#pragma mark -右下角
-(void)rightBottonCorner
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGSize size = self.rect.size;
    
    CGFloat x = size.width - cornerWith - 2;
    CGFloat y = size.height - cornerHeight - 2;
    
    [path moveToPoint:CGPointMake(x + cornerWith - klineDistance, y)]; //起始点
    [path addLineToPoint:CGPointMake(x + cornerWith , y)];
    [path addLineToPoint:CGPointMake(x + cornerWith , y + cornerHeight)];
    [path addLineToPoint:CGPointMake(x , y + cornerHeight)];
    [path addLineToPoint:CGPointMake(x , y + cornerHeight - klineDistance)];
    [path addLineToPoint:CGPointMake(x + cornerWith - klineDistance , y + cornerHeight - klineDistance)];
    [path closePath];
    
    //获取当前环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    //保存当前环境，便于以后恢复
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0, 0);
    //将当前的颜色变成黄色
    UIColor* fillColor = [UIColor redColor];
    [fillColor setFill];
    //五角星填充为黄色
    [path fill];
    
    CGContextRestoreGState(context);
}

#pragma mark -左下角
-(void)leftBottonCorner
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGSize size = self.rect.size;
    
    CGFloat x = 2;
    CGFloat y = size.height - cornerHeight - 2;
    
    [path moveToPoint:CGPointMake(x , y)]; //起始点
    [path addLineToPoint:CGPointMake(x + klineDistance , y)];
    [path addLineToPoint:CGPointMake(x + klineDistance , y + cornerHeight - klineDistance)];
    [path addLineToPoint:CGPointMake(x + cornerWith , y + cornerHeight - klineDistance)];
    [path addLineToPoint:CGPointMake(x + cornerWith , y + cornerHeight)];
    [path addLineToPoint:CGPointMake(x , y + cornerHeight)];
    [path closePath];
    
    //获取当前环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    //保存当前环境，便于以后恢复
    CGContextSaveGState(context);
    
    //将坐标的起点变成（100，100）
    CGContextTranslateCTM(context, 0, 0);
    //将当前的颜色变成黄色
    UIColor* fillColor = [UIColor redColor];
    [fillColor setFill];
    //五角星填充为黄色
    [path fill];
    
    CGContextRestoreGState(context);
}


@end
