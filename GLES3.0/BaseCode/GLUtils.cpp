//
//  GLUtils.cpp
//  MyGLES
//
//  Created by davi on 2017/10/28.
//  Copyright © 2017年 davi. All rights reserved.
//

#include "GLUtils.hpp"
#include "DvLog.hpp"
#include <iostream>

GLuint loadShader(GLenum type, const char *shaderSrc) {
    GLuint shader;
    GLint compiled;
    // create the shader object
    shader = glCreateShader(type);
    if (shader == 0)
        return 0;
    
    // load the shader source
    glShaderSource(shader, 1, &shaderSrc, NULL);
    
    // Compile the shader
    glCompileShader(shader);
    
    // Check the compile status
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (!compiled) {
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char * infoLog = (char *) malloc(sizeof(char) * infoLen);
            glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
            
            LOGD(infoLog);
            
            free(infoLog);
        }
        
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

GLuint linkToProgram(GLuint vertexShader, GLuint fragmentShader) {
    GLuint programObject;
    GLint linked;
    
    // Create teh program object
    programObject = glCreateProgram();
    if (programObject == 0)
        return -1;
    
    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);
    
    // Link the program
    glLinkProgram(programObject);
    
    // Check the program
    glGetProgramiv(programObject, GL_LINK_STATUS, &linked);
    
    if (!linked) {
        GLint infoLen = 0;
        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char *infoLog = (char *) malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(programObject, infoLen, NULL, infoLog);
            LOGD(infoLog);
            
            free(infoLog);
        }
        
        glDeleteProgram(programObject);
        return -1;
    }
    
    return programObject;
}


