//
//  UIImage+ImageManage.m
//  ClassRoomFright
//
//  Created by rimi on 16/3/18.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "UIImage+ImageManage.h"
#import <CoreImage/CoreImage.h>//  图像处理框架

@implementation UIImage (ImageManage)

+ (UIImage *)fuzzyImage:(UIImage *)image byRadius:(CGFloat)radiues {
    CIContext *context = [CIContext contextWithOptions:nil];
    //载入图片
    NSData * imageData = UIImagePNGRepresentation(image);
    CIImage * ciImage = [CIImage imageWithData:imageData];
    //过滤方式
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@(radiues) forKey: @"inputRadius"];
    //处理后图片
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}

@end
