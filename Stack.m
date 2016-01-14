//
//  Stack.m
//  Solitaire
//
//  Created by Brian Gregg on 11/9/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "Stack.h"
#import "Card.h"


@implementation Stack

- (id)init
{
	[super init];
	top = nil;
	tail = nil;
	count = 0;
	return self;
}

- (Card *)top
{
	return top;
}

- (void)push:(Card *)newCard
{
	if(newCard == nil)
		return;
	[newCard retain];
	if (top == nil) {
		top = newCard;
		tail = top;
	} else {
		[tail setNextCard:newCard];
		tail = newCard;
	}
	[tail setNextCard:nil];
	count++;
}

- (void)insert:(Card *)newCard
{
	if(newCard == nil)
		return;
	[newCard retain];
	if (top == nil) {
		top = newCard;
		tail = top;
	} else {
		[newCard setNextCard:top];
		top = newCard;
	}
	//[tail setNextCard:nil];
	count++;
}

- (Card *)tail
{
	return tail;
}

- (Card *)removeTail
{
	Card *temp = top;
	if (top == tail) {
		top = nil;
		tail = nil;
		count=0;
		return temp;
	}
	while([temp nextCard] != tail)
		temp = [temp nextCard];
	[temp setNextCard:nil];
	Card *temp2 = tail;
	tail = temp;
	count--;
	return temp2;
}

- (Card *)removeHead
{
	Card *temp = top;
	if(temp == nil)
		return nil;
	if (top == tail) {
		top = nil;
		tail = nil;
		count=0;
		return temp;
	}
	top = [temp nextCard];
	[temp setNextCard:nil];
	count--;
	return temp;
}

- (Card *)removeCards:(int)cardNum
{
	Card *temp = top;
	if (top == tail) {
		top = nil;
		tail = nil;
		count=0;
		return temp;
	}
	while([[temp nextCard] cardNum] != cardNum)
		temp = [temp nextCard];
	tail = temp;
	temp = [temp nextCard];
	[tail setNextCard:nil];
	return temp;
}

- (Stack *)getStackFromPoint:(NSPoint)mousePos
{
	Card *card;
	Card *prevCard=nil;
	NSRect drawRect;
	Stack *newStack;
	int i;
	
	for (card = top,i=0;card != nil;card=[card nextCard],i++) {
		if([card isFaceDown]) {
			if(![card nextCard]) {
				[card setIsFaceDown:NO];
				return nil;
			}
			prevCard = card;
			continue;
		}
		drawRect = [card drawRect];
		if(mousePos.x >= drawRect.origin.x && mousePos.y >= drawRect.origin.y &&
			mousePos.x <= drawRect.origin.x + drawRect.size.width &&
			mousePos.y <= drawRect.origin.y + drawRect.size.height) {
				newStack = [Stack new];
				if(card == top) {
					newStack->top = top;
					newStack->tail = tail;
					newStack->count = count;
					top = nil;
					tail = nil;
					count = 0;
				} else {
					newStack = [Stack new];
					newStack->count = count - i;
					newStack->top = card;
					newStack->tail = tail;
					tail = prevCard;
					if(tail)
						[tail setNextCard:nil];
					count -= newStack->count;
				}
				return newStack;
		}
		prevCard = card;
	}
	/*if([card isFaceDown]) {
		[card setIsFaceDown:NO];
		return nil;
	}*/
	/*if(card == top) {
		newStack = [Stack new];
		[newStack push:card];
		[self removeHead];
		return newStack;
	}*/
	NSLog(@"program should not have gotten here");
	return nil;
}

- (Stack *)getStackFromCard:(Card *)topCard
{
	Card *card,*prevCard = nil;
	Stack *retVal;
	
	if(topCard == nil)
		return nil;
	retVal = [Stack new];
	if(top == topCard) {
		
		retVal->top = top;
		retVal->tail = tail;
		retVal->count = count;
		top = nil;
		tail = nil;
		count = 0;
	} else {
		int i;
		for (card = top,i=0;card!= topCard;card=[card nextCard],i++) {
			prevCard = card;
		}
		retVal->tail = tail;
		tail = prevCard;
		[prevCard setNextCard:nil];
		retVal->top = card;
		retVal->count = count - i;
		count = i;
	}
	return retVal;
}

- (Stack *)getSingleCardStack
{
	Card *temp;
	Stack *retVal;
	
	temp = [self removeTail];
	retVal = [Stack new];
	retVal->top = temp;
	retVal->tail = temp;
	retVal->count = 1;
	return retVal;
}

- (void)appendStack:(Stack *)endStack
{	
	//Card *card;
	if(!endStack)
		return;
	if(count == 0) {
		top = endStack->top;
		tail = endStack->tail;
		count = endStack->count;
	} else {
		[tail setNextCard:endStack->top];
		tail = endStack->tail;
		count += endStack->count;
		//for(;[endStack count]>0;)
		//	[endStack removeHead];
	}
	endStack->top = nil;
	endStack->tail = nil;
	[endStack release];
}

- (int)count
{
	return count;
}

- (void)dealloc
{
	Card *temp,*temp2;
	for(temp=top;temp!=nil;temp=temp2){
		temp2 = [temp nextCard];
		[temp release];
	}
	[super dealloc];
}

@end
