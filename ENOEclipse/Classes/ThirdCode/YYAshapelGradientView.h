//
//  YYAshapelGradientView.h
//  ENOEclipse
//
//  Created by Chinasunhealth on 2016/12/26.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYAshapelGradientView : UIView

@property (nonatomic,strong)CAShapeLayer *trackLayer;//背景轨迹 层
@property (nonatomic,strong)CAShapeLayer *progressLayer;//上面的可视层  (改到.h文件  是因为  根据需要改变它的渲染程度时，是在外面进行的。)

@property (nonatomic,assign)CGFloat progressLineWidth;//环宽  默认是 15 最大是45（再大 多彩拼接缝隙能被看到 不美观）

//开始的角度数
@property (nonatomic,assign)CGFloat startAngle;
//结束的角度数
@property (nonatomic,assign)CGFloat endAngle;

@property (nonatomic,copy)NSString *biggerTitle;

@property (nonatomic,copy)NSString *smallerTitle;

@property (nonatomic,strong)UIView *bgView;//大view
@property (nonatomic,strong)UILabel *biggerLabel;//大标题 label


@end
