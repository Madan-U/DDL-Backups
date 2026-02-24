-- Object: PROCEDURE dbo.Usp_DpFileforBackoffice_13072022_2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
  
        
        
        
--exec Usp_DpFileforBackoffice        
Create Proc [dbo].[Usp_DpFileforBackoffice_13072022_2]        
        
As        
BEGIN  
  
truncate table tbl_Final_Dp_File 
truncate table tbl_Gm7_DP       
        
--Exchange Var details  

select * into #sett12 from sett_mst where Start_date < Convert(varchar(11),GETDATE(),120) and  Sec_Payin>= Convert(varchar(11),GETDATE(),120)   and Sett_Type in ('W','N')  
declare @maxDate datetime
select @maxDate= MAX(Start_date) from #sett12
select @maxDate 
       
select * into #VARDETAIL from anand1.msajag.dbo.VARDETAIL where DetailKey=replace(convert(varchar, @maxDate, 103),'/','')      
        
---settlement Cal         
--select * into  #sett from [196.1.115.197].msajag.dbo.sett_mst where  Sec_Payin  between '2022-05-31 00:00:00.000' and '2022-06-01 23:59:59.000' and Sett_Type in ('N','W')--,'F')        
  
select * into #tbl_closing_mtm  from closing_mtm where UPLOAD_ON >GETDATE()-1        
        
Select * into  #sett from [196.1.115.197].msajag.dbo.sett_mst S where Start_date <=convert(varchar(11),getdate(),120)        
and Sec_Payin >convert(varchar(11),getdate(),120) and Sett_Type in ('N','W','M','Z')        
        
        
        
---Combine New DP and Old Dp from Backoffice        
select tradingid,hld_isin_code,netqty,PLEDGE_QTY,Rate,FREE_QTY,FREEZE_QTY,LOCKIN_QTY,SecurityName,Valuation        
into #Dp_FreeHolding_Data        
from [172.31.16.108].dmat.citrus_usr.holding   
  
select a.*,b.cl_rate into #Dp_FreeHolding  from #Dp_FreeHolding_Data a left join #tbl_closing_mtm b  
on a.hld_isin_code=b.ISIN  


    
        
-----CUsa Mtf and Margin pledge details Table         
select * into  #Cusa_MTF_MP from [196.1.115.197].msajag.dbo.deltrans where DrCr='D' and Delivered='0' and Filler2='1'         
and Party_Code not in ('exe','broker','NSE')         
Union all        
select * from [196.1.115.197].BSEDB.dbo.deltrans where DrCr='D' and Delivered='0' and Filler2='1'         
and Party_Code not in ('exe','broker','BSE')        
        
        
        
select Party_Code,CertNo,sum(Qty) as Qty into #finalCusa_MTF_MP from #Cusa_MTF_MP CMM --where EXISTS (select * from #sett ab where ab.Sett_No=CMM.Sett_No and ab.Sett_Type=CMM.Sett_Type)        
group by Party_Code,CertNo
        
        
--select * into #deliveryclt  from [196.1.115.197].msajag.dbo.deliveryclt del        
--where EXISTS (select * from #sett ab where ab.Sett_No=del.Sett_No and ab.Sett_Type=del.Sett_Type) and inout ='o'        
        
----Unsettled T-2        
select * into #deliveryclt  from [196.1.115.197].msajag.dbo.deliveryclt del        
where Sett_no in (select MIN(Sett_No)  from #sett) and inout ='o'        
        
--select * from #deliveryclt where Party_code in ('G270869','AVNE1008')  
----sett no M and Z New Condition 

insert into #deliveryclt
select * from [196.1.115.197].msajag.dbo.deliveryclt del        
where Sett_no in (select min(Sett_No)  from #sett where Sett_Type in ('M','Z')) and inout ='o'        
        
        
        
select a.*,b.Party_Code,b.Qty,b.CertNo into #FreeDp_CMM from #Dp_FreeHolding a left join #finalCusa_MTF_MP b        
on a.tradingid=b.Party_Code        
and a.hld_isin_code=b.CertNo        
        
        
        
select a.*,b.Party_code as deli_Party_code,b.Qty as deli_Qty,b.I_ISIN as  deli_ISIN         
into #tbl_Final_Data        
from #FreeDp_CMM a left join #deliveryclt b         
on a.tradingid=b.Party_code        
and a.hld_isin_code=b.I_ISIN 


--insert into #tbl_Final_Data 
--select a.*,b.Party_code as deli_Party_code,b.Qty as deli_Qty,b.I_ISIN as  deli_ISIN         
--from #FreeDp_CMM a Right join #deliveryclt b         
--on a.tradingid=b.Party_code        
--and a.hld_isin_code=b.I_ISIN
--and a.tradingid is null       
        
         
select a.*,b.AppVar into #TBl_DP_Final_Data from #tbl_Final_Data a left join #VARDETAIL b         
on a.hld_isin_code=b.IsIN        
        
        
insert into tbl_Final_Dp_File              
select tradingid,hld_isin_code,(FREE_QTY+isnull (Qty,0)+isnull (deli_Qty,0))as Total_Qty,        
(ceiling (AppVar))/100 as AppVar,(isnull (Qty,0)+isnull (deli_Qty,0)) as Limit_Qty,(case when cl_rate IS null then 0 else CL_RATE end) as Rate ,GETDATE()              
from #TBl_DP_Final_Data  order by hld_isin_code desc      


------------------===================GM7 Dp file Creation on 2 july 2022--------------------------------------

select AccountId,clientstatus,OmnemanagerId,BrokerId into #tbl_usermasterinfo from [172.31.15.250].[uploader-db].dbo.tbl_usermasterinfo where OmnemanagerId='7' 


select * into #Tbl_GM7_DP from tbl_Final_Dp_File a inner join #tbl_usermasterinfo b 
on a.tradingid=b.AccountId collate Latin1_General_CI_AI 
where b.OmnemanagerId='7'   

insert into tbl_Gm7_DP 
select tradingid+'|'+hld_isin_code+'|'+convert(varchar,convert(decimal(18,2), Total_Qty))+'|1|0|'+convert(varchar,convert(decimal(18,2), VarMarginRate)) +'|'+ convert(varchar,convert(decimal(18,2), Limit_Qty))+'|'+convert(varchar,convert(decimal(18,2), Rate))
from  #Tbl_GM7_DP where Total_Qty<>0 or Limit_Qty<>0

delete from tbl_Gm7_DP where fileformat is null

DECLARE @filename_GM7 as varchar(100)                                                           
select @filename_GM7='\\196.1.115.147\Upload1\OmnesysFileFormat\GM7_DP_File\BO_GM7_Dp_FileFormat'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'        
				                 
DECLARE @BCPCOMMAND_GM7 VARCHAR(250)                      

declare @s_GM7 as varchar(max)                      


SET @filename_GM7 = '\\196.1.115.147\Upload1\OmnesysFileFormat\GM7_DP_File\BO_GM7_Dp_FileFormat'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'                                                                              
SET @BCPCOMMAND_GM7 = 'BCP "SELECT   FileFormat FROM MSAJAG.dbo.tbl_Gm7_DP" QUERYOUT "'                      
SET @BCPCOMMAND_GM7 = @BCPCOMMAND_GM7 + @filename_GM7 + '" -c -t, -SANAND1 -Uinhouse -Pinh6014'                      
EXEC MASTER..XP_CMDSHELL @BCPCOMMAND_GM7    

---------------------------------------------------END------------------------------------------------------------
        
        
END       
  
  
        
--select * into #GM2_DpFile from #Final_Dp_File_31052022 a inner join #GM2 b        
--on a.tradingid=b.AccountId collate Latin1_General_CI_AI        
--select COUNT (*) from #GM2_DpFile where Total_Qty=0 or Limit_Qty='0'        
        
        
--select AccountId,Omnemanagerid into #GM2 from [172.31.15.250].[uploader-db].dbo.tbl_usermasterinfo where OmnemanagerId in ('2')        
--select * from [196.1.115.182].general.dbo. tbl_Omne_NewPoolBgFile where PARTY_CODE in ('A102597') order by ISIN desc

GO
