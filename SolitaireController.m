#import "SolitaireController.h"
#import "CardView.h"
#import "PreferenceController.h"

@implementation SolitaireController

- (id)init
{
	int i;
	NSNumber *num;
	//NSMutableArray *pile;
	
	[super init];
	deck = [[NSMutableArray alloc] init];
	for (i=0;i<52;i++) {
		num = [[NSNumber alloc] initWithInt:i];
		[deck addObject:num];
		[num release];
	}
	/*piles = [[NSMutableArray alloc] initWithCapacity:12];
	for (i=0;i<12;i++) {
		if(i<7)
			pile = [[NSMutableArray alloc] initWithCapacity:i+1];
		else if(i==7)
			pile = [[NSMutableArray alloc] initWithCapacity:52-28];
		else
			pile = [[NSMutableArray alloc] initWithCapacity:13];
		[piles addObject:pile];
		[pile release];
	}*/
	toolbar = [[NSToolbar alloc] initWithIdentifier:@"Solitaire"];
	[toolbar setDelegate:self];
	[toolbar setAllowsUserCustomization:NO];
	restart = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"restart"]];
	undo = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"undo"]];
	pref = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"pref"]];
	newgame = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"newgame"]];
	//[toolbar setShowsBaselineSeparator:YES];
	//undo = [[NSUndoManager alloc] init];
	//[[undo prepareWithInvocationTarget:self] newGame:nil];
	inProgress = NO;
	return self;
}

+ (void)initialize
{
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	
	NSData *colorAsData = [NSKeyedArchiver 
		archivedDataWithRootObject:[NSColor colorWithCalibratedRed:0.0 green:0.501961 blue:0.0 alpha:1.0]];
	
	[defaultValues setObject:colorAsData forKey:BNRTableBGColorKey];
	[defaultValues setObject:[NSNumber numberWithInt:0] forKey:BNRCardNumKey];
	//[defaultValues setObject:[NSNumber numberWithInt:0] forKey:BNRGameRulesKey];
	[defaultValues setObject:[NSNumber numberWithInt:0] forKey:BNRCardBackKey];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	//NSLog(@"registered defaults %@",defaultValues);
}

- (void)awakeFromNib
{
	[window setToolbar:toolbar];
}

- (BOOL)inProgress
{
	return inProgress;
}

- (void)setInProgress:(BOOL)isInProgress
{
	if(!isInProgress) {
		//int i;
		[cardView clean];
		/*NSMutableArray *pile;
		[piles release];
		piles = [[NSMutableArray alloc] initWithCapacity:12];
		for (i=0;i<12;i++) {
			if(i<7)
				pile = [[NSMutableArray alloc] initWithCapacity:i+1];
			else if(i==7)
				pile = [[NSMutableArray alloc] initWithCapacity:52-28];
			else
				pile = [[NSMutableArray alloc] initWithCapacity:13];
			[piles addObject:pile];
			[pile release];
		}*/
		inProgress = NO;
		[cardView setNeedsDisplay:YES];
	}
}

/*- (IBAction)test:(id)sender
{
	NSNumber *num;
	NSMutableArray *pile, *pile2;
	
	pile = [piles objectAtIndex:7];
	pile2 = [piles objectAtIndex:0];
	num = [pile objectAtIndex:0];
	[pile2 addObject:num];
	[pile removeObjectAtIndex:0];
	[cardView putCard:YES fromStack:7 toBottomOfStack:0];
}*/

- (IBAction)newGame:(id)sender
{
	long choice=0;
	
	if([[NSString stringWithFormat:@"%@",[sender class]] isEqual:@"NSToolbarItem"]){
		if([sender tag] == 0){
			if(inProgress) {
				choice = NSRunAlertPanel(@"Game in progress!",@"Would you like to start a new game?",@"Yes",@"No",nil);
				if(NSAlertDefaultReturn == choice) {
					currSeed = time(NULL);
					srandom(currSeed);
				} else
					return;
			} else {
				currSeed = time(NULL);
				srandom(currSeed);
			}
		} else {
			if(inProgress) {
				choice = NSRunAlertPanel(@"Game in progress!",@"Would you like to restart this game?",@"Yes",@"No",nil);
				if(NSAlertDefaultReturn == choice) {
					srandom(currSeed);
				} else
					return;
			} else {
				currSeed = time(NULL);
				srandom(currSeed);
			}
		}
		[cardView clean];
		//NSMutableArray *pile;
		/*[piles release];
		piles = [[NSMutableArray alloc] initWithCapacity:8];
		for (i=0;i<8;i++) {
			if(i<7)
				pile = [[NSMutableArray alloc] initWithCapacity:i+1];
			else if(i==7)
				pile = [[NSMutableArray alloc] initWithCapacity:52-28];
			else
				pile = [[NSMutableArray alloc] initWithCapacity:13];
			[piles addObject:pile];
			[pile release];
		}*/
	} else if(inProgress) {
		choice = NSRunAlertPanel(@"Game in progress!",@"What would you like to do?",@"Same game",@"Cancel",@"New Game");
		if(NSAlertAlternateReturn == choice)
				return;
		else if(NSAlertDefaultReturn == choice)
			srandom(currSeed);
		else {
			currSeed = time(NULL);
			srandom(currSeed);
		}
		[cardView clean];
		//NSMutableArray *pile;
		//[piles release];
		/*piles = [[NSMutableArray alloc] initWithCapacity:8];
		for (i=0;i<8;i++) {
			if(i<7)
				pile = [[NSMutableArray alloc] initWithCapacity:i+1];
			else if(i==7)
				pile = [[NSMutableArray alloc] initWithCapacity:52-28];
			else
				pile = [[NSMutableArray alloc] initWithCapacity:13];
			[piles addObject:pile];
			[pile release];
		}*/
	} else {
		currSeed = time(NULL);
		srandom(currSeed);
	}
	[self shuffle];
	//[self deal];
	[cardView deal:deck];
	//[deck release];
	//deck = nil;
	inProgress = YES;
	//currCard = -1;
	//[cardView addCards:deck];
	[cardView setParent:self];
	[cardView setNeedsDisplay:YES];
}

- (void)shuffle
{
	//NSEnumerator *e;
	NSNumber *num;
	int i, rand;
	
	for (i=0;i<52;i++){
		num = [[NSNumber alloc] initWithInt:i];
		[deck replaceObjectAtIndex:i withObject:num];
		[num release];
	}
	for (i=0;i<52;i++) { //cool shuffling algorithm
		rand = random() % 52;
		[deck exchangeObjectAtIndex:i withObjectAtIndex:rand];
	}
	//currCard = 0;
	//e = [deck objectEnumerator];
	//while (num = [e nextObject]) {
	//	NSLog(@"%d\n",[num intValue]);
	//}
}

/*- (void)deal
{
	int k,i;
	NSNumber *num;
	NSMutableArray *pile;
	for (k=0;k<7;k++) {
		for (i=k,num=[deck objectAtIndex:currCard];i<7;i++,num=[deck objectAtIndex:++currCard]) {
			[[piles objectAtIndex:i] addObject:num];
		}
	}
	pile = [piles objectAtIndex:7];
	for (k=28;k<52;k++) {
		[pile addObject:[deck objectAtIndex:currCard++]];
	}
	//NSLog(@"Current Card = %d",currCard);
	for (k=0;k<8;k++) {
		[cardView makeStack:k fromArray:[piles objectAtIndex:k]];
	}
}*/

- (IBAction)showPreferencePanel:(id)sender
{
	//NSLog(@"Is showing preference panel");
	if(!prefCont) {
		prefCont = [[PreferenceController alloc] init];
	}
	[prefCont setParent:self];
	[prefCont setDefaults];
	[prefCont showWindow:self];
}

- (void)changeBGColor:(NSColor *)newColor
{
	[cardView setBGColor:newColor];
}

- (void)setOneCard:(BOOL)hasOneCard
{
	[cardView setOneCard:hasOneCard];
}

- (void)setRedBack:(BOOL)backIsRed
{
	[cardView setRedBack:backIsRed];
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
	return nil;
}

- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *) toolbar {
    return [NSArray arrayWithObjects: @"New Game",
		@"Restart Game",
		@"Undo",
		NSToolbarSeparatorItemIdentifier,
		@"Preferences", nil];
}

- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *) toolbar {
    return [NSArray arrayWithObjects: @"New Game",
		@"Restart Game",
		@"Undo",
		NSToolbarSeparatorItemIdentifier,
		@"Preferences",
        nil];
}

- (NSToolbarItem *) toolbar:(NSToolbar *)toolbar
      itemForItemIdentifier:(NSString *)itemIdentifier
  willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
	
    if ([itemIdentifier isEqual: @"New Game"]) {
		// Set the text label to be displayed in the 
		// toolbar and customization palette 
		[toolbarItem setLabel:@"New Game"];
		[toolbarItem setPaletteLabel:@"New Game"];
		
		// Set up a reasonable tooltip, and image
		// you will likely want to localize many of the item's properties 
		[toolbarItem setToolTip:@"Start a new game"];
		[toolbarItem setImage:newgame];
		
		// Tell the item what message to send when it is clicked 
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(newGame:)];
		[toolbarItem setTag:0];
    } else if ([itemIdentifier isEqual: @"Restart Game"]) {
		// Set the text label to be displayed in the 
		// toolbar and customization palette 
		[toolbarItem setLabel:@"Restart"];
		[toolbarItem setPaletteLabel:@"Restart"];
		
		
		// Set up a reasonable tooltip, and image
		// you will likely want to localize many of the item's properties 
		[toolbarItem setToolTip:@"Restart this game"];
		[toolbarItem setImage:restart];
		
		// Tell the item what message to send when it is clicked 
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(newGame:)];
		[toolbarItem setTag:1];
    } else if ([itemIdentifier isEqual: @"Preferences"]) {
		// Set the text label to be displayed in the 
		// toolbar and customization palette 
		[toolbarItem setLabel:@"Preferences"];
		[toolbarItem setPaletteLabel:@"Preferences"];
		
		// Set up a reasonable tooltip, and image
		// you will likely want to localize many of the item's properties 
		[toolbarItem setToolTip:@"Open preferences"];
		[toolbarItem setImage:pref];
		
		// Tell the item what message to send when it is clicked 
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(showPreferencePanel:)];
    } else if ([itemIdentifier isEqual: @"Undo"]) {
		// Set the text label to be displayed in the 
		// toolbar and customization palette 
		[toolbarItem setLabel:@"Undo"];
		[toolbarItem setPaletteLabel:@"Undo"];
		
		// Set up a reasonable tooltip, and image
		// you will likely want to localize many of the item's properties 
		[toolbarItem setToolTip:@"Undo last move"];
		[toolbarItem setImage:undo];
		
		// Tell the item what message to send when it is clicked 
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(undo)];
    }
	else {
		// itemIdentifier referred to a toolbar item that is not 
		// not provided or supported by us or cocoa 
		// Returning nil will inform the toolbar 
		// this kind of item is not supported 
		toolbarItem = nil;
    }
    return toolbarItem;
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)toolbarItem
{
	BOOL enable = NO;
    if ([[toolbarItem itemIdentifier] isEqual:@"Restart Game"]) {
        // We will return YES (enable the save item)
        // only when the document is dirty and needs saving
        enable = inProgress;
    } else if([[toolbarItem itemIdentifier] isEqual:@"Undo"]) {
		enable = [[cardView undoManager] canUndo];
	} else {
        // always enable print for this window
        enable = YES;
    }
    return enable;
}

- (void)undo
{
	[[cardView undoManager] undo];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

/*- (IBAction)raiseSheet:(id)sender
{
	[NSApp beginSheet:testSheet
	   modalForWindow:window
		modalDelegate:self
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
		  contextInfo:NULL];
}

- (void)sheetDidEnd:(NSWindow *)sheet
		 returnCode:(int)returnCode
		contextInfo:(void *)contextInfo
{
	NSLog(@"Coolio");
}

- (IBAction)hideSheet:(id)sender
{
	[testSheet orderOut:sender];
	[NSApp endSheet:testSheet returnCode:1];
}*/

- (void)dealloc
{
	[deck release];
	[piles release];
	[toolbar release];
	[prefCont release];
	[restart release];
	[pref release];
	[undo release];
	[newgame release];
	[super dealloc];
}

@end
