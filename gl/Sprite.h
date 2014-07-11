//
//  Sprite.h
//  gl
//
//  Created by silvere letellier on 11/07/2014.
//  Copyright (c) 2014 silvere letellier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface Sprite : NSObject

- (id) initWithEffect:(GLKBaseEffect*)baseEffect;
- (void) update;
- (void) render;

@property (nonatomic, strong) GLKTextureInfo* textureInfo;
@property (assign) GLKVector2 position;
@property (assign) float rotation;

@end
