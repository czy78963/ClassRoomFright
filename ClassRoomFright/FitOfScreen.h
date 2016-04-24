//
//  FitOfScreen.h
//  骨科医患通
//
//  Created by rimi on 16/3/1.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#ifndef FitOfScreen_h
#define FitOfScreen_h
#import <UIKit/UIKit.h>

#define CZYCurrentScreenWidth [UIScreen mainScreen].bounds.size.width //当前屏宽
#define CZYCurrentScreenHeight [UIScreen mainScreen].bounds.size.height //当前屏高
#define iPhone5Width   320
#define iPhone5Height  568
#define CZYRadioWidth CZYCurrentScreenWidth/iPhone5Width    //宽相对于iPhone的比例
#define CZYRadioHeight CZYCurrentScreenHeight/iPhone5Height //高相对于iPhone的比例

CG_INLINE CGPoint CZYCGPointMake(CGFloat x, CGFloat y) {
    return CGPointMake(x*CZYRadioWidth, y*CZYRadioHeight);
}
CG_INLINE CGRect CZYCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return CGRectMake(x*CZYRadioWidth, y*CZYRadioHeight, width*CZYRadioWidth, height*CZYRadioHeight);
}

#endif /* FitOfScreen_h */
