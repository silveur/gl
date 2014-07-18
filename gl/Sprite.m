//
//  Sprite.m
//  gl
//
//  Created by silvere letellier on 11/07/2014.
//  Copyright (c) 2014 silvere letellier. All rights reserved.
//

#import "Sprite.h"

@interface Sprite()

@property (nonatomic, weak) GLKBaseEffect* baseEffect;

@end

@implementation Sprite

- (id)initWithEffect:(GLKBaseEffect *)baseEffect
{
	if(self = [super init])
	{
		self.baseEffect = baseEffect;
		self.rotation = 0;
	}
	
	return self;
}

- (void)render
{	
	self.baseEffect.texture2d0.name = self.textureInfo.name;
	self.baseEffect.texture2d0.target = self.textureInfo.target;

	GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, self.position.x, self.position.y, 0);
	self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
	
	modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(self.rotation), 0.0f, 0.0f, 1.0f);
	self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
	
	[self.baseEffect prepareToDraw];
	
	glDrawArrays(GL_TRIANGLES, 0, 6);

}

-(void)update
{
	self.position = GLKVector2Add(self.position, self.velocity);
	self.rotation += self.rotationVelocity;
}



@end
