//
//  BSOpenGLController.m
//  OpenGLDemos
//
//  Created by yoctech on 2021/10/21.
//

#import "BSOpenGLController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"

@interface BSOpenGLController ()

@end

@implementation BSOpenGLController

- (void)loadView {
    [super loadView];
    [self.glView startAnimation];
}

// MARK: - 三角形
- (void)triangle {
    static GLfloat rotation = 0;
    
    // 三个顶点
    Vertex3D vertex1 = Vertex3DMake(0.0, 1.0, -3.0);
    Vertex3D vertex2 = Vertex3DMake(1.0, 0.0, -3.0);
    Vertex3D vertex3 = Vertex3DMake(-1.0, 0.0, -3.0);

    // 堆分配的内存 再 复制其值到数组中
    // 三角形
    Triangle3D triangle = Triangle3DMake(vertex1, vertex2, vertex3);
    
    // 复位，清除一切旋转，移动和其他变化，将观察者置于原点
    glLoadIdentity();
    // 旋转
    glRotatef(rotation, 0, 0, 1);
    // 灰色背景
    glClearColor(0.9, 0.9, 0.9, 1.0);
    // 清除所有图形，并设置为clear颜色，两个参数是颜色缓存和深度缓存
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // 启动顶点数组
    glEnableClientState(GL_VERTEX_ARRAY);
    // 绘图的颜色
    glColor4f(1.0, 0.0, 0.0, 1.0);
    // 传递顶点
    // 3: 表示多少个GLFloat代表一个点，二维下2，三维下3
    // GL_FLOAT: 顶点数据类型
    // 0:
    // &triangle: 传递结构体的地址，和传递数组地址是一样的
    glVertexPointer(3, GL_FLOAT, 0, &triangle);
    // 提交顶点数组，绘制三角形
    // GL_TRIANGLES: 绘制什么，支持绘制点，线，线回路，三角形和三角形扇
    glDrawArrays(GL_TRIANGLES, 0, 9);
    // 禁止先前启动的特性，保证不会对其他地方绘制代码有影响
    // 衣柜和储物柜，全都是白色；电视柜靠走廊的侧板和门板是白色，隔板背板都是木色；
    // 厨房吊柜全部白色，地柜全部木色；鞋柜门板+左面的侧板（靠近冰箱的板）是白色，柜体是木色
    glDisableClientState(GL_VERTEX_ARRAY);
    
    rotation += 1;
}

// MARK: - 正方形
/// 两个三角形构成一个正方形，需要6个顶点
- (void)square_2_triangle {
    
    static GLfloat rotation = 0;
    
    // 两个三角形放在同一个顶点数组中
    
    /* Vertex3DMake在堆中分配内存，再复制到 数组中，造成额外的内存占用
     Triangle3D triangle[2];
     triangle[0].v1 = Vertex3DMake(1, -1, -3);
     triangle[0].v2 = Vertex3DMake(-1, -1, -3);
     triangle[0].v3 = Vertex3DMake(1, 1, -3);
     triangle[1].v1 = Vertex3DMake(1, 1, -3);
     triangle[1].v2 = Vertex3DMake(-1, -1, -3);
     triangle[1].v3 = Vertex3DMake(-1, 1, -3);
     */
    
    // 使用malloc/calloc（同时将所有值设置为0）将顶点分配到栈中
    Triangle3D * triangles = malloc(sizeof(Triangle3D)*2);
    Vertex3DSet(&triangles[0].v1, 1, -1, -3);
    Vertex3DSet(&triangles[0].v2, -1, -1, -3);
    Vertex3DSet(&triangles[0].v3, 1, 1, -3);
    Vertex3DSet(&triangles[1].v1, 1, 1, -3);
    Vertex3DSet(&triangles[1].v2, -1, -1, -3);
    Vertex3DSet(&triangles[1].v3, -1, 1, -3);
    
    // 复位
    glLoadIdentity();
    glRotatef(rotation, 0, 0, 1);
    // 背景颜色
    glClearColor(0.9, 0.9, 0.9, 1.0);
    // 清除所有图形，并设置为clear颜色，两个参数是颜色缓存和深度缓存
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColor4f(1, 0, 0, 1);
    glVertexPointer(3, GL_FLOAT, 0, triangles);
    glDrawArrays(GL_TRIANGLES, 0, 18);
    glDisableClientState(GL_VERTEX_ARRAY);
    rotation += 1;
    
    if (triangles)
        free(triangles);
}

/// 三角形条构成正方形，只需要4个顶点
/// 三角形条：第一个三角形有前三个顶点构成（0，1，2），第二个三角形
/// 由前一个三角形的两个顶点加数组中下一个（3）顶点构成，直到整个数组结束
- (void)square_triangle_strips {
    
    static GLfloat rotation = 0;
    
    Vertex3D * vertexs = calloc(4, sizeof(Vertex3D));
    
    Vertex3DSet(&vertexs[0], 1, -1, -3);
    Vertex3DSet(&vertexs[1], -1, -1, -3);
    Vertex3DSet(&vertexs[2], 1, 1, -3);
    Vertex3DSet(&vertexs[3], -1, 1, -3);
    
    Color3D * colors = calloc(4, sizeof(Color3D));
    Color3DSet(&colors[0], 1, 0, 0, 1);
    Color3DSet(&colors[1], 0, 1, 0, 1);
    Color3DSet(&colors[2], 0, 0, 1, 1);
    Color3DSet(&colors[3], 1, 1, 0, 1);
    
    glLoadIdentity();
    glRotatef(rotation, 0, 0, 1);
    glClearColor(0.9, 0.9, 0.9, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    // glColor4f(1, 1, 0, 1);
    glVertexPointer(3, GL_FLOAT, 0, vertexs);
    glColorPointer(4, GL_FLOAT, 0, colors);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 12);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    rotation += 1;
    if (vertexs)
        free(vertexs);
}

// MARK: - 立方体
- (void)cube {
    
    static GLfloat rot = 0;
    
    static const Vertex3D vertexs[] = {
        1,1,1,
        1,-1,1,
        -1,-1,1,
        -1,1,1,
        1,1,-1,
        1,-1,-1,
        -1,-1,-1,
        -1,1,-1
    };
    
    static const Color3D colors[] = {
        {1.0, 0.0, 0.0, 1.0},
        {1.0, 0.5, 0.0, 1.0},
        {1.0, 1.0, 0.0, 1.0},
        {0.5, 1.0, 0.0, 1.0},
        {0.0, 1.0, 0.0, 1.0},
        {0.0, 1.0, 0.5, 1.0},
        {0.0, 1.0, 1.0, 1.0},
        {0.0, 0.5, 1.0, 1.0}
    };
    
    // 立方体有12个三角形
    static const GLubyte faceEles[] = {
        0,1,2,
        0,2,3,
        0,4,7,
        0,3,7,
        0,1,4,
        1,4,5,
        2,3,7,
        2,6,7,
        1,2,5,
        2,5,6,
        4,5,6,
        4,6,7,
    };
    
    glLoadIdentity();
    glTranslatef(0, 0, -5);
    glRotatef(rot,1.0f,1.0f,1.0f);
    glClearColor(0.9, 0.9, 0.9, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    // 传递顶点
    glVertexPointer(3, GL_FLOAT, 0, vertexs);
    // 传递顶点颜色
    glColorPointer(4, GL_FLOAT, 0, colors);

    // 如果按绘制的正确次序提供顶点，应该使用glDrawArrays()
    // 如果提供一个数组然后用另一个以索引值区分顶点次序的数组的话，应该使用glDrawElements()
    // 提交元素
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, faceEles);

    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rot+=50 * timeSinceLastDraw;
    }
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
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
    // 传递顶点
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    // 传递顶点颜色
    glColorPointer(4, GL_FLOAT, 0, colors);

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
    
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rot+=50 * timeSinceLastDraw;
    }
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void)drawView:(UIView *)theView {
    
    switch (self.type) {
        case 0:
            [self triangle];
            break;
        case 1:
            [self square_2_triangle];
            break;
        case 2:
            [self square_triangle_strips];
            break;
        case 3:
            [self cube];
            break;
        case 4:
            [self polyhedronCount:1];
            break;
        case 5:
            [self polyhedronCount:5];
            break;
        default:
            break;
    }
}

- (void)setupView:(GLView *)view {
    [self setPerspectiveViewportWithNear:0.001 far:1000 angle:60];
}

@end
