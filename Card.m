//
//  Card.m
//  Solitaire
//
//  Created by Brian Gregg on 11/8/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "Card.h"


@implementation Card

- (id)initWithFace:(NSImage *)firstFace 
		isFaceDown:(BOOL)firstFaceDown 
		drawRect:(NSRect)startRect
		withNum:(NSNumber *)startNum
{
	[super init];
	face = firstFace;
	[face retain];
	isFaceDown = firstFaceDown;
	drawRect = startRect;
	nextCard = nil;
	cardNum = startNum;
	return self;
}

- (NSImage *)face
{
	return face;
}

- (BOOL)isFaceDown
{
	return isFaceDown;
}

- (void)setFace:(NSImage *)newFace
{
	[newFace retain];
	[face release];
	face = newFace;
}

- (void)setIsFaceDown:(BOOL)newValue
{
	isFaceDown = newValue;
}

- (NSRect)drawRect
{
	return drawRect;
}

- (void)setDrawRect:(NSRect)newRect
{
	drawRect = newRect;
}

- (Card *)nextCard
{
	return nextCard;
}

- (void)setNextCard:(Card *)newCard
{
	nextCard = newCard;
}

- (int)cardNum
{
	return [cardNum intValue];
}

- (void)dealloc
{
	[face release];
	[super dealloc];
}

@end
