

#import "weatherViewController.h"
#import "OWMWeatherAPI.h"
#import <CFNetwork/CFNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "scheduleViewController.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>

//#define DARK_SKY_API_KEY @"04db53018375745d95630af63b4be36d"
@interface weatherViewController ()<CLLocationManagerDelegate> {
OWMWeatherAPI *weatherAPI;

    __weak IBOutlet UILabel *city;
    __weak IBOutlet UILabel *weatherDescription;
    __weak IBOutlet UILabel *highTemp;
    __weak IBOutlet UILabel *lowTemp;
    __weak IBOutlet UILabel *humidity;
    __weak IBOutlet UIButton *shutoffButt;
    __weak IBOutlet UISwitch *valve1Butt;
    __weak IBOutlet UISwitch *valve2Butt;
    __weak IBOutlet UISwitch *someotherButt;
    CLLocationManager *_locationManager;
    NSInteger oldWeekday;
    BOOL needChange;
    //int const weekday;
}
@end

@implementation weatherViewController
- (IBAction)Valve1Act:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"info"];
    [query getObjectInBackgroundWithId:@"GNoVk3Re5d" block:^(PFObject *deviceInfo, NSError *error) {
        // Do stuff after successful login.
        // PFObject *deviceInfo;
        if ([valve1Butt isOn]){
           deviceInfo[@"v1"] = @"on";
        }
        else{
            NSLog (@"turn off");
            deviceInfo[@"v1"] = @"off";
        }
        [deviceInfo saveInBackground];
    }];



}
- (IBAction)valve2ACT:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"info"];
    [query getObjectInBackgroundWithId:@"GNoVk3Re5d" block:^(PFObject *deviceInfo, NSError *error) {
        // Do stuff after successful login.
        // PFObject *deviceInfo;
        if ([valve2Butt isOn]){
            deviceInfo[@"v2"] = @"on";
        }
        else{
            NSLog (@"turn off");
            deviceInfo[@"v2"] = @"off";
        }
        [deviceInfo saveInBackground];
    }];
}
- (IBAction)otherButtAct:(id)sender {
}
- (IBAction)shutOffButt:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"info"];
    [query getObjectInBackgroundWithId:@"GNoVk3Re5d" block:^(PFObject *deviceInfo, NSError *error) {
        deviceInfo[@"S"] = @"shutDOWN";

        [deviceInfo saveInBackground];
    }];

  
}

int sock = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *gradientView = [[UIView alloc] initWithFrame:self.view.frame];
    gradientView.alpha = .7;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blueColor] CGColor], nil];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    [self.view insertSubview:gradientView atIndex:0];
    needChange = false;
    // initialize the location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestLocation];
    // Set the delegate
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSLog(@"The day of the week: %@", [dateFormatter stringFromDate:[NSDate date]]);
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    oldWeekday = [comps weekday];
    NSLog(@"The week day number: %ld", (long)oldWeekday);
    switch (oldWeekday){
        case 2:
            if ( ![[PFUser currentUser][@"D1"]  isEqual: @"0m"]){
                needChange = true;
            }
            break;
        case 3:
            if ( ![[PFUser currentUser][@"D2"]  isEqual: @"0m"]){
                needChange = true;
            }
            break;
        case 4:
            if ( ![[PFUser currentUser][@"D3"]  isEqual: @"0m"]){
                needChange = true;
            }
            break;
        case 5:
            if ( ![[PFUser currentUser][@"D4"]  isEqual: @"0m"]){
                needChange = true;
            }
            break;
        case 6:
            if ( ![[PFUser currentUser][@"D5"]  isEqual: @"0m"]){
                needChange = true;
            }
            break;
        case 7:
            if ( ![[PFUser currentUser][@"D6"]  isEqual: @"0m"]){
                needChange = true;
            }
            break;
        case 1:
            if ( ![[PFUser currentUser][@"D7"]  isEqual: @"0m"]){
                needChange = true;
            }
            break;
        default:
            break;
    }
    NSLog(@"%d", needChange);
    // get the user's current location
    [self getQuickLocationUpdate];
    UIView *movingDot = [[UIView alloc]initWithFrame:(CGRectMake(0, self.view.bounds.size.height/2, 20, 20))];
    UIView *movingDot2 = [[UIView alloc]initWithFrame:(CGRectMake(0, self.view.bounds.size.height/2, 20, 20))];
    UIView *movingDot3 = [[UIView alloc]initWithFrame:(CGRectMake(0, self.view.bounds.size.height/2, 20, 20))];

    movingDot.backgroundColor = [UIColor purpleColor];
    movingDot.layer.cornerRadius = 10;
    movingDot2.backgroundColor = [UIColor greenColor];
    movingDot2.layer.cornerRadius = 10;
    movingDot3.backgroundColor = [UIColor orangeColor];
    movingDot3.layer.cornerRadius = 10;
    [self.view addSubview:movingDot];
    [self.view addSubview:movingDot2];
    [self.view addSubview:movingDot3];
    [UIView animateWithDuration: 5
                          delay: 0            // DELAY
         usingSpringWithDamping: 1
          initialSpringVelocity: 0
                        options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                     animations:^
     {
         movingDot.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width - movingDot.bounds.size.width, 0);//(1, 1);
     } completion: nil
     ];
    [UIView animateWithDuration: 5
                           delay: 1            // DELAY
          usingSpringWithDamping: 1
           initialSpringVelocity: 0
                         options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                      animations:^
      {
          movingDot2.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width - movingDot.bounds.size.width, 0);//(1, 1);
      } completion: nil];
      [UIView animateWithDuration: 5
                            delay: 2            // DELAY
           usingSpringWithDamping: 1
            initialSpringVelocity: 0
                          options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                       animations:^
       {
           movingDot3.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width - movingDot.bounds.size.width, 0);//(1, 1);
       }
                    completion:nil];
    weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:@"05f4e6bca74c0df78911398115a7368d"];
    [weatherAPI setTemperatureFormat:kOWMTempFahrenheit];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.LedLabel.text = @"Start LED";
    
    if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1)
    {
        NSLog(@"Failed to create socket, error=%s", strerror(errno));
        //self.LedLabel.text = @"Failed to Create Socket";
    }
    [weatherAPI currentWeatherByCityName:@"LosAngeles" withCallback:^(NSError *error, NSDictionary *result) {
        if (error) {
            // handle the error
            NSLog(@"%@", error);
            return;
        }

        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 2;
        formatter.roundingMode = NSNumberFormatterRoundUp;
      
        city.text = result[@"name"];
        highTemp.text = [formatter stringFromNumber:result[@"main"][@"temp_max"]];
        lowTemp.text = [formatter stringFromNumber:result[@"main"][@"temp_min"]];
        humidity.text = [formatter stringFromNumber:result[@"main"][@"humidity"]];
        
        
    }];
    
    /*[weatherAPI dailyForecastWeatherByCityName:@"LosAngeles" withCount:2 andCallback:^(NSError *error, NSDictionary *result) {
        NSLog(@"%@", error);
        NSLog(@"daily forecast: %@", result);
    }];*/
    
   /* [weatherAPI forecastWeatherByCityName:@"LosAngeles" withCallback:^(NSError *error, NSDictionary *result) {
        if (error){
            NSLog(@"%@", error);
            return;
        }
        NSLog(@"%@",result);
    }];*/

    
}
-(void) dailyForecastWeatherByCityName:(NSString *) name
                             withCount:(int) count
                           andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback{
    
}

static void SendMessage(NSString *msg )
{
    unsigned int echolen;
    struct sockaddr_in destination;
    memset(&destination, 0, sizeof(struct sockaddr_in));
    destination.sin_len = sizeof(struct sockaddr_in);
    destination.sin_family = AF_INET;
    
    NSString *ip = @"192.168.11.2";
    destination.sin_addr.s_addr = inet_addr([ip UTF8String]);
    destination.sin_port = htons(33033); //port
    
    /* server port */
    setsockopt(sock, IPPROTO_IP, IP_MULTICAST_IF, &destination, sizeof(destination));
    const char *cmsg = [msg UTF8String];
    echolen = round(strlen(cmsg));
    if (sendto(sock, cmsg,echolen,0, (struct sockaddr *) &destination, sizeof(destination)) == -1)
    {
        NSLog(@"did not send, error=%s",strerror(errno));
    }
    else
    {
        NSLog(@"did send");
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void) dailyForecastWeatherByCityName:(NSString *) name
                           //  withCount:(int) count
                          // andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
- (IBAction)ChangeSC:(UISegmentedControl *)sender
{
    NSString *state = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
   // self.LedLabel.text = state;
    
    
    if([state isEqualToString:@"ON"])
    {
        SendMessage(@"1");
    }
    
    if([state isEqualToString:@"OFF"])
    {
        SendMessage(@"0");
    }

}
-(void)getQuickLocationUpdate {
    
    // Request location authorization
    [_locationManager requestWhenInUseAuthorization];
    
    // Request a location update
    [_locationManager requestLocation];
    // Note: requestLocation may timeout and produce an error if authorization has not yet been granted by the user
}



-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations {
    // Process the received location update
    CLLocation *currentLocation ;
   currentLocation =  [currentLocation initWithLatitude:34.052235 longitude:-118.243683];

    [self getForcastUsingLocation:currentLocation apikey:@"04db53018375745d95630af63b4be36d"];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failure:%@",error.description);
}
#pragma mark - Dark Sky API

-(void)getForcastUsingLocation:(CLLocation *)currentLocation apikey:(NSString *)apiKey {
    
    CLLocationDegrees latitude = 	34.052235;//currentLocation.coordinate.latitude;
    CLLocationDegrees longitude = -118.243683;//currentLocation.coordinate.longitude;
    NSString *urlString = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%f,%f",apiKey,latitude,longitude];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSMutableDictionary * innerJson = [NSJSONSerialization
                                                   JSONObjectWithData:data options:kNilOptions error:&error
                                                   ];
                // get the forcast for the week
                AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                NSDictionary *daily = innerJson[@"daily"];
                NSLog(@"Daily: %@", daily);
                NSArray *array = daily[@"data"];
                //NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:newData];
                NSMutableArray *newArray = [[NSMutableArray alloc]init];
                dispatch_async(dispatch_get_main_queue(), ^{
                    double percentage = [array[0][@"precipProbability"] doubleValue];
                    double newPercent = percentage * 100;
                    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:newPercent];
                    weatherDescription.text = @
                    "0.00%";//[NSString stringWithFormat:@"%@%%",[myDoubleNumber stringValue]];
                    if (newPercent > 0 && needChange){
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@"It might rain today!"
                                                      message:@"Do you want to turn off sprinkler today?"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 appDel.weekday = [NSString stringWithFormat: @"%ld", (long)oldWeekday];
                                                 
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 
                                             }];
                        UIAlertAction* cancel = [UIAlertAction
                                                 actionWithTitle:@"Cancel"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action)
                                                 {
                                                     appDel.weekday = @"0";
                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                 }];
                        
                        [alert addAction:ok];
                        [alert addAction:cancel];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                });
               for (int i = 0; i < [array count]; i ++){
                    [newArray addObject: array[i][@"precipProbability"]];
                    
                }
               // NSLog(@"%@", array);
               // NSLog (@"%@", newArray);
                //self.resultsArray = daily[@"data"];
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    
                });
                
                
            }] resume];
    
    
}


@end
