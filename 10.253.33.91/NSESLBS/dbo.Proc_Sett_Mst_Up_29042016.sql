-- Object: PROCEDURE dbo.Proc_Sett_Mst_Up_29042016
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc [dbo].[Proc_Sett_Mst_Up](@FilePath Varchar(200), @UpFlag Varchar(1))  
AS  
Declare @strSql varchar(500)    
  
Select Sett_Type,Sett_No,Start_Date,End_Date,Funds_Payin,Funds_Payout,  
Sec_Payin,Sec_Payout,RecDate=GetDate(),Flag1=0, Flag2='YY'  
Into #Sett_Mst_Bulk  
from sett_mst Where 1 = 2   
  
Set @strSql = 'Bulk insert #Sett_Mst_Bulk from ''' + @FilePath  + '''  with ( FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'' )'    
Exec(@strSql)    
  
Update #Sett_Mst_Bulk Set   
End_Date = Left(End_Date,11) + ' 23:59:59',  
Funds_Payout = Left(Funds_Payout,11) + ' 23:59:59',  
Sec_Payout = Left(Funds_Payout,11) + ' 23:59:59'  
  
If @UpFlag = 'U'   
Begin   
 Delete From #Sett_Mst_Bulk   
 Where Sett_No In (Select Sett_No From Sett_Mst   
 Where Sett_No = #Sett_Mst_Bulk.Sett_No  
 And Sett_Type = #Sett_Mst_Bulk.Sett_Type)  
  
 Insert into Sett_Mst  
 Select Exchange='NSE',Sett_Type,Sett_No,Start_Date,End_Date,Funds_Payin,Funds_Payout,Sec_Payin,Sec_Payout,  
 Series='EQ',Markettype=1  
 From #Sett_Mst_Bulk  
End  
  
If @UpFlag = 'O'   
Begin   
 Insert Into #Sett_Mst_Bulk  
 Select Sett_Type,Sett_No,Start_Date,End_Date,Funds_Payin,Funds_Payout,Sec_Payin,  
 Sec_Payout,RecDate=GetDate(),Flag1=0, Flag2='YY' 
 From Sett_Mst   
 Where Sett_No Not In (Select Sett_No From #Sett_Mst_Bulk   
 Where Sett_No = Sett_Mst.Sett_No  
 And Sett_Type = Sett_Mst.Sett_Type)  
  
 Truncate Table Sett_Mst  
 Insert into Sett_Mst  
 Select Exchange='NSE',Sett_Type,Sett_No,Start_Date,End_Date,Funds_Payin,Funds_Payout,Sec_Payin,Sec_Payout,  
 Series='EQ',Markettype=1  
 From #Sett_Mst_Bulk  
  
End

GO
