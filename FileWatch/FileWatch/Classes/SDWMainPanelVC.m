//
//  ViewController.m
//  Filewatch
//
//  Created by alex on 11/20/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWMatch.h"
#import "NSImage+HHTint.h"
#import "SDWMainPanelVC.h"
#import "NSColor+Util.h"

@interface SDWMainPanelVC ()

@property (strong) IBOutlet NSImageView *imageView;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong) NSURL *selectedFolderURL;
@property (strong) NSTimer *scanTimer;
@property (strong) IBOutlet NSTextField *selectedFolderLabel;
@property (strong) NSMutableArray *shortListed;
@property (strong) IBOutlet NSTextField *regexField;
@property (strong) IBOutlet NSTextField *offField;
@property (strong) IBOutlet NSTextField *amberField;
@property (strong) IBOutlet NSTextField *redField;
@property (strong) IBOutlet NSTextField *extensionField;

@end

@implementation SDWMainPanelVC

- (void)viewDidLoad {

    [super viewDidLoad];
    [self setupTopMenu];
}

- (void)setupTopMenu {

    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.title = @"";

    _statusItem.image = [NSImage imageNamed:@"menuItem"];
    _statusItem.alternateImage = [NSImage imageNamed:@"menuItemWhite"];
    _statusItem.highlightMode = YES;

    NSMenu *menu = [[NSMenu alloc] init];
    _statusItem.menu = menu;

    [self addStandardMenuOptions];
}

- (void)openSettings:(id)sender {

    
}

- (void)quitApp:(id)sender {

    [[NSApplication sharedApplication] terminate:nil];
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

    self.shortListed = [NSMutableArray array];

    [self openEachFileAt:[self fileNameFromURL:self.selectedFolderURL]];

    [self updateMenuWithCases:self.shortListed];
    [self updateMenuItemForCount:self.shortListed.count];
}

-(void)openEachFileAt:(NSString *)path {

    NSString *docsDir = [NSOpenStepRootDirectory() stringByAppendingPathComponent:path];

    NSURL *file;
    NSDirectoryEnumerator* enumerator = [[NSFileManager defaultManager] enumeratorAtURL:[NSURL URLWithString:docsDir] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants errorHandler:nil];


    while (file = [enumerator nextObject])
    {
        // check if it's a directory
        BOOL isDirectory = NO;
        NSString *filePath = file.absoluteString;

        [[NSFileManager defaultManager] fileExistsAtPath: filePath
                                             isDirectory: &isDirectory];
        if (!isDirectory)
        {

            if ([file.pathExtension isEqualToString:self.extensionField.stringValue]) {



                NSString * fileAsString = [NSString stringWithContentsOfURL:file encoding:NSUTF8StringEncoding error:nil];

                NSRange searchRange = NSMakeRange(0,fileAsString.length);
                NSRange foundRange;

                while (searchRange.location < fileAsString.length) {

                    searchRange.length = fileAsString.length-searchRange.location;

                    NSString *regEx = self.regexField.stringValue;
                    foundRange = [fileAsString rangeOfString:regEx options:NSRegularExpressionSearch range:searchRange];

                    if (foundRange.location != NSNotFound) {

                        searchRange.location = foundRange.location+foundRange.length;

                        NSUInteger numberOfLines, index, stringLength = searchRange.location;
                        for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {

                            index = NSMaxRange([fileAsString lineRangeForRange:NSMakeRange(index, 0)]);
                            NSLog(@"index - %lu",(unsigned long)index);

                        }

                        SDWMatch *newCase = [SDWMatch new];
                        newCase.fileName = [self fileNameFromURL:file];
                        newCase.lineNumber = numberOfLines;
                        [self.shortListed addObject:newCase];


                    } else {

                        break;
                    }
                }


            }
        }
        else
        {
            [self openEachFileAt:filePath];
        }
    }

}


- (void)updateMenuWithCases:(NSArray *)casses {

    [self.statusItem.menu removeAllItems];

    for (SDWMatch *aCase in casses) {

        NSDictionary *attributes = @{ NSForegroundColorAttributeName:[NSColor blackColor], NSFontAttributeName: [NSFont fontWithName:@"DINPro-Bold" size:10] };
        NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - line %lu",aCase.fileName,aCase.lineNumber]];

        [attributedMessage setAttributes:attributes range:NSMakeRange(0, attributedMessage.string.length)];


        NSMenuItem *item = [NSMenuItem new];
        item.attributedTitle = attributedMessage;
        
        [self.statusItem.menu addItem:item];
    }

    [self addStandardMenuOptions];
}

- (void)addStandardMenuOptions {

    [self.statusItem.menu addItemWithTitle:@"Open Settings" action:@selector(openSettings:) keyEquivalent:@""];
    [self.statusItem.menu addItemWithTitle:@"Quit" action:@selector(quitApp:) keyEquivalent:@""];

    [self.statusItem.menu.itemArray makeObjectsPerformSelector:@selector(setTarget:) withObject:self];
}

- (void)updateMenuItemForCount:(NSUInteger)count {

    if (count >= [self.offField.stringValue integerValue] && count < [self.amberField.stringValue integerValue]) {
        self.statusItem.image = [self.statusItem.image bwTintedImageWithColor:[NSColor blackColor]];
    }

    if (count >= [self.amberField.stringValue integerValue] && count < [self.redField.stringValue integerValue]) {

        self.statusItem.image = [self.statusItem.image bwTintedImageWithColor:[NSColor colorWithHexColorString:@"FFC000"]];

    } else if (count >= [self.redField.stringValue integerValue] ) {

        self.statusItem.image = [self.statusItem.image bwTintedImageWithColor:[NSColor colorWithHexColorString:@"C00000"]];

    }
}

@end
