#import "PlacesUITableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosAtPlaceUITableViewController.h"
#import "Place.h"

@interface PlacesUITableViewController()
@property (nonatomic, retain) NSArray *places;
@end

@implementation PlacesUITableViewController

@synthesize places;

- (NSArray *) places
{
    if (!places) {
        places = [[Place topPlaces] retain] ;
    }
    return places;
}

- (void)dealloc
{
    [places release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"Places";
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait 
            || interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.places.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlacesUITableViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    Place *place = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = place.title;
    cell.detailTextLabel.text = place.description;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosAtPlaceUITableViewController *photosAtPlaceVC = [[PhotosAtPlaceUITableViewController alloc] init];
    photosAtPlaceVC.place = [self.places objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:photosAtPlaceVC animated:YES];
    [photosAtPlaceVC release];
}

@end
