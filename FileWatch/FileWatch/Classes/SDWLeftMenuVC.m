//
//  SDWLeftMenuVC.m
//  Filewatch
//
//  Created by alex on 12/2/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWRecipe.h"
#import "SDWLeftMenuVC.h"
#import "JWCTableView.h"

@interface SDWLeftMenuVC () <JWCTableViewDataSource, JWCTableViewDelegate>
@property (strong) IBOutlet JWCTableView *tableView;

//@property (strong) NSArray *items;
@property (strong) NSArray *sections;
@property (strong) NSDictionary *content;

@property (nonatomic, retain) NSMutableArray *sectionKeys;
@property (nonatomic, retain) NSMutableDictionary *sectionContents;

@end

@implementation SDWLeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];

  //  self.items = [self seededRecipies];
//    self.sections = @[@"Programming",@"General"];
//    self.content = @{self.sections[0]:[self seededRecipies],self.sections[1]:[self seededRecipiesGeneral]};

    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableDictionary *contents = [[NSMutableDictionary alloc] init];

    NSString *general = @"General";
    NSString *programming = @"Programming";

    [contents setObject:[self seededRecipiesGeneral] forKey:general];
    [contents setObject:[self seededRecipies] forKey:programming];

    [keys addObject:general];
    [keys addObject:programming];


    self.sectionKeys = keys;
    self.sectionContents = contents;

}

- (NSArray *)seededRecipiesGeneral {

    SDWRecipe *curlies = [SDWRecipe new];
    curlies.name = @"Curly brackets should start on the same line as method name";
    curlies.offLimit = 1;
    curlies.amberLimit = 3;
    curlies.redLimit = 9;
    curlies.fileExtension = @"m";

    NSArray *recipes = @[curlies];

    return recipes;
}

- (NSArray *)seededRecipies {

    SDWRecipe *curlies = [SDWRecipe new];
    curlies.name = @"Curly brackets should start on the same line as method name";
    curlies.offLimit = 1;
    curlies.amberLimit = 3;
    curlies.redLimit = 9;
    curlies.fileExtension = @"m";

    NSArray *recipes = @[curlies,curlies];

    return recipes;
}


#pragma mark - JWCTableViewDataSource, JWCTableViewDelegate


-(BOOL)tableView:(NSTableView *)tableView shouldSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected section %ld, row %ld",(long)indexPath.section,(long)indexPath.row);
    return YES;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectSection:(NSInteger)section
{
    NSLog(@"Selected section header for section %ld", (long)section);
    return YES;
}



//Number of rows in section
-(NSInteger)tableView:(NSTableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSString *key = [[self sectionKeys] objectAtIndex:section];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    NSInteger rows = [contents count];

    return rows;

}

//Number of sections
-(NSInteger)numberOfSectionsInTableView:(NSTableView *)tableView {
    NSInteger sections = [[self sectionKeys] count];
    return sections;
}

//Has a header view for a section
-(BOOL)tableView:(NSTableView *)tableView hasHeaderViewForSection:(NSInteger)section {
    return YES;
}

//Height related
-(CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

-(CGFloat)tableView:(NSTableView *)tableView heightForHeaderViewForSection:(NSInteger)section {

    return 30;
}


-(NSView *)tableView:(NSTableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSTableCellView *resultView = [tableView makeViewWithIdentifier:@"cellView" owner:self];

    resultView.textField.stringValue = [[self sectionKeys] objectAtIndex:section];
    resultView.textField.textColor = [NSColor blackColor];

    return resultView;
}

-(NSView *)tableView:(NSTableView *)tableView viewForIndexPath:(NSIndexPath *)indexPath {


    NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    SDWRecipe *recipe = [contents objectAtIndex:[indexPath row]];


    NSTableCellView *resultView = [tableView makeViewWithIdentifier:@"cellView" owner:self];
    resultView.textField.stringValue = recipe.name;
    resultView.textField.textColor = [NSColor darkGrayColor];

    return resultView;
}

@end
