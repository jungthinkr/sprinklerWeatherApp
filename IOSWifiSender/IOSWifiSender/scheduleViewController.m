//
//  scheduleViewController.m
//  IOSWifiSender
//
//  Created by Aaron Liu on 3/9/16.
//  Copyright © 2016 tanno. All rights reserved.
//

#import "scheduleViewController.h"
#import <Parse/Parse.h>
@interface scheduleViewController(){
    
    __weak IBOutlet UITableView *timeTable;
    __weak IBOutlet UITableView *durationTable;
    __weak IBOutlet UIButton *updateButton;

    
    
    NSArray* timeArray;
    NSArray * durationArray;
    UIView * tempHolder;
    UITapGestureRecognizer *tapGesture;
}

@end

@implementation scheduleViewController
- (IBAction)updateFunc:(id)sender {
    NSLog(@"update");
    NSMutableArray * duration = [[NSMutableArray alloc] init];
    NSMutableArray * time = [[NSMutableArray alloc] init];
    NSArray * schedule = [[NSArray alloc] initWithObjects:time, duration, nil];
      for (UIView *subView in self.view.subviews) {
          if (subView.tag == 1){
              UILabel* tempLabel = (UILabel*) subView;
              [time addObject:tempLabel.text];
              
          }
          if (subView.tag == 2){
              UILabel* tempLabel = (UILabel*) subView;
              [duration addObject:tempLabel.text];
              
          }
      }
    [PFUser currentUser][@"schedule"] = schedule;
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* schedule = [PFUser currentUser][@"schedule"];
    NSInteger i = 0;
    NSInteger j = 0;
    NSLog(@"%@",schedule);
    for (UIView *subView in self.view.subviews) {
        if (subView.tag == 1){
            UILabel* tempLabel = (UILabel*) subView;
            tempLabel.text = schedule[0][i];
            //subView = tempLabel;
            i++;
            
        }
        if (subView.tag == 2){
            UILabel* tempLabel = (UILabel*) subView;
            tempLabel.text = schedule[1][j];
           // subView = tempLabel;
            j++;
            
        }
    }
    
    tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFunc:)];
    tapGesture.enabled = NO;
    timeTable.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width/2, 0);
    durationTable.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width/2, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    timeArray = @[@"12:00AM", @"1:00AM", @"2:00AM", @"3:00AM", @"4:00AM", @"5:00AM", @"6:00AM", @"7:00AM",@"8:00AM", @"9:00AM", @"10:00AM", @"11:00AM", @"12:00PM", @"1:00PM", @"2:00PM", @"3:00PM", @"4:00PM", @"5:00PM", @"6:00PM", @"7:00PM", @
                  "8:00PM", @"9:00PM", @"10:00PM", @"11:00PM"];
    durationArray = @[@"---",@"15 min", @"30 min", @"1 hour", @"2 hours"  ];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"number of row");
    if (tableView == timeTable){
        return [timeArray count];
    }
    else if (tableView == durationTable){
        return [durationArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    // Reuse and create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (tableView == timeTable){
        [cell.textLabel setText:[timeArray objectAtIndex:indexPath.row]];
    }
    else if (tableView == durationTable){
        [cell.textLabel setText:[durationArray objectAtIndex:indexPath.row]];

    }
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == timeTable){
        timeTable.delegate = nil;
        timeTable.dataSource = nil;
        [UIView animateWithDuration: 0.5
                              delay: 0            // DELAY
             usingSpringWithDamping: 1
              initialSpringVelocity: 0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             timeTable.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width/2, 0);

         } completion:^(BOOL finished) {
             timeTable.hidden = YES;
         }
         ];
        
    }
    else if (tableView == durationTable){
        durationTable.delegate = nil;
        durationTable.dataSource = nil;
        [UIView animateWithDuration: 0.5
                              delay: 0            // DELAY
             usingSpringWithDamping: 1
              initialSpringVelocity: 0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             durationTable.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width/2, 0);
             
         } completion:^(BOOL finished) {
             durationTable.hidden = YES;
         }
         ];
        
    }
   NSLog(@"%@", [tableView cellForRowAtIndexPath:indexPath].textLabel.text);
    for (UIView *subView in self.view.subviews) {

        if (subView == tempHolder){
            UITextField *tempTextField = (UITextField*)subView;
            tempTextField.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        }
}
}
-(void)keyboardWillShow {
    NSLog(@"keyboardwillshow");
    
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            tempHolder = subView;
            if (subView.tag == 1){
                NSLog(@"tag is 1");
                tapGesture.enabled = YES;
                timeTable.hidden = NO;
                timeTable.delegate = self;
                timeTable.dataSource = self;
                
                [timeTable reloadData];
                
                [UIView animateWithDuration: 0.5
                                      delay: 0            // DELAY
                     usingSpringWithDamping: 1
                      initialSpringVelocity: 0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^
                 {
                     timeTable.transform = CGAffineTransformMakeTranslation(0, 0);
                 } completion:^(BOOL finished) {

                 }
                 ];
    
                
            }
            else if (subView.tag == 2){
                NSLog(@"tag is 2");
                tapGesture.enabled = YES;
                durationTable.hidden = NO;
                durationTable.delegate = self;
                durationTable.dataSource = self;
                
                [durationTable reloadData];
                
                [UIView animateWithDuration: 0.5
                                      delay: 0            // DELAY
                     usingSpringWithDamping: 1
                      initialSpringVelocity: 0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^
                 {
                     durationTable.transform = CGAffineTransformMakeTranslation(0, 0);
                 } completion:^(BOOL finished) {

                 }
                 ];
 
            }
        }
    }
    [self.view endEditing:YES];
}
-(void)touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    NSArray *subviews = [self.view subviews];
    for (id objects in subviews) {
        if ([objects isKindOfClass:[UITableView class]]) {
            UITableView *theTableView = objects;
            if (theTableView.delegate != nil && !CGAffineTransformEqualToTransform(timeTable.transform, durationTable.transform)) {
                NSLog(@"cancel table please");
                if (theTableView == timeTable){
                    timeTable.delegate = nil;
                    timeTable.dataSource = nil;
                    [UIView animateWithDuration: 0.5
                                          delay: 0            // DELAY
                         usingSpringWithDamping: 1
                          initialSpringVelocity: 0
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^
                     {
                         timeTable.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width/2, 0);
                         
                     } completion:^(BOOL finished) {
                         timeTable.hidden = YES;
                     }
                     ];
                    
                }
                else if (theTableView == durationTable){
                    durationTable.delegate = nil;
                    durationTable.dataSource = nil;
                    [UIView animateWithDuration: 0.5
                                          delay: 0            // DELAY
                         usingSpringWithDamping: 1
                          initialSpringVelocity: 0
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^
                     {
                         durationTable.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width/2, 0);
                         
                     } completion:^(BOOL finished) {
                         durationTable.hidden = YES;
                     }
                     ];
                    
                }
            }
        }
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"should begin editing");
    [textField resignFirstResponder];
    // Here You can do additional code or task instead of writing with keyboard
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField { //Keyboard becomes visible
    NSLog(@"did begin editing");
    [textField resignFirstResponder];
    if (textField.tag == 1){
        NSLog(@"1");
    }
    else if (textField.tag == 2){
        NSLog(@"2");
    }
}
-(void)tapGestureFunc:(UITapGestureRecognizer*)sender{
    NSLog(@"tapgesturefunc");
}

@end
