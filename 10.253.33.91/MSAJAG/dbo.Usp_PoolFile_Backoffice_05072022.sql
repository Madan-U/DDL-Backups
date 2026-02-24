-- Object: PROCEDURE dbo.Usp_PoolFile_Backoffice_05072022
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    

--exec Usp_PoolFile_Backoffice    
Create Proc [dbo].[Usp_PoolFile_Backoffice_05072022]    
As    
BEGIN  

truncate table Tbl_PoolFile
truncate table Tbl_Pool_File_BO
---Pool File     
    
Select * into  #sett from [196.1.115.197].msajag.dbo.sett_mst S where Start_date <=convert(varchar(11),getdate(),120)    
and Sec_Payin >convert(varchar(11),getdate(),120) and Sett_Type in ('N','W')    
    
--Exchange Var details     
select * into #VARDETAIL from anand1.msajag.dbo.VARDETAIL where DetailKey=replace(convert(varchar, getdate()-1, 103),'/','')    
    
    
select * into #deliveryclt  from [196.1.115.197].msajag.dbo.deliveryclt del    
where Sett_no in (select max(Sett_No)  from #sett) and inout ='o'    
    
    
    
select a.*,b.VarMarginRate into #TBl_Pool_Final_Data from #deliveryclt a left join #VARDETAIL b     
on a.I_ISIN=b.IsIN    
    
select cl_type,cl_code into #NBFC_ClientCodes from Msajag.dbo.client_details where cl_type='NBF'       
    
delete from #TBl_Pool_Final_Data where party_code in (select cl_code from #NBFC_ClientCodes)    
    
--select Party_code,I_ISIN,(FREE_QTY+isnull (Qty,0)+isnull (deli_Qty,0))as Total_Qty,    
--VarMarginRate,(isnull (Qty,0)+isnull (deli_Qty,0)) as Limit_Qty,Rate     
--into #Final_Pool_File_31052022    
--from     
--#TBl_Pool_Final_Data  order by I_ISIN desc    
  
  
select SCRIP_CD,SERIES,ISIN,CL_RATE into #cls_Rate from anand1.msajag.dbo.closing_mtm         
where cast(sysdate as date)= (select max(sysdate)  from anand1.msajag.dbo.closing_mtm)   
  
select a.*,b.SecVar,b.IndexVar,b.AppVar,b.SecSpecVar,b.VarMarginRate,b.DetailKey        
into #ClsRate_Varmgr        
from #cls_Rate a inner join anand1.msajag.dbo.VARDETAIL b         
on a.ISIN=b.IsIN        
and a.SCRIP_CD=b.SCRIP_CD        
where b.DetailKey=replace(convert(varchar, getdate()-1, 103),'/','')  
  
select a.*,ISIN,b.CL_RATE,b.SecVar,b.IndexVar,b.AppVar,b.SecSpecVar,b.VarMarginRate as b_VarMarginRat into #Tbl_PoolData from #TBl_Pool_Final_Data a left join #ClsRate_Varmgr b on         
a.I_ISIN=b.ISIN       
  
select Sett_no,Sett_Type,Party_code,Qty as Toatl_Qty,scrip_cd,I_ISIN,Qty as limit_Qty ,CL_RATE,VarMarginRate,AppVar,(Qty*CL_RATE) as value,        
(Qty*CL_RATE)*VarMarginRate/100 as FinalAmt        
into  #tbl_Final_Pool_Data_New        
from #Tbl_PoolData      
   
   
update #tbl_Final_Pool_Data_New  
set AppVar='20.00'  
where AppVar<20  
  
update a  
set a.AppVar =b.VARMARGIN  
from #tbl_Final_Pool_Data_New a inner join [196.1.115.182].general.dbo.tbl_ISIN_100per_Haricut b  
on a.I_ISIN=b.ISIN  
  
  
update #tbl_Final_Pool_Data_New  
set AppVar =100  
where I_ISIN in  (select [ISIN No] from  [196.1.115.182].general.dbo.TBL_NRMS_RESTRICTED_SCRIPS where [Angel scrip category]='Poor')  
  
insert into Tbl_PoolFile    
select Party_code,I_ISIN,Toatl_Qty,'1' as Format_1,'0' as Format_2,limit_Qty,((ceiling (AppVar))/100) as FinalVarMargin,CL_RATE,'CNC' as Product ,GETDATE() from    
#tbl_Final_Pool_Data_New


----------------///**********B2C GM7 serevr Pool File Download on 02 July 2022 *******************////////////////--------------------------  
     
     
   insert into Tbl_Pool_File_BO   
   select Ltrim (rtrim(Party_code))+'|'+I_Isin+'|'+Total_Qty+'|'+Format_1+'|'+Format_2+'|'+limit_Qty+'|'+Haircut+'|'+convert(varchar,convert(decimal(18,2), CL_Rate))+'|'+Product from  Tbl_PoolFile  
      
    
       
   DECLARE @filename_GM7 as varchar(100)                                                           
   select @filename_GM7='\\196.1.115.147\Upload1\OmnesysFileFormat\GM7_Pool_File\BO_OmnPoolFile_GM7'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'        
                 
   DECLARE @BCPCOMMAND_GM7 VARCHAR(250)                      
   --DECLARE @FILENAME_GM3 VARCHAR(250)               
   declare @s8 as varchar(max)                      
                      
   --SET @PATH ='\\'+@server+'\D$\Upload\GenerateIPOCSV\'                      
   --SET @FILENAME = 'h:\upload1\OmnLimitFile'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'        
   SET @FILENAME_GM7 = '\\196.1.115.147\Upload1\OmnesysFileFormat\GM7_Pool_File\BO_OmnPoolFile_GM7'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'                                                                              
   SET @BCPCOMMAND_GM7 = 'BCP "SELECT   FileFormat FROM MSAJAG.dbo.Tbl_Pool_File_BO with (nolock)" QUERYOUT "'                      
   SET @BCPCOMMAND_GM7 = @BCPCOMMAND_GM7 + @filename_GM7 + '" -c -t, -SANAND1 -Uinhouse -Pinh6014'                      
   EXEC MASTER..XP_CMDSHELL @BCPCOMMAND_GM7      
       
   
         
 /*===============================END==========================*/  
  

   
END

GO
