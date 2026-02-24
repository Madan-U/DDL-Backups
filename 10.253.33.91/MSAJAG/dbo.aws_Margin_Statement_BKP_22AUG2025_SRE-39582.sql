-- Object: PROCEDURE dbo.aws_Margin_Statement_BKP_22AUG2025_SRE-39582
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
--[aws_Margin_Statement] '2020-05-28' --,'2020-04-15'      
      
      
CREATE   proc [dbo].[aws_Margin_Statement_BKP_22AUG2025_SRE-39582] (@dt datetime)      
as      
      
declare @date varchar(30),@sdt varchar(11),@tdt varchar(11)      
      
      
select @date= convert(varchar(11),@dt,103)      
print  @date       
      
select @sdt=replace( convert(varchar(12),@dt,107),',','')       
select @tdt=replace( convert(varchar(12),@dt,107),',','') +' 23:59:59'      
      
---Truncate table aws_margin_details      
      
--insert into aws_margin_details       
--EXEC RPT_DAILYMARGINSTATEMENT_Aws_History '2021-02-10','A000','zzzzzzzzz','','zzzzzzzzzzz','','zzzzzzzzzzz','broker','broker',1,0,'C','ALL'      
EXEC RPT_DAILYMARGINSTATEMENT_Aws @sdt,'A000','zzzzzzzzz','','zzzzzzzzzzz','','zzzzzzzzzzz','broker','broker',1,0,'C','ALL'      
      
       
      
      
truncate table Margin_process      
      
       
      
      
       
        
 INSERT INTO Margin_process      
SELECT DISTINCT C.PARTY_CODE,'1' AS SNO,C.PARTY_CODE+'|'+'H'+'|'+C.PARTY_CODE+'('+c.branch_cd+'/'+c.sub_broker+')'+'|'+long_name+'|'      
+replace(C.L_ADDRESS1,'|','')+'|'+replace(isnull(C.L_ADDRESS2,''),'|','')+'|'+replace(isnull(C.L_ADDRESS3,''),'|','')+'|'+C.L_CITY+'|'+C.L_STATE+'-'+C.L_ZIP+'|'+'0'+'|'+C.PAN_GIR_NO+'|'+      
CONVERT(VARCHAR(11),margindate,120) +'|'+c.email +'|'+c.mobile_pager  AS TEXT ,'','','','',''      
--CONVERT(VARCHAR(11),margindate,120) +'|'+'shashi.soni@angelbroking.com' +'|'+'9321501694'  AS TEXT ,'','','','',''      
FROM aws_margin_details D,msajag.dbo.CLIENT_DETAILS C      
WHERE   C.PARTY_CODE >='a0' AND C.PARTY_CODE <='zzzzz'  ----or c.PARTY_CODE in ('A120276','A84155'))      
AND D.PARTY_CODE=C.CL_CODE       
      
/*      
 INSERT INTO Margin_process       
SELECT PARTY_CODE,'2' AS SNO,LTRIM(RTRIM(PARTY_CODE))+'|'+'A'+'|'+DEALING_ADDRESS+'|'+GST_LOCATION+'|'+TGST_NO,'','','','','' FROM #DELAING_ADDRESS       
*/      
       
         
 INSERT INTO Margin_process       
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
LED_MARGIN_AMT, NONCASH_AMT, BGFD_AMT, OTHER_MARGIN, TOTAL_MARGIN_AVL, INITIALMARGIN ,EXPOSURE_MARGIN,       
TOTAL_MARGIN ,EXCESS_SHORTFALL, ADD_MARGIN ,MARGIN_STATUS,DELIVERY_MARGIN,MAR_PLEDGE_AMT      
FROM aws_margin_details WITH(NOLOCK) WHERE   PARTY_CODE >='a0' AND PARTY_CODE <='zzzzz'   and RPT_ORD ='1DET'      
)a group by PARTY_CODE,(case when segment ='capital' THEN 'EQUITY' else exchange end)      
order by party_CODE,(case when segment ='capital' THEN 'EQUITY' else exchange end)      
      
--delete from Margin_process where sno in (4,5,6)      
INSERT INTO Margin_process      
SELECT PARTY_CODE,'4' AS SNO,PARTY_CODE+'|'+'F'+'|'+CONVERT(VARCHAR(100),Isin+'-'+scripname) +'|'+      
CONVERT(VARCHAR,series) +'|'+CONVERT(varchar(20),cast(qty as decimal(18,0))) +'|'+      
CONVERT(varchar(20),cast(SEC_CLRATE as decimal(18,2)))+'|'+CONVERT(varchar(20),cast(SEC_AMOUNT as decimal(18,2)))+'|'      
+CONVERT(varchar(20),cast(SEC_HAIRCUT as decimal(18,2))) +'|'+CONVERT(varchar(20),cast(SEC_fAMOUNT as decimal(18,2)))      
+'|'+(CASE WHEN SEGMENT='CAPITAL' THEN 'CUSA' ELSE 'PLEDGE' END)+'|'+RPT_ORD ,0,'','','',''      
FROM aws_margin_details WHERE  PARTY_CODE >='a0' AND PARTY_CODE <='zzz'  and  rpt_ord ='2sec' --and UGST <>0      
order BY  PARTY_CODE      
      
INSERT INTO Margin_process      
SELECT PARTY_CODE,'5' AS SNO,PARTY_CODE+'|'+'F'+'|'+CONVERT(VARCHAR(100),FDRNO) +'|'+      
+CONVERT(VARCHAR,FDR_AMOUNT)+'|'      
+CONVERT(VARCHAR,FDR_EXPIRYDATE) +'|'+exchange+'|'+RPT_ORD ,0,'','','',''      
FROM aws_margin_details WHERE  PARTY_CODE >='a0' AND PARTY_CODE <='zzzz'   and  rpt_ord ='2FD' --and UGST <>0      
order BY  PARTY_CODE      
      
INSERT INTO Margin_process      
SELECT PARTY_CODE,'6' AS SNO,PARTY_CODE+'|'+'F'+'|'+CONVERT(VARCHAR(100),BGNO) +'|'+      
+CONVERT(VARCHAR,BG_AMOUNT)+'|'      
+CONVERT(VARCHAR,BG_EXPIRYDATE) +'|'+exchange +'|'+RPT_ORD,0,'','','',''      
FROM aws_margin_details WHERE  PARTY_CODE >='a00' AND PARTY_CODE <='zzzz'and  rpt_ord ='2BG' --and UGST <>0      
order BY  PARTY_CODE      
      
SELECT B2C_SB INTO #BTWOB FROM [MIS].REMISIOR.DBO.B2C_SB WITH(NOLOCK)      
WHERE ISNULL(B2C_SB,'')  NOT IN ('AMRVT')      
      
update n set  Data_text=data_text+'|'+(case when B2C_SB is null then 'B2B' else 'B2C' end)       
from Margin_process n,client_Details d      
 left outer join #BTWOB on B2C_SB=sub_broker      
 where n.party_code =d.cl_code and sno=1       
      
  --select * from aws_margin_details where rpt_ord ='2FD'       
      
 -- ADDED FOR CASH TRADING TDAY HOLIDAY      
 /*
TRUNCATE TABLE AUC_CN       
INSERT INTO AUC_CN SELECT DISTINCT PARTY_CODE FROM ANGELCOMMODITY.MCDX.DBO.FOMARGINNEW WITH (NOLOCK) WHERE MDATE = @dt      
DELETE FROM Margin_process WHERE PARTY_CODE NOT IN (SELECT P FROM AUC_CN)  
*/
 -- ADDED FOR CASH TRADING TDAY HOLIDAY      
      
declare @NSEQUERY varchar(max)      
set @NSEQUERY = ' bcp " select Data_text'      
set @NSEQUERY = @NSEQUERY + ' from AngelNseCM.msajag.dbo.Margin_process  order by party_code ,sno,SRNO " queryout J:\Comb_Margin\ContractNote_Margin_'+replace(convert(varchar,@dt,103),'/','')+'.txt -c -t"," -Sangelcommodity -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'      
set @NSEQUERY = '''' + @NSEQUERY + ''''      
set @NSEQUERY = 'EXEC MASTER.DBO.XP_CMDSHELL '+ @NSEQUERY      
print @NSEQUERY       
exec (@NSEQUERY)

GO
