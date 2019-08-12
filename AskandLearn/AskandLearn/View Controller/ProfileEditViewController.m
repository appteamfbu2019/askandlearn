//
//  ProfileEditViewController.m
//  AskandLearn
//
//  Created by estherb on 7/30/19.
//  Copyright © 2019 estherb. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "Parse/Parse.h"
#import "ProfileViewController.h"


@interface ProfileEditViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) UIImage *originalImage;
@property (weak, nonatomic) UIImage *editedImage;

@end

@implementation ProfileEditViewController {
    BOOL _isUploadingProfilePic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)saveProfile{
    NSString *name = self.nameTextField.text;
    NSString *profession = self.professionTextField.text;
    NSString *major = self.majorTextField.text;
    UIImage *profilePic = self.profileImageView.image;
    UIImage *backgroundPic = self.backgroundImageView.image;
    NSString *bio = self.bioTextView.text;
    if ([self.nameTextField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"No name inserted" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *nameAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];
        [alert addAction:nameAlert];
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else {
        PFObject *profile = [PFObject objectWithClassName:@"Profile"];
        profile[@"user"] = PFUser.currentUser;
        profile[@"name"] = name;
        profile[@"profession"] = profession;
        profile[@"major"] = major;
        profile[@"bio"] = bio;
        if (profilePic != nil && backgroundPic != nil){
            NSData *profileImage = UIImagePNGRepresentation(profilePic);
            PFFileObject *ImageFile = [PFFileObject fileObjectWithData: profileImage];
            profile[@"profilePic"] = ImageFile;
            NSData *backgroundImage = UIImagePNGRepresentation(backgroundPic);
            PFFileObject *picFile = [PFFileObject fileObjectWithData:backgroundImage];
            profile[@"backgroundPic"] = picFile;
        }
        [profile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Information Saved!");
            } else {
                NSLog(@"Information did not save.");
            }
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadProfilePic {
    _isUploadingProfilePic = YES;
    [self uploadImage];
}

- (void)uploadBackgroundPic {
    _isUploadingProfilePic = NO;
    [self uploadImage];
}



-(void)uploadImage{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    //    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    //        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    }
    //    else {
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    if (_isUploadingProfilePic) {
        self.profileImageView.image = [self resizeImage:editedImage withSize:CGSizeMake(400, 400)];
    } else {
        //self.backgroundImageView.image = editedImage;
        self.backgroundImageView.image = [self resizeImage:editedImage withSize:CGSizeMake(400, 400)];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)didTapSaveProfile:(id)sender {
    [self saveProfile];
    //[self prepareForSegue:@"ProfileViewController" sender:nil];
}

- (IBAction)didTapProfileUpload:(id)sender {
    [self uploadProfilePic];
}

- (IBAction)didTapImageUpload:(id)sender {
    [self uploadBackgroundPic];
}
- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissKeyboard {
    [self.view endEditing:true];
}

@end
