//
//  Menu.h
//  unmountMe
//
//  Created by Valera Antonov on 3/28/13.
//  Copyright (c) 2013 Valera Antonov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property (strong) NSStatusItem *item;
@property (strong) NSImage *icon;


- (id)initTrayWithMenu:(NSMenu *)appMenu;
- (void)setTrayText:(NSString *)text;

@end
