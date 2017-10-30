//
//  DvGLESView.m
//  MyGLES
//
//  Created by davi on 2017/10/28.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "DvGLESView.h"
#import "GLUtils.hpp"

@implementation DvGLESView

GLuint programObject;
GLfloat vVertices[] = {
    0.0f, 0.5f, 0.0f,
    -0.5f, -0.5f, 0.0f,
    0.5f, -0.5f, 0.0
};

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self onGLViewCreated];
        [self onGLViewChanged:frame.size.width Height:frame.size.height];
        [self setupDisplayLink];
    }
    return self;
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDraw:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void) setLayer {
    eaglLayer = (CAEAGLLayer *) self.layer;
    eaglLayer.opaque = YES;
}

- (void) setContext {
    EAGLRenderingAPI renderApi = kEAGLRenderingAPIOpenGLES3;
    glContext = [[EAGLContext alloc] initWithAPI:renderApi];
    if (!glContext) {
        NSLog(@"Failed to initialize OpenGLES 3.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:glContext]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
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

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
}

- (void)setupFrameBuffer {
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void) onGLViewCreated {
    [self setLayer];
    [self setContext];
    [self initShader];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
}

- (void) onGLViewChanged:(GLint)w Height:(GLint)h {
    glViewport(0, 0, w, h);
}

- (void) onDraw:(CADisplayLink*)displayLink {
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
