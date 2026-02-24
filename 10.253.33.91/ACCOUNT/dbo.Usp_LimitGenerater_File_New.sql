-- Object: PROCEDURE dbo.Usp_LimitGenerater_File_New
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

            
--exec Usp_LimitGenerater_File_New           
CREATE Proc [dbo].[Usp_LimitGenerater_File_New]            
As            
BEGIN            
            
Truncate table  tbl_Limit_Data   
truncate table tbl_OmnLimitFile_GM7           
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
          
--insert into NBFC_OtherSegmentBal          
exec Usp_NBFC_OtherSegmentBal           
          
select client_code,(ACTUALLEDGER+INTEREST+UNSETTLEAMT) as limit into #nbfc_miles_ledger from ABVSCITRUS.INHOUSE.DBO.nbfc_miles_ledger          
          
          
select a.client_code,a.limit,b.* into #Combine_Ledger_NBFC from  #nbfc_miles_ledger a left join NBFC_OtherSegmentBal b          
on a.client_code=b.Cltcode          
          
select client_code,limit, ISNULL(Vamt,0)as Vamt  ,(limit+ISNULL(Vamt,0)) as FinalAmt          
into #tbl_Final_Combine_Ledger_NBFC           
from #Combine_Ledger_NBFC          
          
insert into #Tbl_Final          
select client_code ,sum(FinalAmt) as FinalAmt from #tbl_Final_Combine_Ledger_NBFC group by client_code   
  
  
          
          
------------------------------------------------------END-------------------------------------------------------------------------------            
---------------------------------------------------Unreco Amt---------------------------------------------------------------------------            
            
select * into #UncreMark_ALG from [CSOKYC-6].general.dbo.ALG_EXP_MAST where UN_RECO_CR_LMT='0'            
            
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
                 
-----------------------------------------------------END-------------------------------------------------------------------------------            
          
          
-----------------------------------------------------Shortcell Query-------------------------------------------------------         
          
--insert into tbl_BSECM_Shortage_LimitALG          
--(Sett_No,Sett_Type,Party_Code,Short_Name,Branch_Cd,sub_broker,Scrip_Cd,Certno,Delqty,Recqty,Isettqtyprint,Isettqtymark,Ibenqtyprint,Ibenqtymark,Hold,Pledge,Nsehold,Nsepledge)          
--exec  ANGELDEMAT.INHOUSE.DBO.Rpt_BSE_Delpayinmatch_CMSPRO_cli_LimitALG          
          
--insert into tbl_NSECM_Shortage_LimitALG          
--(Sett_No,Sett_Type,Party_Code,Short_Name,Branch_Cd,Sub_Broker,Scrip_Cd,Certno,Delqty,Recqty,Isettqtyprint,Isettqtymark,Ibenqtyprint,Ibenqtymark,Hold,Pledge,BSEHold,BSEPledge)          
--exec  ANGELDEMAT.INHOUSE.DBO.RPT_NSE_DELPAYINMATCH_CMSPRO_cli_LimitALG          
        
--insert into [AngelDemat].MSAJAG.dbo.Tbl_ShortSell        
exec [AngelDemat].msajag.dbo.Usp_ShortSell        
    
select *,value+finalAmt as Final_Data_Amt into  #Tbl_ShortSell_Data from [AngelDemat].MSAJAG.dbo.Tbl_ShortSell    
  
select Sett_no,Party_code,sum (Final_Data_Amt) as Final_Data_Amt into #Tbl_ShortSell from #Tbl_ShortSell_Data group by Sett_no,Party_code  
    
select a.*,b.Final_Data_Amt,a.vamt-(isnull (b.Final_Data_Amt,0)) as data  into #final_shortsell from  #Tbl_Final a left join #Tbl_ShortSell b on     
a.cltcode=b.party_code    
  
  
  
           
------------------------------------------------------------END-------------------------------------------------------------          
-------------------------------------------chequee Bounce Query------------------------------------------------------------      
        
exec Usp_ChequeeBounce      
      
    
select a.*,b.relamt,a.data-(isnull (b.relamt,0)) as finaldata  into #final_chequee from  #final_shortsell a left join Tbl_ChequeeBounce b on     
a.cltcode=b.party_code    
             
      
------------------------------------------------END----------------------------------------------------------------------      
  
insert into  tbl_Limit_Data   
select CLTCODE,finaldata,GETDATE()  from #final_chequee --where vamt<>0             
  
--------------------------------------------File Generation-------------------------------------------------------------  
select AccountId,clientstatus,OmnemanagerId,BrokerId into #tbl_usermasterinfo from [172.31.15.250].[uploader-db].dbo.tbl_usermasterinfo where OmnemanagerId='7'  
  
select * into  #wsxc1 from tbl_Limit_Data a left join #tbl_usermasterinfo b on   
a.cltcode =b.accountId collate Latin1_General_CI_AI  
where b.OmnemanagerId='7'  
  
 alter table #wsxc1  
 add Clientprofile varchar(20)  
  
 SELECT DISTINCT a.CLTCODE,b.Intraday_Type into #hh FROM #wsxc1 a left join [CSOKYC-6].general.dbo. ALG_EXP_MAST b   
 on a.CLTCODE=b.ENTITY_CODE    
 --where b.Intraday_Type='Both'  
   
  
   
 update #wsxc1  
 Set Clientprofile = 'INTRADAY' ---(case when Intraday_Type ='Both' then 'INTRADAY' else 'NON-INTRADAY' end) from #hh  
 where CLTCODE in (select CLTCODE from #hh where Intraday_Type='Both')  
   
 update #wsxc1  
 Set Clientprofile = 'NON-INTRADAY'  
 where  isnull (Clientprofile,'') =''  
  
--------------------===============================END==========================*/                
   
----------------///**********B2C GM7 serevr Limit File Download on 23 June 2022 *******************////////////////--------------------------  
     
     
   insert into tbl_OmnLimitFile_GM7   
   select CLTCODE+'||||'+convert(varchar,convert(decimal(18,2), Amt))+'|9999999999999|||9999999999999||||||||'+Clientprofile+'||9999999999999|||||||0|ANGEL||||||||||||||||||||||||||' from  #wsxc1  
      
     
       
   DECLARE @filename_GM7 as varchar(100)                                                           
   select @filename_GM7='\\INHOUSELIVEAPP1-FS.angelone.in\Upload1\OmnesysFileFormat\Limit_File_GM7\BO_OmnLimitFile_GM7'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'        
                 
   DECLARE @BCPCOMMAND_GM7 VARCHAR(250)                      
   --DECLARE @FILENAME_GM3 VARCHAR(250)               
   declare @s8 as varchar(max)                      
                      
   --SET @PATH ='\\'+@server+'\D$\Upload\GenerateIPOCSV\'                      
   --SET @FILENAME = 'h:\upload1\OmnLimitFile'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'        
   SET @FILENAME_GM7 = '\\INHOUSELIVEAPP1-FS.angelone.in\Upload1\OmnesysFileFormat\Limit_File_GM7\BO_OmnLimitFile_GM7'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'                                                                              
   SET @BCPCOMMAND_GM7 = 'BCP "SELECT   FileFormat FROM Account.dbo.tbl_OmnLimitFile_GM7 with (nolock)" QUERYOUT "'                      
   SET @BCPCOMMAND_GM7 = @BCPCOMMAND_GM7 + @filename_GM7 + '" -c -t, -SABVSNSECM.angelone.in -Uclassmkt -Pdd$$gnfDTVs244648ysjgZAcc'                      
   EXEC MASTER..XP_CMDSHELL @BCPCOMMAND_GM7      
       
   
         
 /*===============================END==========================*/  
  
  
               
END

GO
