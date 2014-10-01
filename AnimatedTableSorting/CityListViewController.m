//
//  CityListViewController.m
//  AnimatedTableSorting
//
//  Created by Michael Neuwert on 12.05.13.
//  Copyright (c) 2013 Michael Neuwert. All rights reserved.
//

#import "CityListViewController.h"

@interface CityListViewController ()
@property (nonatomic, strong) NSArray *cities;
@end

@implementation CityListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //TODO
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Populate the data
    [self _loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.textLabel.text = self.cities[[indexPath row]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)sort {
    
    // We need an unsorted copy of the array for the animation
    NSArray *unsortedList = [self.cities copy];
    
    // Sort the elements and replace the array used by the data source with the sorted ones
    self.cities = [self.cities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    // Prepare table for the animations batch
    [self.tableView beginUpdates];
    
    // Move the cells around
    NSInteger sourceRow = 0;
    for (NSString *city in unsortedList) {
        NSInteger destRow = [self.cities indexOfObject:city];
        
        if (destRow != sourceRow) {
            // Move the rows within the table view
            NSIndexPath *sourceIndexPath = [NSIndexPath indexPathForItem:sourceRow inSection:0];
            NSIndexPath *destIndexPath = [NSIndexPath indexPathForItem:destRow inSection:0];
            [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destIndexPath];
            
        }
        sourceRow++;
    }
    
    // Commit animations
    [self.tableView endUpdates];
}

- (IBAction)reset {
    [self _loadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Private methods

- (void)_loadData {
    self.cities = @[@"Augsburg",
                    @"San Francisco",
                    @"Paris",
                    @"Moscow",
                    @"New York",
                    @"Rome",
                    @"Tokyo",
                    @"Astana",
                    @"Berlin",
                    @"St. Petersburg",
                    @"Shanghai",
                    @"Hamburg"
                    ];
}

@end
