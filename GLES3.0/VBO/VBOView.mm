//
//  VBOView.m
//  VBO
//
//  Created by davi on 2017/11/7.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "VBOView.h"
#import "GLUtils.hpp"

#define VERTEX_POS_SIZE 3
#define VERTEX_COLOR_SIZE 4

#define VERTEX_POS_INDEX 0
#define VERTEX_COLOR_INDEX 1

@implementation VBOView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

- (void)onGLViewCreated {
    [super onGLViewCreated];
    
    [self initShader];
}

- (void)onGLViewChanged:(GLint)w Height:(GLint)h {
    [super onGLViewChanged:w Height:h];
}

- (void) onDraw {
    [super onDraw];
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(0, 0, 0, 0);
    
    if (programObject < 1)
        return;
    
    glUseProgram(programObject);
    
    GLfloat vertices[3 * (VERTEX_POS_SIZE + VERTEX_COLOR_SIZE)] = {
        -0.5f, 0.5f, 0.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        -1.0f, -0.5f, 0.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        0.0f, -0.5f, 0.0f,
        0.0f, 0.0f, 1.0f, 1.0f
    };
    
    GLushort indices[3] = {0, 1, 2};
    
//    // 不使用顶点缓冲区对象绘制图形
//    [self drawPrimitiveWithoutVBOs:vertices andVtxStride:sizeof(GLfloat) * (VERTEX_POS_SIZE + VERTEX_COLOR_SIZE) andNumIndices:3 andIndices:indices];
    
//    // 使用缓冲区对象绘制（顶点属性结构数组）
//    [self drawPrimitiveWithVBOsByNumVertices:3 andVtxBuf:vertices andVtxStride:sizeof(GLfloat) * (VERTEX_POS_SIZE + VERTEX_COLOR_SIZE) andNumIndices:3 andIndices:indices];
    
    
    // 对每个属性使用一个换中区对象绘制.
    GLuint vtxStrides[2];
    vtxStrides[0] = sizeof(GLfloat) * VERTEX_POS_SIZE;
    vtxStrides[1] = sizeof(GLfloat) * VERTEX_COLOR_SIZE;
    
    GLfloat verticePosArray[VERTEX_POS_SIZE * 3] = {
        -0.5f, 0.5f, 0.0f,
        -1.0f, -0.5f, 0.0f,
        0.0f, -0.5f, 0.0f
    };
    GLfloat verticeColorArray[VERTEX_COLOR_SIZE * 3] = {
        1.0f, 0.0f, 0.0f, 1.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f
    };
    
    [self drawPrimitiveWithVBOs2ByNumVertices:3 andVtxPosBuf:verticePosArray andVtxColorBuf:verticeColorArray andVtxStride:vtxStrides andNumIndices:3 andIndices:indices];
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
    
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_SHORT, indices);
    
    glDisableVertexAttribArray(VERTEX_POS_INDEX);
    glDisableVertexAttribArray(VERTEX_COLOR_INDEX);
}

- (void) drawPrimitiveWithVBOsByNumVertices:(GLint)numVertices andVtxBuf:(GLfloat *)vtxBuf andVtxStride:(GLint)vtxStride andNumIndices:(GLint)numIndices andIndices:(GLushort *)indices {
    GLuint offset = 0;
    
    static GLuint vboIds[2];
    
    if (vboIds[0] == 0 && vboIds[1] == 0) {
        glGenBuffers(2, vboIds);
        
        glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]);
        glBufferData(GL_ARRAY_BUFFER, vtxStride * numVertices, vtxBuf, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIds[1]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort) * numIndices, indices, GL_STATIC_DRAW);
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIds[1]);
    
    glEnableVertexAttribArray(VERTEX_POS_INDEX);
    glEnableVertexAttribArray(VERTEX_COLOR_INDEX);
    
    glVertexAttribPointer(VERTEX_POS_INDEX, VERTEX_POS_SIZE, GL_FLOAT, GL_FALSE, vtxStride, (const void *)offset);
    
    offset += VERTEX_POS_SIZE * sizeof(GLfloat);
    glVertexAttribPointer(VERTEX_COLOR_INDEX, VERTEX_COLOR_SIZE, GL_FLOAT, GL_FALSE, vtxStride, (const void *)offset);
    
    offset = 0;
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_SHORT, (const void *)offset);
    
    glDisableVertexAttribArray(VERTEX_POS_INDEX);
    glDisableVertexAttribArray(VERTEX_COLOR_INDEX);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

- (void) drawPrimitiveWithVBOs2ByNumVertices:(GLint)numVertices andVtxPosBuf:(GLfloat *)vtxPosBuf andVtxColorBuf:(GLfloat *)vtxColorBuf andVtxStride:(GLint *)vtxStride andNumIndices:(GLint)numIndices andIndices:(GLushort *)indices {
    
    static GLuint vboIds[3];

    if (vboIds[0] == 0 || vboIds[1] == 0 || vboIds[2] == 0) {
        glGenBuffers(3, vboIds);
        glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]);
        glBufferData(GL_ARRAY_BUFFER, vtxStride[0] * numVertices, vtxPosBuf, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ARRAY_BUFFER, vboIds[1]);
        glBufferData(GL_ARRAY_BUFFER, vtxStride[1] * numVertices, vtxColorBuf, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIds[2]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLfloat) * numIndices, indices, GL_STATIC_DRAW);
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]);
    glEnableVertexAttribArray(VERTEX_POS_INDEX);
    glVertexAttribPointer(VERTEX_POS_INDEX, VERTEX_POS_SIZE, GL_FLOAT, GL_FALSE, vtxStride[0], 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, vboIds[1]);
    glEnableVertexAttribArray(VERTEX_COLOR_INDEX);
    glVertexAttribPointer(VERTEX_COLOR_INDEX, VERTEX_COLOR_SIZE, GL_FLOAT, GL_FALSE, vtxStride[1], 0);
   
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIds[2]);
    
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_SHORT, 0);
    
    glDisableVertexAttribArray(VERTEX_POS_INDEX);
    glDisableVertexAttribArray(VERTEX_COLOR_INDEX);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}


@end
