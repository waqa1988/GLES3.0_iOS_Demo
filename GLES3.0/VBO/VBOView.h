//
//  VBOView.h
//  VBO
//
//  Created by davi on 2017/11/7.
//  Copyright © 2017年 davi. All rights reserved.
//

#import "DvGLESView.h"

@interface VBOView : DvGLESView {
    GLuint programObject;
}


/**
 不使用顶点缓冲区对象绘制图形

 @param vertices <#vertices description#>
 @param vtxStride <#vtxStride description#>
 @param numIndices <#numIndices description#>
 @param indices <#indices description#>
 */
- (void) drawPrimitiveWithoutVBOs:(GLfloat *)vertices andVtxStride:(GLint) vtxStride andNumIndices:(GLint) numIndices andIndices:(GLushort*) indices;


/**
 使用缓冲区对象绘制（顶点属性结构数组）

 @param numVertices <#numVertices description#>
 @param vtxBuf <#vtxBuf description#>
 @param vtxStride <#vtxStride description#>
 @param numIndices <#numIndices description#>
 @param indices <#indices description#>
 */
- (void) drawPrimitiveWithVBOsByNumVertices:(GLint)numVertices andVtxBuf:(GLfloat *)vtxBuf andVtxStride:(GLint)vtxStride andNumIndices:(GLint)numIndices andIndices:(GLushort *)indices;

/**
 使用缓冲区对象绘制（数组结构：对每个属性使用一个缓冲区对象绘制）

 @param numVertices <#numVertices description#>
 @param vtxPosBuf <#vtxPosBuf description#>
 @param vtxColorBuf <#vtxColorBuf description#>
 @param vtxStride <#vtxStride description#>
 @param numIndices <#numIndices description#>
 @param indices <#indices description#>
 */
- (void) drawPrimitiveWithVBOs2ByNumVertices:(GLint)numVertices andVtxPosBuf:(GLfloat *)vtxPosBuf andVtxColorBuf:(GLfloat *)vtxColorBuf andVtxStride:(GLuint *)vtxStride andNumIndices:(GLint)numIndices andIndices:(GLushort *)indices;

@end
