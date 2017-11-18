/* 
  frag.glsl
  GLES3.0

  Created by davi on 2017/11/12.
  Copyright © 2017年 davi. All rights reserved.
*/

#version 300 es

precision mediump float;

in vec4 v_color;
out vec4 o_fragColor;

void main() {
    o_fragColor = v_color;
}
