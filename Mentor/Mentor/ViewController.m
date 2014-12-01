//
//  ViewController.m
//  Mentor
//
//  Created by alex on 11/20/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "NSImage+HHTint.h"
#import "ViewController.h"
#import "NSColor+Util.h"

@interface ViewController ()

@property (strong) IBOutlet NSImageView *imageView;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong) NSURL *selectedFolderURL;
@property (strong) NSTimer *scanTimer;
@property (strong) IBOutlet NSTextField *selectedFolderLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTopMenu];
    
}

- (void)setupTopMenu {

    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    // The text that will be shown in the menu bar
    _statusItem.title = @"";

    // The image that will be shown in the menu bar, a 16x16 black png works best
    _statusItem.image = [NSImage imageNamed:@"menuItem"];

    // The highlighted image, use a white version of the normal image
    _statusItem.alternateImage = [NSImage imageNamed:@"menuItemWhite"];

    // The image gets a blue background when the item is selected
    _statusItem.highlightMode = YES;

    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Show settings" action:@selector(openApp:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Refresh" action:@selector(refreshApp:) keyEquivalent:@""];

    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Quit Mentor" action:@selector(terminate:) keyEquivalent:@""];
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




- (IBAction)sendFileButtonAction:(id)sender{

    NSOpenPanel* openDlg = [NSOpenPanel openPanel];

    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setPrompt:@"Select"];


    if ( [openDlg runModal] == NSFileHandlingPanelOKButton ) {

        NSArray* urls = [openDlg URLs];
        self.selectedFolderURL = urls.firstObject;
        self.selectedFolderLabel.stringValue = [[self.selectedFolderURL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        [self restartTimer];


    }
    
}

- (void)restartTimer {

    [self.scanTimer invalidate];
    self.scanTimer = nil;
    [self scanFolder];

    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scanFolder) userInfo:nil repeats:YES];
}

- (void)scanFolder {

    NSMutableArray *images = [NSMutableArray array];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *contents = [fileManager contentsOfDirectoryAtURL:self.selectedFolderURL
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
    [self updateMenuItemForCount:images.count];
}

- (void)updateMenuItemForCount:(NSUInteger)count {

    if (count < 3) {


        self.statusItem.image = [self.statusItem.image bwTintedImageWithColor:[NSColor colorWithHexColorString:@"FFC000"]];


    } else if (count >= 3 ) {

      self.statusItem.image = [self.statusItem.image bwTintedImageWithColor:[NSColor colorWithHexColorString:@"C00000"]];

    }
}

@end
