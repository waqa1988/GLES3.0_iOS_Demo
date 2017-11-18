//
//  PrimitiveRestartView.m
//  PrimitiveRestart
//
//  Created by davi on 2017/11/18.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "PrimitiveRestartView.h"
#import "GLUtils.hpp"

#define VERTEX_POS_SIZE 3
#define VERTEX_COLOR_SIZE 4

#define VERTEX_POS_INDEX 0
#define VERTEX_COLOR_INDEX 1

@implementation PrimitiveRestartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)onGLViewCreated {
    [super onGLViewCreated];
    
    [self initShader];
}

- (void)onGLViewChanged:(GLint)w Height:(GLint)h {
    [super onGLViewChanged:w Height:h];
}

-(void)onDraw {
    [super onDraw];
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(0, 0, 0, 0);
    
    if (programObject < 1)
    return;
    
    glUseProgram(programObject);
    
    GLfloat vertices[6 * (VERTEX_POS_SIZE + VERTEX_COLOR_SIZE)] = {
        -0.5f, 0.5f, 0.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        -1.0f, -0.5f, 0.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        0.0f, -0.5f, 0.0f,
        0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 0.5f, 0.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        0.5f, 0.5f, 0.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        0.5f, 0.0f, 0.0f,
        0.0f, 0.0f, 1.0f, 1.0f,
    };
    // 0xFFFF索引为特殊索引，用于图元重启
    GLushort indices[12] = {0, 1, 2, 0xFFFF, 3, 4, 5};
    // 不使用顶点缓冲区对象绘制图形
    [self drawPrimitiveWithoutVBOs:vertices andVtxStride:sizeof(GLfloat) * (VERTEX_POS_SIZE + VERTEX_COLOR_SIZE) andNumIndices:12 andIndices:indices];
}

- (void) initShader {
    NSString *vertexPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
    NSError *vertexError;
    NSString *vertexShaderStr = [NSString stringWithContentsOfFile:vertexPath encoding:NSUTF8StringEncoding error:&vertexError];
    NSString *fragPath = [[NSBundle mainBundle] pathForResource:@"frag" ofType:@"glsl"];
    NSError *fragError;
    NSString *fragShaderStr = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&fragError];
    
    if (vertexShaderStr && fragShaderStr) {
        GLuint vertexShader;
        GLuint fragmentShader;
        // Load the vertex/fragment shaders
        vertexShader = loadShader(GL_VERTEX_SHADER, [vertexShaderStr UTF8String]);
        fragmentShader = loadShader(GL_FRAGMENT_SHADER, [fragShaderStr UTF8String]);
        
        // create and link to program object
        programObject = linkToProgram(vertexShader, fragmentShader);
    }
}

- (void) drawPrimitiveWithoutVBOs:(GLfloat *)vertices andVtxStride:(GLint) vtxStride andNumIndices:(GLint) numIndices andIndices:(GLushort*) indices {
    GLfloat *vtxBuf = vertices;
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    glEnableVertexAttribArray(VERTEX_POS_INDEX);
    glEnableVertexAttribArray(VERTEX_COLOR_INDEX);
    
    // 采用结构数组的形式加载
    glVertexAttribPointer(VERTEX_POS_INDEX, VERTEX_POS_SIZE, GL_FLOAT, GL_FALSE, vtxStride, vtxBuf);
    vtxBuf += VERTEX_POS_SIZE;
    glVertexAttribPointer(VERTEX_COLOR_INDEX, VERTEX_COLOR_SIZE, GL_FLOAT, GL_FALSE, vtxStride, vtxBuf);
    
    // 打开图元重启
    glEnable(GL_PRIMITIVE_RESTART_FIXED_INDEX);
    
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_SHORT, indices);
    // 关闭图元重启
    glDisable(GL_PRIMITIVE_RESTART_FIXED_INDEX);
    
    glDisableVertexAttribArray(VERTEX_POS_INDEX);
    glDisableVertexAttribArray(VERTEX_COLOR_INDEX);
}

@end
