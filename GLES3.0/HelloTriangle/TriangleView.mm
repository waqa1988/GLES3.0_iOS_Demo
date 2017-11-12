//
//  TriangleView.m
//  GLES3.0
//
//  Created by davi on 2017/11/12.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "TriangleView.h"
#import "GLUtils.hpp"

@implementation TriangleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

GLfloat vVertices[] = {
    0.0f, 0.5f, 0.0f,
    -0.5f, -0.5f, 0.0f,
    0.5f, -0.5f, 0.0
};

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
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(0, 0, 0, 0);
    
    if (programObject < 1)
        return;
    
    glUseProgram(programObject);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, vVertices);
    glEnableVertexAttribArray(0);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    [glContext presentRenderbuffer:GL_RENDERBUFFER];
}

@end
