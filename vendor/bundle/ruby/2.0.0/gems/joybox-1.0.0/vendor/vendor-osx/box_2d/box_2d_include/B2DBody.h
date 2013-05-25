//
//  CBBody.h
//  CBBox2D
//
//  Created by Juan Jose Karam on 2/17/13.
//  Copyright (c) 2013 Joybox. All rights reserved.
//
//  Inspired by:
//
//  Thanks to Axcho for his beautiful Cocos2D-Box2D implementation
//  CCBox2D (https://github.com/axcho/CCBox2D)


#import <Foundation/Foundation.h>

@class B2DShape;

@interface B2DBody : NSObject {
  
  b2Body *body;
}

@property (nonatomic, assign) b2Body *body;
@property (nonatomic, getter = position, setter = setPosition:) CGPoint position;
@property (nonatomic, readonly, getter = angle) CGFloat angle;
@property (nonatomic, readonly, getter = center) CGPoint center;
@property (nonatomic, getter = isSleepingAllowed, setter = setSleepingAllowed:) BOOL isSleepingAllowed;


- (id)initWithBody:(b2Body *)boxBody;

- (void)addFixtureForShape:(B2DShape *)shape
                  friction:(CGFloat)friction
               restitution:(CGFloat)restitution
                   density:(CGFloat)density
                  isSensor:(BOOL)isSensor;

- (void)applyForce:(CGPoint)force
        atLocation:(CGPoint)location
         asImpulse:(BOOL)asImpulse;


- (void)applyTorque:(CGFloat)torque
          asImpulse:(BOOL)impulse;

@end
