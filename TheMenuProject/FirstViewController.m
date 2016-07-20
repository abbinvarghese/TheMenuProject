//
//  FirstViewController.m
//  TheMenuProject
//
//  Created by Abbin Varghese on 20/07/16.
//  Copyright © 2016 ThePaadamCompany. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"+"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(addButtonClicked:)];
    addButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addButton;
    self.title = @"Nearby";
}

-(void)addButtonClicked:(id)sender{
    [self performSegueWithIdentifier:@"TMPImagePickerControllerSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
