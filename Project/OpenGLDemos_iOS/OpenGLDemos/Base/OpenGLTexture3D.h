//
//  OpenGLTexture3D.h
//  OpenGLDemos
//
//  Created by yoctech on 2021/10/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface OpenGLTexture3D : NSObject {
    GLuint texture[1];
    NSString *filename;
}

@property (nonatomic, copy) NSString *filename;

- (id)initWithFilename:(NSString *)inFilename width:(GLuint)inWidth height:(GLuint)inHeight;
- (void)bind;
+ (void)useDefaultTexture;

@end
