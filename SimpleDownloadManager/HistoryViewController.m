//
//  HistoryViewController.m
//  SimpleDownloadManager
//
//  Created by Sam on 11/18/16.
//  Copyright © 2016 Roma. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "HistoryViewController.h"
#import "HistoryInfoCell.h"
#import "AppDelegate.h"

@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HistoryViewController
-(NSManagedObjectContext*)managedObjectContext{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = appDelegate.mainContext;
    return context;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.downloadInfo = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSManagedObjectContext * managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DownloadEntity"];
    self.downloadInfo = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy ];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.downloadInfo count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    NSManagedObject * download = [self.downloadInfo objectAtIndex:indexPath.row];
    
;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    
    NSString *startDateString = [formatter stringFromDate:[download valueForKey:@"dateStartDownload"]];
    NSString *finishedDateString = [formatter stringFromDate:[download valueForKey:@"dateCompletedDownload"]];
    
    NSString *name = [NSString stringWithFormat:@"Name: %@",[download valueForKey:@"name"]];
    NSString *dateStart =[NSString stringWithFormat:@"Date start download: %@", startDateString];
    NSString *dateFinised= [NSString stringWithFormat:@"Date finished download: %@", finishedDateString];
    
    [cell.nameLable setText:name];
    [cell.dateStartDownload setText:dateStart];
    [cell.dateFinisedDownload setText:dateFinised];
    [cell.status setText:[download valueForKey:@"status"]];

    return cell;
    }

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSManagedObjectContext * context = [self managedObjectContext];
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [context deleteObject: [self.downloadInfo objectAtIndex:indexPath.row]];
    }
    
    [self.downloadInfo removeObjectAtIndex:indexPath.row];
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
}


@end
