//
//  GLUtils.hpp
//  MyGLES
//
//  Created by davi on 2017/10/28.
//  Copyright © 2017年 davi. All rights reserved.
//

#ifndef GLUtils_hpp
#define GLUtils_hpp

#include <stdio.h>
#include <stdlib.h>
#include <OpenGLES/ES3/gl.h>

GLuint loadShader(GLenum type, const char *shaderSrc);

GLuint linkToProgram(GLuint vertexShader, GLuint fragmentShader);

#endif /* GLUtils_hpp */
