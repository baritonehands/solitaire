/* CardView */

#import <Cocoa/Cocoa.h>
@class Stack;
@class Card;
@class SolitaireController;

@interface CardView : NSView
{
	NSBundle *myBundle;
	NSMutableArray *piles;
	NSMutableArray *aceImages;
	//NSMutableArray *undoDragStacks;
	//NSMutableArray *stack;
	NSImage *backImage;
	NSColor *bgColor;
	//NSUndoManager *undo;
	//NSImage *backPartImage;
	//NSPoint downPoint;
	NSPoint currentPoint;
	NSPoint difference;
	NSSize normalSize, backSize;
	Stack *dragStack;
	//Card *backCard;
	SolitaireController *solCont;
	NSRect dragRect;
	int oldStack;
	BOOL isDragging,oneCard;
}

//- (void)addCards:(NSMutableArray *)newCards;
//- (void)makeStack:(int)stackNum fromArray:(NSArray *)cardArray;
- (void)deal:(NSArray *)deck;
- (NSRect)currentRect:(NSSize)imageSize;
- (void)clean;
- (void)putCard:(BOOL)top fromStack:(int)from toBottomOfStack:(int)to;
- (void)putCard:(BOOL)top fromStack:(int)from toTopOfStack:(int)to;
- (void)updateOrigin:(int)stackNum;
- (void)setOneCard:(BOOL)hasOneCard;
- (void)setBGColor:(NSColor *)newBGColor;
//- (void)setVegasRules:(BOOL)newRules;
- (void)setRedBack:(BOOL)backIsRed;
- (void)setParent:(SolitaireController *)parent;
- (void)undoAppendStackWithCard:(Card *)topCard currStack:(int)currStack prevStack:(int)prevStack;
//- (void)putBottomCardFromStack:(int)from toBottomOfStack:(int)to;
//- (void)clearTrackingRect;
@end
