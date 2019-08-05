//
//  ProfileViewConttroller.m
//  Instagram
//
//  Created by estherb on 7/11/19.
//  Copyright © 2019 estherb. All rights reserved.
//
#import "ProfileViewConttroller.h"
#import "HomeFeed.h"
#import "PostViewCell.h"
#import "Post.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *postArray;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (strong, nonatomic) UIImage *profileImage;

@end

@implementation ProfileViewController

- (void)viewWillAppear:(BOOL)animated{
    //    PFFileObject *image = [self.user objectForKey:@"profileImage"];
    //    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
    //        if (!data) {
    //            return NSLog(@"%@", error);
    //        }
    //        // Do something with the image
    //        self.profileImage = [UIImage imageWithData:data];
    //        self.profileImageView.image = self.profileImage;
    //    }];
    //    NSString *userBio = [self.user objectForKey:@"userBio"];
    //    self.bioLabel.text = userBio;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.collectionView.dataSource = self;
//    self.collectionView.delegate = self;
    self.editButton.hidden = YES;
    if(self.user == nil){
        self.user = [PFUser currentUser];
        self.editButton.hidden = NO;
    }
    self.username.text= self.user.username;
    
    
    // [self fetchPosts];
    self.editButton.layer.borderWidth = 1.0f;
    self.editButton.layer.borderColor = [[UIColor grayColor] CGColor];
    self.editButton.layer.cornerRadius = 5.0f;
    self.profileImageView.layer.cornerRadius = 50.0f;
    
}

- (void)fetchPosts{
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"author" equalTo:self.user];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts) {
            self.postArray = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


//- (nonnull UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
//    Post *post = self.postArray[indexPath.row];
//    cell.post = post;
//    [post.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        if (!data) {
//            return NSLog(@"%@", error);
//        }
//        // Do something with the image
//        cell.postImageView.image = [UIImage imageWithData:data];
//    }];
//
//    return cell;
//
//}
//
//- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.postArray.count;
//}
@end
