//
//  MLKeyboardToolbar.m
//  Networking
//
//  Created by Mauricio Minestrelli on 9/3/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLKeyboardToolbar.h"

@implementation MLKeyboardToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor lightGrayColor];
        self.translucent = YES;
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.okButton = [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:nil action:nil];
        self.okButton.tintColor= [UIColor blueColor];
        self.items =   @[flexibleSpaceLeft, self.okButton];
    }
    return self;
}

@end