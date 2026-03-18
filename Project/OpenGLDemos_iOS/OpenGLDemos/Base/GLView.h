//
//  GLView.h
//  OpenGLDemos
//
//  Created by yoctech on 2021/10/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@protocol GLViewDelegate

- (void)drawView:(UIView *)theView;
- (void)setupView:(UIView *)theView;

@end

@interface GLView : UIView
{
    @private

    GLint backingWidth;
    GLint backingHeight;

    EAGLContext *context;
    GLuint viewRenderbuffer, viewFramebuffer;
    GLuint depthRenderbuffer;
}

@property (nonatomic, assign) NSTimeInterval animationInterval;
@property (nonatomic, weak) /* weak ref */ id <GLViewDelegate> delegate;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;

@end
