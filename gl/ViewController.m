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

VertexData vertices[] =
{
	{{ -SQUARE_SIZE/2, -SQUARE_SIZE/2, 0.0f }, {0.0f, 0.0f}},
	{{ SQUARE_SIZE/2, -SQUARE_SIZE/2, 0.0f }, {1.0f, 0.0f}},
	{{ -SQUARE_SIZE/2, SQUARE_SIZE/2, 0.0f }, {0.0f, 1.0f}},
	{{ -SQUARE_SIZE/2, SQUARE_SIZE/2, 0.0f }, {0.0f, 1.0f}},
	{{ SQUARE_SIZE/2, -SQUARE_SIZE/2, 0.0f }, {1.0f, 0.0f}},
	{{ SQUARE_SIZE/2, SQUARE_SIZE/2, 0.0f  }, {1.0f, 1.0f}}
};

@interface ViewController ()

@end

@implementation ViewController
{
	GLuint _vertexBufferID;
	GLKTextureInfo* bulletTextureInfo;
	GLKTextureInfo* rockTextureInfo;
	NSMutableArray* bullets;
	NSMutableArray* rockArray;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	if ([super initWithCoder:aDecoder])
	{
		bullets = [[NSMutableArray alloc] initWithCapacity:20];
		rockArray = [[NSMutableArray alloc] initWithCapacity:20];
	}
	return self;
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
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(VertexData), (GLvoid*)offsetof(VertexData, textureCoordinates));
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	UITapGestureRecognizer* gestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRocketLocation:)];
	[self.view addGestureRecognizer:gestureRecogniser];
	
	UISwipeGestureRecognizer* swipeRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shoot:)];
	swipeRecogniser.direction = UISwipeGestureRecognizerDirectionUp;
	[self.view addGestureRecognizer:swipeRecogniser];
	
	GLKTextureInfo* rocketTextureInfo = [self loadImage:@"rocket_small.png"];
	bulletTextureInfo = [self loadImage:@"bullet.gif"];
	rockTextureInfo = [self loadImage:@"rock.png"];
				
	self.rocket = [[Sprite alloc] initWithEffect:self.baseEffect];
	self.rocket.textureInfo = rocketTextureInfo;
	self.rocket.position = GLKVector2Make(320, 200);
	self.rocket.rotation = 360;
	
	
}

- (GLKTextureInfo*)loadImage:(NSString*) name
{
	CGImageRef imageReference = [[UIImage imageNamed:name] CGImage];
	
	GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithCGImage:imageReference options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft] error:NULL];
	
	return textureInfo;
}

- (void) changeRocketLocation:(UITapGestureRecognizer*)gestureRecogniser
{
	int xLocation = [gestureRecogniser locationInView:self.view].x;
	int yLocation = [gestureRecogniser locationInView:self.view].y;
	self.rocket.position = GLKVector2Make(xLocation*2, 200);
}

- (void) addRock
{
	Sprite* newRock = [[Sprite alloc] initWithEffect:self.baseEffect];
	newRock.textureInfo = rockTextureInfo;
	int xLocation = arc4random()%(int)self.view.bounds.size.width;
	newRock.position = GLKVector2Make(xLocation, SQUARE_SIZE + self.view.bounds.size.height*2);
	newRock.velocity = GLKVector2Make(0.0f, -5.0f);
	newRock.rotation = -5.0f;
	[rockArray addObject:newRock];
}

- (void) shoot:(UISwipeGestureRecognizer*)swip
{
	Sprite* bullet;
	
	for (Sprite* newbullet in bullets)
	{
		if (newbullet.position.y > self.view.bounds.size.height*2)
		{
			bullet = newbullet;
			bullet.position = GLKVector2Add(self.rocket.position, GLKVector2Make(0.0f, SQUARE_SIZE*0.8f));
			bullet.velocity = GLKVector2Make(0.0f, 10.0f);
			break;
		}
	}
	
	if (bullet == nil)
	{
		bullet = [[Sprite alloc] initWithEffect:self.baseEffect];
		bullet.textureInfo = bulletTextureInfo;
		bullet.position = GLKVector2Add(self.rocket.position, GLKVector2Make(0.0f, SQUARE_SIZE));
		bullet.velocity = GLKVector2Make(0.0f, 10.0f);
		bullet.rotationVelocity = 10;
		[bullets addObject:bullet];
	}
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	glClear(GL_COLOR_BUFFER_BIT);
	[self.rocket render];
	for ( Sprite* bullet in bullets)
	{
		if (!(bullet.position.y > self.view.bounds.size.height * 2))
			[bullet render];
	}
	
	for ( Sprite* rock in rockArray)
	{
		if (!(rock.position.y < self.view.bounds.size.height * 2))
			[rock render];
	}
}

- (void) update
{
	static double lastRock = 0.0f;
	lastRock += self.timeSinceLastUpdate;
	if (lastRock >= 1.0f)
	{
		[self addRock];
		lastRock = 0.0f;
	}
	
	[self.rocket update];
	for ( Sprite* bullet in bullets)
	{
		[bullet update];
	}
	for ( Sprite* rock in rockArray)
	{
		if (rock.position.y < 0)
		[rock update];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	[EAGLContext setCurrentContext:self.context];
	glDeleteBuffers(1, &_vertexBufferID);
	
	GLuint textBufferID = rockTextureInfo.name;
	glDeleteBuffers(1, &textBufferID);
	
	self.baseEffect = nil;
	self.context = nil;
	
	[EAGLContext setCurrentContext:nil];
}

@end
