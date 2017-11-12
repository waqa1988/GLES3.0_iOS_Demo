//
//  DvGLESView.h
//  MyGLES
//
//  Created by davi on 2017/10/28.
//  Copyright © 2017年 davi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface DvGLESView : UIView {
    CAEAGLLayer * eaglLayer;
    EAGLContext * glContext;
    GLuint _colorRenderBuffer;
}

- (void) onGLViewCreated;

- (void) onGLViewChanged:(GLint)w Height:(GLint)h;

- (void) onDraw;

@end

