//
//  LoginViewController.m
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/6/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (BOOL) loginProtection{
    //A method to protect the login screen, returns good if both username and password are nonempty
    bool u_empty = [self.usernameTextField.text isEqual:@""];
    bool p_empty = [self.passwordTextField.text isEqual:@""];
       
       
    UIAlertController *alert = [UIAlertController alloc];
    if (u_empty && p_empty){
        alert = [UIAlertController alertControllerWithTitle:@"Login Error"
                message:@"Both Username and Password cannot be empty"
           preferredStyle:(UIAlertControllerStyleAlert)];
               
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
               style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * _Nonnull action) {
                       // handle response here.
        }];
               
        [alert addAction:okAction];
           
    }
    else if (u_empty){
        alert = [UIAlertController alertControllerWithTitle:@"Login Error"
                message:@"Username cannot be empty"
        preferredStyle:(UIAlertControllerStyleAlert)];
               
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
               style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
                       // handle response here.
        }];
               
        [alert addAction:okAction];
               
    }
    else if (p_empty){
        alert = [UIAlertController alertControllerWithTitle:@"Login Error"
            message:@"Password cannot be empty"
            preferredStyle:(UIAlertControllerStyleAlert)];
               
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                           // handle response here.
                       }];
               
        [alert addAction:okAction];
    }
    
    bool good_val = !(p_empty || u_empty);
    if (!good_val){
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
    
    return good_val;
}
- (void) registerUser{
    // initialize a user object
    PFUser *newUser = [PFUser user];
       
    // set user properties
    newUser.username = self.usernameTextField.text;
    //newUser.email = self.emailField.text;
    newUser.password = self.passwordTextField.text;
       
    bool good_pass = [self loginProtection];
       
    if (good_pass){
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
                   
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"loginToHome" sender:nil];
            }
        }];
    }
}


- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    bool good_pass = [self loginProtection];
    if (good_pass){
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
            } else {
                NSLog(@"User logged in successfully");
            
                // display view controller that needs to shown after successful login
                [self performSegueWithIdentifier:@"loginToHome" sender:nil];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.passwordTextField.secureTextEntry = YES;
}
- (IBAction)signupPressed:(id)sender {
    [self registerUser];
}

- (IBAction)loginPressed:(id)sender {
    [self loginUser];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
