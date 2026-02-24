-- Object: PROCEDURE dbo.AUDIT_DATA_SHASHI
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

---AUDIT_DATA_SHASHI 'dec 22 2021'  
  
CREATE PROCEDURE [dbo].[AUDIT_DATA_SHASHI]  
(@DATE DATETIME  )  
AS   
BEGIN   


-----------------------------------MTF_MARKING------------
  
  
TRUNCATE TABLE TBL_MTF_MARKING_SSRS_REPORT  
BEGIN  
INSERT INTO TBL_MTF_MARKING_SSRS_REPORT  
select SAUDA_DATE,PARTY_CODE,ISIN,QTY,HOLDFLAG,RUNDATE from MTFTRADE..TBL_MTF_MARKING where SAUDA_DATE=@DATE  
  
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\BackOffice\Automation\UPDATION\Margin_Shortfall_Verification\'                       
SET @FILE = @PATH + 'MTF_MARKING' +'_'+ CONVERT(VARCHAR(11),@DATE , 112) + '.csv' --Folder Name     
DECLARE @S VARCHAR(MAX)                              
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''SAUDA_DATE'''',''''PARTY_CODE'''',''''ISIN'''',''''QTY'''',''''HOLDFLAG'''',''''RUNDATE'''''    --Column Name    
SET @S = @S + ' UNION ALL SELECT  CONVERT (VARCHAR (11),SAUDA_DATE,109) as SAUDA_DATE, cast([PARTY_CODE] as varchar), cast([ISIN] as varchar), cast([QTY] as varchar), cast([HOLDFLAG] as varchar), CONVERT (VARCHAR (11),RUNDATE,109) as RUNDATE FROM [MSAJAG].[dbo].[TBL_MTF_MARKING_SSRS_REPORT]    " QUERYOUT ' --Convert data type if required    
    
 +@file+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''     
--       PRINT  (@S)     
EXEC(@S)      
end   
  
  
  ----------------------------EPN_BENEFIT--------------------------
  
  
TRUNCATE TABLE TBL_EPN_BENEFIT_SSRS_REPORT  
BEGIN  
INSERT INTO TBL_EPN_BENEFIT_SSRS_REPORT  
select * from TBL_EPN_BENEFIT where transdate=@DATE  AND  party_code between '0'and 'mzzzzz'
  
DECLARE @FILE1 VARCHAR(MAX),@PATH1 VARCHAR(MAX) = 'J:\BackOffice\Automation\UPDATION\Margin_Shortfall_Verification\'                       
SET @FILE1 = @PATH1 + 'EPN_BENEFIT' +'_'+ CONVERT(VARCHAR(11),@DATE , 112) + '.csv' --Folder Name     
DECLARE @S1 VARCHAR(MAX)                              
SET @S1 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''SETT_NO'''',''''SETT_TYPE'''',''''TRANSDATE'''',''''PARTY_CODE'''',''''SCRIP_CD'''',''''SERIES'''',''''SELLQTY'''',''''EPNQTY_CC'''',''''NONEPNQTY'''',''''MARGIN_REQUIREMENT'''',''''SELLAMOUNT'''',''''SQOFFAMT'''',''''CASHBENEFIT'''',''''MARGIN_BENEFIT'''''    --Column Name    
SET @S1 = @S1 + ' UNION ALL SELECT    cast([SETT_NO] as varchar), cast([SETT_TYPE] as varchar),CONVERT (VARCHAR (11),TRANSDATE,109) as TRANSDATE, cast([PARTY_CODE] as varchar), cast([SCRIP_CD] as varchar),cast([SERIES] as varchar) ,cast([SELLQTY] as varchar),cast([EPNQTY_CC] as varchar) ,cast([NONEPNQTY] as varchar),cast([MARGIN_REQUIREMENT] as varchar ),cast([SELLAMOUNT] as varchar),cast([SQOFFAMT] as varchar),cast([CASHBENEFIT] as varchar),cast([MARGIN_BENEFIT] as varchar) FROM [MSAJAG].[dbo].[TBL_EPN_BENEFIT_SSRS_REPORT]    " QUERYOUT ' --Convert data type if required    
    
 +@file1+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''     
--       PRINT  (@S)     
EXEC(@S1)      
end   
    
  
TRUNCATE TABLE TBL_EPN_BENEFIT_SSRS_REPORT_2  
BEGIN  
INSERT INTO TBL_EPN_BENEFIT_SSRS_REPORT_2  
select * from TBL_EPN_BENEFIT where transdate=@DATE  AND    party_code between 'N'and 'ZZzzzzz'
  
DECLARE @FILE5 VARCHAR(MAX),@PATH5 VARCHAR(MAX) = 'J:\BackOffice\Automation\UPDATION\Margin_Shortfall_Verification\'                       
SET @FILE5 = @PATH5 + 'EPN_BENEFIT_2' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name     
DECLARE @S5 VARCHAR(MAX)                              
SET @S5 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''SETT_NO'''',''''SETT_TYPE'''',''''TRANSDATE'''',''''PARTY_CODE'''',''''SCRIP_CD'''',''''SERIES'''',''''SELLQTY'''',''''EPNQTY_CC'''',''''NONEPNQTY'''',''''MARGIN_REQUIREMENT'''',''''SELLAMOUNT'''',''''SQOFFAMT'''',''''CASHBENEFIT'''',''''MARGIN_BENEFIT'''''    --Column Name    
SET @S5 = @S5 + ' UNION ALL SELECT    cast([SETT_NO] as varchar), cast([SETT_TYPE] as varchar),CONVERT (VARCHAR (11),TRANSDATE,109) as TRANSDATE, cast([PARTY_CODE] as varchar), cast([SCRIP_CD] as varchar),cast([SERIES] as varchar) ,cast([SELLQTY] as varchar),cast([EPNQTY_CC] as varchar) ,cast([NONEPNQTY] as varchar),cast([MARGIN_REQUIREMENT] as varchar ),cast([SELLAMOUNT] as varchar),cast([SQOFFAMT] as varchar),cast([CASHBENEFIT] as varchar),cast([MARGIN_BENEFIT] as varchar) FROM [MSAJAG].[dbo].[TBL_EPN_BENEFIT_SSRS_REPORT_2]    " QUERYOUT ' --Convert data type if required    
    
 +@FILE5+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''     
--       PRINT  (@S)     
EXEC(@S5)      
end 

-----------------------------COLLATERAL_MARGIN_COMBINE----------------------------
 
  
TRUNCATE TABLE V2_TBL_COLLATERAL_MARGIN_COMBINE_SSRS_REPORT  
BEGIN  
INSERT INTO V2_TBL_COLLATERAL_MARGIN_COMBINE_SSRS_REPORT  
  
select   
EXCHANGE,SEGMENT,PARTY_CODE,COLL_TYPE,SCRIP_CD,SERIES,ISIN,QTY,FD_TYPE,FD_BG_NO,  
AMOUNT,FINALAMOUNT,BANK_CODE,MRG_CL_RATE,MRG_AMOUNT,MRG_HAIRCUT,MRG_VAR_MARGIN,MRG_FINALAMOUNT,  
RMS_CL_RATE,RMS_HAIRCUT,RMS_AMOUNT,RMS_FINALAMOUNT,CASH_NCASH,PERCENTAGECASH,PERECNTAGENONCASH,  
MRG_CASH,MRG_NONCASH,RMS_CASH,RMS_NONCASH,MRG_EFFECTIVECOLL,RMS_EFFECTIVECOLL,MARGIN_CALL,LEDGER_AMT,  
RELEASE_QTY,RELEASE_AMT,RECORD_TYPE,effdate,createdon,EXCHANGE_ORG,SEGMENT_ORG  
  
 from V2_TBL_COLLATERAL_MARGIN_COMBINE where effdate=@DATE   AND    party_code between '0'and 'mzzzzz'
  
DECLARE @FILE2 VARCHAR(MAX),@PATH2 VARCHAR(MAX) = 'J:\BackOffice\Automation\UPDATION\Margin_Shortfall_Verification\'                       
SET @FILE2 = @PATH2 + 'COLLATERAL_MARGIN_COMBINE' +'_'+ CONVERT(VARCHAR(11),@DATE , 112) + '.csv' --Folder Name     
DECLARE @S2 VARCHAR(MAX)                              
SET @S2 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''EXCHANGE'''',''''SEGMENT'''',''''PARTY_CODE'''',''''COLL_TYPE'''',''''SCRIP_CD'''',''''SERIES'''',''''ISIN'''',''''QTY'''',''''FD_TYPE'''',''''FD_BG_NO'''', ''''AMOUNT'''',''''FINALAMOUNT'''',''''BANK_CODE'''',''''MRG_CL_RATE'''',''''MRG_AMOUNT'''',''''MRG_HAIRCUT'''',''''MRG_VAR_MARGIN'''' ,''''MRG_FINALAMOUNT'''',''''RMS_CL_RATE'''',''''RMS_HAIRCUT'''',''''RMS_AMOUNT'''',''''RMS_FINALAMOUNT'''' ,''''CASH_NCASH'''',''''PERCENTAGECASH'''',''''PERECNTAGENONCASH'''',''''MRG_CASH'''',''''MRG_NONCASH'''' ,''''RMS_CASH'''',''''RMS_NONCASH'''',''''MRG_EFFECTIVECOLL'''',''''RMS_EFFECTIVECOLL'''',''''MARGIN_CALL'''',''''LEDGER_AMT'''',''''RELEASE_QTY'''' ,''''RELEASE_AMT'''',''''RECORD_TYPE'''',''''effdate'''',''''createdon'''',''''EXCHANGE_ORG'''',''''SEGMENT_ORG'''''  --Column Name   
 SET @S2 = @S2 + ' UNION ALL SELECT    cast([EXCHANGE] as varchar), cast([SEGMENT] as varchar),cast([PARTY_CODE] as varchar), cast([COLL_TYPE] as varchar), cast([SCRIP_CD] as varchar),cast([SERIES] as varchar) ,cast([ISIN] as varchar),cast([QTY] as varchar) ,cast([FD_TYPE] as varchar),cast([FD_BG_NO] as varchar ),cast([AMOUNT] as varchar),cast([FINALAMOUNT] as varchar),cast([BANK_CODE] as varchar),cast([MRG_CL_RATE] as varchar) ,cast([MRG_AMOUNT] as varchar), cast([MRG_HAIRCUT] as varchar),cast([MRG_VAR_MARGIN] as varchar) ,cast([MRG_FINALAMOUNT] as varchar),cast([RMS_CL_RATE] as varchar) ,cast([RMS_HAIRCUT] as varchar),cast([RMS_AMOUNT] as varchar ),cast([RMS_FINALAMOUNT] as varchar),cast([CASH_NCASH] as varchar),cast([PERCENTAGECASH] as varchar),cast([PERECNTAGENONCASH] as varchar) ,cast([MRG_CASH] as varchar), cast([MRG_NONCASH] as varchar),cast([RMS_CASH] as varchar) ,cast([RMS_NONCASH] as varchar),cast([MRG_EFFECTIVECOLL] as varchar) ,cast([RMS_EFFECTIVECOLL] as varchar),cast([MARGIN_CALL] as varchar ),cast([LEDGER_AMT] as varchar),cast([RELEASE_QTY] as varchar),cast([RELEASE_AMT] as varchar),cast([RECORD_TYPE] as varchar) ,CONVERT (VARCHAR (11),effdate,109) as EFFDATE,CONVERT (VARCHAR (11),createdon,109) as CREATEDON, cast([EXCHANGE_ORG] as varchar),cast([SEGMENT_ORG] as varchar)  FROM [MSAJAG].[dbo].[V2_TBL_COLLATERAL_MARGIN_COMBINE_SSRS_REPORT]    " QUERYOUT ' --Convert data type if required    
  
    
 +@file2+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''     
--       PRINT  (@S)     
EXEC(@S2)      
end   
 
  
TRUNCATE TABLE V2_TBL_COLLATERAL_MARGIN_COMBINE_SSRS_REPORT_2  
BEGIN  
INSERT INTO V2_TBL_COLLATERAL_MARGIN_COMBINE_SSRS_REPORT_2  
  
select   
EXCHANGE,SEGMENT,PARTY_CODE,COLL_TYPE,SCRIP_CD,SERIES,ISIN,QTY,FD_TYPE,FD_BG_NO,  
AMOUNT,FINALAMOUNT,BANK_CODE,MRG_CL_RATE,MRG_AMOUNT,MRG_HAIRCUT,MRG_VAR_MARGIN,MRG_FINALAMOUNT,  
RMS_CL_RATE,RMS_HAIRCUT,RMS_AMOUNT,RMS_FINALAMOUNT,CASH_NCASH,PERCENTAGECASH,PERECNTAGENONCASH,  
MRG_CASH,MRG_NONCASH,RMS_CASH,RMS_NONCASH,MRG_EFFECTIVECOLL,RMS_EFFECTIVECOLL,MARGIN_CALL,LEDGER_AMT,  
RELEASE_QTY,RELEASE_AMT,RECORD_TYPE,effdate,createdon,EXCHANGE_ORG,SEGMENT_ORG  
  
 from V2_TBL_COLLATERAL_MARGIN_COMBINE where effdate=@DATE      and party_code between 'N'and 'ZZzzzzz'
  
DECLARE @FILE4 VARCHAR(MAX),@PATH4 VARCHAR(MAX) = 'J:\BackOffice\Automation\UPDATION\Margin_Shortfall_Verification\'                       
SET @FILE4 = @PATH4 + 'COLLATERAL_MARGIN_COMBINE_2' +'_'+ CONVERT(VARCHAR(11),@DATE , 112) + '.csv' --Folder Name     
DECLARE @S4 VARCHAR(MAX)                              
SET @S4 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''EXCHANGE'''',''''SEGMENT'''',''''PARTY_CODE'''',''''COLL_TYPE'''',''''SCRIP_CD'''',''''SERIES'''',''''ISIN'''',''''QTY'''',''''FD_TYPE'''',''''FD_BG_NO'''', ''''AMOUNT'''',''''FINALAMOUNT'''',''''BANK_CODE'''',''''MRG_CL_RATE'''',''''MRG_AMOUNT'''',''''MRG_HAIRCUT'''',''''MRG_VAR_MARGIN'''' ,''''MRG_FINALAMOUNT'''',''''RMS_CL_RATE'''',''''RMS_HAIRCUT'''',''''RMS_AMOUNT'''',''''RMS_FINALAMOUNT'''' ,''''CASH_NCASH'''',''''PERCENTAGECASH'''',''''PERECNTAGENONCASH'''',''''MRG_CASH'''',''''MRG_NONCASH'''' ,''''RMS_CASH'''',''''RMS_NONCASH'''',''''MRG_EFFECTIVECOLL'''',''''RMS_EFFECTIVECOLL'''',''''MARGIN_CALL'''',''''LEDGER_AMT'''',''''RELEASE_QTY'''' ,''''RELEASE_AMT'''',''''RECORD_TYPE'''',''''effdate'''',''''createdon'''',''''EXCHANGE_ORG'''',''''SEGMENT_ORG'''''  --Column Name   
 SET @S4 = @S4 + ' UNION ALL SELECT    cast([EXCHANGE] as varchar), cast([SEGMENT] as varchar),cast([PARTY_CODE] as varchar), cast([COLL_TYPE] as varchar), cast([SCRIP_CD] as varchar),cast([SERIES] as varchar) ,cast([ISIN] as varchar),cast([QTY] as varchar) ,cast([FD_TYPE] as varchar),cast([FD_BG_NO] as varchar ),cast([AMOUNT] as varchar),cast([FINALAMOUNT] as varchar),cast([BANK_CODE] as varchar),cast([MRG_CL_RATE] as varchar) ,cast([MRG_AMOUNT] as varchar), cast([MRG_HAIRCUT] as varchar),cast([MRG_VAR_MARGIN] as varchar) ,cast([MRG_FINALAMOUNT] as varchar),cast([RMS_CL_RATE] as varchar) ,cast([RMS_HAIRCUT] as varchar),cast([RMS_AMOUNT] as varchar ),cast([RMS_FINALAMOUNT] as varchar),cast([CASH_NCASH] as varchar),cast([PERCENTAGECASH] as varchar),cast([PERECNTAGENONCASH] as varchar) ,cast([MRG_CASH] as varchar), cast([MRG_NONCASH] as varchar),cast([RMS_CASH] as varchar) ,cast([RMS_NONCASH] as varchar),cast([MRG_EFFECTIVECOLL] as varchar) ,cast([RMS_EFFECTIVECOLL] as varchar),cast([MARGIN_CALL] as varchar ),cast([LEDGER_AMT] as varchar),cast([RELEASE_QTY] as varchar),cast([RELEASE_AMT] as varchar),cast([RECORD_TYPE] as varchar) ,CONVERT (VARCHAR (11),effdate,109) as EFFDATE,CONVERT (VARCHAR (11),createdon,109) as CREATEDON, cast([EXCHANGE_ORG] as varchar),cast([SEGMENT_ORG] as varchar)  FROM [MSAJAG].[dbo].[V2_TBL_COLLATERAL_MARGIN_COMBINE_SSRS_REPORT_2]    " QUERYOUT ' --Convert data type if required    
  
    
 +@FILE4+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''     
--       PRINT  (@S)     
EXEC(@S4)      
end 

  -------------------------COLLATERAL_DATA--------------------
 
  
TRUNCATE TABLE Collateral_SSRS_DATA  
BEGIN  
INSERT INTO Collateral_SSRS_DATA  
  
select * from CollateralDetails where effdate=@DATE  
  
DECLARE @FILE3 VARCHAR(MAX),@PATH3 VARCHAR(MAX) = 'J:\BackOffice\Automation\UPDATION\Margin_Shortfall_Verification\'                       
SET @FILE3 = @PATH3 + 'COLLATERAL_DATA' +'_'+ CONVERT(VARCHAR(11),@DATE , 112) + '.csv' --Folder Name     
DECLARE @S3 VARCHAR(MAX)                              
SET @S3 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT  ''''EffDate'''',''''Exchange'''',''''Segment'''',''''Party_Code'''',''''Scrip_Cd'''',''''Series'''',''''Isin'''',''''Cl_Rate'''',''''Amount'''', ''''Qty'''',''''HairCut'''',''''FinalAmount'''',''''PercentageCash'''',''''PerecntageNonCash'''',''''Receive_Date'''',''''Maturity_Date'''' ,''''Coll_Type'''',''''ClientType'''',''''Remarks'''',''''LoginName'''',''''LoginTime'''' ,''''Cash_Ncash'''',''''Group_Code'''',''''Fd_Bg_No'''',''''Bank_Code'''',''''Fd_Type'''''  --Column Name   
 SET @S3= @S3 + ' UNION ALL SELECT    CONVERT (VARCHAR (11),effdate,109) as EFFDATE, cast([Exchange] as varchar),cast([Segment] as varchar), cast([Party_Code] as varchar),  cast([SCRIP_CD] as varchar),cast([SERIES] as varchar) ,cast([ISIN] as varchar),cast([Cl_Rate] as varchar) ,cast([Amount] as varchar),cast([Qty] as varchar )  ,cast([HairCut] as varchar),cast([FinalAmount] as varchar),cast([PercentageCash] as varchar),cast([PerecntageNonCash] as varchar),CONVERT (VARCHAR (11),Receive_Date,109) as Receive_Date,CONVERT (VARCHAR (11),Maturity_Date,109) as Maturity_Date,cast([Coll_Type] as varchar) ,cast([ClientType] as varchar),cast([Remarks] as varchar) ,cast([LoginName] as varchar),CONVERT (VARCHAR (11),LoginTime,109) as LoginTime,cast([Cash_Ncash] as varchar),cast([Group_Code] as varchar), cast([Fd_Bg_No] as varchar),  cast([Bank_Code] as varchar),cast([Fd_Type] as varchar)   FROM [MSAJAG].[dbo].[Collateral_SSRS_DATA]    " QUERYOUT ' --Convert data type if required    
  
    
 +@file3+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''     
--       PRINT  (@S)     
EXEC(@S3)      
end   
  
  
TRUNCATE TABLE RMS_Holding_SSRS_DATA  
BEGIN  

  --drop table #data
select isin,scrip_cd,series,sett_no,sett_type,party_Code,bs,exchange,qty,clsrate,accno,dpid,clid, flag,aben,apool,nben,npool,approved,scripname,partyname,pool,total,DUMMY1,DUMMY2,  nse_approved,source,upd_date,AdjQty  into #data  from [CSOKYC-6].general.dbo.rms_holding where upd_date>='2021-12-22 00:00:00'   and upd_date<='2021-12-22 23:59:59' and source<>'DP'  
union all  
select isin,scrip_cd,series,sett_no,sett_type,party_Code,bs,exchange,qty,clsrate,accno,dpid,clid, flag,aben,apool,nben,npool,approved,scripname,partyname,pool,total,DUMMY1,DUMMY2,  nse_approved,source,upd_date,AdjQty   from [CSOKYC-6].history.dbo.rms_holding where upd_date>='2021-12-22 00:00:00'   and upd_date<='2021-12-22 23:59:59' and source<>'DP'  
  
  INSERT INTO RMS_Holding_SSRS_DATA  
  select * from #data
  
DECLARE @FILE7 VARCHAR(MAX),@PATH7 VARCHAR(MAX) = '  J:\BackOffice\Automation\UPDATION\Margin_Shortfall_Verification\'                       
SET @FILE7 = @PATH7 + 'RMS_Holding' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name     
DECLARE @S7 VARCHAR(MAX)                              
SET @S7 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''isin'''',''''scrip_cd'''',''''series'''',''''sett_no'''',''''sett_type'''',''''party_Code'''',''''bs'''',''''exchange'''',''''qty'''',''''clsrate'''',''''accno'''',''''dpid'''',''''clid'''',''''flag'''',''''aben'''',''''apool'''',''''nben'''',''''npool'''',''''approved'''',''''scripname'''',''''partyname'''',''''pool'''',''''total'''',''''DUMMY1'''',''''DUMMY2'''',''''nse_approved'''',''''source'''',''''upd_date'''',''''AdjQty'''''  --Column Name   
 SET @S7= @S7 + ' UNION ALL SELECT      cast([isin] as varchar),cast([scrip_cd] as varchar), cast([series] as varchar),  cast([sett_no] as varchar), cast([sett_type] as varchar) ,cast([party_Code] as varchar),cast([bs] as varchar) ,cast([exchange] as varchar),cast([Qty] as varchar )  ,cast([clsrate] as varchar),cast([accno] as varchar),cast([dpid] as varchar),cast([clid] as varchar), cast([flag] as varchar) ,cast([aben] as varchar),cast([apool] as varchar) ,cast([nben] as varchar), cast([npool] as varchar) ,cast([approved] as varchar),cast([scripname] as varchar), cast([partyname] as varchar),  cast([pool] as varchar),cast([total] as varchar) ,cast([DUMMY1] as varchar) ,cast([DUMMY2] as varchar) ,cast([nse_approved] as varchar) ,cast([source] as varchar)  ,CONVERT (VARCHAR (11),upd_date,109) as upd_date ,cast([AdjQty] as varchar)   FROM [MSAJAG].[dbo].[RMS_Holding_SSRS_DATA]    " QUERYOUT ' --Convert data type if required    
  
    
 +@FILE7+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''     
--       PRINT  (@S)     
EXEC(@S7)      
end 
  
END

GO
