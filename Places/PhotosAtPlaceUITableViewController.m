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
    self.clearsSelectionOnViewWillAppear = NO;
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

- (void) addToRecentPhotos: (NSDictionary *) photo  {
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* recentPhotos = [defaults objectForKey:@"recent"];
    if(!recentPhotos) recentPhotos = [NSArray array];
    recentPhotos = [recentPhotos arrayByAddingObject:photo];
    [defaults setObject:recentPhotos forKey:@"recent"];    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    UIViewController *vc = [[UIViewController alloc] init ];
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *detailView = [[UIScrollView alloc] initWithFrame:frame];
    NSDictionary *photo = [self photoAtIndex:indexPath];
    [self addToRecentPhotos: photo];

    UIImage *image = [UIImage imageWithData:[FlickrFetcher imageDataForPhotoWithFlickrInfo:photo format:FlickrFetcherPhotoFormatLarge]];

    imageView = [[UIImageView alloc] initWithImage:image];
    [detailView addSubview:imageView];
    detailView.contentSize = imageView.bounds.size;
    detailView.minimumZoomScale = 0.3;
    detailView.maximumZoomScale = 3.0;
    detailView.delegate = self;

    [detailView zoomToRect:[imageView bounds] animated:NO];
    vc.view = detailView;
    vc.title = [self titleForPhotoAtIndex:indexPath];
    [self.navigationController pushViewController:vc animated:YES];

    [imageView release];
    [detailView release];
    [vc release];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return imageView;
}

@end
