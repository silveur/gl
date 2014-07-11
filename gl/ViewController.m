//
//  ViewController.m
//  gl
//
//  Created by silvere letellier on 09/07/2014.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"

typedef struct
{
	GLKVector3 positionCoordinates;
	GLKVector2 textureCoordinates;
	
} VertexData;

#define SQUARE_SIZE	80

VertexData vertices[] =
{
	{{ 0.0f, 0.0f, 0.0f }, {0.0f, 0.0f}},
	{{ SQUARE_SIZE, 0.0f, 0.0f }, {1.0f, 0.0f}},
	{{ 0.0f, SQUARE_SIZE, 0.0f }, {0.0f, 1.0f}},
	{{ 0.0f, SQUARE_SIZE, 0.0f }, {0.0f, 1.0f}},
	{{ SQUARE_SIZE, 0.0f, 0.0f }, {1.0f, 0.0f}},
	{{ SQUARE_SIZE, SQUARE_SIZE, 0.0f  }, {1.0f, 1.0f}}
};

@interface ViewController ()

@end

@implementation ViewController
{
	GLuint _vertexBufferID;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	
	GLKView* view = (GLKView*)self.view;
	view.context = self.context;
	[EAGLContext setCurrentContext:self.context];
	
	self.baseEffect = [[GLKBaseEffect alloc] init];
//	self.baseEffect.useConstantColor = YES;
//	self.baseEffect.constantColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
	glClearColor(1.0f, 1.0f, 1.0f, 0.5f);
	
	self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, 640, 0, 1136, 0, 0);
	
	glGenBuffers(1, &_vertexBufferID);
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition,3, GL_FLOAT, GL_FALSE,sizeof(VertexData),offsetof(VertexData, positionCoordinates));
	
	
	
	CGImageRef imageReference = [[UIImage imageNamed:@"IconSmall.png"] CGImage];
	
	GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithCGImage:imageReference options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft] error:NULL];
	self.baseEffect.texture2d0.name = textureInfo.name;
	self.baseEffect.texture2d0.target = textureInfo.target;
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(VertexData), (GLvoid*)offsetof(VertexData, textureCoordinates));
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	glClear(GL_COLOR_BUFFER_BIT);
	[self.baseEffect prepareToDraw];
	
	glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void) update
{
	glClear(GL_COLOR_BUFFER_BIT);
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

@end
