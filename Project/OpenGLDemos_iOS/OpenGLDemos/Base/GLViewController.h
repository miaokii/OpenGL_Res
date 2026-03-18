//
//  GLViewController.h
//  OpenGLDemos
//
//  Created by yoctech on 2021/10/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"

@interface GLViewController : UIViewController <GLViewDelegate>

@property (nonatomic, strong) GLView * glView;

/// 设置透视视口
/// @param zNear 近截面距离
/// @param zFar 远截面距离
/// @param fieldOfView 视角度数
- (void)setPerspectiveViewportWithNear:(const float)zNear far:(const float)zFar angle:(const float) fieldOfView;

/// 正交视口
- (void)setQuadratureViewportWithNear:(const float)zNear far:(const float)zFar;

@end
