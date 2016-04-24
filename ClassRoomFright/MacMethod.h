//
//  MacMethod.h
//  ClassRoomFright
//
//  Created by rimi on 16/3/14.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MacMethod : NSObject
//计算两点间的距离
+ (CGFloat)distanceBetweenPointA:(CGPoint)startPoint pointB:(CGPoint)endPoint;
//计算两点连线与x轴夹角的正切值
+ (CGFloat)cosineOfXAndThelinePassPointA:(CGPoint)startPoint pointB:(CGPoint)endPoint;
//获取固定的坐标点
+ (CGPoint)pointAtNumber:(NSInteger)num place:(NSInteger)place;
//判断范围
+ (NSArray *)cosineOfEndPoint:(CGPoint)endPoint fromStartPoint:(CGPoint)startPoint ofRowPoint:(CGPoint)rowPoint;
//粉笔到达目标所需时间
+ (NSInteger)pickToGoalNeedTime:(NSInteger)goal;
//滑动方向目标点坐标
+ (CGPoint)goalPointByPointA:(CGPoint)startPoint pointB:(CGPoint)endPoint;

@end