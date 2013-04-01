//
//  Unmounter.m
//  unmountMe
//
//  Created by Valera Antonov on 3/28/13.
//  Copyright (c) 2013 Valera Antonov. All rights reserved.
//

#import "Unmounter.h"

@implementation Unmounter

+ (int)unmountAllDisks {
    unsigned numberOfUnmounted = 0;
    NSArray *listOfMedia = [[NSWorkspace sharedWorkspace]mountedRemovableMedia];
    if(![listOfMedia count])
    {
        //will return 65536 if no unmountable media present
        return 65536;
    }
    else
    {
        for (NSString *path in listOfMedia)
        {
            if([[NSWorkspace sharedWorkspace] unmountAndEjectDeviceAtPath:path])
            {
                NSLog(@"Device %@ unmounted successfully!", path);
                numberOfUnmounted++;
            }
            else
            {
                NSAlert *couldntUnmount = [[NSAlert alloc]init];
                couldntUnmount.informativeText = [NSString stringWithFormat:@"Couldn't unmount %@", path];
                NSLog(@"Couldn't unmount %@. Maybe something's using it?", path);
            }
        }
        NSLog(@"%d volumes unmounted", numberOfUnmounted);
    }
    return numberOfUnmounted;
}

+ (int)currentlyMountedDisksNumber {
    int count = (int)[[[NSWorkspace sharedWorkspace]mountedRemovableMedia]count];
    return count;
}

+ (NSArray *)currentlyMountedDisks {
    //NSLog(@"%@", [[NSWorkspace sharedWorkspace]mountedRemovableMedia]);
    return [[NSWorkspace sharedWorkspace]mountedRemovableMedia];
}

+ (void)unmountDeviceAtPath:(NSString*)path {
    //NSLog(@"will unmount %@", path);
    [[NSWorkspace sharedWorkspace]unmountAndEjectDeviceAtPath:path];
}

@end
