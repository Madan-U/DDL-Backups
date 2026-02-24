-- Object: PROCEDURE dbo.SYNERGY_LEDGER_NXT_V1
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

    
 --- Exec SYNERGY_LEDGER_OPT '2023-04-01','2023-06-22','RG13'  
    
   
  
CREATE   Proc [dbo].[SYNERGY_LEDGER_NXT_V1]    (@fromdate Datetime,@todate datetime,@Partycode varchar(10))    
        
as        
  
--DECLARE @fromdate Datetime,@todate datetime,@Partycode varchar(10)  
  
--Set @fromdate='2023-04-01'  
--SET @todate='2023-06-20'  
--Set @Partycode ='RP61'  
  
Declare @table varchar(50)  
  
Select @table='LEDGER'+convert(varchar(2),FIN_ID) from DMAT.CITRUS_USR.Financial_Yr_Mstr WHERE  FIN_START_DT= @fromdate  
  
Create table #ledger  
(LDG_ID int,  
LDG_DPM_ID int,  
LDG_VOUCHER_TYPE int,  
LDG_BOOK_TYPE_CD varchar(15),  
LDG_VOUCHER_NO int,  
LDG_SR_NO int,  
LDG_REF_NO varchar(25),  
LDG_VOUCHER_DT datetime,  
LDG_ACCOUNT_ID int,  
LDG_ACCOUNT_TYPE char(4),  
LDG_AMOUNT money,  
LDG_NARRATION varchar(100),  
LDG_BANK_ID varchar(15),  
LDG_ACCOUNT_NO varchar(25),  
LDG_INSTRUMENT_NO varchar(30),  
LDG_BANK_CL_DATE datetime,  
LDG_COST_CD_ID int,  
LDG_BILL_BRKUP_ID int,  
LDG_TRANS_TYPE char(4),  
LDG_STATUS char(4),  
LDG_CREATED_BY varchar(15),  
LDG_CREATED_DT datetime,  
LDG_LST_UPD_BY varchar(15),  
LDG_LST_UPD_DT datetime,  
LDG_DELETED_IND smallint,  
LDG_BRANCH_ID int ,DP_ID varchar(20))  
  
  
DECLARE @SQL VARCHAR(8000)  
  
SELECT @SQL =  '  INSErt into #ledger  Select l.*, DPAM_SBA_NO from AGMUBODPL3.DMAT.CITRUS_USR.'+@table+' l WITH(NOLOCK)  Inner Join  AGMUBODPL3.DMAT.CITRUS_USR.dp_acct_mstr  WITH(NOLOCK)on  LDG_ACCOUNT_ID  = dpam_id  AND DPAM_BBO_CODE = ''' + @Partycode+''' '  
EXEC (@SQL)  
  
DECLARE @SQL1 VARCHAR(8000)  
SELECT @SQL1 =  '  INSErt into #ledger  Select l.*, DPAM_SBA_NO from AngelDP5.DMAT.CITRUS_USR.'+@table+' l WITH(NOLOCK)  Inner Join  AngelDP5.DMAT.CITRUS_USR.dp_acct_mstr  WITH(NOLOCK)on  LDG_ACCOUNT_ID  = dpam_id  AND DPAM_BBO_CODE = ''' + @Partycode+''' '  
EXEC (@SQL1)  
  
 select  case when ldg_account_type ='P' then l.DP_ID else ''end LD_CLIENTCD   
  ,LDG_VOUCHER_DT  LD_DT    
 ,convert(numeric(18,4),LDG_AMOUNT  ) LD_AMOUNT   
 ,LDG_NARRATION  LD_PARTICULAR   
,LDG_INSTRUMENT_NO  LD_CHEQUENO     
 ,case when LDG_AMOUNT < 0 then 'D' else 'C' end   LD_DEBITFLAG     
 ,(CASE WHEN LDG_VOUCHER_TYPE =1 THEN 'P'    
 WHEN LDG_VOUCHER_TYPE =2 THEN 'R'       
  WHEN LDG_VOUCHER_TYPE =3 THEN 'J'       
   WHEN LDG_VOUCHER_TYPE =5 THEN 'B' ELSE '' END) LD_DOCUMENTTYPE       
,LDG_VOUCHER_NO  LD_DOCUMENTNO   
,LDG_CREATED_BY  MKRID       
,LDG_LST_UPD_DT  MKRDT       
,YEAR(ldg_voucher_dt) LD_ACCYEAR       
,LEFT(l.DP_ID,8) LD_DPID   INTO #ledger1  
from  #ledger  l WITH(NOLOCK)     
--Inner Join  dp_acct_mstr d  WITH(NOLOCK)on  LDG_ACCOUNT_ID  = dpam_id        
 WHERE LDG_DELETED_IND=1  
  Order by l.DP_ID,LDG_VOUCHER_DT  
    
   
 SELECT [Ledger Date] = a.LD_DT,Particulars = a.LD_PARTICULAR,    
  [DocType] = a.LD_DOCUMENTTYPE,DocumentNo = a.LD_DOCUMENTNO,    
  DEBIT = CONVERT(DECIMAL(18,2),(CASE WHEN a.LD_DEBITFLAG = 'D' THEN ABS(a.LD_AMOUNT) ELSE 0 END)),    
  CREDIT = CONVERT(DECIMAL(18,2),(CASE WHEN a.LD_DEBITFLAG = 'C' THEN a.LD_AMOUNT ELSE 0 END)),    
  BALANCE = CONVERT(DECIMAL(18,2),0)    
 INTO #TEMP1    
 FROM #ledger1 a WITH(NOLOCK)    
 --join (    
 --  SELECT Client_CODE     
 --  FROM INHOUSE.dbo.Vw_Acc_Curr_Bal WITH(NOLOCK)    
 --  WHERE party_code=@Partycode--'A102344'--@Client    
    
 --  ) b    
 --on a.ld_clientcd = b.Client_CODE    
     
 SELECT ROW_NUMBER() OVER(ORDER BY [Ledger Date]) ID,    
  [Ledger Date],Particulars,[DocType],DocumentNo,DEBIT,CREDIT,BALANCE    
 INTO #TEMP    
 FROM #TEMP1    
 order by 2    
     
 DECLARE @Bal DECIMAL(18,2)    
    
 SET @Bal = 0    
    
 UPDATE  #TEMP    
 SET @Bal = BALANCE = @Bal + (CREDIT - DEBIT)    
    
 SELECT [Ledger Date],Particulars,DocType,DocumentNo,DEBIT,CREDIT,BALANCE FROM #TEMP    
 ORDER BY [Ledger Date]

GO
