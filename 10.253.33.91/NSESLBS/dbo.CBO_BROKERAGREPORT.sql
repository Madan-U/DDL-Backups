-- Object: PROCEDURE dbo.CBO_BROKERAGREPORT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--EXEC CBO_BROKERAGREPORT 'p','2.50','All'
  
CREATE PROCEDURE CBO_BROKERAGREPORT        
@VALPERC VARCHAR(20),
@VAL1 VARCHAR(20),
@TRDDEL VARCHAR(10),       
@STATUSID VARCHAR(25) = 'BROKER',
@STATUSNAME VARCHAR(25) = 'BROKER'
As        
If @VAL1 = '%'
Begin
        
If @TRDDEL = 'ALL'

Begin            
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,
Trd_del = (case When Trd_del = 't' Then 'trading'             
  When Trd_del = 'd' Then 'delivery'            
  When Trd_del = 'f' Then 'first Leg'            
  When Trd_del = 's' Then 'second Leg'            
  End)            
From Broktable
Where Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('t','s','f','d') And Val_perc Like @VALPERC)              
Order By Table_no,line_no,upper_lim            
End
      
If @TRDDEL = 'T'
        
Begin        
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal, round_to,            
Trd_del = (case When Trd_del = 't' Then 'trading'             
  When Trd_del = 'd' Then 'delivery'            
  When Trd_del = 'f' Then 'first Leg'            
  When Trd_del = 's' Then 'second Leg'            
  End)
From Broktable            
Where  Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('t','s','f') And Val_perc Like @VALPERC)              
Order By Table_no,line_no,upper_lim            
End
           
If @TRDDEL = 'D'
            
Begin            
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,            
Trd_del = (case When Trd_del = 't' Then 'trading'             
  When Trd_del = 'd' Then 'delivery'            
  When Trd_del = 'f' Then 'first Leg'            
  When Trd_del = 's' Then 'second Leg'            
  End)
From Broktable
Where Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('d') And Val_perc Like @VALPERC)              
Order By Table_no,line_no,upper_lim            
End
         
End
         
If @VAL1 <> '%'
            
Begin
       
If @TRDDEL = 'ALL'
            
Begin            
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,            
Trd_del = (case When Trd_del = 't' Then 'trading'             
  When Trd_del = 'd' Then 'delivery'            
  When Trd_del = 'f' Then 'first Leg'            
  When Trd_del = 's' Then 'second Leg'            
  End)
From Broktable            
Where Table_no In (select Distinct Table_no From Broktable Where            
(day_puc = Cast(@VAL1 As Numeric(18,6)) Or Day_sales = Cast(@VAL1 As Numeric(18,6)) Or Sett_purch = Cast(@VAL1 As Numeric(18,6)) Or Sett_sales = Cast(@VAL1 As Numeric(18,6)) Or Normal = Cast(@VAL1 As Numeric(18,6)))            
And Trd_del In ('t','s','f','d') And Val_perc Like @VALPERC)              
Order By Table_no,line_no,upper_lim            
End         
If @TRDDEL = 'T'            
Begin            
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,            
Trd_del = (case When Trd_del = 't' Then 'trading'             
  When Trd_del = 'd' Then 'delivery'            
  When Trd_del = 'f' Then 'first Leg'            
  When Trd_del = 's' Then 'second Leg'            
  End)
From Broktable
Where Table_no In (select Distinct Table_no From Broktable Where            
 (day_puc = Cast(@VAL1 As Numeric(18,6)) Or Day_sales = Cast(@VAL1 As Numeric(18,6)) Or Sett_purch = Cast(@VAL1 As Numeric(18,6)) Or Sett_sales = Cast(@VAL1 As Numeric(18,6)) Or Normal = Cast(@VAL1 As Numeric(18,6)))            
And Trd_del In ('t','s','f') And Val_perc Like @VALPERC)        
Order By Table_no,line_no,upper_lim            
End            
If @TRDDEL = 'D'
            
Begin     
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,            
Trd_del = (case When Trd_del = 't' Then 'trading'             
  When Trd_del = 'd' Then 'delivery'            
  When Trd_del = 'f' Then 'first Leg'            
  When Trd_del = 's' Then 'second Leg'            
  End)
From Broktable            
Where  Table_no In (select Distinct Table_no From Broktable Where            
(day_puc = Cast(@VAL1 As Numeric(18,6)) Or Day_sales = Cast(@VAL1 As Numeric(18,6)) Or Sett_purch = Cast(@VAL1 As Numeric(18,6)) Or Sett_sales = Cast(@VAL1 As Numeric(18,6)) Or Normal = Cast(@VAL1 As Numeric(18,6)))            
And Trd_del In ('d') And Val_perc Like @VALPERC)
Order By Table_no,line_no,upper_lim
End         
End

GO
