//
//  GLViewController.m
//  OpenGLDemos
//
//  Created by yoctech on 2021/10/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

#import "GLViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"

@implementation GLViewController

- (void)loadView {
    self.view = self.glView;
}

- (GLView *)glView {
    if (!_glView) {
        _glView = [[GLView alloc] init];
        _glView.delegate = self;
    }
    return _glView;
}

#pragma mark - GLViewDelegate

- (void)drawView:(UIView *)theView {
    
}

- (void)setupView:(GLView *)view {
    
}

-(void)setPerspectiveViewportWithNear:(const float)zNear far:(const float)zFar angle:(const float) fieldOfView {
    
    float aspectRatio;
    GLfloat size;
    
    // 屏幕尺寸
    CGRect frame = [[UIScreen mainScreen] bounds];

    // 屏幕纵横比例，
    aspectRatio=(float)frame.size.width/(float)frame.size.height; //5

    // 将当前矩阵从模型视图矩阵设置成投影矩阵
    glMatrixMode(GL_PROJECTION);
    // 重置投影矩阵
    glLoadIdentity();
    // 计算锥形视角的左右上下的限制值。你可以把它想象成3D空间中的虚拟窗口。
    // 原点在屏幕中央，所以x轴和y轴的值都是从-size到+size
    // 这就是为什么会有GLKMathDegreesToRadians (fieldOfView) / 2.0将窗口分为两部分
    // 视角的角度是从-30度到+30度的
    // 乘以zNear就可以计算出近剪裁面在坐标轴各个方向上的大小
    // 这就是正切函数的作用了，眼睛在z轴上，到原点的距离是zNear
    // 视域被z轴分为上下两部分各为30度，所以就可以明白size就是近剪裁面在x和y轴上的长度。
    size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);
    // 将计算的左右上下以及近剪裁面和远剪裁面的值传进glFrustumf函数
    // 这里下边和上边的值都除以了aspectRatio（屏幕宽高比），而左右边没有
    // 这是因为调用glLoadIdentity函数标准化投影矩阵的时候将所有的顶点数据都标准化到了-1~1的范围内
    // 屏幕宽度和高度实际大小不一样，但都被标准化成了1
    // 所以如果左右值和上下值一样的话得到的就是一个宽度比较大而高度比较小的长方形
    // 而不是预期的正方形，所以左右值不变，而上下值要除以宽高比。
    glFrustumf(-size, size, -size /aspectRatio, size /aspectRatio, zNear, zFar);
    // 设置视口，一般为屏幕的大小。可以根据需要来设置坐标和宽度、高度
    glViewport(0, 0, frame.size.width, frame.size.height);
    // 将当前的矩阵从投影矩阵设置为模型视图矩阵
    glMatrixMode(GL_MODELVIEW);
    // 重置模型视图矩阵
    glLoadIdentity();
}

- (void)setQuadratureViewportWithNear:(const float)zNear far:(const float)zFar {
    float aspectRatio;
    // 屏幕尺寸
    CGRect frame = [[UIScreen mainScreen] bounds];

    // 屏幕纵横比例，
    aspectRatio=(float)frame.size.width/(float)frame.size.height; //5

    // 将当前矩阵从模型视图矩阵设置成投影矩阵
    glMatrixMode(GL_PROJECTION);
    // 重置投影矩阵
    glLoadIdentity();
    
    glOrthof(-1, 1, -1/aspectRatio, 1/aspectRatio, zNear, zFar);
    // 设置视口，一般为屏幕的大小。可以根据需要来设置坐标和宽度、高度
    glViewport(0, 0, frame.size.width, frame.size.height);
    // 将当前的矩阵从投影矩阵设置为模型视图矩阵
    glMatrixMode(GL_MODELVIEW);
    // 重置模型视图矩阵
    glLoadIdentity();
}

@end
