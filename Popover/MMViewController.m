//
//  MMViewController.m
//  Popover
//
//  Created by user12 on 01.07.14.
//  Copyright (c) 2014 Level UP. All rights reserved.
//

#import "MMViewController.h"
#import "MMTableViewController.h"
#import "MMPopoverBackgroundView.h"
#import "MMizStoriboardViewController.h"

@interface MMViewController ()
/// hi
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIPopoverController *popover;

@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openPopover:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    MMizStoriboardViewController *testViewController = (MMizStoriboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"izStoriboard"];
    
    testViewController.view.layer.cornerRadius = 500;
    
    UINavigationController *NV = [[UINavigationController alloc] initWithRootViewController:testViewController];
    
    NV.view.layer.shadowColor = [UIColor clearColor].CGColor;
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:NV];
        
//    MMTableViewController *PopoverView =[[MMTableViewController alloc] initWithNibName:@"MMTableViewController" bundle:nil];
//    self.popover =[[UIPopoverController alloc] initWithContentViewController:PopoverView];
    
    self.popover.popoverBackgroundViewClass = [MMPopoverBackgroundView class];
    
    
    [self.popover presentPopoverFromRect:self.button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
}

@end
