//
//  AppDelegate.m
//  unmountMe
//
//  Created by Valera Antonov on 3/28/13.
//  Copyright (c) 2013 Valera Antonov. All rights reserved.
//

#import "AppDelegate.h"
#define DISKLIST 3

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _myMenu = [[Menu alloc]initTrayWithMenu:_tray];
    _defaultSettings = [NSUserDefaults standardUserDefaults];
    [_checkBox setState:[[_defaultSettings objectForKey:@"checkBoxState"]integerValue]];
    
    if([[_defaultSettings objectForKey:@"checkBoxState"] integerValue]) {
    //checkBoxState represents state of the CB in preferences, if true, we'll start timer
        [self startTimer];
    }
    
    
    //@@list devices at launch
    for(NSString *path in [Unmounter currentlyMountedDisks]) {
        NSMenuItem *item = [[NSMenuItem alloc]initWithTitle:path action:@selector(menuUnmountCallback:) keyEquivalent:@""];
        [item setEnabled:YES];
        [_tray insertItem:item atIndex:DISKLIST];
    }
    [_myMenu setTrayText:[NSString stringWithFormat:@"%u", [Unmounter currentlyMountedDisksNumber]]];
    //@@end
}

- (IBAction)unmountDisks:(id)sender {
    NSAlert *nothingToUnmount = [[NSAlert alloc]init];
    nothingToUnmount.messageText = @"Whoa!";
    nothingToUnmount.informativeText = @"Nothing to unmount";
    [_spinner setHidden:NO];
    [_spinner startAnimation:@""];
    int numberOfDisks = [Unmounter unmountAllDisks]; //returns number of unmounted disks; if no disks were unmounted, returns 65536 ('cos actually nobody will have 65536 disks mounted :-)
    if(numberOfDisks == 65536) {
        [nothingToUnmount runModal]; //show popup box
        numberOfDisks = 0; //needed to send notification with right number of disks
    }
    [self sendNotification:numberOfDisks];
    /* debug code
    [_infoLabel setStringValue:[NSString stringWithFormat:@"%u disks unmounted", numberOfDisks]];
    [_spinner stopAnimation:@""];
    [_spinner setHidden:YES]; */
    [_myMenu setTrayText:[NSString stringWithFormat:@"%u", [Unmounter currentlyMountedDisksNumber]]];
}

- (IBAction)showPrefs:(id)sender {
    [_prefsWindow makeKeyAndOrderFront:self]; //creates preferences window and makes it primary
}

- (IBAction)checkBoxStateHasBeenChanged:(id)sender {
    switch ([_checkBox state]) {
        case 0:
            [self stopTimer];
            break;
        case 1:
            [self startTimer];
            break;
        default:
            break;
    }
    NSNumber *state = [NSNumber numberWithLong:[_checkBox state]];
    [_defaultSettings setObject:state forKey:@"checkBoxState"]; //set new defaults value
}

- (IBAction)listAllDevs:(id)sender {
    if ([[_tray itemArray]count] > 2)
    {
        int count = (int)[[_tray itemArray]count];
        for (int i = count-1; i > 1; i--) {
            NSString *line = [[_tray itemAtIndex:i]title];
            if([line rangeOfString:@"/Volumes"].location != NSNotFound) {
            [_tray removeItemAtIndex:i];
            }
        }
    }
    for(NSString *path in [Unmounter currentlyMountedDisks]) {
        NSMenuItem *item = [[NSMenuItem alloc]initWithTitle:path action:@selector(menuUnmountCallback:) keyEquivalent:@""];
        [item setEnabled:YES];
        [_tray insertItem:item atIndex:3];
        [_myMenu setTrayText:[NSString stringWithFormat:@"%i", [Unmounter currentlyMountedDisksNumber]]];
    }
}

- (IBAction)menuUnmountCallback:(id)sender {
    //invoked by menu item (@selector(menuUnmountCallback:))
    [Unmounter unmountDeviceAtPath:[sender title]];
    [_tray removeItem:sender];
    [_myMenu setTrayText:[NSString stringWithFormat:@"%i", [Unmounter currentlyMountedDisksNumber]]];

}

-(void)startTimer {
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

-(void) timerFired:(NSTimer *)theTimer { [self listAllDevs:nil]; }
-(void) stopTimer { [_myTimer invalidate]; } // we don't really use this method, overengineering

- (IBAction)launchTimer:(id)sender {
    [self startTimer];
}

- (IBAction)showAboutPanel:(id)sender {
    NSDictionary *options = @{@"Version":@"1.0c", @"ApplicationName":@"Unmounter", @"Copyright":@"by Valera Antonov", @"ApplicationVersion":@"Unmounter™ 1.0.1"};
    [[NSApplication sharedApplication]orderFrontStandardAboutPanelWithOptions:options];
} //custom about panel

- (void)sendNotification:(int)numberOfDisksUnmounted { //sends notification to ML notification center (obviously, 10.8+)
    if(numberOfDisksUnmounted > 0)
    {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Disks succesfully unmounted!";
    notification.informativeText = [NSString stringWithFormat:@"%i disks were ejected", numberOfDisksUnmounted];
    notification.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
}

@end
