/* SolitaireController */

#import <Cocoa/Cocoa.h>
@class CardView;
@class PreferenceController;

@interface SolitaireController : NSObject
{
    IBOutlet CardView *cardView;
	NSMutableArray *deck;
	NSMutableArray *piles;
	//NSUndoManager *undo;
	PreferenceController *prefCont;
	NSToolbar *toolbar;
	NSImage *restart,*undo,*pref,*newgame;
	IBOutlet NSWindow *window;
	//IBOutlet NSWindow *testSheet;
	long currSeed;
	BOOL inProgress;
}

- (void)shuffle;
- (IBAction)newGame:(id)sender;
//- (IBAction)test:(id)sender;
//- (void)deal;
- (IBAction)showPreferencePanel:(id)sender;
- (BOOL)inProgress;
- (void)setInProgress:(BOOL)isInProgress;
- (void)changeBGColor:(NSColor *)newColor;
- (void)setOneCard:(BOOL)hasOneCard;
- (void)setRedBack:(BOOL)backIsRed;
//- (void)setVegasRules:(BOOL)vegasRules;
- (void)undo;
/*- (IBAction)raiseSheet:(id)sender;
- (IBAction)hideSheet:(id)sender;*/
@end
