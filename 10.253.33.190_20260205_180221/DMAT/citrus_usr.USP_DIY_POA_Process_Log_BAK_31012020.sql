-- Object: PROCEDURE citrus_usr.USP_DIY_POA_Process_Log_BAK_31012020
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE Procedure [citrus_usr].[USP_DIY_POA_Process_Log_BAK_31012020]  
(  
@date datetime  
)  
As  
---exec USP_DIY_POA_Process_Log '09/14/2018'  
  
Begin  
  
declare @count int;  
Declare @counter int=1,@totalcount int,@p26 varchar(100), @pa_login_name varchar(50),@pa_slip_no varchar(50),@pa_excm_id varchar(10), 
@STDATE DATETIME,
@pa_values varchar(50),@pa_settlm_no varchar(50),@executionndate datetime,@pa_tr_setm_type varchar(10),@pa_tr_acct_no varchar(20);  
     
    set @executionndate=  convert(varchar(11),getdate(),120)  
    
   SELECT @count= count(*) From DIY_POA_Process_Log d   
   WHERE CONVERT(VARCHAR(11),CREATED_DATE,103) = CONVERT(VARCHAR(11),@date,103) --AND  POA_STATUS_BO =''  AND  BO_VALIDATION ='Y' AND DP_VALID <> ''  
   --print(convert(datetime,@Date))  
   if(@count>0)  
   begin   
   return;  
   end   

   SELECT @STDATE = MAX(START_DATE) FROM [196.1.115.196].MSAJAG.DBO.SETT_MST WITH(NOLOCK) WHERE START_DATE  < CONVERT(VARCHAR(11),@date,120)
   AND SETT_TYPE ='N'

  INSERT INTO DIY_POA_Process_Log  
  SELECT    
  PARTYCODE ClientID,DPID ,SYMBOL,ISIN, Exchange=(CASE WHEN EXCHANGE IN ('1','3') THEN 'NSE'   
                      --WHEN EXCHANGE ='3' THEN 'BSE'  
                      ELSE '' END ) , sum(convert(float, replace(Quantity,',',''))) Quantity,POAStatus AS ONL,  
  CREATED_DATE =convert(varchar(11),date_time_stamp,120)  ,'','','','',@date,'',ROW_NUMBER() over(order by PARTYCODE),'','' ,0 
  FROM  
    [172.31.16.75].Angel_WMS.DBO.po_acceptance_status a  
    WHERE date_time_stamp >= @STDATE +' 16:00:00.000' AND date_time_stamp<= CONVERT(VARCHAR(11),@date,120) +' 23:59'
    --AND CreationDate <=CONVERT(VARCHAR(11),@date,120) +' 23:59' AND   
   AND ACTION ='SELL'   and  isnull(convert(float, replace(Quantity,',','')),0) <>0 
    and  ISNULL(SYMBOL,'') <> '' AND ISNULL( ISIN,'')  <>'' --AND LEN(DPID)=16  
    GROUP BY  PARTYCODE,Exchange,POAStatus,SYMBOL,ISIN,DPID,convert(varchar(11),date_time_stamp,120)  
   
          
   UPDATE D SET DP_ID = Cltdpid FROM DIY_POA_Process_Log D,[196.1.115.197].MSAJAG.DBO.CLIENT4 C  
   WHERE D.Cl_code = C.CL_CODE AND  DEFDP=1 AND Depository ='CDSL'    
   AND CONVERT(VARCHAR(11),CREATED_DATE,103) = CONVERT(VARCHAR(11),@date,103)  
      
  
  UPDATE D SET DP_ID = Cltdpid FROM DIY_POA_Process_Log D,[196.1.115.197].BSEDB.DBO.CLIENT4 C  
  WHERE D.Cl_code = C.CL_CODE AND  DEFDP=1 AND Depository ='CDSL'    
     AND CONVERT(VARCHAR(11),CREATED_DATE,103) = CONVERT(VARCHAR(11),@date,103) AND LEN(ISNULL(DP_ID,''))<16  
   
  UPDATE  D SET POA_STATUS_BO ='1'   FROM  DIY_POA_Process_Log D,TBL_CLIENT_POA P  
   WHERE DP_ID=CLIENT_CODE   
    AND MASTER_POA ='2203320000000014' AND POA_STATUS ='A'  and convert(varchar(11),CREATED_DATE,103) =CONVERT(VARCHAR(11),@date,103)  
      
    SELECT  CL_cODE,EXCHANGE,ISIN,SUM(QTY) QTY INTO #TEMP From DIY_POA_Process_Log WHERE  POA_STATUS_BO ='' AND LEFT(DP_ID,6)='120332'   
    and convert(varchar(11),CREATED_DATE,103) =CONVERT(VARCHAR(11),@date,103)  
         GROUP BY CL_cODE,EXCHANGE,ISIN   
       
       
    SELECT  PARTY_CODE,D.SETT_NO,D.SETT_TYPE,I.ISIN ,QTY,'NSE' EXCHANGE INTO #BOSTOCKO  FROM  [196.1.115.197].MSAJAG.DBO.DELIVERYCLT D ,    
    [196.1.115.197].MSAJAG.DBO.SETT_MST M,[196.1.115.197].MSAJAG.DBO.MULTIISIN I  
    WHERE  CONVERT(VARCHAR(11),START_dATE,103) =CONVERT(VARCHAR(11),@date,103)   
    AND D.SETT_NO=M.SETT_NO AND D.SETT_TYPE =M.SETT_TYPE AND M.SETT_TYPE NOT IN ('A','X')  
    AND INOUT ='I' AND PARTY_CODE IN (SELECT CL_cODE FROM #TEMP) AND D.SCRIP_CD=I.SCRIP_CD AND D.SERIES =I.SERIES   
    AND VALID =1   
    UNION ALL  
    SELECT  PARTY_CODE,D.SETT_NO,D.SETT_TYPE,I.ISIN ,QTY ,'BSE' EXCHANGE  FROM  [196.1.115.197].BSEDB.DBO.DELIVERYCLT D ,  [196.1.115.197].BSEDB.DBO.SETT_MST M,[196.1.115.197].BSEDB.DBO.MULTIISIN I  
    WHERE  CONVERT(VARCHAR(11),START_dATE,103) =CONVERT(VARCHAR(11),@date,103)  
    AND D.SETT_NO=M.SETT_NO AND D.SETT_TYPE =M.SETT_TYPE AND M.SETT_TYPE NOT IN ('Ad','AC')  
    AND INOUT ='I' AND PARTY_CODE IN (SELECT CL_cODE FROM #TEMP) AND D.SCRIP_CD=I.SCRIP_CD AND D.SERIES =I.SERIES   
    AND VALID =1   
       
      UPDATE DIY_POA_Process_Log  SET BO_VALIDATION ='Y' ,VALID_QTY =B.QTY,BO_VALID_COMPLETION_DT=@date,SETT_NO =B.SETT_NO,SETT_TYPE =B.SETT_TYPE   
    FROM  #BOSTOCKO B ,(SELECT  CL_cODE,EXCHANGE,ISIN,SUM(QTY) QTY   From DIY_POA_Process_Log WHERE  POA_STATUS_BO ='' AND LEFT(DP_ID,6)='120332'   
    and  convert(varchar(11),CREATED_DATE,103) =CONVERT(VARCHAR(11),@date,103)  
    GROUP BY CL_cODE,EXCHANGE,ISIN) D    
    WHERE PARTY_CODE =D.CL_cODE   
    --AND B.EXCHANGE = D.EXCHANGE 
	AND B.ISIN=D.ISIN   
    AND DIY_POA_Process_Log.CL_CODE =B.PARTY_CODE --AND DIY_POA_Process_Log.EXCHANGE =B.EXCHANGE   
    AND DIY_POA_Process_Log.ISIN =B.ISIN  and  convert(varchar(11),CREATED_DATE,103) =CONVERT(VARCHAR(11),@date,103)  
        
   
   UPDATE D   
   SET   
   DP_VALID =HLD_AC_POS  
   FROM  
    DIY_POA_Process_Log d ,HoldingData h  
   WHERE POA_STATUS_BO =''AND BO_VALIDATION ='Y'  
   and DP_ID =HLD_AC_CODE  AND  convert(varchar(11),CREATED_DATE,103) =CONVERT(VARCHAR(11),@date,103)  
   AND ISIN =HLD_ISIN_CODE   
  
   --SELECT * FROM #BOSTOCKO  
  
   --SELECT  *  FROM  
   -- DIY_POA_Process_Log d   
   --WHERE CREATED_DATE =CONVERT(VARCHAR(11),@date-1,120) AND  POA_STATUS_BO =''  AND  BO_VALIDATION ='Y' AND DP_VALID <> ''  
   --AND SETT_NO <> '2018155'  
    
  
 Select DP_ID pa_login_name,(select srNo from tbl_ProcessSRNo) pa_slip_no,(Case when EXCHANGE='BSE' then 4 When EXCHANGE='NSE' then '3' End)  As pa_excm_id,  
 (Case when SETT_TYPE='N' then 11  
       When SETT_TYPE='W' then 13
    when SETT_TYPE IN ('D','C') then 1  
      End) AS pa_tr_setm_type,  
 'A|*~|'+ISIN+'|*~|'+convert(varchar(10),(case when CONVERT(float,DP_VALID)>=CONVERT(float,VALID_QTY) then VALID_QTY else CONVERT(float,DP_VALID) end))+'|*~|*|~*' pa_values,  
(Case when EXCHANGE='BSE' then cast(RIGHT(LEFT(SETT_NO,4),2) AS VARCHAR(2))+CAST((RIGHT(LEFT(SETT_NO,4),2))+1  AS VARCHAR(2))+cast(right(SETT_NO,3) as varchar(3)) else SETT_NO End) pa_settlm_no,  
(Case when EXCHANGE='BSE' then '1203320000006579' When EXCHANGE='NSE' then '1203320006951435' End) As pa_tr_acct_no  
  Into #FinalTable   
 From DIY_POA_Process_Log  
 where convert(varchar(11),CREATED_DATE,103) =CONVERT(VARCHAR(11),@date,103) AND  POA_STATUS_BO =''  AND  BO_VALIDATION ='Y' AND DP_VALID <> ''  
---- AND SETT_TYPE ='W'
   
 Alter table #FinalTable Add ID int Identity(1,1) primary key   

 CREATE INDEX #F ON #FinalTable (ID)

  
 Select @totalcount= count(*) from #FinalTable  
  
 While(@counter<=@totalcount)  
  
 Begin  
 select  @pa_login_name= pa_login_name,@pa_slip_no='E'+convert(varchar(100),(pa_slip_no+@counter)),@pa_excm_id=pa_excm_id,@pa_values=pa_values,  
 @pa_settlm_no=pa_settlm_no,@pa_tr_setm_type=pa_tr_setm_type,@pa_tr_acct_no=pa_tr_acct_no from #FinalTable where ID=@counter  
  
--set @p26='INE008A01015|*~|IDBI-EQ (E|*~|87181|*~|1450.000|*~|*|~*'   
exec pr_ins_upd_trx_cdsl_sp_EBulk @pa_id='0',@pa_tab='BOCM',@pa_action='INS',@pa_login_name=@pa_login_name,  
@pa_dpm_dpid='12033200',@pa_dpam_acct_no=@pa_login_name,@pa_slip_no=@pa_slip_no,@pa_mkt_type=@pa_tr_setm_type,  
@pa_settlm_no=@pa_settlm_no,@pa_req_dt=@executionndate,@pa_cm_id='0',@pa_excm_id=@pa_excm_id,@pa_cash_trf='NA',@pa_exe_dt=@executionndate,  
@pa_tr_cmbpid='',@pa_tr_dp_id='12033200',@pa_tr_setm_type=@pa_tr_setm_type,@pa_tr_setm_no=@pa_settlm_no,@pa_tr_acct_no=@pa_tr_acct_no,@pa_values=@pa_values,  
@pa_rmks='',@pa_trdReasoncd=0,@pa_Paymode=null,@pa_Bankacno=null,@pa_Bankacname=null,@pa_Bankbrname=null,@pa_Transfereename=null,@pa_DOI =null,  
@pa_ChqRefno=null,@pa_chk_yn=1,@RowDelimiter='*|~*',@ColDelimiter='|*~|',@PA_ERRMSG=@p26 output  
  
--select @p26  
  
update DIY_POA_Process_Log set DP_PROCESS_DT=@date where SRNO=(select srno from #FinalTable where ID=@counter)  and  SETT_NO =@pa_settlm_no
set @counter=@counter+1  
  
End  
update tbl_ProcessSRNo set SRNO = SRNO+(select count(*) from #FinalTable)  

DECLARE @DP_CNT INT ,@DP_CNT1 INT
Select @DP_CNT=COUNT(1)
 From DIY_POA_Process_Log  
 where convert(varchar(11),CREATED_DATE,103) =CONVERT(VARCHAR(11),@date,103) AND  POA_STATUS_BO =''  AND  BO_VALIDATION ='Y' AND DP_VALID <> ''  

 Select @DP_CNT1=COUNT(1)
 From DIY_POA_Process_Log  
 where convert(varchar(11),CREATED_DATE,103) =CONVERT(VARCHAR(11),@date,103) AND  POA_STATUS_BO =''  AND  BO_VALIDATION ='Y'  

select 'Process completed sucessfully. Total records :' + CONVERT(VARCHAR(10),@DP_CNT1) + ' Process records :'
 + CONVERT(VARCHAR(10),@DP_CNT)
 As MSG  
  
End

GO
