//
//  ViewController.m
//  Mentor
//
//  Created by alex on 11/20/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWCodeStyleCase.h"
#import "NSImage+HHTint.h"
#import "SDWMainViewController.h"
#import "NSColor+Util.h"

@interface SDWMainViewController ()

@property (strong) IBOutlet NSImageView *imageView;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong) NSURL *selectedFolderURL;
@property (strong) NSTimer *scanTimer;
@property (strong) IBOutlet NSTextField *selectedFolderLabel;

@end

@implementation SDWMainViewController

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
        self.selectedFolderLabel.stringValue = [self fileNameFromURL:self.selectedFolderURL];
        [self restartTimer];

    }
    
}

- (NSString *)fileNameFromURL:(NSURL *)url {
    return [[url absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
}

- (void)restartTimer {

	[self.scanTimer invalidate];
	self.scanTimer = nil;
	[self scanFolder];

	self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scanFolder) userInfo:nil repeats:YES];
}

- (void)scanFolder {

    NSMutableArray *shortListed = [NSMutableArray array];

    NSFileManager *fileManager = [NSFileManager defaultManager];


    NSArray *contents = [fileManager contentsOfDirectoryAtURL:self.selectedFolderURL
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == 'm'"];

    for (NSURL *fileURL in [contents filteredArrayUsingPredicate:predicate]) {


        NSString * fileAsString = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];

        NSRange searchRange = NSMakeRange(0,fileAsString.length);
        NSRange foundRange;

        while (searchRange.location < fileAsString.length) {

            searchRange.length = fileAsString.length-searchRange.location;

            foundRange = [fileAsString rangeOfString:@"\n{" options:NSCaseInsensitiveSearch range:searchRange];

            if (foundRange.location != NSNotFound) {

                searchRange.location = foundRange.location+foundRange.length;

                NSUInteger numberOfLines, index, stringLength = searchRange.location;
                for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {

                    index = NSMaxRange([fileAsString lineRangeForRange:NSMakeRange(index, 0)]);
                     NSLog(@"index - %lu",(unsigned long)index);

                }

                SDWCodeStyleCase *newCase = [SDWCodeStyleCase new];
                newCase.type = @"Same line curlies";
                newCase.fileName = [self fileNameFromURL:fileURL];
                newCase.lineNumber = numberOfLines;
                [shortListed addObject:newCase];


            } else {

                break;
            }
        }


    }


    [self updateMenuWithCases:shortListed];
    [self updateMenuItemForCount:shortListed.count];
}



- (void)updateMenuWithCases:(NSArray *)casses {

    //NSString *string;

    [self.statusItem.menu removeAllItems];

    for (SDWCodeStyleCase *aCase in casses) {

        NSDictionary *attributes = @{ NSForegroundColorAttributeName:[NSColor blackColor], NSFontAttributeName: [NSFont fontWithName:@"DINPro-Bold" size:10] };
        NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@ - line %lu",aCase.type,aCase.fileName,aCase.lineNumber]];

        [attributedMessage setAttributes:attributes range:NSMakeRange(0, attributedMessage.string.length)];




        NSMenuItem *item = [NSMenuItem new];
        item.attributedTitle = attributedMessage;

        [self.statusItem.menu addItem:item];
    }

}

- (void)updateMenuItemForCount:(NSUInteger)count {

    if (count == 0) {
        self.statusItem.image = [self.statusItem.image bwTintedImageWithColor:[NSColor blackColor]];
    }

    if (count < 3) {

        self.statusItem.image = [self.statusItem.image bwTintedImageWithColor:[NSColor colorWithHexColorString:@"FFC000"]];

    } else if (count >= 3 ) {

      self.statusItem.image = [self.statusItem.image bwTintedImageWithColor:[NSColor colorWithHexColorString:@"C00000"]];

    }
}

@end
