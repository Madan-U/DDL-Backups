-- Object: PROCEDURE dbo.Usp_DpFileforBackoffice_01072022
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



      
      
      
--exec Usp_DpFileforBackoffice      
Create Proc [dbo].[Usp_DpFileforBackoffice_01072022]      
      
As      
BEGIN

truncate table tbl_Final_Dp_File      
      
--Exchange Var details       
select * into #VARDETAIL from anand1.msajag.dbo.VARDETAIL where DetailKey=replace(convert(varchar, getdate()-1, 103),'/','')    
      
---settlement Cal       
--select * into  #sett from [196.1.115.197].msajag.dbo.sett_mst where  Sec_Payin  between '2022-05-31 00:00:00.000' and '2022-06-01 23:59:59.000' and Sett_Type in ('N','W')--,'F')      
      
      
Select * into  #sett from [196.1.115.197].msajag.dbo.sett_mst S where Start_date <=convert(varchar(11),getdate(),120)      
and Sec_Payin >convert(varchar(11),getdate(),120) and Sett_Type in ('N','W','M','Z')      
      
      
      
---Combine New DP and Old Dp from Backoffice      
select tradingid,hld_isin_code,netqty,PLEDGE_QTY,Rate,FREE_QTY,FREEZE_QTY,LOCKIN_QTY,SecurityName,Valuation      
into #Dp_FreeHolding      
from [172.31.16.108].dmat.citrus_usr.holding      
      
      
-----CUsa Mtf and Margin pledge details Table       
select * into  #Cusa_MTF_MP from [196.1.115.197].msajag.dbo.deltrans where DrCr='D' and Delivered='0' and Filler2='1'       
and Party_Code not in ('exe','broker','NSE')       
Union all      
select * from [196.1.115.197].BSEDB.dbo.deltrans where DrCr='D' and Delivered='0' and Filler2='1'       
and Party_Code not in ('exe','broker','BSE')      
      
      
      
select Sett_No,Sett_type,Party_Code,CertNo,scrip_cd,sum(Qty) as Qty into #finalCusa_MTF_MP from #Cusa_MTF_MP CMM --where EXISTS (select * from #sett ab where ab.Sett_No=CMM.Sett_No and ab.Sett_Type=CMM.Sett_Type)      
group by Sett_No,Sett_type,Party_Code,CertNo,scrip_cd      
      
      
--select * into #deliveryclt  from [196.1.115.197].msajag.dbo.deliveryclt del      
--where EXISTS (select * from #sett ab where ab.Sett_No=del.Sett_No and ab.Sett_Type=del.Sett_Type) and inout ='o'      
      
----Unsettled T-2      
select * into #deliveryclt  from [196.1.115.197].msajag.dbo.deliveryclt del      
where Sett_no in (select MIN(Sett_No)  from #sett) and inout ='o'      
      
--select * from #deliveryclt where Party_code in ('G270869','AVNE1008')      
      
      
      
select a.*,b.Party_Code,b.Qty,b.Sett_No,b.CertNo into #FreeDp_CMM from #Dp_FreeHolding a left join #finalCusa_MTF_MP b      
on a.tradingid=b.Party_Code      
and a.hld_isin_code=b.CertNo      
      
      
      
select a.*,b.Party_code as deli_Party_code,b.Qty as deli_Qty,b.I_ISIN as  deli_ISIN       
into #tbl_Final_Data      
from #FreeDp_CMM a left join #deliveryclt b       
on a.tradingid=b.Party_code      
and a.hld_isin_code=b.I_ISIN      
      
       
select a.*,b.VarMarginRate into #TBl_DP_Final_Data from #tbl_Final_Data a left join #VARDETAIL b       
on a.hld_isin_code=b.IsIN      
      
      
insert into tbl_Final_Dp_File            
select tradingid,hld_isin_code,(FREE_QTY+isnull (Qty,0)+isnull (deli_Qty,0))as Total_Qty,      
(ceiling (VarMarginRate))/100 as VarMarginRate,(isnull (Qty,0)+isnull (deli_Qty,0)) as Limit_Qty,Rate,GETDATE()            
from #TBl_DP_Final_Data  order by hld_isin_code desc        
      
      
      
END     


      
      
--select * into #GM2_DpFile from #Final_Dp_File_31052022 a inner join #GM2 b      
--on a.tradingid=b.AccountId collate Latin1_General_CI_AI      
--select COUNT (*) from #GM2_DpFile where Total_Qty=0 or Limit_Qty='0'      
      
      
--select AccountId,Omnemanagerid into #GM2 from [172.31.15.250].[uploader-db].dbo.tbl_usermasterinfo where OmnemanagerId in ('2')      
--select * from [196.1.115.182].general.dbo. tbl_Omne_NewPoolBgFile where PARTY_CODE in ('A102597') order by ISIN desc

GO
