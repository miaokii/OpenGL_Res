//
//  LightViewController.m
//  OpenGLDemos
//
//  Created by yoctech on 2021/10/22.
//

#import "LightViewController.h"
#import "OpenGLCommon.h"

@interface LightViewController ()

@end

@implementation LightViewController

- (void)loadView {
    [super loadView];
    [self.glView startAnimation];
}

// MARK: - 二十面体
- (void)polyhedronCount:(NSInteger)count {
    // 跟踪旋转
    static GLfloat rot = 0.0;
    // 面数+顶点数-棱数=2
    // 顶点数组，几何体不会发生变化，定义为const，不需要每帧都分配/清除内存
    static const Vertex3D vertices[]= {
        {0, -0.525731, 0.850651},             // vertices[0]
        {0.850651, 0, 0.525731},              // vertices[1]
        {0.850651, 0, -0.525731},             // vertices[2]
        {-0.850651, 0, -0.525731},            // vertices[3]
        {-0.850651, 0, 0.525731},             // vertices[4]
        {-0.525731, 0.850651, 0},             // vertices[5]
        {0.525731, 0.850651, 0},              // vertices[6]
        {0.525731, -0.850651, 0},             // vertices[7]
        {-0.525731, -0.850651, 0},            // vertices[8]
        {0, -0.525731, -0.850651},            // vertices[9]
        {0, 0.525731, -0.850651},             // vertices[10]
        {0, 0.525731, 0.850651}               // vertices[11]
    };

    // 颜色数组
    static const Color3D colors[] = {
         {1.0, 0.0, 0.0, 1.0},
         {1.0, 0.5, 0.0, 1.0},
         {1.0, 1.0, 0.0, 1.0},
         {0.5, 1.0, 0.0, 1.0},
         {0.0, 1.0, 0.0, 1.0},
         {0.0, 1.0, 0.5, 1.0},
         {0.0, 1.0, 1.0, 1.0},
         {0.0, 0.5, 1.0, 1.0},
         {0.0, 0.0, 1.0, 1.0},
         {0.5, 0.0, 1.0, 1.0},
         {1.0, 0.0, 1.0, 1.0},
         {1.0, 0.0, 0.5, 1.0}
    };

    // 描述形状，二十个面，第一个面（1，2，6）表示绘制位于索引1（0.850651, 0, 0.525731），2（1.0, 1.0, 0.0, 1.0），6（0.0, 1.0, 1.0, 1.0）三个顶点之间的三角形
    static const GLubyte icosahedronFaces[] = {
        1, 2, 6,
        1, 7, 2,
        3, 4, 5,
        4, 3, 8,
        6, 5, 11,
        5, 6, 10,
        9, 10, 2,
        10, 9, 3,
        7, 8, 9,
        8, 7, 0,
        11, 0, 1,
        0, 11, 4,
        6, 2, 10,
        1, 6, 11,
        3, 5, 10,
        5, 4, 11,
        2, 7, 9,
        7, 1, 0,
        3, 9, 8,
        4, 8, 0,
    };
    
    // 使用光线时，需要表面发现确定光线是怎样与各多边形交互
    // 顶点法向量
    static const Vector3D normals[] = {
        {0.000000, -0.417775, 0.675974},
        {0.675973, 0.000000, 0.417775},
        {0.675973, -0.000000, -0.417775},
        {-0.675973, 0.000000, -0.417775},
        {-0.675973, -0.000000, 0.417775},
        {-0.417775, 0.675974, 0.000000},
        {0.417775, 0.675973, -0.000000},
        {0.417775, -0.675974, 0.000000},
        {-0.417775, -0.675974, 0.000000},
        {0.000000, -0.417775, -0.675973},
        {0.000000, 0.417775, -0.675974},
        {0.000000, 0.417775, 0.675973},
    };
    
    glLoadIdentity();
    // 移动z轴
    if (count == 1) {
        glTranslatef(0.0f,0.0f,-3.0f);
        glRotatef(rot,1.0f,1.0f,1.0f);
    }
    glClearColor(0.7, 0.7, 0.7, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    // 启动顶点法向量数组
    glEnableClientState(GL_NORMAL_ARRAY);
    // 传递顶点
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    // 传递顶点颜色
    glColorPointer(4, GL_FLOAT, 0, colors);
    // 传递顶点法向量
    glNormalPointer(GL_FLOAT, 0, normals);

    // 如果按绘制的正确次序提供顶点，应该使用glDrawArrays()
    // 如果提供一个数组然后用另一个以索引值区分顶点次序的数组的话，应该使用glDrawElements()
    // 提交元素
    // glDrawElements(GL_TRIANGLES, 60, GL_UNSIGNED_BYTE, icosahedronFaces);
    
    if (count > 1) {
        for (int i = 0; i < 30; i++) {
            glLoadIdentity();
            glTranslatef(0, 1.5, -3*i);
            glRotatef(rot, 1, 1, 1);
            glDrawElements(GL_TRIANGLES, 60, GL_UNSIGNED_BYTE, icosahedronFaces);
        }
    } else {
        glDrawElements(GL_TRIANGLES, 60, GL_UNSIGNED_BYTE, icosahedronFaces);
    }

    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rot+=50 * timeSinceLastDraw;
    }
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
}


- (void)drawView:(UIView *)theView {
    [self polyhedronCount:1];
}

- (void)setupView:(UIView *)theView {
    float aspectRatio;
    GLfloat size;
    GLfloat zNear = 0.01;
    GLfloat zFar = 1000;
    GLfloat fieldOfView = 45;
    
    // 屏幕尺寸
    CGRect frame = [[UIScreen mainScreen] bounds];

    // 屏幕纵横比例，
    aspectRatio=(float)frame.size.width/(float)frame.size.height;
    
    // 计算锥形视角的左右上下的限制值。你可以把它想象成3D空间中的虚拟窗口。
    // 原点在屏幕中央，所以x轴和y轴的值都是从-size到+size
    // 这就是为什么会有GLKMathDegreesToRadians (fieldOfView) / 2.0将窗口分为两部分
    // 视角的角度是从-30度到+30度的
    // 乘以zNear就可以计算出近剪裁面在坐标轴各个方向上的大小
    // 这就是正切函数的作用了，眼睛在z轴上，到原点的距离是zNear
    // 视域被z轴分为上下两部分各为30度，所以就可以明白size就是近剪裁面在x和y轴上的长度。
    size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);

    glEnable(GL_DEPTH_TEST);
    // 将当前矩阵从模型视图矩阵设置成投影矩阵
    glMatrixMode(GL_PROJECTION);
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
    
    // 启动光效，但是没有创建任何光源，除了背景外的任何绘制物体都是黑色的。
    glEnable(GL_LIGHTING);
    // 启动第0个光源，一共有8个光源，linght0-7
    glEnable(GL_LIGHT0);
    // 启动光源后，设置光的属性
    // 光由三个元素组成，环境元素，散射元素，高光元素
    // 高光元素：光线直接照射，并反射到观察者形成物体上的光泽和热点
    // 散射元素：比较平均的定向光源，在物体面向光线的一面具有光泽
    // 环境元素：没有明显的光源，平均作用于场景中的所有物体的所有面
    
    [self ambientLight];
    [self diffuseLight];
    [self specularLight];
    
    // 重置模型视图矩阵
    glLoadIdentity();
}

// 环境光
// 无题没有面向光线的面或有其他物体挡住的物体在场景中看的不清楚
- (void)ambientLight {
    const GLfloat light0Ambient[] = {0.1, 0.1, 0.1, 1.0};
    glLightfv(GL_LIGHT0, GL_AMBIENT, light0Ambient);
}

// 散射光
- (void)diffuseLight {
    const GLfloat light0Diffuse[] = {0.7, 0.7, 0.7, 1.0};
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light0Diffuse);
}

// 高光
- (void)specularLight {
    // 亮度
    const GLfloat light0Specular[] = {0.7, 0.7, 0.7, 1.0};
    glLightfv(GL_LIGHT0, GL_SPECULAR, light0Specular);
    // 光源的位置
    const GLfloat light0Position[] = {0, 10, 10, 0};
    // 将一个光源放置在观察者后方的右上角
    glLightfv(GL_LIGHT0, GL_POSITION, light0Position);
    // 高光光源的方向（射灯照亮物体的一个角）（向量）
    // 沿z轴向下
    const GLfloat light0Direction[] = {0,0,-1};
    // GL_SPOT_DIRECTION聚光灯效果
    glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, light0Direction);
    // 光的角度 ()
    glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 45);
    
}

@end
