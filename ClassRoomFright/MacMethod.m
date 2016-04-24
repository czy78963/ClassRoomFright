//
//  MacMethod.m
//  ClassRoomFright
//
//  Created by rimi on 16/3/14.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "MacMethod.h"
#import "FitOfScreen.h"

@interface MacMethod ()

@end

@implementation MacMethod
//计算两点间的距离
+ (CGFloat)distanceBetweenPointA:(CGPoint)startPoint pointB:(CGPoint)endPoint {
    return sqrt((endPoint.x - startPoint.x) * (endPoint.x - startPoint.x) + (endPoint.y - startPoint.y) * (endPoint.y - startPoint.y));
}
//计算两点连线与x轴夹角的正切值
+ (CGFloat)cosineOfXAndThelinePassPointA:(CGPoint)startPoint pointB:(CGPoint)endPoint {
    return (endPoint.x - startPoint.x)/[self distanceBetweenPointA:startPoint pointB:endPoint];
}
//获取固定的坐标点
+ (CGPoint)pointAtNumber:(NSInteger)num place:(NSInteger)place {
    //012为接收范围，1是中点。3是发射点
    NSArray * point1 = @[[NSValue valueWithCGPoint:CZYCGPointMake(45, 200)],[NSValue valueWithCGPoint:CZYCGPointMake(70, 200)],[NSValue valueWithCGPoint:CZYCGPointMake(95, 200)],[NSValue valueWithCGPoint:CZYCGPointMake(70, 350)]];
    NSArray * point2 = @[[NSValue valueWithCGPoint:CZYCGPointMake(135, 200)],[NSValue valueWithCGPoint:CZYCGPointMake(160, 200)],[NSValue valueWithCGPoint:CZYCGPointMake(185, 200)],[NSValue valueWithCGPoint:CZYCGPointMake(160, 350)]];
    NSArray * point3 = @[[NSValue valueWithCGPoint:CZYCGPointMake(225, 200)],[NSValue valueWithCGPoint:CZYCGPointMake(250, 200)],[NSValue valueWithCGPoint:CZYCGPointMake(275, 200)],[NSValue valueWithCGPoint:CZYCGPointMake(250, 350)]];
    NSArray * point4 = @[[NSValue valueWithCGPoint:CZYCGPointMake(35, 325)],[NSValue valueWithCGPoint:CZYCGPointMake(60, 325)],[NSValue valueWithCGPoint:CZYCGPointMake(85, 325)],[NSValue valueWithCGPoint:CZYCGPointMake(60, 375)]];
    NSArray * point5 = @[[NSValue valueWithCGPoint:CZYCGPointMake(135, 325)],[NSValue valueWithCGPoint:CZYCGPointMake(160, 325)],[NSValue valueWithCGPoint:CZYCGPointMake(185, 325)],[NSValue valueWithCGPoint:CZYCGPointMake(160, 375)]];
    NSArray * point6 = @[[NSValue valueWithCGPoint:CZYCGPointMake(235, 325)],[NSValue valueWithCGPoint:CZYCGPointMake(260, 325)],[NSValue valueWithCGPoint:CZYCGPointMake(285, 325)],[NSValue valueWithCGPoint:CZYCGPointMake(260, 375)]];
    NSArray * point7 = @[[NSValue valueWithCGPoint:CZYCGPointMake(25, 470)],[NSValue valueWithCGPoint:CZYCGPointMake(50, 450)],[NSValue valueWithCGPoint:CZYCGPointMake(75, 430)],[NSValue valueWithCGPoint:CZYCGPointMake(50, 550)]];
    NSArray * point8 = @[[NSValue valueWithCGPoint:CZYCGPointMake(135, 450)],[NSValue valueWithCGPoint:CZYCGPointMake(160, 450)],[NSValue valueWithCGPoint:CZYCGPointMake(185, 450)],[NSValue valueWithCGPoint:CZYCGPointMake(160, 550)]];
    NSArray * point9 = @[[NSValue valueWithCGPoint:CZYCGPointMake(245, 430)],[NSValue valueWithCGPoint:CZYCGPointMake(270, 450)],[NSValue valueWithCGPoint:CZYCGPointMake(295, 470)],[NSValue valueWithCGPoint:CZYCGPointMake(270, 550)]];
    NSArray * allPoint = @[point1, point2, point3, point4, point5, point6 ,point7 ,point8, point9];
    return [allPoint[num - 1][place - 1] CGPointValue];
}
//判断范围
+ (NSArray *)cosineOfEndPoint:(CGPoint)endPoint fromStartPoint:(CGPoint)startPoint ofRowPoint:(CGPoint)rowPoint {
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:@9];
    for (int i = 1; i <= 9; ++ i) {
        CGPoint leftPoint = [self pointAtNumber:i place:1];
        CGPoint rightPoint = [self pointAtNumber:i place:3];
        CGFloat cosineOfPoint = [self cosineOfXAndThelinePassPointA:startPoint pointB:endPoint];
        CGFloat cosineOfLeftPoint = [self cosineOfXAndThelinePassPointA:rowPoint pointB:leftPoint];
        CGFloat cosineOfRightPoint = [self cosineOfXAndThelinePassPointA:rowPoint pointB:rightPoint];
//        NSLog(@"*****%d******\ncosineOfPoint%f\ncosineOfLeftPoint%f\ncosineOfRightPoint%f",i,cosineOfPoint,cosineOfLeftPoint,cosineOfRightPoint);
        if (cosineOfPoint > cosineOfLeftPoint && cosineOfPoint < cosineOfRightPoint) {
            [array addObject:@1];
        } else {
            [array addObject:@0];
        }
    }
    return array;
}
//粉笔到达目标所需时间
+ (NSInteger)pickToGoalNeedTime:(NSInteger)goal {
    switch (goal) {
        case 1:
        case 3:
            return 1.1;
            
        case 2:
            return 1;
            
        case 4:
        case 6:
            return 1.2;
            
        case 5:
            return 1.1;
            
        case 7:
        case 9:
            return 1.3;
            
        case 8:
            return 1.2;
        default:
            return 0;
    }
    
}
//滑动方向目标点坐标
+ (CGPoint)goalPointByPointA:(CGPoint)startPoint pointB:(CGPoint)endPoint {
    CGFloat lenth = [self distanceBetweenPointA:startPoint pointB:endPoint];
    CGFloat x = 450 * CZYRadioHeight / lenth * (endPoint.x - startPoint.x) + startPoint.x;
    CGFloat y = 450 * CZYRadioHeight / lenth * (endPoint.y - startPoint.y) + startPoint.y;
    return CGPointMake(x, y);
}


@end
