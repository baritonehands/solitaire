//
//  Stack.h
//  Solitaire
//
//  Created by Brian Gregg on 11/9/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Card;


@interface Stack : NSObject {
	Card *top;
	Card *tail;
	int count;
}

- (Card *)top;
- (Card *)tail;
- (void)push:(Card *)newCard;
- (void)insert:(Card *)newCard;
- (Card *)removeTail;
- (int)count;
- (Card *)removeCards:(int)cardNum;
- (Stack *)getStackFromPoint:(NSPoint)mousePos;
- (Stack *)getSingleCardStack;
- (void)appendStack:(Stack *)endStack;
- (Card *)removeHead;
- (Stack *)getStackFromCard:(Card *)topCard;

@end
