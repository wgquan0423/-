//
//  ViewController.m
//  自定义城市选择器
//
//  Created by 冲锋的小兵 on 2016/11/29.
//  Copyright © 2016年 quan. All rights reserved.
//

#import "ViewController.h"

#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * leftTableView; //左侧列表
@property(nonatomic,strong)UITableView * rightTableView;//右侧列表
@property(nonatomic,strong)NSDictionary * cityNamesDict;//plist对应的字典
@property(nonatomic,strong)NSArray * provincesArray;
@property(nonatomic,strong)NSArray * citiesArray;
@property(nonatomic,copy)NSString * currentProvince;
@property(nonatomic,copy)NSString * currentCity;

@end

@implementation ViewController

//懒加载plist文件
-(NSDictionary *)cityNamesDict
{
    if(_cityNamesDict==nil)
    {
        NSString * cityPath =[[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"];
        _cityNamesDict =[NSDictionary dictionaryWithContentsOfFile:cityPath];
    }
    return _cityNamesDict;
}

-(NSArray *)provincesArray
{
    if(_provincesArray==nil)
    {
         //将省份保存到数组中  但是字典保存的是无序的 所以读出来的省份也是无序的
        _provincesArray = [self.cityNamesDict allKeys];
    }
    return _provincesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _leftTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth/2, ScreenHeight)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.backgroundColor =[UIColor redColor];
    [self.view addSubview:_leftTableView];
    
    _rightTableView =[[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/2,0,ScreenWidth/2,ScreenHeight)];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.tableFooterView =[[UIView alloc]init];
    [self.view addSubview:_rightTableView];

    NSString * cityPath =[[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"];
    _cityNamesDict =[NSDictionary dictionaryWithContentsOfFile:cityPath];
    
     _provincesArray = [_cityNamesDict allKeys];
    
    _currentProvince = _provincesArray[0];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_leftTableView ==tableView)
    {
        return _provincesArray.count;
        
    }else
    {
         //通过省份去获取对应的城市
        _citiesArray = [_cityNamesDict valueForKey:_currentProvince];
        
        return _citiesArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_leftTableView == tableView)
    {
        UITableViewCell * leftCell =[tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        if(leftCell==nil)
        {
            leftCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftCell"];
        }
        //左侧tableView显示省份
        leftCell.textLabel.text = _provincesArray[indexPath.row];
        
        return leftCell;
        
    }else
    {
        UITableViewCell * rightCell =[tableView dequeueReusableCellWithIdentifier:@"rightCell"];
        if(rightCell==nil)
        {
            rightCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightCell"];
        }
        
        _citiesArray =[_cityNamesDict valueForKey:_currentProvince];
        //右侧tableView显示城市
        rightCell.textLabel.text = _citiesArray[indexPath.row];
        
        return rightCell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_leftTableView==tableView)
    {
        _currentProvince = _provincesArray[indexPath.row];
        [_rightTableView reloadData];
        
    }else
    {
        _currentCity = _citiesArray[indexPath.row];
        
        NSLog(@"%@%@",_currentProvince,_currentCity);
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
