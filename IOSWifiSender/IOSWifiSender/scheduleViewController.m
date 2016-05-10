//
//  scheduleViewController.m
//  IOSWifiSender
//
//  Created by Aaron Liu on 3/9/16.
//  Copyright © 2016 tanno. All rights reserved.
//

#import "scheduleViewController.h"
#import <Parse/Parse.h>
#import "weatherViewController.h"
#import "OWMWeatherAPI.h"
#import <CFNetwork/CFNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "AppDelegate.h"
@interface scheduleViewController(){
    
    __weak IBOutlet UITableView *timeTable;
    __weak IBOutlet UITableView *durationTable;
    __weak IBOutlet UIButton *updateButton;

    
   // NSInteger *weekday;
    NSArray* timeArray;
    NSArray * durationArray;
    NSArray *timeArray2;
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
    PFQuery *query = [PFQuery queryWithClassName:@"info"];
    [query getObjectInBackgroundWithId:@"GNoVk3Re5d" block:^(PFObject *deviceInfo, NSError *error) {
        // Do stuff after successful login.
        // PFObject *deviceInfo;
        for (int i = 0; i < [duration count];++i){
            
            switch (i){
                case 0:
                    deviceInfo[@"D1"] = duration[i];
                    deviceInfo[@"T1"] = time[i];
                    break;
                case 1:
                    deviceInfo[@"D2"] = duration[i];
                    deviceInfo[@"T2"] = time[i];
                    break;
                case 2:
                    deviceInfo[@"D3"] = duration[i];
                    deviceInfo[@"T3"] = time[i];
                    break;
                case 3:
                    deviceInfo[@"D4"] = duration[i];
                    deviceInfo[@"T4"] = time[i];
                    break;
                case 4:
                    deviceInfo[@"D5"] = duration[i];
                    deviceInfo[@"T5"] = time[i];
                    break;
                case 5:
                    deviceInfo[@"D6"] = duration[i];
                    deviceInfo[@"T6"] = time[i];
                    break;
                case 6:
                    deviceInfo[@"D7"] = duration[i];
                    deviceInfo[@"T7"] = time[i];
                    break;
                default:
                    break;
            }
            
        }
      
        [deviceInfo saveInBackground];
        
    }];
    for (int i = 0; i < [duration count];++i){
        
        switch (i){
            case 0:
                [PFUser currentUser][@"D1"] = duration[i];
                [PFUser currentUser][@"T1"] = time[i];
                break;
            case 1:
                [PFUser currentUser][@"D2"] = duration[i];
                [PFUser currentUser][@"T2"] = time[i];
                break;
            case 2:
                [PFUser currentUser][@"D3"] = duration[i];
                [PFUser currentUser][@"T3"] = time[i];
                break;
            case 3:
                [PFUser currentUser][@"D4"] = duration[i];
                [PFUser currentUser][@"T4"] = time[i];
                break;
            case 4:
                [PFUser currentUser][@"D5"] = duration[i];
                [PFUser currentUser][@"T5"] = time[i];
                break;
            case 5:
                [PFUser currentUser][@"D6"] = duration[i];
                [PFUser currentUser][@"T6"] = time[i];
                break;
            case 6:
                [PFUser currentUser][@"D7"] = duration[i];
                [PFUser currentUser][@"T7"] = time[i];
                break;
            default:
                break;
        }
        
    }
   // [PFUser currentUser][@"schedule"] = schedule;
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
    UIView *gradientView = [[UIView alloc] initWithFrame:self.view.frame];
    gradientView.alpha = .7;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blueColor] CGColor], nil];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    [self.view insertSubview:gradientView atIndex:0];
    NSArray* schedule = [PFUser currentUser][@"schedule"];
    NSInteger i = 0;
    NSInteger j = 0;
    
    //NSLog(@"%@",schedule);
    for (UIView *subView in self.view.subviews) {
        if (subView.tag == 1){
            UILabel* tempLabel = (UILabel*) subView;
            //tempLabel.text = schedule[0][i];
            //subView = tempLabel;
            switch (i){
                case 0:
                    tempLabel.text = [PFUser currentUser][@"T1"];
                    break;
                case 1:
                    tempLabel.text = [PFUser currentUser][@"T2"];
                    break;
                case 2:
                    tempLabel.text = [PFUser currentUser][@"T3"];
                    break;
                case 3:
                    tempLabel.text = [PFUser currentUser][@"T4"];
                    break;
                case 4:
                    tempLabel.text = [PFUser currentUser][@"T5"];
                    break;
                case 5:
                    tempLabel.text = [PFUser currentUser][@"T6"];
                    break;
                case 6:
                    tempLabel.text = [PFUser currentUser][@"T7"];
                    break;
                default:
                    break;
            }
            i++;
            
        }
        if (subView.tag == 2){
            UILabel* tempLabel = (UILabel*) subView;
          //  tempLabel.text = schedule[1][j];
           // subView = tempLabel;
            switch (j){
                case 0:
                    tempLabel.text = [PFUser currentUser][@"D1"];
                    break;
                case 1:
                    tempLabel.text = [PFUser currentUser][@"D2"];
                    break;
                case 2:
                    tempLabel.text = [PFUser currentUser][@"D3"];
                    break;
                case 3:
                    tempLabel.text = [PFUser currentUser][@"D4"];
                    break;
                case 4:
                    tempLabel.text = [PFUser currentUser][@"D5"];
                    break;
                case 5:
                    tempLabel.text = [PFUser currentUser][@"D6"];
                    break;
                case 6:
                    tempLabel.text = [PFUser currentUser][@"D7"];
                    break;
                default:
                    break;
            }
            j++;
            
        }
    }
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDel.weekday > 0){
        //NSLog(@"%lu", weekday);
        NSLog(@"greather than zero");
        if ([appDel.weekday intValue] == 1){
            int i = 0;
            for (UIView *subView in self.view.subviews){
                if (subView.tag == 2){
                    if (i ==6){
                        UILabel* tempLabel = (UILabel*) subView;
                        tempLabel.text = @"0m";
                    }
                    else{
                        
                    }
                    i++;
                }
                
            }
        }
        else{
            int j = 0;
            for (UIView *subView in self.view.subviews){
                if (subView.tag == 2){
                    if (j == [appDel.weekday intValue] - 2){
                        UILabel* tempLabel = (UILabel*) subView;
                        tempLabel.text = @"0m";
                    }
                    else{
                        
                    }
                    j++;

                }
            }

        }
    }
    else{
        NSLog(@"not greater than zero");
    }
    
    tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFunc:)];
    tapGesture.enabled = NO;
    timeTable.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width/2, 0);
    durationTable.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width/2, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    timeArray = @[@"00:00", @"01:00", @"02:00", @"03:00", @"04:00", @"05:00", @"06:00", @"07:00",@"08:00", @"09:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @
                  "20:00", @"21:00", @"22:00", @"23:00"];

    durationArray = @[@"0m",@"15m", @"30m", @"60m", @"120m"  ];
    
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
