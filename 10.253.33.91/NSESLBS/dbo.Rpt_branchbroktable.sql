-- Object: PROCEDURE dbo.Rpt_branchbroktable
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

 CREATE Procedure Rpt_branchbroktable      
@branch as Varchar(10),  
@valperc As Varchar(20),      
@val1 As Varchar(20),      
@trddel As Int      
As      
      
If @val1 = '%'      
      
Begin      
If @trddel = 0           
Begin      
Select Distinct B.Table_no,line_no,B.table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,      
Trd_del = (case When Trd_del = 't' Then 'trading'       
  When Trd_del = 'd' Then 'delivery'      
  When Trd_del = 'f' Then 'first Leg'      
  When Trd_del = 's' Then 'second Leg'      
    End), T.Branch_Code  
From Broktable B, BranchBrokTable T  
Where B.Table_No = T.Table_No   
And B.Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('t','s','f','d') And Val_perc Like @valperc)        
and T.Branch_Code Like @branch  
Order By T.Branch_Code, B.Table_no,line_no,upper_lim      
End      
      
      
If @trddel = 1          
Begin      
Select Distinct B.Table_no,line_no,B.table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,      
Trd_del = (case When Trd_del = 't' Then 'trading'       
  When Trd_del = 'd' Then 'delivery'      
  When Trd_del = 'f' Then 'first Leg'      
  When Trd_del = 's' Then 'second Leg'      
    End), T.Branch_Code      
From Broktable B, BranchBrokTable T  
Where B.Table_No = T.Table_No   
And B.Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('t','s','f') And Val_perc Like @valperc)        
and T.Branch_Code Like @branch  
Order By T.Branch_Code, B.Table_no,line_no,upper_lim      
End      
If @trddel = 2          
Begin      
Select Distinct B.Table_no,line_no,B.table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,      
Trd_del = (case When Trd_del = 't' Then 'trading'       
  When Trd_del = 'd' Then 'delivery'      
  When Trd_del = 'f' Then 'first Leg'      
  When Trd_del = 's' Then 'second Leg'      
    End), T.Branch_Code      
From Broktable B, BranchBrokTable T  
Where B.Table_No = T.Table_No   
And B.Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('d') And Val_perc Like @valperc)        
and T.Branch_Code Like @branch  
Order By T.Branch_Code, B.Table_no,line_no,upper_lim      
End      
End      
      
If @val1 <> '%'      
Begin      
If @trddel = 0       
Begin      
Select Distinct B.Table_no,line_no,B.table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,      
Trd_del = (case When Trd_del = 't' Then 'trading'       
  When Trd_del = 'd' Then 'delivery'      
  When Trd_del = 'f' Then 'first Leg'      
  When Trd_del = 's' Then 'second Leg'      
    End), T.Branch_Code      
From Broktable B, BranchBrokTable T  
Where B.Table_No = T.Table_No   
And B.Table_no In (select Distinct Table_no From Broktable Where      
(day_puc = Cast(@val1 As Numeric(18,6)) Or Day_sales = Cast(@val1 As Numeric(18,6)) Or Sett_purch = Cast(@val1 As Numeric(18,6)) Or Sett_sales = Cast(@val1 As Numeric(18,6)) Or Normal = Cast(@val1 As Numeric(18,6)))      
And Trd_del In ('t','s','f','d') And Val_perc Like @valperc)        
and T.Branch_Code Like @branch  
Order By T.Branch_Code, B.Table_no,line_no,upper_lim      
End      
      
      
If @trddel = 1      
      
Begin      
Select Distinct B.Table_no,line_no,B.table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,      
Trd_del = (case When Trd_del = 't' Then 'trading'       
  When Trd_del = 'd' Then 'delivery'      
  When Trd_del = 'f' Then 'first Leg'      
  When Trd_del = 's' Then 'second Leg'      
    End), T.Branch_Code      
From Broktable B, BranchBrokTable T  
Where B.Table_No = T.Table_No   
And B.Table_no In (select Distinct Table_no From Broktable Where      
 (day_puc = Cast(@val1 As Numeric(18,6)) Or Day_sales = Cast(@val1 As Numeric(18,6)) Or Sett_purch = Cast(@val1 As Numeric(18,6)) Or Sett_sales = Cast(@val1 As Numeric(18,6)) Or Normal = Cast(@val1 As Numeric(18,6)))      
And Trd_del In ('t','s','f') And Val_perc Like @valperc)         
and T.Branch_Code Like @branch  
Order By T.Branch_Code, B.Table_no,line_no,upper_lim      
End      
If @trddel = 2      
      
Begin      
Select Distinct B.Table_no,line_no,B.table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,      
Trd_del = (case When Trd_del = 't' Then 'trading'       
  When Trd_del = 'd' Then 'delivery'      
  When Trd_del = 'f' Then 'first Leg'      
  When Trd_del = 's' Then 'second Leg'      
    End), T.Branch_Code      
From Broktable B, BranchBrokTable T  
Where B.Table_No = T.Table_No   
And B.Table_no In (select Distinct Table_no From Broktable Where      
 (day_puc = Cast(@val1 As Numeric(18,6)) Or Day_sales = Cast(@val1 As Numeric(18,6)) Or Sett_purch = Cast(@val1 As Numeric(18,6)) Or Sett_sales = Cast(@val1 As Numeric(18,6)) Or Normal = Cast(@val1 As Numeric(18,6)))      
And Trd_del In ('d') And Val_perc Like @valperc)        
and T.Branch_Code Like @branch  
Order By T.Branch_Code, B.Table_no,line_no,upper_lim      
End      
End

GO
