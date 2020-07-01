//
//  DetailsViewController.m
//  flix
//
//  Created by Angel Gutierrez on 6/29/20.
//  Copyright © 2020 Angel Gutierrez. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synposisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// our base url string to access our media
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
	
	// for the poster
	NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
	
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
	[self.posterView setImageWithURL:posterURL];
	
	// for the backdrop
	NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
	
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
	[self.backdropView setImageWithURL:backdropURL];
	
	// Configure our title and synopsis label
	self.titleLabel.text = self.movie[@"title"];
	self.synposisLabel.text = self.movie[@"overview"];
	
//	[self.titleLabel sizeToFit];
	[self.synposisLabel sizeToFit];
	
	
}


#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	UITableViewCell *tappedCell = sender;
	NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
	NSDictionary *movie = self.movies[indexPath.row];
}
 */


@end
