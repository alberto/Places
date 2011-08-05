
#import "RecentUITableViewController.h"
#import "FlickrFetcher.h"

@implementation RecentUITableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSArray*) photos
{
    //if(photos) [photos release];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    photos = [defaults objectForKey:@"recent"];
    [self.view setNeedsDisplay];
    
    return photos;
}

- (void)dealloc
{
    [photos release];
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
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait 
            || interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[self photos] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecentUITableViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *photo = [[self photos] objectAtIndex:indexPath.row];
    cell.textLabel.text = [photo objectForKey:@"title"];
    return cell;
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    UIViewController *vc = [[UIViewController alloc] init ];
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *detailView = [[UIScrollView alloc] initWithFrame:frame];
    NSDictionary *photo = [self photoAtIndex:indexPath];
    
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
