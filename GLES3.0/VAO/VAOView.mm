//
//  VAOView.m
//  VAO
//
//  Created by davi on 2017/11/12.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "VAOView.h"
#import "GLUtils.hpp"

@implementation VAOView

#define VERTEX_POS_SIZE 3
#define VERTEX_COLOR_SIZE 4

#define VERTEX_POS_INDX 0
#define VERTEX_COLOR_INDX 1

#define VERTEX_STRIDE ( sizeof(GLfloat) * (VERTEX_POS_SIZE + VERTEX_COLOR_SIZE))

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
    [self createVAO];
}

- (void)onGLViewChanged:(GLint)w Height:(GLint)h {
    [super onGLViewChanged:w Height:h];
}

- (void)onDraw {
    [super onDraw];
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(0, 0, 0, 0);
    
    glUseProgram(programObject);
    
    // Bind the VAO
    glBindVertexArray(vaoId);
    
    // Draw with the VAO settings
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_SHORT, (const void *) 0);
    
    // Return to the default VAO
    glBindVertexArray(0);
}

- (GLboolean) createVAO {
    GLfloat vertices[3 * (VERTEX_POS_SIZE + VERTEX_COLOR_SIZE)] = {
        -0.5f, 0.5f, 0.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        -1.0f, -0.5f, 0.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        0.0f, -0.5f, 0.0f,
        0.0f, 0.0f, 1.0f, 1.0f
    };
    
    // index buffer data
    GLushort indices[3] = {0, 1, 2};
    
    if (programObject == 0)
        return GL_FALSE;
    
    GLuint vboIds[2];
    glGenBuffers(2, vboIds);
    
    glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIds[1]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    // Generate VAO ID
    glGenVertexArrays(1, &vaoId);
    
    // Bind the VAO and then set up the vertex attributes
    glBindVertexArray(vaoId);
    
    glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIds[1]);
    
    glEnableVertexAttribArray(VERTEX_POS_INDX);
    glEnableVertexAttribArray(VERTEX_COLOR_INDX);
    
    glVertexAttribPointer(VERTEX_POS_INDX, VERTEX_POS_SIZE, GL_FLOAT, GL_FALSE, VERTEX_STRIDE, (const void *) 0);
    glVertexAttribPointer(VERTEX_COLOR_INDX, VERTEX_COLOR_SIZE, GL_FLOAT, GL_FALSE, VERTEX_STRIDE, (const void *) (VERTEX_POS_SIZE * sizeof(GLfloat)));

    // Reset to the default VAO
    glBindVertexArray(0);
    
    return GL_TRUE;
}

@end
