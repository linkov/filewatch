//
//  ViewController.m
//  Mentor
//
//  Created by alex on 11/20/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong) IBOutlet NSImageView *imageView;
@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray *images = [NSMutableArray array];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *bundleURL = [NSURL URLWithString:@"file:///Users/linkov/Desktop"];

    NSArray *contents = [fileManager contentsOfDirectoryAtURL:bundleURL
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == 'png'"];

    for (NSURL *fileURL in [contents filteredArrayUsingPredicate:predicate]) {

        NSLog(@"file - %@",fileURL);
        NSImage *img = [[NSImage alloc]initByReferencingURL:fileURL];
        [images addObject:img];
    }


    self.imageView.image = images.firstObject;

    
}

- (void)setupTopMenu {

    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    // The text that will be shown in the menu bar
    _statusItem.title = @"";

    // The image that will be shown in the menu bar, a 16x16 black png works best
    _statusItem.image = [NSImage imageNamed:@"feedbin-logo"];

    // The highlighted image, use a white version of the normal image
    _statusItem.alternateImage = [NSImage imageNamed:@"feedbin-logo-alt"];

    // The image gets a blue background when the item is selected
    _statusItem.highlightMode = YES;

    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Open Feedbin" action:@selector(openApp:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Refresh" action:@selector(refreshApp:) keyEquivalent:@""];

    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Quit Feedbin Notifier" action:@selector(terminate:) keyEquivalent:@""];
    _statusItem.menu = menu;
}

- (void)openApp:(id)sender {

}

- (void)refreshApp:(id)sender {

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
