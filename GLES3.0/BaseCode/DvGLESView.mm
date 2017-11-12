//
//  DvGLESView.m
//  MyGLES
//
//  Created by davi on 2017/10/28.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "DvGLESView.h"

@implementation DvGLESView

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
    [self setupRenderBuffer];
    [self setupFrameBuffer];
}

- (void) onGLViewChanged:(GLint)w Height:(GLint)h {
    glViewport(0, 0, w, h);
}

- (void) onDraw:(CADisplayLink*)displayLink {
    [self onDraw];
    
    [glContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void) onDraw {
    
}


@end

