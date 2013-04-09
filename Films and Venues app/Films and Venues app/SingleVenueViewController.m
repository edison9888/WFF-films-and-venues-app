//
//  SingleVenueViewController.m
//  Films and Venues app
//
//  Created by Jordan Carney on 4/9/13.
//  Copyright (c) 2013 Jordan Carney. All rights reserved.
//

#import "SingleVenueViewController.h"
#import "BButton.h"
#import <MapKit/MapKit.h>
#import "DMSlidingTableViewCell.h"

@interface SingleVenueViewController ()

@end

@implementation SingleVenueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Path to the plist (in the application bundle)
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"Movies" ofType:@"plist"];
    
    // Build the array from the plist
    NSArray *movieArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    _movies = [[NSMutableArray alloc] init];
    
    NSLog(@"venue value: %d", _venueValue);
    for (NSDictionary *dict in movieArray) {
        NSLog(@"dict val: %d", [[dict objectForKey:@"venue"] intValue]);
        if ([[dict objectForKey:@"venue"] intValue] == _venueValue) {
            [_movies addObject:dict];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allPinsDone) name:kAllPinsDone object:nil];
    
    self.title = [_venueDict objectForKey:@"name"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_venueDict objectForKey:@"image_name"]]];
    [imageView setFrame:CGRectMake(10, 10, 100, 100)];
    [self.view addSubview:imageView];
    
    NSArray *strArray = [[_venueDict objectForKey:@"address"] componentsSeparatedByString:@"South"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, 200, 20)];
    [label setFont:[UIFont fontWithName:@"LTTetria Bold" size:18]];
    [label setText:[strArray objectAtIndex:0]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    
    UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(130, 40, 200, 20)];
    [labelTwo setFont:[UIFont fontWithName:@"LTTetria Light" size:14]];
    [labelTwo setText:[NSString stringWithFormat:@"South %@", [strArray objectAtIndex:1]]];
    [labelTwo setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:labelTwo];
    
    BButton *button = [[BButton alloc] initWithFrame:CGRectMake(130, 70, 150, 30)];
    [button setTitle:@"Get Directions!" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getDirections:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)getDirections:(id)sender {
    _holderArray = [[NSMutableArray alloc] init];
    
    NSString *location = [_venueDict objectForKey:@"address"];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                         [mapItem setName:[_venueDict objectForKey:@"name"]];
                         
                         [_holderArray addObject:mapItem];
                         _val++;
                         
                         if (_val == 1) {
                             [[NSNotificationCenter defaultCenter] postNotificationName:kAllPinsDone object:nil];
                         }
                     }
                 }
     ];
}

-(void)allPinsDone {
    _val = 0;
    [MKMapItem openMapsWithItems:_holderArray launchOptions:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Movies";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_movies count];
}

//- (void) resetCellsState {
//    [revealedCells enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//        DMSlidingTableViewCell *cell = ((DMSlidingTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]]);
//        [cell setBackgroundVisible:NO];
//    }];
//}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DMSlidingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[DMSlidingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *eachView in [cell subviews])
        [eachView removeFromSuperview];
    
    NSString *str = [NSString stringWithFormat:@"%@ -- %@", [[_movies objectAtIndex:indexPath.row] objectForKey:@"day"],[[_movies objectAtIndex:indexPath.row] objectForKey:@"time"]];
    
    // Configure the cell...
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 180, 50)];
    [lbl1 setFont:[UIFont fontWithName:@"LTTetria Bold" size:18.0]];
    [lbl1 setTextColor:[UIColor blackColor]];
    [lbl1 setBackgroundColor:[UIColor clearColor]];
    lbl1.text = [[_movies objectAtIndex:indexPath.row] objectForKey:@"movie"];
    [cell addSubview:lbl1];
    
    
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 200, 20)];
    [lbl2 setFont:[UIFont fontWithName:@"LTTetria Light" size:14.0]];
    [lbl2 setTextColor:[UIColor grayColor]];
    [lbl2 setBackgroundColor:[UIColor clearColor]];
    lbl2.text = str;
    [cell addSubview:lbl2];
    
    UIButton *favButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 25, 50, 30)];
    favButton.tag = indexPath.row + 1000;
    
    [favButton setImage:[UIImage imageNamed:@"bttn-favorites-selected"] forState:UIControlStateSelected];
    [favButton setImage:[UIImage imageNamed:@"bttn-favorites"] forState:UIControlStateNormal];
    
    NSString *movie = [[_movies objectAtIndex:indexPath.row] objectForKey:@"movie"];
    NSString *day = [[_movies objectAtIndex:indexPath.row] objectForKey:@"day"];
    NSString *time = [[_movies objectAtIndex:indexPath.row] objectForKey:@"time"];
    
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
    
    int tagVal = btnClicked.tag - 1000;
    
    NSString *movie = [[_movies objectAtIndex:tagVal] objectForKey:@"movie"];
    NSString *day = [[_movies objectAtIndex:tagVal] objectForKey:@"day"];
    NSString *time = [[_movies objectAtIndex:tagVal] objectForKey:@"time"];
    
    if ([btnClicked isSelected]) {
        [self addClickedMovie:movie withTime:time withDay:day];
    } else {
        [self removeClickedMovie:movie withTime:time withDay:day];
    }
}



@end
