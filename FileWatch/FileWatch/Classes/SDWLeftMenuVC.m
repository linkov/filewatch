//
//  SDWLeftMenuVC.m
//  Filewatch
//
//  Created by alex on 12/2/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWRecipe.h"
#import "SDWLeftMenuVC.h"

@interface SDWLeftMenuVC () <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) NSArray *items;


@end

@implementation SDWLeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.items = [self seededRecipies];
}

- (NSArray *)seededRecipies {


    SDWRecipe *curlies = [SDWRecipe new];
    curlies.name = @"Curly brackets should start on the same line as method name";
    curlies.offLimit = 1;
    curlies.amberLimit = 3;
    curlies.redLimit = 9;
    curlies.fileExtension = @"m";

    NSArray *recipes = @[curlies];

    return recipes;
}

#pragma mark - NSTableViewDataSource, NSTableViewDelegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.items.count;
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {

    // Get an existing cell with the MyView identifier if it exists
    NSTextField *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];

    // There is no existing cell to reuse so create a new one
    if (result == nil) {

        result = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        result.backgroundColor = [NSColor clearColor];
        result.bordered = NO;
        result.identifier = @"MyView";
    }

    SDWRecipe *recipe = self.items[row];

    result.stringValue = recipe.name;

    return result;
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 60;
}

//- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
//
//    NSTableRowView *r = [[NSTableRowView alloc]initWithFrame:CGRectMake(0, 0, 200, 60)];
//    return r;
//
//}
//
//- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
//
//}

@end
