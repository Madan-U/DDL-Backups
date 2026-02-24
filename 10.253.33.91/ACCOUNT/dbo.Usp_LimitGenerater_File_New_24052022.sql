-- Object: PROCEDURE dbo.Usp_LimitGenerater_File_New_24052022
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

    
--exec Usp_LimitGenerater_File_New    
Create Proc [dbo].[Usp_LimitGenerater_File_New_24052022]    
As    
BEGIN    
    
drop table tbl_Limit_Data    
----------------------------------------------All Leder Bal Get in Backoffice Table ----------------------------------------------    
Select Cltcode,sum(case when drcr='D' then Vamt*-1 else vamt end) vamt     
into #temp     
from ledger_all With(Nolock) where vdt >='2022-04-01' --and CLTCODE='S242871'    
group by Cltcode    
    
Insert into #temp    
Select Cltcode,sum(case when drcr='D' then Vamt*-1 else vamt end) vamt  from Mtftrade.dbo.ledger With(Nolock) where vdt >='2022-04-01' --and CLTCODE='S242871'    
group by Cltcode    
    
Insert into #temp    
Select Cltcode,sum(case when drcr='D' then Vamt*-1 else vamt end) vamt  from Angelcommodity.accountcurbfo.dbo.ledger With(Nolock)    
 where vdt >='2022-04-01' --and CLTCODE='S242871'    
group by Cltcode    
     
Insert into #temp    
Select Cltcode,sum(case when drcr='D' then Vamt*-1 else vamt end) vamt  from Angelcommodity.accountbfo.dbo.ledger With(Nolock)    
where vdt >='2022-04-01' --and CLTCODE='S242871'    
group by Cltcode    
    
    
Select Cltcode,sum(vamt)as vamt into #final from #temp    
group by Cltcode    
select CLTCODE,SUM(vamt) as vamt into #Tbl_Final from #final  group by CLTCODE    
    
------------------------------------------------END----------------------------------------------------------------------------------    
    
------------------------------------------------NBFC Client Ledger Bal ---------------------------------------------------------------    
select cl_type,cl_code into #NBFC_ClientCodes from Msajag.dbo.client_details where cl_type='NBF'    
  
delete  from #Tbl_Final where Cltcode in (SELECT cl_code from #NBFC_ClientCodes)   
  
insert into NBFC_OtherSegmentBal  
exec Usp_NBFC_OtherSegmentBal   
  
select client_code,(ACTUALLEDGER+INTEREST+UNSETTLEAMT)*-1 as limit into #nbfc_miles_ledger from [172.31.16.57].INHOUSE.DBO.nbfc_miles_ledger  
  
  
select a.client_code,a.limit,b.* into #Combine_Ledger_NBFC from  #nbfc_miles_ledger a left join NBFC_OtherSegmentBal b  
on a.client_code=b.Cltcode  
  
select client_code,limit, ISNULL(Vamt,0)as Vamt  ,(limit+ISNULL(Vamt,0)) as FinalAmt  
into #tbl_Final_Combine_Ledger_NBFC   
from #Combine_Ledger_NBFC  
  
insert into #Tbl_Final  
select client_code ,sum(FinalAmt) as FinalAmt from #tbl_Final_Combine_Ledger_NBFC group by client_code  
    
  
  
------------------------------------------------------END-------------------------------------------------------------------------------    
---------------------------------------------------Unreco Amt---------------------------------------------------------------------------    
    
select * into #UncreMark_ALG from [196.1.115.182].general.dbo.ALG_EXP_MAST where UN_RECO_CR_LMT='0'    
    
insert into Tbl_unreco_Final_Data    
exec Usp_All_Combine_Unreco_Data    
    
    
select a.*,b.ENTITY_CODE,b.UN_RECO_CR_LMT into #Uncreo_cleintcode from Tbl_unreco_Final_Data a inner join #UncreMark_ALG b     
on a.cltcode=b.ENTITY_CODE    
    
    
    
select a.*,b.cltcode as Party_code,b.Cramt,(a.vamt-b.Cramt) as Final_Vamt  into #Final_Unreco from   
#Tbl_Final a inner join  #Uncreo_cleintcode b    
on a. CLTCODE=b.cltcode    
    
    
update a     
set a.vamt= b.Final_Vamt    
from #Tbl_Final a inner join  #Final_Unreco  b    
on a.CLTCODE=b.Party_code    
    
    
select * into #tbl_Limit_Data from #Tbl_Final where vamt<>0     
    
select *  from #tbl_Limit_Data    
    
    
-----------------------------------------------------END-------------------------------------------------------------------------------    
  
  
-----------------------------------------------------Shortcell Query-------------------------------------------------------  
  
insert into tbl_BSECM_Shortage_LimitALG  
(Sett_No,Sett_Type,Party_Code,Short_Name,Branch_Cd,sub_broker,Scrip_Cd,Certno,Delqty,Recqty,Isettqtyprint,Isettqtymark,Ibenqtyprint,Ibenqtymark,Hold,Pledge,Nsehold,Nsepledge)  
exec  ANGELDEMAT.INHOUSE.DBO.Rpt_BSE_Delpayinmatch_CMSPRO_cli_LimitALG  
  
insert into tbl_NSECM_Shortage_LimitALG  
(Sett_No,Sett_Type,Party_Code,Short_Name,Branch_Cd,Sub_Broker,Scrip_Cd,Certno,Delqty,Recqty,Isettqtyprint,Isettqtymark,Ibenqtyprint,Ibenqtymark,Hold,Pledge,BSEHold,BSEPledge)  
exec  ANGELDEMAT.INHOUSE.DBO.RPT_NSE_DELPAYINMATCH_CMSPRO_cli_LimitALG  
  
  
------------------------------------------------------------END-------------------------------------------------------------  
    
    
END

GO
