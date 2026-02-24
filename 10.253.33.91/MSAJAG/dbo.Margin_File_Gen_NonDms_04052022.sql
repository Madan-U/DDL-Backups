-- Object: PROCEDURE dbo.Margin_File_Gen_NonDms_04052022
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create PROC [dbo].[Margin_File_Gen_NonDms_04052022]      
AS      
      
Declare @Mdate datetime,@Cl_code varchar(11)      
      
Set @Mdate ='2021-11-26'      
Set @Cl_code ='AZ'      
      
      
Create table #temp (mdate datetime,cl_Code varchar(11))      
      
-- INSERT INTO  TABLE THE DATA OF FILES.      
      
CREATE TABLE [DBO].[#DATA]([FILEDATA] [VARCHAR](MAX))      
      
TRUNCATE TABLE [#DATA]
BULK INSERT [dbo].[#DATA] FROM 'J:\Backoffice\EXPORT\DMS_REV.CSV' WITH ( FIRSTROW = 0);      
 
TRUNCATE TABLE #temp      
INSERT INTO #temp SELECT DISTINCT CONVERT(VARCHAR(11), CONVERT(DATE, DBO.PIECE(FILEDATA,',',1), 103), 109), DBO.PIECE(FILEDATA,',',2)  FROM #DATA      
      
      
-- INSERT INTO  TABLE THE DATA OF FILES.      
      
--Insert into #temp values (@mdate,@cl_Code )      
Select * into #Margin_process from Margin_process where 1=2      
      
       
 Create index #t  on #temp (Mdate,cl_code)      
      
      
      
Select * into #tday from TBL_COMBINE_REPORTING_DETAIL_HIST t With(Nolock),#temp s      
where   t.MARGINDATE =s.Mdate and t.PARTY_CODE =s.cl_code       
      
Select * into #tday_peak from TBL_COMBINE_REPORTING_PEAK_DETAIL_HIST t With(Nolock),#temp s      
where t.PARTY_CODE =s.cl_code and t.MARGINDATE =s.Mdate      
      
Insert into #tday      
Select *   from TBL_COMBINE_REPORTING_DETAIL  t,#temp s      
where t.PARTY_CODE =s.cl_code and t.MARGINDATE =s.Mdate      
      
Insert into #tday_peak      
Select * from TBL_COMBINE_REPORTING_PEAK_DETAIL  t,#temp s      
where t.PARTY_CODE =s.cl_code and t.MARGINDATE =s.Mdate      
      
Select ISnull(A.PARTY_CODE,B.PARTY_CODE) as Party ,(case when isnull(Margin,0)> isnull(PMargin,0) Then 'C' Else 'P' ENd) as Flag      
Into #Clientf      
from       
(      
Select Party_code,Sum(Tday_margin+Tday_MTM) as Margin  from #tday Group by Party_code)A      
Full outer Join      
(      
Select Party_code,Sum(Tday_margin+Tday_MTM) as PMargin from #tday_peak Group by Party_code)B      
On a.PARTY_CODE=B.PARTY_CODE      
      
      
Select * into #final from #tday where Party_code in (Select Party from #Clientf Where Flag='C' )      
      
insert into #final      
Select *  from #tday_peak  where Party_code in (Select Party from #Clientf Where Flag='P' )      


      
--SELECT    PARTY_CODE, exchange,      
--SEGMENT,      
--Tday_ledger LED_MARGIN_AMT, (Case when segment ='Capital' Then TDAY_NONCASH Else 0 end) NONCASH_AMT,TDAY_FDBG BGFD_AMT, 0 OTHER_MARGIN, TOTAL_MARGIN_AVL=Tday_ledger+TDAY_NONCASH+TDAY_CASHCOLL,       
--Tday_margin INITIALMARGIN, Tday_MTM EXPOSURE_MARGIN,       
--TOTAL_MARGIN=Tday_margin+Tday_MTM ,EXCESS_SHORTFALL=( Case when T_MARGINAVL>0 Then 0 else T_MARGINAVL end) +      
--( Case when T_MTMAVL>0 Then 0 else T_MARGINAVL  end) , ADD_MARGIN=0 ,MARGIN_STATUS=0,DELIVERY_MARGIN=0,      
--MAR_PLEDGE_AMT=(Case when segment ='Futures' Then TDAY_NONCASH Else 0 end)      
--FROM #final WITH(NOLOCK)        
       
 Select top 0  EXCHANGE ,SEGMENT, PARTY_CODE ,COLL_TYPE ,SCRIP_CD ,SERIES, ISIN, QTY ,FD_TYPE ,FD_BG_NO,      
 AMOUNT ,FINALAMOUNT, BANK_CODE, MRG_CL_RATE, MRG_AMOUNT, MRG_HAIRCUT, MRG_VAR_MARGIN, MRG_FINALAMOUNT, RMS_CL_RATE ,RMS_HAIRCUT       
 ,RMS_AMOUNT ,RMS_FINALAMOUNT, CASH_NCASH, PERCENTAGECASH, PERECNTAGENONCASH, MRG_CASH ,MRG_NONCASH ,RMS_CASH, RMS_NONCASH ,      
 MRG_EFFECTIVECOLL ,RMS_EFFECTIVECOLL ,MARGIN_CALL, LEDGER_AMT, RELEASE_QTY ,RELEASE_AMT, RECORD_TYPE,      
 effdate, createdon, EXCHANGE_ORG ,SEGMENT_ORG into #Scrip from V2_TBL_COLLATERAL_MARGIN_COMBINE       
      
       
 Insert into #Scrip      
 Select  EXCHANGE ,SEGMENT, PARTY_CODE ,COLL_TYPE ,SCRIP_CD ,SERIES, ISIN, QTY ,FD_TYPE ,FD_BG_NO,      
 AMOUNT ,FINALAMOUNT, BANK_CODE, MRG_CL_RATE, MRG_AMOUNT, MRG_HAIRCUT, MRG_VAR_MARGIN, MRG_FINALAMOUNT, RMS_CL_RATE ,RMS_HAIRCUT       
 ,RMS_AMOUNT ,RMS_FINALAMOUNT, CASH_NCASH, PERCENTAGECASH, PERECNTAGENONCASH, MRG_CASH ,MRG_NONCASH ,RMS_CASH, RMS_NONCASH ,      
 MRG_EFFECTIVECOLL ,RMS_EFFECTIVECOLL ,MARGIN_CALL, LEDGER_AMT, RELEASE_QTY ,RELEASE_AMT, RECORD_TYPE,      
 effdate, createdon, EXCHANGE_ORG ,SEGMENT_ORG  from V2_TBL_COLLATERAL_MARGIN_COMBINE_History T,#temp S      
 where T.PARTY_CODE =s.cl_code and T.effdate =Mdate       
      
 insert into #Scrip       
 Select  EXCHANGE ,SEGMENT, PARTY_CODE ,COLL_TYPE ,SCRIP_CD ,SERIES, ISIN, QTY ,FD_TYPE ,FD_BG_NO,      
 AMOUNT ,FINALAMOUNT, BANK_CODE, MRG_CL_RATE, MRG_AMOUNT, MRG_HAIRCUT, MRG_VAR_MARGIN, MRG_FINALAMOUNT, RMS_CL_RATE ,RMS_HAIRCUT       
 ,RMS_AMOUNT ,RMS_FINALAMOUNT, CASH_NCASH, PERCENTAGECASH, PERECNTAGENONCASH, MRG_CASH ,MRG_NONCASH ,RMS_CASH, RMS_NONCASH ,      
 MRG_EFFECTIVECOLL ,RMS_EFFECTIVECOLL ,MARGIN_CALL, LEDGER_AMT, RELEASE_QTY ,RELEASE_AMT, RECORD_TYPE,      
 effdate, createdon, EXCHANGE_ORG ,SEGMENT_ORG from V2_TBL_COLLATERAL_MARGIN_COMBINE  T,#temp S      
 where T.PARTY_CODE =s.cl_code and T.effdate =Mdate       
      
      
      
 Alter table #Scrip      
 Add Scripname varchar(50)      
      
UPDATE #Scrip          
SET  SCRIPNAME = ISNULL(S1.LONG_NAME,#Scrip.SCRIP_CD)                                        
FROM SCRIP1 S1 (NOLOCK),                                                 
SCRIP2 S2 (NOLOCK)                                                
WHERE S1.CO_CODE = S2.CO_CODE                                                
AND S1.SERIES = S2.SERIES                                                
AND #Scrip.SCRIP_CD = S2.SCRIP_CD                                                
AND #Scrip.SERIES = S2.SERIES        
      
INSERT INTO #Margin_process      
SELECT DISTINCT C.PARTY_CODE,'1' AS SNO,C.PARTY_CODE+'|'+'H'+'|'+C.PARTY_CODE+'('+c.branch_cd+'/'+c.sub_broker+')'+'|'+long_name+'|'      
+replace(C.L_ADDRESS1,'|','')+'|'+replace(isnull(C.L_ADDRESS2,''),'|','')+'|'+replace(isnull(C.L_ADDRESS3,''),'|','')+'|'+C.L_CITY+'|'+C.L_STATE+'-'+C.L_ZIP+'|'+'0'+'|'+C.PAN_GIR_NO+'|'+      
CONVERT(VARCHAR(11),Mdate,103) +'|'+c.email +'|'+c.mobile_pager  AS TEXT ,'','','','',''      
--CONVERT(VARCHAR(11),margindate,120) +'|'+'shashi.soni@angelbroking.com' +'|'+'9321501694'  AS TEXT ,'','','','',''      
FROM  anand1.msajag.dbo.CLIENT_DETAILS C (NOLOCK),#temp d      
WHERE   C.PARTY_CODE >='a0' AND C.PARTY_CODE <='zzzzz'  ----or c.PARTY_CODE in ('A120276','A84155'))      
AND D.CL_CODE=C.CL_CODE       
      
/*      
 INSERT INTO Margin_process       
SELECT PARTY_CODE,'2' AS SNO,LTRIM(RTRIM(PARTY_CODE))+'|'+'A'+'|'+DEALING_ADDRESS+'|'+GST_LOCATION+'|'+TGST_NO,'','','','','' FROM #DELAING_ADDRESS       
*/      
      
      
Alter table #final      
alter column Exchange Varchar(25)      
      
update  #final set Exchange = 'BSE-CASH' where SEGMENT ='CAPITAL' and Exchange ='BSE'      
update  #final set Exchange = 'NSE-CASH' where SEGMENT ='CAPITAL' and Exchange ='NSE'      
update  #final set Exchange = 'NSE-F&O' where SEGMENT ='FUTURES' and Exchange ='NSE'      
       
      
INSERT INTO #Margin_process       
SELECT PARTY_CODE,'3' AS SNO,LTRIM(RTRIM(PARTY_CODE))+'|'+'D'+'|'+      
(case when segment ='capital' THEN 'EQUITY' else exchange end)+'|'+      
convert( varchar(20), cast(sum(LED_MARGIN_AMT) as decimal(18,2)))+'|'+convert( varchar(20), cast(sum(NONCASH_AMT) as decimal(18,2)))+'|'+      
convert( varchar(20), cast(sum(BGFD_AMT) as decimal(18,2)))+'|'+convert( varchar(20), cast(sum(OTHER_MARGIN) as decimal(18,2)))+'|'+      
convert( varchar(20), cast(sum(TOTAL_MARGIN_AVL) as decimal(18,2)))+'|'+convert( varchar(20), cast(sum(INITIALMARGIN) as decimal(18,2)))+'|'+      
convert( varchar(20), cast(sum(EXPOSURE_MARGIN) as decimal(18,2)))+'|'+convert( varchar(20), cast(sum(TOTAL_MARGIN) as decimal(18,2)))+'|'+      
convert( varchar(20), cast(sum(EXCESS_SHORTFALL) as decimal(18,2)))+'|'+convert( varchar(20), cast(sum(ADD_MARGIN) as decimal(18,2)))+'|'+      
convert( varchar(20), cast(sum(MARGIN_STATUS) as decimal(18,2)))+'|'+convert( varchar(20), cast(sum(MAR_PLEDGE_AMT) as decimal(18,2)))+'|'+      
convert( varchar(20), cast(sum(DELIVERY_MARGIN) as decimal(18,2)))      
,'','','','',''      
FROM (      
SELECT  dense_rank ()OVER(PARTITION BY PARTY_CODE ORDER BY PARTY_CODE,exchange )AS SRNO, PARTY_CODE,replace(EXCHANGE,'HOLD','HLODING')exchange,      
SEGMENT,      
Tday_ledger LED_MARGIN_AMT, (Case when segment ='Capital' Then TDAY_NONCASH Else 0 end) NONCASH_AMT,       
TDAY_FDBG BGFD_AMT, 0 OTHER_MARGIN, TOTAL_MARGIN_AVL=Tday_ledger+TDAY_NONCASH+TDAY_CASHCOLL,       
Tday_margin INITIALMARGIN, Tday_MTM EXPOSURE_MARGIN,       
TOTAL_MARGIN=Tday_margin+Tday_MTM ,    
--EXCESS_SHORTFALL=( Case when T_MARGINAVL>0 Then 0 else T_MARGINAVL end) +      
--( Case when T_MTMAVL>0 Then 0 else T_MARGINAVL  end), ADD_MARGIN=0 ,MARGIN_STATUS=0,DELIVERY_MARGIN=0,      
EXCESS_SHORTFALL=(Tday_ledger+TDAY_NONCASH+TDAY_CASHCOLL-Tday_margin-Tday_MTM), ADD_MARGIN=0   ,  
MARGIN_STATUS=(Tday_ledger+TDAY_NONCASH+TDAY_CASHCOLL-Tday_margin-Tday_MTM),  
MAR_PLEDGE_AMT=(Case when segment ='Futures' Then TDAY_NONCASH Else 0 end) ,   DELIVERY_MARGIN=0  
FROM #final WITH(NOLOCK)        
      
)a group by PARTY_CODE,(case when segment ='capital' THEN 'EQUITY' else exchange end)      
order by party_CODE,(case when segment ='capital' THEN 'EQUITY' else exchange end)      

      
--delete from Margin_process where sno in (4,5,6)      
INSERT INTO #Margin_process      
SELECT PARTY_CODE,'4' AS SNO,PARTY_CODE+'|'+'F'+'|'+CONVERT(VARCHAR(100),Isin+'-'+scripname) +'|'+      
CONVERT(VARCHAR,series) +'|'+CONVERT(varchar(20),cast(qty as decimal(18,0))) +'|'+      
CONVERT(varchar(20),cast(MRG_CL_RATE as decimal(18,2)))+'|'+CONVERT(varchar(20),cast(AMOUNT as decimal(18,2)))+'|'      
+CONVERT(varchar(20),cast(MRG_VAR_MARGIN as decimal(18,2))) +'|'+CONVERT(varchar(20),cast(MRG_FINALAMOUNT as decimal(18,2)))      
+'|'+(CASE WHEN SEGMENT='CAPITAL' THEN 'CUSA' ELSE 'PLEDGE' END)+'|'+'2sec' ,0,'','','',''      
FROM #Scrip       
order BY  PARTY_CODE      
      
      
INSERT INTO #Margin_process      
SELECT PARTY_CODE,'5' AS SNO,PARTY_CODE+'|'+'F'+'|'+CONVERT(VARCHAR(100),Fd_Bg_No) +'|'+      
+CONVERT(VARCHAR,FInalAMount)+'|'      
+CONVERT(VARCHAR,Maturity_Date) +'|'+exchange+'|'+'2FD' ,0,'','','',''      
FROM CollateralDetails C (NOLOCK), #temp P WHERE  p.mdate=c.effdate and  PARTY_CODE >='a0' AND PARTY_CODE <='zzzz' and Coll_Type ='FD'        
and C.Party_Code=P.cl_Code      
--and UGST <>0      
order BY  PARTY_CODE      
      
INSERT INTO #Margin_process      
SELECT PARTY_CODE,'6' AS SNO,PARTY_CODE+'|'+'F'+'|'+CONVERT(VARCHAR(100),Fd_Bg_No) +'|'+      
+CONVERT(VARCHAR,FInalAMount)+'|'      
+CONVERT(VARCHAR,Maturity_Date) +'|'+exchange +'|'+'2BG',0,'','','',''      
FROM CollateralDetails C, #temp P WHERE  PARTY_CODE >='a00' AND PARTY_CODE <='zzzz'        
and P.mdate=c.effdate  and Coll_Type ='BG'  and C.Party_Code=P.cl_Code --and UGST <>0      
order BY  PARTY_CODE      
      
SELECT B2C_SB INTO #BTWOB FROM [MIS].REMISIOR.DBO.B2C_SB WITH(NOLOCK)      
WHERE ISNULL(B2C_SB,'')  NOT IN ('AMRVT')      
      
update n set  Data_text=data_text+'|'+(case when B2C_SB is null then 'B2B' else 'B2C' end)       
from #Margin_process n,client_Details d  (NOLOCK)    
 left outer join #BTWOB on B2C_SB=sub_broker      
 where n.party_code =d.cl_code and sno=1       
      
  --select * from #Margin_process where rpt_ord ='2FD'       
      
      
--declare @NSEQUERY varchar(max)      
--set @NSEQUERY = ' bcp " select Data_text'      
--set @NSEQUERY = @NSEQUERY + ' from anand1.msajag.dbo.Margin_process order by party_code ,sno,SRNO " queryout J:\Comb_Margin\ContractNote_Margin_'+@Cl_code+'_'+replace(convert(varchar,@mdate,103),'/','')+'.txt -c -t"," -Sangelcommodity -Usa -Psuropt09'  
  
    
--set @NSEQUERY = '''' + @NSEQUERY + ''''      
--set @NSEQUERY = 'EXEC MASTER.DBO.XP_CMDSHELL '+ @NSEQUERY      
--print @NSEQUERY       
--exec (@NSEQUERY)        
      
Select Data_text from #Margin_process order by party_code ,sno,SRNO    
--Select * from #Margin_process order by party_code ,sno,SRNO

GO
