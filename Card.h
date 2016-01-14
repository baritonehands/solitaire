//
//  Card.h
//  Solitaire
//
//  Created by Brian Gregg on 11/8/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Card : NSObject {
	NSImage *face;
	Card *nextCard;
	NSRect drawRect;
	NSNumber *cardNum;
	BOOL isFaceDown;
}

- (id)initWithFace:(NSImage *)firstFace 
		isFaceDown:(BOOL)firstFaceDown 
		drawRect:(NSRect)startRect
		withNum:(NSNumber *)startNum;
- (NSImage *)face;
- (BOOL)isFaceDown;
- (void)setFace:(NSImage *)newFace;
- (void)setIsFaceDown:(BOOL)newValue;
- (NSRect)drawRect;
- (void)setDrawRect:(NSRect)newRect;
- (void)setNextCard:(Card *)newCard;
- (Card *)nextCard;
- (int)cardNum;

@end
