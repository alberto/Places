#import "PlacesUITableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosAtPlaceUITableViewController.h"

@interface PlacesUITableViewController()
@property (nonatomic, retain) NSArray *places;
@end

@implementation PlacesUITableViewController

@synthesize places;

- (NSArray *) places
{
    if (!places) {
        places = [[FlickrFetcher topPlaces]
                  sortedArrayUsingDescriptors: [NSArray arrayWithObject:
                                                [NSSortDescriptor sortDescriptorWithKey:
                                                 @"_content" ascending:YES]]];
        [places retain];
    }
    return places;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [places release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"Places";
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = [place objectForKey:@"_content"];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    NSLog(@"Seleccionada celda %i", indexPath.row);
    PhotosAtPlaceUITableViewController *photosAtPlaceVC = [[PhotosAtPlaceUITableViewController alloc] init];
    photosAtPlaceVC.place_id = [[self.places objectAtIndex:indexPath.row] objectForKey:@"place_id"];
    [self.navigationController pushViewController:photosAtPlaceVC animated:YES];
    [photosAtPlaceVC release];
}

@end
