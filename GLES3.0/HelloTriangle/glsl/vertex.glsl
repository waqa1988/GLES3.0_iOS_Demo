/* 
  vertex.glsl
  MyGLES

  Created by davi on 2017/10/29.
  Copyright © 2017年 davi. All rights reserved.
*/
#version 300 es
layout(location = 0) in vec4 vPosition;

void main() {
    gl_Position = vPosition;
}
