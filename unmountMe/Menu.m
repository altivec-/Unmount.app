//
//  Menu.m
//  unmountMe
//
//  Created by Valera Antonov on 3/28/13.
//  Copyright (c) 2013 Valera Antonov. All rights reserved.
//

#import "Menu.h"

@implementation Menu

- (id)initTrayWithMenu:(NSMenu *)appMenu {
    self = [super init];
    if(self) {
        NSStatusBar *bar = [NSStatusBar systemStatusBar];
        _item = [bar statusItemWithLength:NSVariableStatusItemLength];
        [_item setEnabled:YES];
        [_item setMenu:appMenu];
        NSImage *icon = [NSImage imageNamed:@"NSListViewTemplate"];
        [_item setImage:icon];
        [_item setHighlightMode:YES];
    }
    return self;

}
- (void)setTrayText:(NSString *)text {
    [_item setTitle:text];
}


@end
