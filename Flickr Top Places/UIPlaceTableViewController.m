//
//  UIPlaceTableViewController.m
//  Flickr Top Places
//
//  Created by Austin on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "UIPlaceTableViewController.h"
#import "UIFlickrPhotoViewController.h"
#import "FlickrFetcher.h"

@interface UIPlaceTableViewController() 
@property (nonatomic, strong) NSString* photoTitle;
@end

@implementation UIPlaceTableViewController

@synthesize photoList = _photoList;
@synthesize photoTitle = _photoTitle;

- (void) setPhotoList:(NSArray *)photoList {
    [self setPhotoList:photoList withTitle:nil];
}

- (void) setPhotoList:(NSArray *)photoList withTitle:(NSString *)title {
    
    if (photoList != _photoList) {
        _photoList = photoList;
        [self.tableView reloadData];
    }
    
    if (_photoTitle != title) {
        _photoTitle = title;
    }    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photos in Place";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *place = [self.photoList objectAtIndex:indexPath.row];
    NSString *photoTitle = [place objectForKey:FLICKR_PHOTO_TITLE];
    NSString *photoDescription = [place objectForKey:FLICKR_PHOTO_DESCRIPTION];
    
    if (photoTitle && ![photoTitle isEqualToString:@""]) {
        cell.textLabel.text = photoTitle;
        cell.detailTextLabel.text = photoDescription;
    } else if (photoDescription && ![photoDescription isEqualToString:@""]) {
        cell.textLabel.text = photoDescription;
        cell.detailTextLabel.text = @"";
    } else {
        cell.textLabel.text = @"Uknown";
        cell.detailTextLabel.text = @"";        
    }
     
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *photoDictionary = [self.photoList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    [[segue destinationViewController] setFlickrPhoto:photoDictionary];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFlickrPhotoViewController* flickrPhotoViewController = [[self.splitViewController viewControllers] lastObject];
    
    if (flickrPhotoViewController) {
        [flickrPhotoViewController redrawPhoto:[self.photoList objectAtIndex:indexPath.row]];
    }
}

@end
