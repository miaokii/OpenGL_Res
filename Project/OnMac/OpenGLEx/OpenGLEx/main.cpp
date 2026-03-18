
#include "GLTools.h"
// 着色器管理
#include "GLShaderManager.h"

#ifdef __APPLE__
#include <glut/glut.h>
#else
#define FREEGLUT_STATIC
#include <GL/glut.h>
#endif


GLBatch triangleBatch;
GLShaderManager shaderManager;

//窗口大小改变时接受新的宽度和高度，其中0,0代表窗口中视口的左下角坐标，w，h代表像素
void ChangeSize(int w,int h) {
    glViewport(0,0, w, h);
}

//为程序作一次性的设置
void SetupRC() {
    //设置背影颜色
    glClearColor(0.0f,0.0f,1.0f,1.0f);
    //初始化着色管理器
    shaderManager.InitializeStockShaders();
    //设置三角形，其中数组vVert包含所有3个顶点的x,y,笛卡尔坐标对。
    GLfloat vVerts[] = {
        -0.5f,0.0f,0.0f,
        0.5f,0.0f,0.0f,
        0.0f,0.5f,0.0f,
    };
    //批次处理
    triangleBatch.Begin(GL_TRIANGLES,3);
    triangleBatch.CopyVertexData3f(vVerts);
    triangleBatch.End();
}

//开始渲染
void RenderScene(void)
{
    //清除一个或一组特定的缓冲区
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);
    //设置一组浮点数来表示红色
    GLfloat vRed[] = {1.0f,0.0f,0.0f,1.0f};
    //传递到存储着色器，即GLT_SHADER_IDENTITY着色器，这个着色器只是使用指定颜色以默认笛卡尔坐标第在屏幕上渲染几何图形
    shaderManager.UseStockShader(GLT_SHADER_IDENTITY,vRed);
    //提交着色器
    triangleBatch.Draw();
    //将在后台缓冲区进行渲染，然后在结束时交换到前台
    glutSwapBuffers();
}

int main(int argc,char* argv[]) {
    
    // 初始化GLUT
    glutInit(&argc, argv);
    // 初始化双缓冲窗口
    // 双缓冲区、rgb缓冲区、深度缓冲区、模板缓冲区
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH | GLUT_STENCIL);
    // glut窗口大小
    glutInitWindowSize(800, 600);
    // 传建一个窗口
    glutCreateWindow("Triangle");
    // 注册窗口尺寸改变
    
    return 0;
}
