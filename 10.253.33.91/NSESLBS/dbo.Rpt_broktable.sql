-- Object: PROCEDURE dbo.Rpt_broktable
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure Dbo.rpt_broktable    Script Date: 01/15/2005 1:28:10 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_broktable    Script Date: 12/16/2003 2:31:44 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_broktable    Script Date: 05/08/2002 12:35:08 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_broktable    Script Date: 01/14/2002 20:32:52 ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_broktable    Script Date: 12/26/2001 1:23:16 Pm ******/  
  
Create Procedure Rpt_broktable  
  
@valperc As Varchar(20),  
@val1 As Varchar(20),  
@trddel As Int  
As  
  
  
If @val1 = '%'  
  
Begin  
  
  
If @trddel = 0   
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('t','s','f','d') And Val_perc Like @valperc)    
Order By Table_no,line_no,upper_lim  
End  
  
  
If @trddel = 1  
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where  Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('t','s','f') And Val_perc Like @valperc)    
Order By Table_no,line_no,upper_lim  
End  
If @trddel = 2  
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('d') And Val_perc Like @valperc)    
Order By Table_no,line_no,upper_lim  
End  
  
End  
  
  
  
If @val1 <> '%'  
  
Begin  
  
  
If @trddel = 0   
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where Table_no In (select Distinct Table_no From Broktable Where  
(day_puc = Cast(@val1 As Numeric(18,6)) Or Day_sales = Cast(@val1 As Numeric(18,6)) Or Sett_purch = Cast(@val1 As Numeric(18,6)) Or Sett_sales = Cast(@val1 As Numeric(18,6)) Or Normal = Cast(@val1 As Numeric(18,6)))  
And Trd_del In ('t','s','f','d') And Val_perc Like @valperc)    
Order By Table_no,line_no,upper_lim  
End  
  
  
If @trddel = 1  
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where Table_no In (select Distinct Table_no From Broktable Where  
 (day_puc = Cast(@val1 As Numeric(18,6)) Or Day_sales = Cast(@val1 As Numeric(18,6)) Or Sett_purch = Cast(@val1 As Numeric(18,6)) Or Sett_sales = Cast(@val1 As Numeric(18,6)) Or Normal = Cast(@val1 As Numeric(18,6)))  
And Trd_del In ('t','s','f') And Val_perc Like @valperc)     
Order By Table_no,line_no,upper_lim  
End  
If @trddel = 2  
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where  Table_no In (select Distinct Table_no From Broktable Where  
 (day_puc = Cast(@val1 As Numeric(18,6)) Or Day_sales = Cast(@val1 As Numeric(18,6)) Or Sett_purch = Cast(@val1 As Numeric(18,6)) Or Sett_sales = Cast(@val1 As Numeric(18,6)) Or Normal = Cast(@val1 As Numeric(18,6)))  
And Trd_del In ('d') And Val_perc Like @valperc)    
Order By Table_no,line_no,upper_lim  
End  
  
End

GO
