//
//  ViewController.h
//  gl
//
//  Created by silvere letellier on 09/07/2014.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "Sprite.h"

@interface ViewController : GLKViewController

@property (nonatomic, strong) EAGLContext* context;
@property (nonatomic, strong) GLKBaseEffect* baseEffect;
@property (nonatomic, strong) Sprite* rocket;

@end
