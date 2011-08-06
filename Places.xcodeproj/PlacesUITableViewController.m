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
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        places = [[FlickrFetcher topPlaces]
                  sortedArrayUsingDescriptors: [NSArray arrayWithObject:
                                                [NSSortDescriptor sortDescriptorWithKey:
                                                 @"_content" ascending:YES]]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

-(NSDictionary *) placeAtIndex:(NSIndexPath *) indexPath
{
    return [self.places objectAtIndex:indexPath.row];
}

-(NSString *) titleForPlace:(NSDictionary *)place
{
    NSString * content = [place objectForKey:@"_content"];
    return [[content componentsSeparatedByString:@","] objectAtIndex:0];
}

-(NSString *) descriptionForPlace:(NSDictionary *)place
{
    NSString * content = [place objectForKey:@"_content"];
    
    NSArray * components = [content componentsSeparatedByString:@", "];
    return [[components subarrayWithRange:NSMakeRange(1, [components count] -1)] componentsJoinedByString:@", "];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlacesUITableViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *place = [self placeAtIndex:indexPath];
    cell.textLabel.text = [self titleForPlace:place];
    cell.detailTextLabel.text = [self descriptionForPlace:place];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosAtPlaceUITableViewController *photosAtPlaceVC = [[PhotosAtPlaceUITableViewController alloc] init];
    id place = [self.places objectAtIndex:indexPath.row];
    photosAtPlaceVC.place_id = [place objectForKey:@"place_id"];
    photosAtPlaceVC.title = [self titleForPlace:place];
    [self.navigationController pushViewController:photosAtPlaceVC animated:YES];
    [photosAtPlaceVC release];
}

@end
