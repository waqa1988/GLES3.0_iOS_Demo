//
//  VBOView.h
//  VBO
//
//  Created by davi on 2017/11/7.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "DvGLESView.h"

@interface VBOView : DvGLESView

- (void) drawPrimitiveWithoutVBOs:(GLfloat *)vertices andVtxStride:(GLint) vtxStride andNumIndices:(GLint) numIndices andIndices:(GLushort*) indices;

@end
