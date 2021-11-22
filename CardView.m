#import "CardView.h"
#import "Card.h"
#import "Stack.h"
#import "PreferenceController.h"
#import "SolitaireController.h"

@implementation CardView

- (id)initWithFrame:(NSRect)frameRect
{
	Stack *newStack;
	NSString *path;
	NSImage *temp;
	int i;
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
	}
	myBundle = [NSBundle mainBundle];
	piles = [[NSMutableArray alloc] initWithCapacity:14];
	aceImages = [[NSMutableArray alloc] initWithCapacity:4];
	//undoDragStacks = [[NSMutableArray alloc] init];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *num = [defaults objectForKey:BNRCardNumKey];
	if([num intValue] == 0)
		oneCard = YES;
	else
		oneCard = NO;
	num = [defaults objectForKey:BNRCardBackKey];
	if([num intValue] == 0) 
		path = [myBundle pathForImageResource:@"b2fv.png"];
	else
		path = [myBundle pathForImageResource:@"b1fv.png"];
	backImage = [[NSImage alloc] initWithContentsOfFile:path];
	backSize = [backImage size];
	/*num = [defaults objectForKey:BNRGameRulesKey];
	if([num intValue] == 0) {
		vegasRules = NO;
	} else {
		vegasRules = YES;
		oneCard = YES;
	}*/
	//path = [myBundle pathForImageResource:@"b2pt.png"];
	//backPartImage = [[NSImage alloc] initWithContentsOfFile:path];
	//path = [myBundle pathForImageResource:@"1.png"];
	//temp = [[NSImage alloc] initWithContentsOfFile:path];
	//normalSize = [temp size];
	//[temp release];
	for(i=0;i<52;i+=13) {
		path = [myBundle pathForImageResource:[NSString stringWithFormat:@"%d.png",i]];
		temp = [[NSImage alloc] initWithContentsOfFile:path];
		[temp setFlipped:YES];
		[aceImages addObject:temp];
		[temp release];
	}
	normalSize = [[aceImages objectAtIndex:0] size];
	//[backPartImage setFlipped:YES];
	for (i=0;i<14;i++) {
		newStack = [Stack new];
		[piles addObject:newStack];
		[newStack release];
	}
	NSData *colorAsData = [defaults objectForKey:BNRTableBGColorKey];
	bgColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
	[bgColor retain];
	//currentPoint.x = 35;
	//currentPoint.y = 22;
	return self;
}

- (void)clean
{
	int i;
	[piles release];
	NSUndoManager *undo = [self undoManager];
	[undo removeAllActions];
	//[undoDragStacks release];
	//currentCard = nil;
	piles = [[NSMutableArray alloc] initWithCapacity:14];
	for (i=0;i<14;i++) {
		Stack *newStack = [Stack new];
		[piles addObject:newStack];
		[newStack release];
	}
	//undoDragStacks = [[NSMutableArray alloc] init];
	//currentPoint.x = 35;
	//currentPoint.y = 22;
}

- (BOOL)isFlipped
{
	return YES;
}

- (void)drawRect:(NSRect)rect
{
	NSRect bounds = [self bounds];
	Card *card;
	NSImage *image;
	NSRect imageRect;
	NSRect drawingRect;
	NSSize imageSize;
	
	Stack *pile;
	int i,k,j;
	//int k=0;
	//int j=0;
	[bgColor set];
	[NSBezierPath fillRect:bounds];
	
	for(i=0;i<7;i++) {
		pile = [piles objectAtIndex:i];
		//e = [pile objectEnumerator];
		k=0;
		j=0;
		card = [pile top];
		if(!card) {
			NSRect emptyRect;
			//NSBezierPath *bezPath;
			emptyRect.size = normalSize;
			emptyRect.origin.x = 35.0 + ((35.0 + normalSize.width) * i);
			emptyRect.origin.y = 44.0 + normalSize.height;
			[[NSColor blackColor] set];
			[NSBezierPath strokeRect:emptyRect];
			//[bezPath fillRect];
		}
		while(card!=nil){
            imageRect.origin = NSZeroPoint;
			if ([card isFaceDown]) {
				image = backImage;
				if ([card nextCard]) {
					//image = backPartImage;
					imageSize = backSize;
					imageRect.size.width = imageSize.width;
					imageRect.size.height = 10.0;
					drawingRect.size.width = normalSize.width;
					drawingRect.size.height = 10.0;
					drawingRect.origin.x = [card drawRect].origin.x;
					drawingRect.origin.y = 44.0 + normalSize.height + (k * imageRect.size.height);
					[card setDrawRect:drawingRect];
				} else {
					//int backSize = (int)[backPartImage size].height;
					//image = backImage;
					imageSize = [image size];
					imageRect.size = imageSize;
					drawingRect.size = normalSize;
					drawingRect.origin.x = [card drawRect].origin.x;
					drawingRect.origin.y = 44.0 + normalSize.height + (k * 10.0);
					[card setDrawRect:drawingRect];
				}
				k++;
			} else {
				//int backSize = (int)[backPartImage size].height;
				image = [card face];
				imageSize = [image size];
				drawingRect.origin.x = [card drawRect].origin.x;
				drawingRect.origin.y = 44.0 + imageSize.height + (k * 10.0) + (j * (imageSize.height - 71.0));
				if ([card nextCard]) {
					imageRect.size.width = imageSize.width;
					drawingRect.size.width = imageSize.width;
					imageRect.size.height = imageSize.height - 71.0;
					drawingRect.size.height = imageSize.height - 71.0;
                    imageRect.origin = NSMakePoint(0, 71.0);
				} else {
					imageRect.size = imageSize;
					drawingRect.size = imageSize;
				}
				[card setDrawRect:drawingRect];
				j++;
			}
			//tail = (card == [pile tail]);
			
			
			//imageRect.size.width = imageSize.width;
			//imageRect.size.height = imageSize.height - 65 * (1-(k+1)/[pile count]);
			
			//drawingRect.size = imageRect.size;
			//drawingRect.origin.x = (i * (imageRect.size.width + 20)) + 20;
			//drawingRect.origin.y = rect.size.height - imageRect.size.height - 20 - (k * (imageRect.size.height-65));
		
			[image drawInRect:drawingRect
					fromRect:imageRect
					operation:NSCompositeSourceOver
					fraction:1.0];
			//k++;
			card = [card nextCard];
		}
	}
	for (i=8;i<12;i++) {
		//Stack *pile;
		pile = [piles objectAtIndex:i];
		if([pile count] == 0) {
			//NSString *path = [myBundle pathForImageResource:[NSString stringWithFormat:@"%d",i-7]];
			//image = [[NSImage alloc] initWithContentsOfFile:path];
			//NSRect imageRect;
			//NSRect drawingRect;
			image = [aceImages objectAtIndex:i-8];
			
			//[image setFlipped:YES];
			imageRect.size = normalSize;
			imageRect.origin = NSZeroPoint;
			drawingRect.size = normalSize;
			drawingRect.origin.y = 22;
			drawingRect.origin.x = 35 + ((i-5) * (normalSize.width + 35));
			[image drawInRect:drawingRect
					fromRect:imageRect
					operation:NSCompositeSourceOver
					fraction:0.30];
		} else {
			
			card = [pile tail];
			//NSRect imageRect;
			//NSRect drawingRect;
			image = [card face];
			
			imageRect.size = normalSize;
			imageRect.origin = NSZeroPoint;
			drawingRect.size = normalSize;
			drawingRect.origin.y = 22;
			drawingRect.origin.x = 35 + ((i-5) * (normalSize.width + 35));
			[image drawInRect:drawingRect
					fromRect:imageRect
					operation:NSCompositeSourceOver
					fraction:1.0];
		}
	}
	imageRect.origin = NSZeroPoint;
	drawingRect.origin.y = 22;
	if(oneCard)
		pile = [piles objectAtIndex:12];
	else
		pile = [piles objectAtIndex:13];
	if([pile count] > 0){
		if(oneCard){
			image = [[pile tail] face];
			imageSize = [image size];
			imageRect.size = imageSize;
			drawingRect.size = imageSize;
			drawingRect.origin.x = 70 + normalSize.width;
			
			[image drawInRect:drawingRect
					 fromRect:imageRect
					operation:NSCompositeSourceOver
					 fraction:1.0];
		} else {
			int i;
			Card *card = [pile top];
			for (i=0;i<[pile count],card;i++,card = [card nextCard]) {
				image = [card face];
				imageSize = [image size];
				imageRect.size.height = imageSize.height;
				imageRect.size.width = 67.0 + (15.0 * (![card nextCard]));
				drawingRect.size = imageRect.size;
				drawingRect.origin.x = 70 + normalSize.width + (15.0 * i);
				
				[image drawInRect:drawingRect
						 fromRect:imageRect
						operation:NSCompositeSourceOver
						 fraction:1.0];
			}
		}
	} else if(!oneCard && [pile count] == 0) {
		image = [[[piles objectAtIndex:12] tail] face];
		imageSize = [image size];
		imageRect.size = imageSize;
		drawingRect.size = imageSize;
		drawingRect.origin.x = 70 + normalSize.width;
		
		[image drawInRect:drawingRect
				 fromRect:imageRect
				operation:NSCompositeSourceOver
				 fraction:1.0];
	}
	if([[piles objectAtIndex:7] count] > 0) {
		imageSize = [backImage size];
		imageRect.size = imageSize;
		drawingRect.size = normalSize;
		drawingRect.origin.x = 35;
		[backImage drawInRect:drawingRect
					 fromRect:imageRect
					operation:NSCompositeSourceOver
					 fraction:1.0];
	} else {
		NSRect emptyRect;
		emptyRect.size = normalSize;
		emptyRect.origin.x = 35.0;
		emptyRect.origin.y = 22.0;
		[[NSColor blackColor] set];
		[NSBezierPath strokeRect:emptyRect];
	}
	
	if(dragStack){
		j = 0;
		/*
		imageRect.origin = NSZeroPoint;
		imageRect.size = [backImage size];
		drawingRect = [self currentRect:normalSize];
		[backImage drawInRect:drawingRect
				fromRect:imageRect
				operation:NSCompositeSourceOver
				fraction:1.0];*/
		card = [dragStack top];
		while(card) { 
			image = [card face];
			imageSize = [image size];
			drawingRect.origin.x = currentPoint.x;
			drawingRect.origin.y = currentPoint.y + (j * (imageSize.height - 71));
			if ([card nextCard]) {
				imageRect.size.width = imageSize.width;
				drawingRect.size.width = imageSize.width;
				imageRect.size.height = imageSize.height - 71;
				drawingRect.size.height = imageSize.height - 71;
                imageRect.origin = NSMakePoint(0, 71.0);
			} else {
				imageRect.size = imageSize;
				drawingRect.size = imageSize;
                imageRect.origin = NSZeroPoint;
			}
			[image drawInRect:drawingRect
					fromRect:imageRect
					operation:NSCompositeSourceOver
					fraction:1.0];
			card = [card nextCard];
			j++;
		}
	} 
}

- (void)mouseDown:(NSEvent *)event
{
	int stackNum;
	NSRect stackRect;
	NSRect tempRect;
	NSPoint downPoint;
	NSUndoManager *undo = [self undoManager];
	//Card *card;
	Stack *pile;
	//NSLog(@"mouseDown: %d", [event clickCount]);
	NSPoint p = [event locationInWindow];
	downPoint = [self convertPoint:p fromView:nil];
	//NSSize imageSize = [backImage size];
	/*if(difference.x < normalSize.width && difference.y < normalSize.height &&
		difference.x > 0 && difference.y>0)
		isDragging = YES;
	else
		isDragging = NO;*/
	stackNum = downPoint.x / (normalSize.width + 35);
	//stackNum = 0;
	oldStack = stackNum;
	//NSLog(@"Stack num = %d",stackNum);
	//card = [[piles objectAtIndex:stackNum] top];
	//while(card && ![card isFaceDown])
	//	[card nextCard];
	pile = [piles objectAtIndex:stackNum];
	tempRect = [[pile top] drawRect];
	stackRect.origin = tempRect.origin;
	tempRect = [[pile tail] drawRect];
	stackRect.size.width = tempRect.size.width;
	stackRect.size.height = stackRect.origin.y + tempRect.origin.x + tempRect.size.height;
	if(stackNum == 0 && downPoint.y < 22 + normalSize.height && downPoint.y > 22 && downPoint.x > 35 &&
	   downPoint.x < 35 + normalSize.width){
		//NSLog(@"Stack clicked");
		Stack *pile = [piles objectAtIndex:7];
		if([pile count] > 0) {
			if(oneCard) {
				//[self putCard:YES fromStack:13 toBottomOfStack:12];
				[self putCard:YES fromStack:7 toBottomOfStack:12];
				[[undo prepareWithInvocationTarget:self] putCard:NO fromStack:12 toTopOfStack:7];
				[undo setActionName:@"Flip Card"];
				//backCard = nil;
				//oldStack = 12;
			} else {
				int i,count;
				count = [[piles objectAtIndex:13] count];
				for(i=0;i < count;i++) {
					[self putCard:YES fromStack:13 toBottomOfStack:12];
					[[undo prepareWithInvocationTarget:self] putCard:NO fromStack:12 toTopOfStack:13];
				}
				for(i=0;i<3 && [pile count]>0;i++) {
					[self putCard:YES fromStack:7 toBottomOfStack:13];
					[[undo prepareWithInvocationTarget:self] putCard:NO fromStack:13 toTopOfStack:7];
				}
				[undo setActionName:@"Flip Cards"];
			}
		} else {
			if(!oneCard){
				int i,count;
				count = [[piles objectAtIndex:13] count];
				for(i=0;i<count;i++) {
					[self putCard:YES fromStack:13 toBottomOfStack:12];
					[[undo prepareWithInvocationTarget:self] putCard:NO fromStack:12 toTopOfStack:13];
				}
			}
			//[pile appendStack:[piles objectAtIndex:12]];
			//Stack *tempStack = [Stack new];
			//[piles replaceObjectAtIndex:12 withObject:tempStack];
			[piles exchangeObjectAtIndex:7 withObjectAtIndex:12];
			[[undo prepareWithInvocationTarget:self] setNeedsDisplay:YES];
			[[undo prepareWithInvocationTarget:piles] exchangeObjectAtIndex:7 withObjectAtIndex:12];
			[undo setActionName:@"Flip Pile"];
			//[tempStack release];
		}
		[self setNeedsDisplay:YES];
	}
	else if((stackNum == 1 || stackNum == 2) && downPoint.y < 22 + normalSize.height && downPoint.y > 22 && ((oneCard && 
			downPoint.x > 70 + normalSize.width && downPoint.x < 70 + 2 * normalSize.width) || 
			(downPoint.x > 70 + normalSize.width + (15.0 * ([[piles objectAtIndex:13] count]-1))
			 && downPoint.x < 70 + 2 * normalSize.width + (15.0 * ([[piles objectAtIndex:13] count]-1))))){
		Stack *pile;
		if(oneCard)
			pile = [piles objectAtIndex:12];
		else
			pile = [piles objectAtIndex:13];
		
		if([pile count] > 0){
			dragStack = [pile getSingleCardStack];
			//if([dragStack top] == backCard)
				//backCard = nil;
			if(oneCard)
				oldStack = 12;
			else
				oldStack = 13;
			if([event clickCount] == 2 && [dragStack count] == 1){
				pile = [piles objectAtIndex:[[dragStack top] cardNum]/13 + 8];
				Card *card = [pile tail];
				if(([pile count] == 0 && /*[[dragStack top] cardNum] == */[[dragStack top] cardNum]%13 == 0) || 
				   /*(card && [card cardNum] + 48 == [[dragStack top] cardNum]) ||*/ 
				   [card cardNum] + 1 == [[dragStack top] cardNum]/*+ 4*/) {
					[[undo prepareWithInvocationTarget:self] setNeedsDisplay:YES];
					[[undo prepareWithInvocationTarget:self] undoAppendStackWithCard:[dragStack top] 
																		   currStack:[[dragStack top] cardNum]/13 + 8
																		   prevStack:oldStack];
					[undo setActionName:@"Move Card"];
					[pile appendStack:dragStack];
					dragStack = nil;
					if(oldStack == 13 && !oneCard && [[piles objectAtIndex:13] count] == 0) {
						[self putCard:NO fromStack:12 toBottomOfStack:13];
						[[undo prepareWithInvocationTarget:self] putCard:YES fromStack:13 toBottomOfStack:12];
					}
				}
				else {
					[[piles objectAtIndex:oldStack] appendStack:dragStack];
					dragStack = nil;
				}
				isDragging = NO;
				
			} else {
				isDragging = YES;
				if(oneCard)
					currentPoint.x = 70 + normalSize.width;
				else
					currentPoint.x = 70 + normalSize.width + (15.0 * [[piles objectAtIndex:13] count]);
				currentPoint.y = 22;
				difference.x = downPoint.x - currentPoint.x;
				difference.y = downPoint.y - currentPoint.y;
				dragRect.origin = currentPoint;
				dragRect.size = normalSize;
			}
			[self setNeedsDisplay:YES];
		}
		
	}
	else if(stackNum > 2 && downPoint.y > 22 && downPoint.y < 22 + normalSize.height){
		int i;
		for(i=3;i<8;i++) {
			if(downPoint.x > 35 + (35 + normalSize.width) * i && downPoint.x < 35 + (35 + normalSize.width) * i + normalSize.width) {
				pile = [piles objectAtIndex:i+5];
				if([pile count] == 0) {
					isDragging = NO;
					break;
				}
				dragStack = [pile getSingleCardStack];
				oldStack = i+5;
				isDragging = YES;
				currentPoint.x = 35 + (35 + normalSize.width) * i;
				currentPoint.y = 22;
				difference.x = downPoint.x - currentPoint.x;
				difference.y = downPoint.y - currentPoint.y;
				dragRect.origin = currentPoint;
				dragRect.size = normalSize;
				[self setNeedsDisplay:YES];
				break;
			}
		}
	}
	else if(downPoint.x >= stackRect.origin.x && downPoint.y >= stackRect.origin.y && 
		downPoint.x <= stackRect.origin.x + stackRect.size.width && 
		downPoint.x <= stackRect.origin.y + stackRect.size.height) {
			//NSLog(@"Creating drag stack");
			dragStack = [pile getStackFromPoint:downPoint];
			if(dragStack) {
				if([event clickCount] == 2 && [dragStack count] == 1){
					pile = [piles objectAtIndex:[[dragStack top] cardNum]/13 + 8];
					Card *card = [pile tail];
					if(([pile count] == 0 && /*[[dragStack top] cardNum] == */[[dragStack top] cardNum]%13 == 0) || 
					   /*(card && [card cardNum] + 48 == [[dragStack top] cardNum]) || */
					   [card cardNum] + 1 == [[dragStack top] cardNum]/* + 4*/) {
						[[undo prepareWithInvocationTarget:self] setNeedsDisplay:YES];
						[[undo prepareWithInvocationTarget:self] undoAppendStackWithCard:[dragStack top] 
																			   currStack:[[dragStack top] cardNum]/13 + 8
																			   prevStack:oldStack];
						card = [[piles objectAtIndex:oldStack] tail];
						if([card isFaceDown]) {
							[card setIsFaceDown:NO];
							[[undo prepareWithInvocationTarget:card] setIsFaceDown:YES];
						}
						[pile appendStack:dragStack];
						[undo setActionName:@"Move Card"];
						dragStack = nil;
					}
					else {
						[[piles objectAtIndex:oldStack] appendStack:dragStack];
						dragStack = nil;
					}
					isDragging = NO;
					[self setNeedsDisplay:YES];
				} else {
					tempRect = [[dragStack top] drawRect];
					isDragging = YES;
					currentPoint.x = tempRect.origin.x;
					currentPoint.y = tempRect.origin.y;
					difference.x = downPoint.x - currentPoint.x;
					difference.y = downPoint.y - currentPoint.y;
					dragRect.origin = tempRect.origin;
					tempRect = [[dragStack tail] drawRect];
					dragRect.size.width = tempRect.size.width;
					dragRect.size.height = tempRect.origin.y - dragRect.origin.y + tempRect.size.height;
				}
			} else {
				isDragging = NO;
				[self setNeedsDisplay:YES];
			}
	}
	
}

- (void)mouseDragged:(NSEvent *)event
{
	NSPoint p = [event locationInWindow];
	NSPoint tempPoint;
	tempPoint = [self convertPoint:p fromView:nil];
	if(isDragging) {
		currentPoint.x = tempPoint.x - difference.x;
		currentPoint.y = tempPoint.y - difference.y;
		if (currentPoint.x < 0) {
			currentPoint.x = 0;
			/*difference.x = tempPoint.x - currentPoint.x;
			if(difference.x < 0)
				difference.x = 0;*/
		}
		if (currentPoint.y < 0) {
			currentPoint.y = 0;
			/*difference.y = tempPoint.y - currentPoint.y;
			if(difference.y < 0)
				difference.y = 0;*/
		}
		//NSSize imageSize = [backImage size];
		NSRect bounds = [self bounds];
		if (normalSize.width + currentPoint.x > bounds.size.width) {
			currentPoint.x = bounds.size.width - normalSize.width;
			/*difference.x = tempPoint.x - currentPoint.x;
			if(difference.x > normalSize.width)
				difference.x = normalSize.width;*/
		}
		if (dragRect.size.height + currentPoint.y > bounds.size.height) {
			currentPoint.y = bounds.size.height - dragRect.size.height;
			/*difference.y = tempPoint.y - currentPoint.y;
			if(difference.y > normalSize.height)
				difference.y = normalSize.height;*/
		}
		[self setNeedsDisplay:YES];
	}
}

- (void)mouseUp:(NSEvent *)event
{
	NSPoint p = [event locationInWindow];
	NSPoint tempPoint;
	NSRect tempRect;
	int stackNum;
	Stack *pile;
	Card *card;
	NSUndoManager *undo = [self undoManager];
	tempPoint = [self convertPoint:p fromView:nil];
	if(isDragging) {
		currentPoint.x = tempPoint.x - difference.x;
		currentPoint.y = tempPoint.y - difference.y;
		if (currentPoint.x < 0) {
			currentPoint.x = 0;
			/*difference.x = tempPoint.x - currentPoint.x;
			if(difference.x < 0)
				difference.x = 0;*/
		}
		if (currentPoint.y < 0) {
			currentPoint.y = 0;
			/*difference.y = tempPoint.y - currentPoint.y;
			if(difference.y < 0)
				difference.y = 0;*/
		}
		//NSSize imageSize = [backImage size];
		NSRect bounds = [self bounds];
		if (normalSize.width + currentPoint.x > bounds.size.width) {
			currentPoint.x = bounds.size.width - normalSize.width;
			/*difference.x = tempPoint.x - currentPoint.x;
			if(difference.x > normalSize.width)
				difference.x = normalSize.width;*/
		}
		if (normalSize.height + currentPoint.y > bounds.size.height) {
			currentPoint.y = bounds.size.height - normalSize.height;
			/*difference.y = tempPoint.y - currentPoint.y;
			if(difference.y > normalSize.height)
				difference.y = normalSize.height;*/
		}
		stackNum = currentPoint.x / (normalSize.width + 35);
		pile = [piles objectAtIndex:stackNum];
		card = [pile tail];
		if(!card) {
			tempRect.origin.x = stackNum * (normalSize.width + 35) + 35;
			tempRect.origin.y = 44 + normalSize.height;
			tempRect.size = normalSize;
		} else
			tempRect = [card drawRect];
		//NSLog(@"Card difference = %d",[card cardNum]/4 - [[dragStack top] cardNum]/4);
		//NSLog(@"Suit difference = %d",([card cardNum]%4 + [[dragStack top] cardNum]%4)%2);
		if([dragStack count] == 1 && stackNum > 2 && currentPoint.y > 22 && currentPoint.y < 22 + normalSize.height) {
			pile = [piles objectAtIndex:stackNum + 5];
			card = [pile tail];
			if(([pile count] == 0 && [[dragStack top] cardNum]%13 == 0/* == stackNum - 3*/) || 
			   /*([card cardNum] + 48 == [[dragStack top] cardNum]) || */
			   [card cardNum] + 1 == [[dragStack top] cardNum]/* + 4*/) {
				[[undo prepareWithInvocationTarget:self] setNeedsDisplay:YES];
				[[undo prepareWithInvocationTarget:self] undoAppendStackWithCard:[dragStack top] 
																	   currStack:(stackNum + 5)
																	   prevStack:oldStack];
				card = [[piles objectAtIndex:oldStack] tail];
				if([card isFaceDown]) {
					[card setIsFaceDown:NO];
					[[undo prepareWithInvocationTarget:card] setIsFaceDown:YES];
				}
				[undo setActionName:@"Move Card"];
				[pile appendStack:dragStack];
			}
			else
				[[piles objectAtIndex:oldStack] appendStack:dragStack];
		}
		else if(currentPoint.y > tempRect.origin.y && currentPoint.y < tempRect.origin.y + tempRect.size.height
			&& ![card isFaceDown] && /*(([card cardNum]/4 + 1 == [[dragStack top] cardNum]/4 &&
		   ([card cardNum]%4 + [[dragStack top] cardNum]%4)%5 > 1 && [card cardNum]%4 != [[dragStack top] cardNum]%4)*/
		   (([card cardNum]%13 == [[dragStack top] cardNum]%13 + 1 && (([card cardNum] < 26 && [[dragStack top] cardNum] > 26) || 
		   ([card cardNum] > 26 && [[dragStack top] cardNum] < 26))) ||
									  ([[dragStack top] cardNum]%13/* /4 */ == 12) && [[piles objectAtIndex:stackNum] count] == 0)) {
				
			[[undo prepareWithInvocationTarget:self] setNeedsDisplay:YES];
			[[undo prepareWithInvocationTarget:self] updateOrigin:oldStack];
			[[undo prepareWithInvocationTarget:self] undoAppendStackWithCard:[dragStack top] 
																   currStack:stackNum
																   prevStack:oldStack];
			card = [[piles objectAtIndex:oldStack] tail];
			if([card isFaceDown]) {
				[card setIsFaceDown:NO];
				[[undo prepareWithInvocationTarget:card] setIsFaceDown:YES];
			}
			[undo setActionName:@"Move Cards"];
			[pile appendStack:dragStack];
			[self updateOrigin:stackNum];
			if(oldStack == 13 && !oneCard && [[piles objectAtIndex:13] count] == 0) {
				[self putCard:NO fromStack:12 toBottomOfStack:13];
				[[undo prepareWithInvocationTarget:self] putCard:YES fromStack:13 toBottomOfStack:12];
			}
		}
		else
			[[piles objectAtIndex:oldStack] appendStack:dragStack];
		dragStack = nil;
		[self setNeedsDisplay:YES];
	}
	isDragging = NO;
	BOOL isOver = NO;
	int choice,i;
	if([[piles objectAtIndex:7] count]==0 && [[piles objectAtIndex:12] count]==0 && [[piles objectAtIndex:13] count]==0) {
		for(i=0;i<7;i++) {
			pile = [piles objectAtIndex:i];
			card = [pile top];
			if(![card isFaceDown])
				isOver = YES;
			else {
				isOver = NO;
				break;
			}
		}
	}
	/*for(i=8;i<12;i++) {
		pile = [piles objectAtIndex:i];
		card = [pile tail];
		if([card cardNum]/4 == 1)
			isOver = YES;
		else {
			isOver = NO;
			break;
		}
	}*/
	if([solCont inProgress] && isOver) {
		choice = NSRunAlertPanel(@"You Win!",@"Would you like to play another game?",@"Yes",@"No",nil);
		if(choice == NSAlertDefaultReturn) {
			[solCont setInProgress:NO];
			[solCont newGame:nil];
		} else {
			[solCont setInProgress:NO];
		}
	}
}

- (NSRect)currentRect:(NSSize)imageSize
{	
	NSLog(@"cp =  %d %d",currentPoint.x,currentPoint.y);
	return NSMakeRect(currentPoint.x,currentPoint.y,imageSize.width,
		imageSize.height);
}

/*- (void)addCards:(NSMutableArray *)newCards
{
	Card *newCard;
	NSString *path;
	NSImage *image;
	NSNumber *num;
	int i = 0;
	int currCard = 0;
	int k;
	
	//e = [newCards objectEnumerator];
	//while ((num = [e nextObject]) && i<52) {
	for(k=0;k<7;k++){
		for (i=k,num=[newCards objectAtIndex:currCard];i<7;i++,num=[newCards objectAtIndex:++currCard]) {
			path = [myBundle pathForImageResource:[NSString stringWithFormat:@"%d",[num intValue]+1]];
			//NSLog(@"Path is %@,num is %d",path,[num intValue]+1);
			image = [[NSImage alloc] initWithContentsOfFile:path];
			if(image == nil)
				NSLog(@"Image error!");
			[image setFlipped:YES];
			NSSize imageSize = [image size];
			//NSRect rect = [self bounds];
			newCard = [[Card alloc] initWithFace:image isFaceDown:(i > k) 
				drawRect:NSMakeRect(i * (imageSize.width + 20) + 20,
				/*rect.size.height - imageSize.height - 20 + (k * (imageSize.height-65)),
				imageSize.width,imageSize.height - 65 * (1-(i==k)))
				withNum:num];
			[[piles objectAtIndex:i] push:newCard];
			[newCard release];
			[image release];
		}
	}
	/*for(i=0,num=[newCards objectAtIndex:0];i<13;num = [newCards objectAtIndex:++i]) {
		path = [myBundle pathForImageResource:[NSString stringWithFormat:@"%d",[num intValue]+1]];
		//NSLog(@"Path is %@,num is %d",path,[num intValue]+1);
		image = [[NSImage alloc] initWithContentsOfFile:path];
		if(image == nil)
			NSLog(@"Image error!");
		[image setFlipped:YES];
		newCard = [[Card alloc] initWithFace:image isFaceDown:NO drawRect:NSMakeRect(0,0,0,0)];
		[stack addObject:newCard];
		[newCard release];
		[image release];
	}
	downPoint = NSZeroPoint;
	currentPoint = NSZeroPoint;
	[self setNeedsDisplay:YES];
}*/

/*- (void)makeStack:(int)stackNum fromArray:(NSArray *)cardArray
{
	int i;
	NSNumber *num;
	NSString *path;
	NSImage *image;
	Card *newCard;
	for (i=0;i<[cardArray count];i++) {
		num = [cardArray objectAtIndex:i];
		path = [myBundle pathForImageResource:[NSString stringWithFormat:@"%d",[num intValue]]];
		image = [[NSImage alloc] initWithContentsOfFile:path];
		if(image == nil)
			NSLog(@"Image error!");
		[image setFlipped:YES];
		NSSize imageSize = [image size];
		if (stackNum == 7) {
			newCard = [[Card alloc] initWithFace:image isFaceDown:NO
				drawRect:NSMakeRect(stackNum * (imageSize.width + 35) + 35,
				/*20 + (i * (imageSize.height-65))0, imageSize.width,
				/*imageSize.height - 65 * (1-(i==[cardArray count]-1))0)
				withNum:num];
		} else {
			newCard = [[Card alloc] initWithFace:image isFaceDown:(stackNum > i) 
				drawRect:NSMakeRect(stackNum * (imageSize.width + 35) + 35,
				/*20 + (i * (imageSize.height-65))0, imageSize.width,
				/*imageSize.height - 65 * (1-(i==stackNum))0)
				withNum:num];
		}
		[[piles objectAtIndex:stackNum] push:newCard];
		[newCard release];
		[image release];
	}
}*/

- (void)deal:(NSArray *)deck
{
	NSNumber *num;
	NSString *path;
	NSImage *image;
	Card *newCard;
	Stack *pile;
	int k,i,currCard = 0;
	
	for (k=0;k<7;k++) {
		for (i=k;i<7;i++,currCard++) {
			num=[deck objectAtIndex:currCard];
			path = [myBundle pathForImageResource:[NSString stringWithFormat:@"%d",[num intValue]]];
			image = [[NSImage alloc] initWithContentsOfFile:path];
			if(image == nil)
				NSLog(@"Image error!");
			[image setFlipped:YES];
			NSSize imageSize = [image size];
			newCard = [[Card alloc] initWithFace:image isFaceDown:(i != k) 
				drawRect:NSMakeRect(i * (imageSize.width + 35) + 35,
				/*20 + (i * (imageSize.height-65))*/0, imageSize.width,
				/*imageSize.height - 65 * (1-(i==stackNum))*/0)
				withNum:num];
			[[piles objectAtIndex:i] push:newCard];
			[newCard release];
			[image release];
		}
	}
	pile = [piles objectAtIndex:7];
	for (k=28;k<52;k++) {
		num=[deck objectAtIndex:k];
		path = [myBundle pathForImageResource:[NSString stringWithFormat:@"%d",[num intValue]]];
		image = [[NSImage alloc] initWithContentsOfFile:path];
		if(image == nil)
			NSLog(@"Image error!");
		[image setFlipped:YES];
		NSSize imageSize = [image size];
		newCard = [[Card alloc] initWithFace:image isFaceDown:NO 
			drawRect:NSMakeRect(7 * (imageSize.width + 35) + 35,
			/*20 + (i * (imageSize.height-65))*/0, imageSize.width,
			/*imageSize.height - 65 * (1-(i==stackNum))*/0)
			withNum:num];
		[pile push:newCard];
		[newCard release];
		[image release];
		//[pile addObject:[deck objectAtIndex:currCard++]];
	}
}

- (void)undoAppendStackWithCard:(Card *)topCard currStack:(int)currStack prevStack:(int)prevStack
{
	Stack *temp,*pile;
	
	pile = [piles objectAtIndex:currStack];
	temp = [pile getStackFromCard:topCard];
	pile = [piles objectAtIndex:prevStack];
	[pile appendStack:temp];
}

- (void)putCard:(BOOL)top fromStack:(int)from toBottomOfStack:(int)to
{
	Card *card;
	Stack *pile;
	NSRect tempRect;
	//int i;
	
	pile = [piles objectAtIndex:from];
	if(top)
		card = [pile removeHead];
	else
		card = [pile removeTail];
	pile = [piles objectAtIndex:to];
	tempRect = [[pile tail] drawRect];
	[card setDrawRect:NSMakeRect(tempRect.origin.x,0,normalSize.width,0)];
	[pile push:card];
	[card release];
	[self setNeedsDisplay:YES];
}

- (void)putCard:(BOOL)top fromStack:(int)from toTopOfStack:(int)to
{
	Card *card;
	Stack *pile;
	NSRect tempRect;
	//int i;
	
	pile = [piles objectAtIndex:from];
	if(top)
		card = [pile removeHead];
	else
		card = [pile removeTail];
	pile = [piles objectAtIndex:to];
	tempRect = [[pile tail] drawRect];
	[card setDrawRect:NSMakeRect(tempRect.origin.x,0,normalSize.width,0)];
	[pile insert:card];
	[card release];
	[self setNeedsDisplay:YES];
}

- (void)updateOrigin:(int)stackNum
{
	Stack *pile = [piles objectAtIndex:stackNum];
	Card *card;
	
	for(card = [pile top];card != nil; card = [card nextCard])
		[card setDrawRect:NSMakeRect(stackNum * (normalSize.width + 35) + 35,0, normalSize.width,0)];
}

- (void)setOneCard:(BOOL)hasOneCard
{
	oneCard = hasOneCard;
}

- (void)setBGColor:(NSColor *)newBGColor
{
	[newBGColor retain];
	[bgColor release];
	bgColor = newBGColor;
	[self setNeedsDisplay:YES];
}

- (void)setRedBack:(BOOL)backIsRed
{
	NSString *path;
	if(backIsRed)
		path = [myBundle pathForImageResource:@"b2fv.png"];
	else
		path = [myBundle pathForImageResource:@"b1fv.png"];
	[backImage release];
	backImage = [[NSImage alloc] initWithContentsOfFile:path];
	[self setNeedsDisplay:YES];
}

- (void)setParent:(SolitaireController *)parent
{
	solCont = parent;
}

- (void)dealloc
{
	[piles release];
	//[stack release];
	[aceImages release];
	[backImage release];
	[bgColor release];
	[myBundle release];
	[super dealloc];
}

@end
