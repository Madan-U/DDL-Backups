-- Object: PROCEDURE dbo.Enhance_Report_Sebi
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

 --exec Enhance_Report_Sebi '2018-04-01','2018-04-01','72.5','0','MCD'
 
CREATE Proc [dbo].[Enhance_Report_Sebi]  
 ( @fromdate varchar(11),@todate varchar(11),@AMOUNT varchar(11) ,@r_type varchar(1),@Exchange varchar(11) )  
 as  
   
-- declare   @fromdate varchar(11)='2018-04-01',@todate varchar(11)='2018-04-01',@percentage varchar(11)='72.5' ,@r_type varchar(1)='0',@Exchange varchar(11)='NCX'
   
   DECLARE   @FILENAME_1      AS VARCHAR(100)  ,  @s1 VARCHAR(MAX) = ''    

 IF @r_type = 1  
  BEGIN   
  
    SELECT @fromdate=sdtcur FROM  parameter WHERE  @fromdate BETWEEN sdtcur AND ldtcur   
          
   select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
   into #nsecm            
   from ledger where vdt >=@fromdate           
   and vdt<=@todate + ' 23:59' --AND ISNULL(ENTEREDBY,'') <> 'MTF PROCESS'  
    group by cltcode      
         
   select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
   into #bsecm            
   from AngelBSECM.account_ab.dbo.ledger where vdt >=@fromdate           
   and vdt<=@todate + ' 23:59' --AND ISNULL(ENTEREDBY,'') <>'MTF PROCESS'  
   group by cltcode    
           
   select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
   into #nsefo            
   from angelfo.accountfo.dbo.ledger where vdt >=@fromdate           
   and vdt<=@todate + ' 23:59' --AND ISNULL(ENTEREDBY,'') <>'MTF PROCESS'  
   group by cltcode        
       
   select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
   into #nsx            
   from angelfo.accountcurfo.dbo.ledger where vdt >=@fromdate           
   and vdt<=@todate + ' 23:59' --AND ISNULL(ENTEREDBY,'') <>'MTF PROCESS'  
   group by cltcode      
         
   select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
   into #mcd            
   from angelcommodity.accountmcdxcds.dbo.ledger where vdt >=@fromdate           
   and vdt<=@todate + ' 23:59' --AND ISNULL(ENTEREDBY,'') <>' MTF PROCESS'  
   group by cltcode            
   
   select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
   into #mtf            
   from MTFTRADE.dbo.ledger where vdt >=@fromdate           
   and vdt<=@todate + ' 23:59' --AND ISNULL(ENTEREDBY,'') <>' MTF PROCESS'  
   group by cltcode    
  
    select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
   into #bsx            
   from  angelcommodity.accountcurbfo.dbo.ledger where vdt >=@fromdate           
   and vdt<=@todate + ' 23:59' --AND ISNULL(ENTEREDBY,'') <>' MTF PROCESS'  
   group by cltcode    
  
   
    select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
   into #mcx          
   from  angelcommodity.accountmcdx.dbo.ledger where vdt >=@fromdate           
   and vdt<=@todate + ' 23:59' --AND ISNULL(ENTEREDBY,'') <>' MTF PROCESS'  
   group by cltcode    
  
    select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
   into #ncx  
   from  angelcommodity.accountncdx.dbo.ledger where vdt >=@fromdate           
   and vdt<=@todate + ' 23:59' --AND ISNULL(ENTEREDBY,'') <>' MTF PROCESS'  
   group by cltcode    
  
   
  
            
             
    select * into #ab from (            
    select * from #nsecm            
    union all            
    select * from #bsecm            
    union all            
    select * from #nsefo            
    union all            
    select * from #nsx            
    union all            
    select * from #mcd  
    union all            
    select * from #mtf  
    union all            
    select * from #bsx  
    union all            
    select * from #mcx  
    union all            
    select * from #ncx  
    )x    
  
  UPDATE  #ab SET CLTCODE =PARENTCODE FROM MSAJAG.DBO.CLIENT_DETAILS C        
  WHERE  CLTCODE LIKE '98%' AND CLTCODE=CL_cODE  
  
  SELECT CLTCODE ,SUM(NETAMT) NET_AMT INTO #NSECOMBINED FROM #ab GROUP BY CLTCODE   
  
  
  UPDATE  #bsecm SET CLTCODE =PARENTCODE FROM MSAJAG.DBO.CLIENT_DETAILS C        
  WHERE  CLTCODE LIKE '98%' AND CLTCODE=CL_cODE  
  
  SELECT CLTCODE,SUM(NETAMT) NET_AMT INTO #BSEFINAL FROM #bsecm WHERE CLTCODE >='A00' AND CLTCODE <='ZZZZZ' GROUP BY CLTCODE   
  
  
  SELECT CLTCODE,SUM(NETAMT) NET_AMT INTO #BSXFINAL FROM #bsx WHERE CLTCODE >='A00' AND CLTCODE <='ZZZZZ' GROUP BY CLTCODE    
  SELECT CLTCODE,SUM(NETAMT) NET_AMT INTO #MTFFINAL FROM #MTF WHERE CLTCODE >='A00' AND CLTCODE <='ZZZZZ' GROUP BY CLTCODE   
  SELECT CLTCODE,SUM(NETAMT) NET_AMT INTO #mcxFINAL FROM #mcx WHERE CLTCODE >='A00' AND CLTCODE <='ZZZZZ' GROUP BY CLTCODE    
  SELECT CLTCODE,SUM(NETAMT) NET_AMT INTO #ncxFINAL FROM #ncx WHERE CLTCODE >='A00' AND CLTCODE <='ZZZZZ' GROUP BY CLTCODE   
  
  
  
   SELECT * INTO #NSECOMBINED_FINAL FROM #NSECOMBINED WHERE CLTCODE >='A00' AND CLTCODE <='ZZZZZ'  
  
   ALTER  TABLE #NSECOMBINED_FINAL  
   ADD NSEBALANCE NUMERIC(18,2)  
  
     select CLTCODE,SUM(NETAMT) VAMT into #NSECOMB from (            
    select * from #nsecm            
    union all            
    select * from #nsefo            
    union all            
    select * from #nsx   )A  GROUP BY CLTCODE  
  
    UPDATE F SET  NSEBALANCE = VAMT FROM  #NSECOMBINED_FINAL F,#NSECOMB N WHERE  F.CLTCODE >='A00' AND F.CLTCODE <='ZZZZZ'  
    AND F.CLTCODE =N.CLTCODE   
   
    UPDATE #NSECOMBINED_FINAL SET NSEBALANCE =0.00 WHERE NSEBALANCE IS NULL  
    ------------------  
  
  
    --select * from #NSECOMBINED_FINAL where cltcode ='A112478'  
  
    -------------- Holding   
  

    DECLARE @HLDDATE DATETIME

	 SELECT    @HLDDATE=MAX(UPD_DATE)
    FROM [CSOKYC-6].HISTORY.DBO.RMS_HOLDING WHERE   UPD_DATE <=@todate + ' 23:59' AND SOURCE ='H' GROUP BY PARTY_CODE,ISIN  


    SELECT  PARTY_CODE,ISIN,SUM(QTY) QTY INTO #HOLDING  
    FROM [CSOKYC-6].HISTORY.DBO.RMS_HOLDING WHERE UPD_DATE =@HLDDATE AND SOURCE ='H' GROUP BY PARTY_CODE,ISIN  
  
    SELECT PARTY_CODE,COUNT(ISIN) ISIN_COUNT,SUM(QTY) QTY_COUNT INTO #HOLDCOUNT FROM #HOLDING  GROUP BY PARTY_CODE  
  
    ---------------- Pledge   
    
        DECLARE @PLDDATE DATETIME ,@percentage VARCHAR(11)  
  
  SELECT @PLDDATE = CONVERT(VARCHAR(11),MIN(RMS_DATE),120) FROM [CSOKYC-6].Pledge.dbo.Tbl_party_pledge_data_log WITH(NOLOCK)   
  WHERE RMS_DATE > @todate  
    
  SELECT   * into #tempdw FROM [CSOKYC-6].Pledge.dbo.Tbl_party_pledge_data_log WITH(NOLOCK)  
  WHERE RMS_DATE >=@todate AND RMS_DATE <=@todate + ' 23:59'  

  SELECT @percentage=(@AMOUNT/(sum(Pledge_qty*AVG_CLOSING)/2))*100 FROM #tempdw  



  
  select /* ROW_NUMBER() OVER(ORDER BY A.processdate ASC) SRNO ,*/A.processdate,party_code,isin,    
  qty,pledge_qty,avg_closing,pledge_value,   
  Borrowing=   convert(decimal(18,2), ((pledge_value/2) * isnull(@percentage,0 ))/100)  INTO #PLEDGE   
  from             
  (select processdate,party_code,isin,sum(PLEDGEABLE_QTY) as qty ,sum(Pledge_qty)pledge_qty ,AVG_CLOSING,sum(Pledge_qty*AVG_CLOSING)  as pledge_value   
  from   
   #tempdw  A with(nolock)    
   ---where processdate > = '2018-02-01'  and processdate <= '2018-02-01' + ' 23:59' --AND PARTY_cODE ='JOD17256'  
   group by processdate,party_code,isin,avg_closing   
    ) A           
  
   
    
  SELECT PARTY_CODE,SUM(PLEDGE_QTY) AS PLD_QTY,SUM(PLEDGE_VALUE) AS PLD_VALUE,sum(Borrowing) Borrowing,COUNT(ISIN) ISIN_COUNT  
   INTO #PLD_FINAL   
   FROM #PLEDGE WHERE PLEDGE_QTY <>0 GROUP BY PARTY_CODE   
  
  --SELECT sum(Pledge_qty*AVG_CLOSING) FROM #tempdw  
    
    -------- DROP TABLE #PLD_FINAL  
     ALTER TABLE #NSECOMBINED_FINAL  
   ADD TOTAL_ISIN VARCHAR(25), TOTA_QTY_SEC NUMERIC(18,2),PLEDGE_QTY NUMERIC(18,2),PLDGE_AMOUNT NUMERIC(18,2),SEBI_PAYOUT DATETIME  
  ALTER TABLE #NSECOMBINED_FINAL ADD BSE_BALANCE NUMERIC(18,2),MCD NUMERIC(18,2),BSX NUMERIC(18,2),MTF NUMERIC(18,2),BARROWING  NUMERIC(18,2) ,  
    MCX_BALANCE NUMERIC(18,2),NCX NUMERIC(18,2)  
  
  ALTER TABLE #NSECOMBINED_FINAL ADD PLD_ISIN VARCHAR(25)  
  
  UPDATE  #NSECOMBINED_FINAL SET PLEDGE_QTY=0,PLDGE_AMOUNT =0,PLD_ISIN=0,BARROWING=0  
  
  --SELECT * FROM #PLD_FINAL  
  
   
 
    ---------------- sebi Payout  
    SELECT  PARTY_CODE,MAX(SCCS_SETTDATE_LAST) AS SEBI_DT INTO #SEBIPAYOUT FROM MIS.SCCS.DBO.SCCS_CLIENTMASTER  WHERE SCCS_SETTDATE_LAST <=@todate + ' 23:59'  
    AND PARTY_CODE >='A' AND PARTY_CODE <='ZZZZZ999' AND EXCLUDE ='N' GROUP BY PARTY_CODE  
  
    INSERT INTO #SEBIPAYOUT  
     SELECT  PARTY_CODE,MAX(SCCS_SETTDATE_LAST) FROM MIS.SCCS.DBO.SCCS_CLIENTMASTER_HIST WHERE SCCS_SETTDATE_LAST <=@todate + ' 23:59'  
    AND PARTY_CODE >='A00' AND PARTY_CODE <='ZZZZZ' AND EXCLUDE ='N' GROUP BY PARTY_CODE  
  
    SELECT PARTY_CODE, MAX(SEBI_DT)AS SEBI_DT INTO #SEBI_FINAL FROM #SEBIPAYOUT GROUP BY PARTY_CODE  
  
    -------------- Final Report  
   
   
   UPDATE #NSECOMBINED_FINAL SET TOTAL_ISIN= ISIN_COUNT,TOTA_QTY_SEC = QTY_COUNT FROM #HOLDCOUNT  WHERE #NSECOMBINED_FINAL.CLTCODE=#HOLDCOUNT.PARTY_CODE   
  
   UPDATE #NSECOMBINED_FINAL SET PLEDGE_QTY= PLD_QTY,PLDGE_AMOUNT = PLD_VALUE FROM #PLD_FINAL  WHERE #NSECOMBINED_FINAL.CLTCODE=#PLD_FINAL.PARTY_CODE   
   UPDATE #NSECOMBINED_FINAL SET BARROWING=#PLD_FINAL.Borrowing,PLD_ISIN =ISIN_COUNT  FROM #PLD_FINAL  WHERE #NSECOMBINED_FINAL.CLTCODE=#PLD_FINAL.PARTY_CODE   
  
   UPDATE #NSECOMBINED_FINAL SET SEBI_PAYOUT= SEBI_DT  FROM #SEBI_FINAL  WHERE #NSECOMBINED_FINAL.CLTCODE=#SEBI_FINAL.PARTY_CODE   
    
   UPDATE #NSECOMBINED_FINAL SET TOTAL_ISIN =0,TOTA_QTY_SEC=0 WHERE TOTAL_ISIN IS NULL  
   UPDATE #NSECOMBINED_FINAL SET PLEDGE_QTY =0,PLDGE_AMOUNT=0 WHERE PLEDGE_QTY IS NULL  
   UPDATE #NSECOMBINED_FINAL SET BARROWING =0 WHERE BARROWING IS NULL  
  
   UPDATE #NSECOMBINED_FINAL SET BSE_BALANCE =0  WHERE BSE_BALANCE IS NULL  
   UPDATE #NSECOMBINED_FINAL SET MCD =0 WHERE MCD IS NULL  
   UPDATE #NSECOMBINED_FINAL SET BSX =0 WHERE BSX IS NULL  
   UPDATE #NSECOMBINED_FINAL SET MTF =0 WHERE MTF IS NULL  
    UPDATE #NSECOMBINED_FINAL SET MCX_BALANCE =0 WHERE MCX_BALANCE IS NULL  
   UPDATE #NSECOMBINED_FINAL SET NCX =0 WHERE NCX IS NULL  
  
   UPDATE #NSECOMBINED_FINAL SET SEBI_PAYOUT = ''  WHERE SEBI_PAYOUT IS NULL  
  
  -------to check MTF and BSX------RAHUL SHAH--------  
  
  
   UPDATE  #NSECOMBINED_FINAL SET BSE_BALANCE = #BSEFINAL.NET_AMT FROM #BSEFINAL WHERE #NSECOMBINED_FINAL.CLTCODE=#BSEFINAL.CLTCODE   
  
   UPDATE  #NSECOMBINED_FINAL SET MCD  = #mcd.NETAMT FROM #mcd WHERE #NSECOMBINED_FINAL.CLTCODE=#mcd.CLTCODE   
  
   ---------Rahul-------  
   UPDATE  #NSECOMBINED_FINAL SET BSX = #BSxFINAL.NET_AMT FROM #BSxFINAL WHERE #NSECOMBINED_FINAL.CLTCODE=#BSxFINAL.CLTCODE   
  
   UPDATE  #NSECOMBINED_FINAL SET MTF  = #MTF.NETAMT FROM #mtf WHERE #NSECOMBINED_FINAL.CLTCODE=#mtf.CLTCODE   
  
    UPDATE  #NSECOMBINED_FINAL SET MCX_BALANCE = #MCXFINAL.NET_AMT FROM #MCXFINAL WHERE #NSECOMBINED_FINAL.CLTCODE=#MCXFINAL.CLTCODE   
  
   UPDATE  #NSECOMBINED_FINAL SET NCX  = #NCXFINAL.NET_AMT FROM #NCXFINAL WHERE #NSECOMBINED_FINAL.CLTCODE=#NCXFINAL.CLTCODE   
  
  
   --UPDATE #NSECOMBINED_FINAL SET NET_AMT=NET_AMT*-1,NSEBALANCE=NSEBALANCE*-1,BSE_BALANCE=BSE_BALANCE*-1,MCD=MCD*-1,BSX=BSX*-1,MTF=MTF*-1  
  
  
  
   DROP TABLE NSE_DATA_FINAL  
   drop table PLDRPT  
   DROP TABLE HOLDING  
  
    
   SELECT *  INTO HOLDING FROM #HOLDING  
  
   SELECT * INTO NSE_DATA_FINAL FROM #NSECOMBINED_FINAL WHERE CLTCODE >='a' AND CLTCODE <='ZZZZZZZZZZ'  
  
     SELECT PARTY_CODE,ISIN,SUM(pledge_qty)QTY,SUM(pledge_value)pledge_value,SUM(Borrowing) Borrowing INTO PLDRPT FROM #PLEDGE   
    GROUP BY PARTY_CODE,ISIN  
  
   Truncate table tbl_Enhance_report1
   Insert Into tbl_Enhance_report1 values ('PARTY_CODE','PLD_QTY','PLD_VALUE','Borrowing','ISIN_COUNT','','','','','','','','','','')
   Insert into tbl_Enhance_report1 (CLTCODE,PLEDGE_QTY,NET_AMT,BArrowing,PLD_isin)
   select PARTY_CODE,PLD_QTY,PLD_VALUE,BArrowing,ISIN_COUNT from #PLD_FINAL   
     
       SET @FILENAME_1 ='Enhance_Report_Process_' + replace(convert(varchar(8), Getdate(), 112)+convert(varchar(8),Getdate(), 114), ':','')  + '.csv'          
      -- SET @FILENAME_1 ='Enhance_Report_11042018.xls'          
                             
  
       SET @s1 = 'exec [intranet].MASTER.dbo.xp_cmdshell ' + ''''                                                   
     
       SET @s1 = @s1 + 'bcp "select * from anand1.account.dbo.tbl_Enhance_report1 " queryout \\INHOUSELIVEAPP2-FS.angelone.in\D$\upload1\NRMS\MarginFile\'+@FILENAME_1+' -c -t, -SABVSNCMS.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                     
             
       SET @s1 = @s1 + ''''                                                          
    
       EXEC(@s1)     
  
      SELECT   @FILENAME_1 As 'MSG'
    print(@FILENAME_1)

  END   
    
  IF @r_type = 0  
  BEGIN   
     
   IF @EXCHANGE ='NSE'  
  
    BEGIN   
   SELECT DISTINCT CLTCODE INTO #NSETRAA  FROM (  
   SELECT * FROM  LEDGER WHERE VDT >=@fromdate AND VDT <=@todate + ' 23:59' AND VTYP =15   
   UNION ALL  
   SELECT * FROM ANGELFO.ACCOUNTFO.DBO.LEDGER WHERE VDT >=@fromdate AND VDT <=@todate + ' 23:59' AND VTYP =15   
   UNION ALL  
   SELECT * FROM  ANGELFO.ACCOUNTCURFO.DBO.LEDGER WHERE VDT  >=@fromdate AND VDT <=@todate + ' 23:59' AND VTYP =15 )A ,  
   MSAJAG.DBO.CLIENT_BROK_DETAILS B WHERE CLTCODE =CL_CODE   
   AND EXCHANGE IN ('NSE','NSX')  AND ISNULL(DEACTIVE_VALUE,'')NOT IN ('C','T')  
  
   SELECT DISTINCT CL_CODE INTO #NEWCL  FROM  MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE ACTIVE_DATE >=@fromdate AND ACTIVE_DATE <=@todate + ' 23:59'  
   AND EXCHANGE IN ('NSE','NSX')  AND ISNULL(DEACTIVE_VALUE,'')NOT IN ('C','T')  
    
   SELECT LONG_NAME,CLTCODE,  
   pan_gir_no=(case WHEN ISNULL(pan_gir_no,'') ='' THEN  'NNNNN1111N' ELSE pan_gir_no END  ),  
   mobile_pager =(case WHEN LEN(ISNULL(mobile_pager,''))<>10  THEN  '6666666666' ELSE mobile_pager END  ),  
   email =(case WHEN ISNULL(email,'') ='' THEN 'notprovided@notprovided.com'  ELSE email END  ) ,NSEBALANCE,NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,pld_isin,PLEDGE_QTY,  
   REPLACE(CONVERT(NVARCHAR,SEBI_PAYOUT, 106), ' ', '-')  Sebi_payout  ,BARROWING  into #t  
   FROM MSAJAG.DBO.CLIENT_DETAILS D,  
   NSE_DATA_FINAL F     
   WHERE F.CLTCODE=D.CL_CODE and  
    F.CLTCODE IN (SELECT CL_CODE FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE EXCHANGE ='NSE' AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T')   
    AND Active_Date <=@todate + ' 23:59' AND ISNULL(DEACTIVE_REMARKS,'') NOT LIKE '%MTF%' )  
  
     
    
    SELECT * INTO #NSEFIN FROM (  
  
    select * from #t where NSEBALANCE <>0 OR NET_AMT<> 0 OR TOTAL_ISIN <> 0 OR PLEDGE_QTY <> 0   
    UNION ALL  
  
    select * from #t where NSEBALANCE =0 AND NET_AMT=0 AND TOTAL_ISIN =0 AND PLEDGE_QTY =0   
    AND CLTCODE IN ( SELECT * FROM #NEWCL  
   UNION  
   SELECT * FROM #NSETRAA) )A  
   ORDER BY CLTCODE  
   
   
   
   UPDATE #NSEFIN SET pan_gir_no ='NNNNN1111N' WHERE pan_gir_no ='NNNNNN1111N'  
   
   SELECT    upper(LONG_NAME)LONG_NAME,upper(CLTCODE)CLTCODE,upper(pan_gir_no)pan_gir_no,mobile_pager,LOWER(email)email,ROUND(NSEBALANCE,2)NSEBALANCE,  
   ROUND(NET_AMT,2)NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_ISIN,PLEDGE_QTY,Sebi_payout, BARROWING BARROWING   INTO #F  
   FROM  #NSEFIN t,  
    (SELECT CL_CODE,MIN(ACTIVE_DATE) ASD FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS  
     WHERE EXCHANGE IN ('NSE','NSX') AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T') AND Active_Date <=@todate + ' 23:59' GROUP BY CL_CODE ) R  
   WHERE T.CLTCODE =R.CL_CODE   
    AND pan_gir_no not Like '%.%' and pan_gir_no not Like '%,%' and pan_gir_no  not Like '%-%' and pan_gir_no not Like '%/%' and len(pan_gir_no) = 10    
   and pan_gir_no not like '%\%'  
   AND LONG_NAME NOT LIKE '%VANDHA%'  
  
  delete FROM   #F  WHERE pan_gir_no  Like '%.%' or pan_gir_no  Like '%,%' or pan_gir_no   Like '%-%' or pan_gir_no  Like '%/%' or len(pan_gir_no) <> 10    
   or pan_gir_no  Like '%\%'   
          
         --SELECT * FROM #F    
  
   --SELECT  H.*,ISNULL(P.QTY,0)pledge_qty,ISNULL(pledge_value,0)pledge_value,ISNULL(Borrowing,0)Borrowing FROM HOLDING H   
   --LEFT OUTER JOIN   
   --PLDRPT P ON RTRIM(LTRIM(H.PARTY_CODE)) =RTRIM(LTRIM(P.PARTY_CODE))  AND RTRIM(LTRIM(H.ISIN))=RTRIM(LTRIM(P.ISIN))   
   --WHERE H.PARTY_CODE IN (  
   --SELECT CLTCODE  FROM #F)
    Truncate table tbl_Enhance_report1
   Insert Into tbl_Enhance_report1 values ('LONG_NAME','CLTCODE','pan_gir_no','mobile_pager','email','NSEBALANCE','NET_AMT','TOTAL_ISIN','TOTA_QTY_SEC','PLD_isin','PLEDGE_QTY','BArrowing','','','')
   Insert into tbl_Enhance_report1 (LONG_NAME,CLTCODE,pan_gir_no,mobile_pager,email,MCD_BALANCE,NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,BArrowing)
   select LONG_NAME,CLTCODE,pan_gir_no,mobile_pager,email,NSEBALANCE,NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,BArrowing from #F   
     
       SET @FILENAME_1 ='Enhance_Report_NSE_' + replace(convert(varchar(8), Getdate(), 112)+convert(varchar(8),Getdate(), 114), ':','')  + '.csv'          
      -- SET @FILENAME_1 ='Enhance_Report_11042018.xls'          
                                    
  
       SET @s1 = 'exec [intranet].MASTER.dbo.xp_cmdshell ' + ''''                                                   
     
       SET @s1 = @s1 + 'bcp "select * from anand1.account.dbo.tbl_Enhance_report1 " queryout \\196.1.115.183\D$\upload1\NRMS\MarginFile\'+@FILENAME_1+' -c -t, -Sintranet -uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                     
             
       SET @s1 = @s1 + ''''                                                          
    
       EXEC(@s1)     
  
      SELECT   @FILENAME_1 As 'MSG'
    print(@FILENAME_1)
    END   
  
   
 ---------------NSE COMPLETED  
 IF @EXCHANGE ='BSE'  
     BEGIN   
   SELECT LONG_NAME,CLTCODE,  
   pan_gir_no=(case WHEN LEN(ISNULL(pan_gir_no,''))<> 10 THEN  'NNNNN1111N' ELSE pan_gir_no END  ),  
   mobile_pager =(case WHEN LEN(ISNULL(mobile_pager,''))<>10  THEN  '6666666666' ELSE mobile_pager END  ),  
   email =(case WHEN ISNULL(email,'') ='' THEN 'notprovided@notprovided.com'  ELSE email END  ) ,BSE_BALANCE+BSX AS BSE_BALANCE ,  
   NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,pld_isin,PLEDGE_QTY,BArrowing,  
  ---REPLACE(CONVERT(NVARCHAR,SEBI_PAYOUT, 106), ' ', '-')  Sebi_payout  ,Borrowing      
  CONVERT(VARCHAR(11),SEBI_PAYOUT,103)Sebi_payout ,'A' Action  INTO #BSE   
   FROM MSAJAG.DBO.CLIENT_DETAILS D,  
   NSE_DATA_FINAL F     
  WHERE F.CLTCODE=D.CL_CODE and  
    F.CLTCODE IN (SELECT CL_CODE FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE EXCHANGE ='BSE' AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T')   
    AND Active_Date <=@todate + ' 23:59')  
   
   
   
  
    SELECT DISTINCT CLTCODE INTO #BSETRAA  FROM (  
   SELECT * FROM  AngelBSECM.ACCOUNT_AB.DBO.LEDGER WHERE VDT >='2017-03-01' AND VDT <=@todate + ' 23:59' AND VTYP =15   
    )A ,  
   MSAJAG.DBO.CLIENT_BROK_DETAILS B WHERE CLTCODE =CL_CODE   
   AND EXCHANGE IN ('BSE','BSX')  AND ISNULL(DEACTIVE_VALUE,'')NOT IN ('C','T')  
  
  
   SELECT DISTINCT CL_CODE INTO #NEWCLB  FROM  MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE ACTIVE_DATE >=@fromdate AND ACTIVE_DATE <=@todate + ' 23:59'   
    AND EXCHANGE IN ('BSE','BSX')  AND ISNULL(DEACTIVE_VALUE,'')NOT IN ('C','T')  
   
   --SELECT * FROM #BSETRAA  
   --UNION  
   --SELECT * FROM #NEWCLB  
  
     
    SELECT * INTO #BSEFIN FROM (  
  
    select * from #BSE where BSE_BALANCE <>0 OR NET_AMT<> 0 OR TOTAL_ISIN <> 0 OR PLEDGE_QTY <> 0   
    UNION ALL  
  
    select * from #BSE where BSE_BALANCE =0 AND NET_AMT=0 AND TOTAL_ISIN =0 AND PLEDGE_QTY =0   
    AND CLTCODE IN ( SELECT * FROM #BSETRAA  
   UNION  
   SELECT * FROM #NEWCLB) )A  
   ORDER BY CLTCODE  
   
    
   UPDATE #BSEFIN SET pan_gir_no ='NNNNN1111N' WHERE pan_gir_no ='NNNNNN1111N'  
   
   --SELECT T.*,ASD FROM  #BSEFIN t,  
   -- (SELECT CL_CODE,MIN(ACTIVE_DATE) ASD FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS  
   --  WHERE EXCHANGE IN ('BSE','BSX') AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T') AND Active_Date <=@todate + ' 23:59' GROUP BY CL_CODE ) R  
   --WHERE T.CLTCODE =R.CL_CODE   
  
    SELECT upper(LONG_NAME)LONG_NAME,upper(CLTCODE)CLTCODE,upper(pan_gir_no)pan_gir_no,mobile_pager,LOWER(email)email,ROUND(BSE_BALANCE,2)BSE_BALANCE,  
   ROUND(NET_AMT,2)NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,pld_isin,PLEDGE_QTY,ROUND(BARROWING,2)BARROWING,Sebi_payout,ACTION,ASD  INTO #BC  
   FROM  #BSEFIN t,  
    (SELECT CL_CODE,MIN(ACTIVE_DATE) ASD FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS  
     WHERE EXCHANGE IN ('BSE','BSX') AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T') AND Active_Date <=@todate + ' 23:59' GROUP BY CL_CODE ) R  
   WHERE T.CLTCODE =R.CL_CODE   
   AND  ( pan_gir_no not Like '%.%' and pan_gir_no not Like '%,%' and pan_gir_no  not Like '%-%' and pan_gir_no not Like '%/%' and len(pan_gir_no) = 10 )  
   AND LONG_NAME NOT LIKE '%VANDHA%'  
    
   
  delete FROM   #BC  WHERE pan_gir_no  Like '%.%' and pan_gir_no  Like '%,%' and pan_gir_no   Like '%-%' and pan_gir_no  Like '%/%' and len(pan_gir_no) <> 10    
   and pan_gir_no  Like '%\%'  
   
          --SELECT * FROM #BC  
          
   --SELECT H.*,ISNULL(P.QTY,0)pledge_qty,ISNULL(pledge_value,0)pledge_value,ISNULL(Borrowing,0)Borrowing FROM HOLDING H   
   --LEFT OUTER JOIN   
   --PLDRPT P ON RTRIM(LTRIM(H.PARTY_CODE)) =RTRIM(LTRIM(P.PARTY_CODE))  AND RTRIM(LTRIM(H.ISIN))=RTRIM(LTRIM(P.ISIN))   
   --WHERE H.PARTY_CODE IN (  
   --SELECT CLTCODE  FROM #BC)    
    Truncate table tbl_Enhance_report1
   Insert Into tbl_Enhance_report1 values ('LONG_NAME','CLTCODE','pan_gir_no','mobile_pager','email','BSE_BALANCE','NET_AMT','TOTAL_ISIN','TOTA_QTY_SEC','PLD_isin','PLEDGE_QTY',	'BArrowing','Sebi_payout','ACTION','ASD')
   Insert into tbl_Enhance_report1 (LONG_NAME,CLTCODE,pan_gir_no,mobile_pager,email,MCD_BALANCE,NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,BArrowing,Sebi_payout,ACTION,ASD)
   select * from #BC   
  
       
       SET @FILENAME_1 ='Enhance_Report_BSE_' +replace(convert(varchar(8), Getdate(), 112)+convert(varchar(8),Getdate(), 114), ':','')  + '.csv'          
      -- SET @FILENAME_1 ='Enhance_Report_11042018.xls'          
                                    
  
       SET @s1 = 'exec [intranet].MASTER.dbo.xp_cmdshell ' + ''''                                                   
     
       SET @s1 = @s1 + 'bcp "select * from anand1.account.dbo.tbl_Enhance_report1 " queryout \\196.1.115.183\D$\upload1\NRMS\MarginFile\'+@FILENAME_1+' -c -t, -Sintranet -uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                     
             
       SET @s1 = @s1 + ''''                                                          
    
       EXEC(@s1)     
  
      SELECT   @FILENAME_1 As 'MSG'
  
   END   
   
 ------------------BSE COMPLETED  
  
 IF @Exchange='MCD'  
  
  BEGIN   
    
  
    SELECT LONG_NAME,CLTCODE,  
    pan_gir_no=(case WHEN ISNULL(pan_gir_no,'') ='' THEN  'NNNNN1111N' ELSE pan_gir_no END  ),  
    mobile_pager =(case WHEN LEN(ISNULL(mobile_pager,''))<>10  THEN  '6666666666' ELSE mobile_pager END  ),  
    email =(case WHEN ISNULL(email,'') ='' THEN 'notprovided@notprovided.com'  ELSE email END  ) ,MCD AS MCD_BALANCE ,NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,BArrowing,  
   ---REPLACE(CONVERT(NVARCHAR,SEBI_PAYOUT, 106), ' ', '-')  Sebi_payout  ,Borrowing      
    CONVERT(VARCHAR(11),SEBI_PAYOUT,105)Sebi_payout  INTO #M  
    FROM MSAJAG.DBO.CLIENT_DETAILS D,  
    NSE_DATA_FINAL F     
    WHERE F.CLTCODE=D.CL_CODE and  
     F.CLTCODE IN (SELECT CL_CODE FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE EXCHANGE ='MCD' AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T')   
     AND Active_Date <=@todate + ' 23:59')  
   
  
   
     SELECT DISTINCT CLTCODE INTO #MCD1 FROM (  
    SELECT * FROM  ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER WHERE VDT >=@fromdate AND VDT <='2018-03-31' AND VTYP =15   
    )A ,  
    MSAJAG.DBO.CLIENT_BROK_DETAILS B WHERE CLTCODE =CL_CODE   
    AND EXCHANGE IN ('MCD')  AND ISNULL(DEACTIVE_VALUE,'')NOT IN ('C','T')  
  
  
    SELECT DISTINCT CL_CODE INTO #NEWCLMCD  FROM  MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE ACTIVE_DATE >=@fromdate AND ACTIVE_DATE <=@todate + ' 23:59'   
     AND EXCHANGE IN ('MCD')  AND ISNULL(DEACTIVE_VALUE,'')NOT IN ('C','T')  
   
   
  
     
     SELECT * INTO #MCDFIN FROM (  
  
     select * from #M where MCD_BALANCE <>0 OR NET_AMT<> 0 OR TOTAL_ISIN <> 0 OR PLEDGE_QTY <> 0   
     UNION ALL  
  
     select * from #M where MCD_BALANCE =0 AND NET_AMT=0 AND TOTAL_ISIN =0 AND PLEDGE_QTY =0   
     AND CLTCODE IN (  SELECT * FROM #MCD1  
    UNION  
    SELECT * FROM #NEWCLMCD) )A  
    ORDER BY CLTCODE  
  
      SELECT UPPER(LONG_NAME)LONG_NAME,UPPER(CLTCODE)CLTCODE,UPPER(pan_gir_no)pan_gir_no,mobile_pager,LOWER(email)email,  
      ROUND(MCD_BALANCE,2)MCD_BALANCE,ROUND(NET_AMT,2)NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,ROUND(BArrowing,2)BArrowing,Sebi_payout,ASD INTO #MD  
  FROM  #MCDFIN t,  
     (SELECT CL_CODE,MIN(ACTIVE_DATE) ASD FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS  
      WHERE EXCHANGE ='mcd' AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T') AND Active_Date <=@todate + ' 23:59'   
      GROUP BY CL_CODE ) R  
    WHERE T.CLTCODE =R.CL_CODE   
    AND MCD_BALANCE <>0  
    AND    ( pan_gir_no not Like '%.%' and pan_gir_no not Like '%,%' and pan_gir_no  not Like '%-%' and pan_gir_no not Like '%/%' and len(pan_gir_no) = 10 )  
    AND LONG_NAME NOT LIKE '%VANDHA%'  
  
   delete FROM   #MD  WHERE pan_gir_no  Like '%.%' or pan_gir_no  Like '%,%' or pan_gir_no   Like '%-%' or pan_gir_no  Like '%/%' or len(pan_gir_no) <> 10    
    or pan_gir_no  Like '%\%'  
  
    --SELECT * FROM #MD  
  
    --SELECT H.*,ISNULL(P.QTY,0)pledge_qty,ISNULL(pledge_value,0)pledge_value,ISNULL(Borrowing,0)Borrowing INTO #FGH FROM HOLDING H   
    --LEFT OUTER JOIN   
    --PLDRPT P ON RTRIM(LTRIM(H.PARTY_CODE)) =RTRIM(LTRIM(P.PARTY_CODE))  AND RTRIM(LTRIM(H.ISIN))=RTRIM(LTRIM(P.ISIN))   
    --WHERE H.PARTY_CODE IN (  
    --SELECT CLTCODE  FROM #MD)    
  
    --SELECT LONG_NAME,PAN_GIR_NO,F.* FROM #FGH F,MSAJAG.DBO.CLIENT_DETAILS  
    --WHERE CL_CODE =F.PARTY_CODE   
    
	 Truncate table tbl_Enhance_report1
	 Insert Into tbl_Enhance_report1 values ('LONG_NAME','CLTCODE','pan_gir_no','mobile_pager','email','MCD_BALANCE','NET_AMT','TOTAL_ISIN','TOTA_QTY_SEC','PLD_isin','PLEDGE_QTY','BArrowing','Sebi_payout','ASD','')
     Insert into tbl_Enhance_report1 (LONG_NAME,CLTCODE,pan_gir_no,mobile_pager,email,MCD_BALANCE,NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,BArrowing,Sebi_payout,ASD)
  	  select * from #MD   
  
       
       SET @FILENAME_1 ='Enhance_Report_MCD_' + replace(convert(varchar(8), Getdate(), 112)+convert(varchar(8),Getdate(), 114), ':','')  + '.csv'          
      -- SET @FILENAME_1 ='Enhance_Report_11042018.xls'          
                                    
  
       SET @s1 = 'exec [intranet].MASTER.dbo.xp_cmdshell ' + ''''                                                   
     
       SET @s1 = @s1 + 'bcp "select * from anand1.account.dbo.tbl_Enhance_report1 " queryout \\196.1.115.183\D$\upload1\NRMS\MarginFile\'+@FILENAME_1+' -c -t, -Sintranet -uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                     
             
       SET @s1 = @s1 + ''''                                                          
    
       EXEC(@s1)   
	   
	   SELECT   @FILENAME_1 As 'MSG'
  
     END   
 ---------------MCD END   
 ---MCX-----  
  
   IF @Exchange='MCX'  
     BEGIN   
  
     SELECT LONG_NAME,CLTCODE,  
   pan_gir_no=(case WHEN ISNULL(pan_gir_no,'') ='' THEN  'NNNNN1111N' ELSE pan_gir_no END  ),  
   mobile_pager =(case WHEN LEN(ISNULL(mobile_pager,''))<>10  THEN  '6666666666' ELSE mobile_pager END  ),  
   email =(case WHEN ISNULL(email,'') ='' THEN 'notprovided@notprovided.com'  ELSE email END  ) ,MCX_BALANCE AS MCD_BALANCE ,NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,BArrowing,  
  ---REPLACE(CONVERT(NVARCHAR,SEBI_PAYOUT, 106), ' ', '-')  Sebi_payout  ,Borrowing      
  CONVERT(VARCHAR(11),SEBI_PAYOUT,105)Sebi_payout  INTO #MCX_B  
   FROM MSAJAG.DBO.CLIENT_DETAILS D,  
   NSE_DATA_FINAL F     
  WHERE F.CLTCODE=D.CL_CODE and  
    F.CLTCODE IN (SELECT CL_CODE FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE EXCHANGE ='MCX' AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T')   
    AND Active_Date <=@todate + ' 23:59')  
   
    IF OBJECT_ID('tempdb..#NEWCLMCDMCX') IS NOT NULL
	Begin
    DROP TABLE #NEWCLMCDMCX
	End
    
    SELECT DISTINCT CLTCODE INTO #MCDX1 FROM (  
   SELECT * FROM  ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER WHERE VDT >=@fromdate AND VDT <='2018-03-31' AND VTYP =15   
   )A ,  
   MSAJAG.DBO.CLIENT_BROK_DETAILS B WHERE CLTCODE =CL_CODE   
   AND EXCHANGE IN ('MCX')  AND ISNULL(DEACTIVE_VALUE,'')NOT IN ('C','T')  
  
  
   SELECT DISTINCT CL_CODE INTO #NEWCLMCDMCX  FROM  MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE ACTIVE_DATE >=@fromdate AND ACTIVE_DATE <=@todate + ' 23:59'   
    AND EXCHANGE IN ('MCX')  AND ISNULL(DEACTIVE_VALUE,'')NOT IN ('C','T')  
   
   
  
     
    SELECT * INTO #MCXFIN FROM (  
  
    select * from #MCX_B where MCD_BALANCE <>0 OR NET_AMT<> 0 OR TOTAL_ISIN <> 0 OR PLEDGE_QTY <> 0   
    UNION ALL  
  
    select * from #MCX_B where MCD_BALANCE =0 AND NET_AMT=0 AND TOTAL_ISIN =0 AND PLEDGE_QTY =0   
    AND CLTCODE IN (  SELECT * FROM #MCDX1  
   UNION  
   SELECT * FROM #NEWCLMCDMCX) )A  
   ORDER BY CLTCODE  
   
  
   IF OBJECT_ID('tempdb..#MCF') IS NOT NULL
	Begin
    DROP TABLE #MCF
	End
  
     SELECT UPPER(LONG_NAME)LONG_NAME,UPPER(CLTCODE)CLTCODE,UPPER(pan_gir_no)pan_gir_no,mobile_pager,LOWER(email)email,  
     ROUND(MCD_BALANCE,2)MCD_BALANCE,ROUND(NET_AMT,2)NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,ROUND(BArrowing,2)BArrowing,REPLACE(Sebi_payout,'-','/')  
     Sebi_payout,ASD INTO #MCF  
   FROM  #MCXFIN t,  
    (SELECT CL_CODE,MIN(ACTIVE_DATE) ASD FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS  
     WHERE EXCHANGE ='MCX' AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T') AND Active_Date <=@todate + ' 23:59'   
     GROUP BY CL_CODE ) R  
   WHERE T.CLTCODE =R.CL_CODE   
   AND MCD_BALANCE <>0  
   AND    ( pan_gir_no not Like '%.%' and pan_gir_no not Like '%,%' and pan_gir_no  not Like '%-%' and pan_gir_no not Like '%/%' and len(pan_gir_no) =  10 )  
   AND LONG_NAME NOT LIKE '%VANDHA%'  
  
  delete FROM   #MCF  WHERE pan_gir_no  Like '%.%' or pan_gir_no  Like '%,%' or pan_gir_no   Like '%-%' or pan_gir_no  Like '%/%' or len(pan_gir_no) <> 10    
   or pan_gir_no  Like '%\%'  
  
   
   --SELECT * FROM  #MCF  
  
   SELECT H.*,ISNULL(P.QTY,0)pledge_qty,ISNULL(pledge_value,0)pledge_value,ISNULL(Borrowing,0)Borrowing INTO #MCHOLDING FROM HOLDING H   
   LEFT OUTER JOIN   
   PLDRPT P ON RTRIM(LTRIM(H.PARTY_CODE)) =RTRIM(LTRIM(P.PARTY_CODE))  AND RTRIM(LTRIM(H.ISIN))=RTRIM(LTRIM(P.ISIN))   
   WHERE H.PARTY_CODE IN (  
   SELECT CLTCODE  FROM #MCF)    
  
   --SELECT LONG_NAME,PAN_GIR_NO,F.* FROM #MCHOLDING F,MSAJAG.DBO.CLIENT_DETAILS  
   --WHERE CL_CODE =F.PARTY_CODE   
  
  Truncate table tbl_Enhance_report1
	 Insert Into tbl_Enhance_report1 values ('LONG_NAME','CLTCODE','pan_gir_no','mobile_pager','email','MCD_BALANCE','NET_AMT','TOTAL_ISIN','TOTA_QTY_SEC','PLD_isin','PLEDGE_QTY',	'BArrowing','Sebi_payout','ASD','')
   Insert into tbl_Enhance_report1 (LONG_NAME,CLTCODE,pan_gir_no,mobile_pager,email,MCD_BALANCE,NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,BArrowing,Sebi_payout,ASD)
   select * from #MCF   
  
       
       SET @FILENAME_1 ='Enhance_Report_MCX_' + replace(convert(varchar(8), Getdate(), 112)+convert(varchar(8),Getdate(), 114), ':','')  + '.csv'          
      -- SET @FILENAME_1 ='Enhance_Report_11042018.xls'          
                                    
  
       SET @s1 = 'exec [intranet].MASTER.dbo.xp_cmdshell ' + ''''                                                   
     
       SET @s1 = @s1 + 'bcp "select * from anand1.account.dbo.tbl_Enhance_report1 " queryout \\196.1.115.183\D$\upload1\NRMS\MarginFile\'+@FILENAME_1+' -c -t, -Sintranet -uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                     
             
       SET @s1 = @s1 + ''''                                                          
    
       EXEC(@s1)   
	   
	   SELECT   @FILENAME_1 As 'MSG'
   
 END   
 --------------mcx completed  
  ---NCX-----  
  
   IF @Exchange ='NCX'  
     BEGIN   
  
   SELECT LONG_NAME,CLTCODE,  
   pan_gir_no=(case WHEN ISNULL(pan_gir_no,'') ='' THEN  'NNNNN1111N' ELSE pan_gir_no END  ),  
   mobile_pager =(case WHEN LEN(ISNULL(mobile_pager,''))<>10  THEN  '6666666666' ELSE mobile_pager END  ),  
   email =(case WHEN ISNULL(email,'') ='' THEN 'notprovided@notprovided.com'  ELSE email END  ) ,MCX_BALANCE AS MCD_BALANCE ,NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,BArrowing,  
  ---REPLACE(CONVERT(NVARCHAR,SEBI_PAYOUT, 106), ' ', '-')  Sebi_payout  ,Borrowing      
  CONVERT(VARCHAR(11),SEBI_PAYOUT,105)Sebi_payout  INTO #NCX_B  
   FROM MSAJAG.DBO.CLIENT_DETAILS D,  
   NSE_DATA_FINAL F     
  WHERE F.CLTCODE=D.CL_CODE and  
    F.CLTCODE IN (SELECT CL_CODE FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE EXCHANGE ='MCX' AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T')   
    AND Active_Date <=@todate + ' 23:59')  
   
   --DROP TABLE #NEWCLMCDMCX  
    
    SELECT DISTINCT CLTCODE INTO #NCDX1 FROM (  
   SELECT * FROM  ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER WHERE VDT >=@fromdate AND VDT <='2018-03-31' AND VTYP =15   
   )A ,  
   MSAJAG.DBO.CLIENT_BROK_DETAILS B WHERE CLTCODE =CL_CODE   
   AND EXCHANGE IN ('NCX')  AND ISNULL(DEACTIVE_VALUE,'')NOT IN ('C','T')  
  
  
   SELECT DISTINCT CL_CODE INTO #NEWCLNCDMCX  FROM  MSAJAG.DBO.CLIENT_BROK_DETAILS WHERE ACTIVE_DATE >=@fromdate AND ACTIVE_DATE <=@todate + ' 23:59'   
    AND EXCHANGE IN ('NCX')  AND ISNULL(DEACTIVE_VALUE,'')NOT IN ('C','T')  
   
   
  
     
    SELECT * INTO #NCXFIN FROM (  
  
    select * from #NCX_B where MCD_BALANCE <>0 OR NET_AMT<> 0 OR TOTAL_ISIN <> 0 OR PLEDGE_QTY <> 0   
    UNION ALL  
  
    select * from #NCX_B where MCD_BALANCE =0 AND NET_AMT=0 AND TOTAL_ISIN =0 AND PLEDGE_QTY =0   
    AND CLTCODE IN (  SELECT * FROM #NCDX1  
   --UNION    SELECT * FROM #NEWCLMCDMCX
   ) )A  
   ORDER BY CLTCODE  
   
  
  
   
  
  
     SELECT UPPER(LONG_NAME)LONG_NAME,UPPER(CLTCODE)CLTCODE,UPPER(pan_gir_no)pan_gir_no,mobile_pager,LOWER(email)email,  
     ROUND(MCD_BALANCE,2)MCD_BALANCE,ROUND(NET_AMT,2)NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,ROUND(BArrowing,2)BArrowing,REPLACE(Sebi_payout,'-','/')  
     Sebi_payout,ASD INTO #NCF  
   FROM  #NCXFIN t,  
    (SELECT CL_CODE,MIN(ACTIVE_DATE) ASD FROM AngelBSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS  
     WHERE EXCHANGE ='NCX' AND ISNULL(DEACTIVE_VALUE,'') NOT IN ('C','T') AND Active_Date <=@todate + ' 23:59'   
     GROUP BY CL_CODE ) R  
   WHERE T.CLTCODE =R.CL_CODE   
   AND MCD_BALANCE <>0  
   AND    ( pan_gir_no not Like '%.%' and pan_gir_no not Like '%,%' and pan_gir_no  not Like '%-%' and pan_gir_no not Like '%/%' and len(pan_gir_no) =  10 )  
   AND LONG_NAME NOT LIKE '%VANDHA%'  
  
  delete FROM   #NCF  WHERE pan_gir_no  Like '%.%' or pan_gir_no  Like '%,%' or pan_gir_no   Like '%-%' or pan_gir_no  Like '%/%' or len(pan_gir_no) <> 10    
   or pan_gir_no  Like '%\%'  
  
   
  
  
   SELECT H.*,ISNULL(P.QTY,0)pledge_qty,ISNULL(pledge_value,0)pledge_value,ISNULL(Borrowing,0)Borrowing INTO #NCHOLDING FROM HOLDING H   
   LEFT OUTER JOIN   
   PLDRPT P ON RTRIM(LTRIM(H.PARTY_CODE)) =RTRIM(LTRIM(P.PARTY_CODE))  AND RTRIM(LTRIM(H.ISIN))=RTRIM(LTRIM(P.ISIN))   
   WHERE H.PARTY_CODE IN (  
   SELECT CLTCODE  FROM #NCF)    
  
   --SELECT * FROM  #NCF  
  
   --SELECT LONG_NAME,PAN_GIR_NO,F.* FROM #NCHOLDING F,MSAJAG.DBO.CLIENT_DETAILS  
   --WHERE CL_CODE =F.PARTY_CODE  
   

    Insert Into tbl_Enhance_report1 values ('LONG_NAME','CLTCODE','pan_gir_no','mobile_pager','email','MCD_BALANCE','NET_AMT','TOTAL_ISIN','TOTA_QTY_SEC','PLD_isin','PLEDGE_QTY',	'BArrowing','Sebi_payout','ASD','')
    Insert into tbl_Enhance_report1 (LONG_NAME,CLTCODE,pan_gir_no,mobile_pager,email,MCD_BALANCE,NET_AMT,TOTAL_ISIN,TOTA_QTY_SEC,PLD_isin,PLEDGE_QTY,BArrowing,Sebi_payout,ASD)
     select * from #NCF   
  
       
       SET @FILENAME_1 ='Enhance_Report_NCX_' + replace(convert(varchar(8), Getdate(), 112)+convert(varchar(8),Getdate(), 114), ':','')  + '.csv'          
      -- SET @FILENAME_1 ='Enhance_Report_11042018.xls'          
                                    
  
       SET @s1 = 'exec [intranet].MASTER.dbo.xp_cmdshell ' + ''''                                                   
     
SET @s1 = @s1 + 'bcp "select * from anand1.account.dbo.tbl_Enhance_report1 " queryout \\196.1.115.183\D$\upload1\NRMS\MarginFile\'+@FILENAME_1+' -c -t, -Sintranet -uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                     
             
       SET @s1 = @s1 + ''''                                                          
    
       EXEC(@s1)   
	   
	   SELECT   @FILENAME_1 As 'MSG'
   END   
END

GO
