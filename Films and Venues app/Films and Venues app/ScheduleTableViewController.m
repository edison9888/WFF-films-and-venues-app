//
//  ScheduleTableViewController.m
//  Films and Venues app
//
//  Created by Jordan Carney on 3/21/13.
//  Copyright (c) 2013 Jordan Carney. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "DMSlidingTableViewCell.h"

@interface ScheduleTableViewController () {
    NSMutableIndexSet* revealedCells;
}

@end

@implementation ScheduleTableViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Schedule";
        
        // Path to the plist (in the application bundle)
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          @"Movies" ofType:@"plist"];
        
        // Build the array from the plist
        _movieArray = [[NSArray alloc] initWithContentsOfFile:path];
        
        path = [[NSBundle mainBundle] pathForResource:
                @"Venues" ofType:@"plist"];
        
        _splitMovieArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 3; i++) {
            NSMutableArray *holderArray = [[NSMutableArray alloc] init];
            [_splitMovieArray addObject:holderArray];
        }
        
        for (NSDictionary *dict in _movieArray) {
            if ([[dict objectForKey:@"day"] isEqualToString: @"June 15"]) {
                [[_splitMovieArray objectAtIndex:0] addObject:dict];
            } else if ([[dict objectForKey:@"day"] isEqualToString: @"June 16"]) {
                [[_splitMovieArray objectAtIndex:1] addObject:dict];
            } else {
                [[_splitMovieArray objectAtIndex:2] addObject:dict];
            }
        }
        
        _venuesArray = [[NSArray alloc] initWithContentsOfFile:path]; 
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    revealedCells= [[NSMutableIndexSet alloc] init];
//    
//    
//    ADLivelyTableView * livelyTableView = (ADLivelyTableView *)self.tableView;
////    livelyTableView.initialCellTransformBlock = ADLivelyTransformFan;
//    livelyTableView.initialCellTransformBlock = nil;
    
    // Uncomment the following line to preserve selection between presentatio
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *date;
    
    if (section == 0) {
        date = @"June 15";
    } else if (section == 1) {
        date = @"June 16";
    } else if (section == 2) {
        date = @"June 17";
    }
    
    return date;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_splitMovieArray objectAtIndex:section ] count];
}

//- (void) resetCellsState {
//    [revealedCells enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//        DMSlidingTableViewCell *cell = ((DMSlidingTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]]);
//        [cell setBackgroundVisible:NO];
//    }];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DMSlidingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DMSlidingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *eachView in [cell subviews])
        [eachView removeFromSuperview];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    
    NSString *time = [[[_splitMovieArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"time"];
    
    int index = [[[[_splitMovieArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"venue"] intValue];
    
    NSString *img_name = [[_venuesArray objectAtIndex:index] objectForKey:@"image_name"];
    
    UIImage *img = [UIImage imageNamed:img_name];
    
    [str appendFormat:@"%@", time];
    
    // Configure the cell...
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 220, 50)];
    [lbl1 setFont:[UIFont fontWithName:@"LTTetria Bold" size:18.0]];
    [lbl1 setTextColor:[UIColor blackColor]];
    [lbl1 setBackgroundColor:[UIColor clearColor]];
    lbl1.text = [[[_splitMovieArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"movie"];
    [cell addSubview:lbl1];

    
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, 200, 20)];
    [lbl2 setFont:[UIFont fontWithName:@"LTTetria Light" size:14.0]];
    [lbl2 setTextColor:[UIColor grayColor]];
    [lbl2 setBackgroundColor:[UIColor clearColor]];
    lbl2.text = str;
    [cell addSubview:lbl2];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(10, 10, 60, 60);
    [cell addSubview:imageView];
    
    UIButton *favButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 25, 50, 30)];
    
    [favButton setImage:[UIImage imageNamed:@"bttn-favorites-selected"] forState:UIControlStateSelected];
    [favButton setImage:[UIImage imageNamed:@"bttn-favorites"] forState:UIControlStateNormal];
    
    NSString *movie = [[[_splitMovieArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"movie"];
    NSString *day = [[[_splitMovieArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"day"];
    
    if ([self isMovieFavorited:movie withTime:time withDay:day]) {
        [favButton setSelected:YES];
    } else {
        [favButton setSelected:NO];
   }
    
    [favButton addTarget:self action:@selector(favoriteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:favButton];
    
    return cell;
}

-(BOOL)isMovieFavorited:(NSString *)movie withTime:(NSString *)time withDay:(NSString *)day {
    NSMutableArray *favoritesArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoritedMovies"]];
    
    /* checks if project is favorited */
    for (int i = 0; i < [favoritesArray count]; i++) {
        NSString *testMovieName = [[favoritesArray objectAtIndex:i] objectAtIndex:0];
        NSString *testTime = [[favoritesArray objectAtIndex:i] objectAtIndex:1];
        NSString *testDay = [[favoritesArray objectAtIndex:i] objectAtIndex:2];
        
        if ([movie isEqualToString:testMovieName]) {
            if ([time isEqualToString:testTime]) {
                if ([day isEqualToString:testDay]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

/* removes the specified project from favorites */
-(void)removeClickedMovie:(NSString *)movie withTime:(NSString *)time withDay:(NSString *)day {
    NSMutableArray *favoritesArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoritedMovies"]];
    
    /* finds the project to remove */
    for (int i = 0; i < [favoritesArray count]; i++) {
        NSString *testMovieName = [[favoritesArray objectAtIndex:i] objectAtIndex:0];
        NSString *testTime = [[favoritesArray objectAtIndex:i] objectAtIndex:1];
        NSString *testDay = [[favoritesArray objectAtIndex:i] objectAtIndex:2];
        
        if ([movie isEqualToString:testMovieName]) {
            if ([testTime isEqualToString:time]) {
                if ([testDay isEqualToString:day]) {
                    [favoritesArray removeObjectAtIndex:i];
                    [[NSUserDefaults standardUserDefaults] setObject:favoritesArray forKey:@"favoritedMovies"];
                    break;
                }
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/* adds the specified project to favorites */
-(void)addClickedMovie:(NSString *)movie withTime:(NSString *)time withDay:(NSString *)day {
    NSMutableArray *favoritesArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoritedMovies"]];
    NSArray *comparativeFavoritesValues = [[NSArray alloc] initWithObjects:movie, time, day, nil];
    [favoritesArray addObject:comparativeFavoritesValues];
    [[NSUserDefaults standardUserDefaults] setObject:favoritesArray forKey:@"favoritedMovies"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)favoriteButtonClicked:(id)sender {
    UIButton *btnClicked = (UIButton *)sender;
    [btnClicked setSelected:![btnClicked isSelected]];
    
    for (UIView *parent = [btnClicked superview]; parent != nil; parent = [parent superview]) {
        if ([parent isKindOfClass: [UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell *) parent;
            NSIndexPath *path = [self.tableView indexPathForCell:cell];
            
            NSString *movie = [[[_splitMovieArray objectAtIndex:path.section] objectAtIndex:path.row] objectForKey:@"movie"];
            NSString *time = [[[_splitMovieArray objectAtIndex:path.section] objectAtIndex:path.row] objectForKey:@"time"];
            NSString *day = [[[_splitMovieArray objectAtIndex:path.section] objectAtIndex:path.row] objectForKey:@"day"];
            
            
            if ([btnClicked isSelected]) {
                [self addClickedMovie:movie withTime:time withDay:day];
            } else {
                [self removeClickedMovie:movie withTime:time withDay:day];
            }
            
            break;
        }
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
