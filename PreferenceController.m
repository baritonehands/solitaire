//
//  PreferenceController.m
//  Solitaire
//
//  Created by Brian Gregg on 11/22/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"
#import "SolitaireController.h"

NSString *BNRTableBGColorKey=@"TableBGColor";
NSString *BNRCardNumKey=@"numCards";
//NSString *BNRGameRulesKey=@"gameRules";
NSString *BNRCardBackKey=@"cardBack";

@implementation PreferenceController

- (id)init
{
	self = [super initWithWindowNibName:@"Preferences"];
	return self;
}

- (void)windowDidLoad
{
	[self setDefaultsForKey:BNRCardNumKey];
	//[self setDefaultsForKey:BNRGameRulesKey];
	[self setDefaultsForKey:BNRCardBackKey];
	cardNumState = [[numCards selectedCell] tag];
	backState = [[cardBack selectedCell] tag];
	//ruleState = [[gameRules selectedCell] tag];
	//if(ruleState == 1) {
	//	[numCards setEnabled:NO];
	//}
	[tableBGColor setColor:[self tableBGColor]];
}

- (void)setDefaultsForKey:(NSString *)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *num = [defaults objectForKey:key];
	NSMatrix *buttons = [self valueForKey:key];
	[buttons selectCellWithTag:[num intValue]];
}

- (void)setDefaults
{
	[numCards selectCellWithTag:cardNumState];
	//[gameRules selectCellWithTag:ruleState];
	[cardBack selectCellWithTag:backState];
	[tableBGColor setColor:[self tableBGColor]];
}

- (NSColor *)tableBGColor
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *colorAsData = [defaults objectForKey:BNRTableBGColorKey];
	return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

- (IBAction)changeNumberOfCards:(id)sender
{
	int choice;
	if([parent inProgress]){
		choice = NSRunAlertPanel(@"Game in progess!",@"If you change these settings, your game will end.",
								 @"OK",@"Cancel",nil);
	} else {
		NSCell *cell = [sender selectedCell];
		cardNumState = [cell tag];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:[NSNumber numberWithInt:cardNumState] forKey:BNRCardNumKey];
		if(cardNumState == 0)
			[parent setOneCard:YES];
		else
			[parent setOneCard:NO];
		return;
	}
	if(choice == NSAlertDefaultReturn) {
		NSCell *cell = [sender selectedCell];
		cardNumState = [cell tag];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:[NSNumber numberWithInt:cardNumState] forKey:BNRCardNumKey];
		[parent setInProgress:NO];
		if(cardNumState == 0) {
			[parent setOneCard:YES];
		} else {
			[parent setOneCard:NO];
		}
	}
	else {
		//[self setDefaultsForKey:BNRCardNumKey];
		//[sender selectCellWithTag:cardNumState];
		[self close];
	}
}

/*- (IBAction)changeRules:(id)sender
{
	int choice;
	if([parent inProgress]){
		choice = NSRunAlertPanel(@"Game in progess!",@"If you change these settings, your game will end.",
								 @"OK",@"Cancel",nil);
		
	} else {
		NSCell *cell = [sender selectedCell];
		ruleState = [cell tag];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:[NSNumber numberWithInt:ruleState] forKey:BNRGameRulesKey];
		if(ruleState == 0) {
			[parent setVegasRules:NO];
			[numCards setEnabled:YES];
			if(cardNumState == 0) {
				[parent setOneCard:YES];
			} else {
				[parent setOneCard:NO];
			}
		} else {
			[parent setVegasRules:YES];
			[numCards setEnabled:NO];
			[parent setOneCard:YES];
		}
		return;
	}
	if(choice == NSAlertDefaultReturn) {
		NSCell *cell = [sender selectedCell];
		ruleState = [cell tag];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:[NSNumber numberWithInt:ruleState] forKey:BNRGameRulesKey];
		[parent setInProgress:NO];
		if(ruleState == 0) {
			[parent setVegasRules:NO];
			[numCards setEnabled:YES];
			if(cardNumState == 0) {
				[parent setOneCard:YES];
			} else {
				[parent setOneCard:NO];
			}
		} else {
			[parent setVegasRules:YES];
			[numCards setEnabled:NO];
			[parent setOneCard:YES];
		}
	} else
		//[self setDefaultsForKey:BNRGameRulesKey];
		[self close];
	
}*/

- (IBAction)changeCardBack:(id)sender
{
	NSCell *cell = [sender selectedCell];
	backState = [cell tag];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:backState] forKey:BNRCardBackKey];
	if(backState == 0)
		[parent setRedBack:YES];
	else
		[parent setRedBack:NO];
}

- (IBAction)changeTableBGColor:(id)sender
{
	NSColor *color = [sender color];
	NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:colorAsData forKey:BNRTableBGColorKey];
	[parent changeBGColor:color];
}

- (void)setParent:(SolitaireController *)newParent
{
	parent = newParent;
}

@end
