//
//  AppDelegate.h
//  unmountMe
//
//  Created by Valera Antonov on 3/28/13.
//  Copyright (c) 2013 Valera Antonov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Unmounter.h"
#import "Menu.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
- (IBAction)unmountDisks:(id)sender;
@property (weak) IBOutlet NSTextField *infoLabel;
@property (weak) IBOutlet NSProgressIndicator *spinner;
@property (weak) IBOutlet NSMenu *tray;
@property (strong) Menu *myMenu;
@property (strong) IBOutlet NSWindow *prefsWindow;
@property (weak) NSTimer *myTimer;
- (IBAction)checkBoxStateHasBeenChanged:(id)sender;
@property (weak) IBOutlet NSButton *checkBox;
@property (strong) NSUserDefaults *defaultSettings;


- (void)startTimer;
- (void)stopTimer;
- (void)timerFired:(NSTimer*)theTimer;
- (void)sendNotification:(int)withNumberOfDisksUnmounted;

@end
