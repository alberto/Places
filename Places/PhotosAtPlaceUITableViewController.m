#import "PhotosAtPlaceUITableViewController.h"
#import "FlickrFetcher.h"

@interface  PhotosAtPlaceUITableViewController()
@property (nonatomic, retain) NSArray *photos;
@end

@implementation PhotosAtPlaceUITableViewController

@synthesize place_id, photos;

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
    [super dealloc];
}

-(NSArray *) photos {
    if (!photos) {
        photos = [FlickrFetcher photosAtPlace:[self place_id]];
    }
    [photos retain];
    return photos;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self photos] count];
}

- (NSDictionary *) photoAtIndex:(NSIndexPath *)indexPath {
    return [[self photos] objectAtIndex:indexPath.row];
}

- (NSString *) titleForPhotoAtIndex: (NSIndexPath *)indexPath
{
    id photo = [self photoAtIndex:indexPath];
    NSString * title = [photo objectForKey: @"title"];
    NSString * description = [[photo objectForKey: @"description"]objectForKey:@"_content" ];
    return title ? title : description ? description : @"Unknown";
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotosAtPlaceUITableViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    id photo = [[self photos] objectAtIndex:indexPath.row];
    NSString * title = [photo objectForKey: @"title"];
    NSString * description = [[photo objectForKey: @"description"]objectForKey:@"_content" ];
    cell.textLabel.text = [self titleForPhotoAtIndex:indexPath];
    cell.detailTextLabel.text = title ? description : nil;
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    UIViewController *vc = [[UIViewController alloc] init ];
    UIScrollView *detailView = [[UIScrollView alloc] init];
    UIImage *image = [UIImage imageWithData:[FlickrFetcher imageDataForPhotoWithFlickrInfo:[self photoAtIndex:indexPath]format:FlickrFetcherPhotoFormatLarge]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [detailView addSubview:imageView];
    [imageView release];
    vc.view = detailView;
    vc.title = [self titleForPhotoAtIndex:indexPath];
    [detailView release];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

@end
