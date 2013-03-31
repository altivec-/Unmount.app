//
//  Unmounter.h
//  unmountMe
//
//  Created by Valera Antonov on 3/28/13.
//  Copyright (c) 2013 Valera Antonov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Unmounter : NSObject

+ (int)unmountAllDisks;
+ (int)currentlyMountedDisksNumber;
+ (NSArray*)currentlyMountedDisks;
+ (void)unmountDeviceAtPath:(NSString*)path;

@end
