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

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
