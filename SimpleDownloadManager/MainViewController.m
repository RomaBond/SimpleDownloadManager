//
//  MainViewController.m
//  SimpleDownloadManager
//
//  Created by Sam on 11/17/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import "MainViewController.h"
#import "CustomeCell.h"
#import "DownloadManager.h"
#import "AddFileViewController.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

#define URL @"http://cdimage.debian.org/debian-cd/8.6.0/amd64/iso-cd/debian-8.6.0-amd64-CD-1.iso"
#define URL2 @"http://cdimage.debian.org/debian-cd/8.6.0/amd64/iso-dvd/debian-8.6.0-amd64-DVD-1.iso"
#define URL3 @"https://www.google.com.ua/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwid-afura7QAhVJVSwKHUSjAFoQFggZMAA&url=https%3A%2F%2Fwww.tutorialspoint.com%2Fios%2Fios_tutorial.pdf&usg=AFQjCNF16ShFVH5ggXdImtKEpPlq21nVmg&sig2=MZl3l_drGLAn_SffES5uzw"


@implementation MainViewController




- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.DM = [[DownloadManager alloc] initSession];
    
    
    [self.DM addDownloadFileForUrl:URL3 withName:@"1"];
    [self.DM addDownloadFileForUrl:URL3 withName:@"2"];
    [self.DM addDownloadFileForUrl:URL3 withName:@"3"];
    
};


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.DM removeDownloadFileAtIndex:indexPath.row];
        
        [self.table reloadData];
    }
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.DM.downloadFiles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath] ;
    
    cell.downloadManager = self.DM ;
    cell.index = indexPath.row ;
    [cell showInfo];
    return cell;
}



#pragma mark - StoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"addDownloadFile"]) {
        
        AddFileViewController* addDownloadFile = (AddFileViewController*)[segue destinationViewController];
        addDownloadFile.mainViewController = self;
    }
    
}


- (IBAction)editAction:(UIBarButtonItem *)sender {
    BOOL isEditing = !(self.table.editing);
    [self.table setEditing:isEditing animated:TRUE];
    self.editButton.title = isEditing ? @"Done" : @"Edit";
}


@end
