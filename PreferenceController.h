//
//  PreferenceController.h
//  Solitaire
//
//  Created by Brian Gregg on 11/22/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SolitaireController;
extern NSString *BNRTableBGColorKey;
extern NSString *BNRCardNumKey;
//extern NSString *BNRGameRulesKey;
extern NSString *BNRCardBackKey;

@interface PreferenceController : NSWindowController {
	IBOutlet NSMatrix *numCards;
	//IBOutlet NSMatrix *gameRules;
	IBOutlet NSMatrix *cardBack;
	IBOutlet NSColorWell *tableBGColor;
	SolitaireController *parent;
	uint64_t ruleState,backState,cardNumState;
}
- (IBAction)changeNumberOfCards:(id)sender;
//- (IBAction)changeRules:(id)sender;
- (IBAction)changeCardBack:(id)sender;
- (IBAction)changeTableBGColor:(id)sender;
- (void)setDefaultsForKey:(NSString *)key;
- (NSColor *)tableBGColor;
- (void)setParent:(SolitaireController *)newParent;
- (void)setDefaults;
@end
