//
//  LikeIcon.m
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/12/12.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import "LikeIcon.h"


@interface LikeIcon ()

/**
 * 比率
 */
@property (nonatomic,assign) CGFloat rate;

/**
 * 线条的颜色
 */
@property (nonatomic,strong) UIColor *strokeColor;

/**
 * 线条的宽度
 */
@property (nonatomic,assign) CGFloat lineWidth;

@end

@implementation LikeIcon


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
//    //上面的两个半圆 半径为整个frame的四分之一
//    CGFloat radius = MIN((self.frame.size.width-spaceWidth*2)/4, (self.frame.size.height-spaceWidth*2)/4);
//    
//    //左侧圆心 位于左侧边距＋半径宽度
//    CGPoint leftCenter = CGPointMake(spaceWidth+radius, spaceWidth+radius);
//    //右侧圆心 位于左侧圆心的右侧 距离为两倍半径
//    CGPoint rightCenter = CGPointMake(spaceWidth+radius*3, spaceWidth+radius);
//    
//    //左侧半圆
//    UIBezierPath *heartLine = [UIBezierPath bezierPathWithArcCenter:leftCenter radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
//    
//    //右侧半圆
//    [heartLine addArcWithCenter:rightCenter radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
//    
//    //曲线连接到新的底部顶点 为了弧线的效果，控制点，坐标x为总宽度减spaceWidth，刚好可以相切，平滑过度 y可以根据需要进行调整，y越大，所画出来的线越接近内切圆弧
//    [heartLine addQuadCurveToPoint:CGPointMake((self.frame.size.width/2), self.frame.size.height-spaceWidth*2) controlPoint:CGPointMake(self.frame.size.width-spaceWidth, self.frame.size.height*0.6)];
//    
//    //用曲线 底部的顶点连接到左侧半圆的左起点 为了弧线的效果，控制点，坐标x为spaceWidth，刚好可以相切，平滑过度。y可以根据需要进行调整，y越大，所画出来的线越接近内切圆弧（效果是越胖）
//    [heartLine addQuadCurveToPoint:CGPointMake(spaceWidth, spaceWidth+radius) controlPoint:CGPointMake(spaceWidth, self.frame.size.height*0.6)];
//    
//    //线条处理
//    [heartLine setLineCapStyle:kCGLineCapRound];
//    //线宽
//    [self setHeartLineWidthWithPath:heartLine];
//    //线条的颜色
//    [self setHeartStrokeColor];
//    
//    //根据坐标点连线
//    [heartLine stroke];
//    //clipToBounds 切掉多余的部分
//    [heartLine addClip];
}


@end
