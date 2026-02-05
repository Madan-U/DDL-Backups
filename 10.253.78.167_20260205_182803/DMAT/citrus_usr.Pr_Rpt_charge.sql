-- Object: PROCEDURE citrus_usr.Pr_Rpt_charge
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--select * from nsdl_holding_dtls  
--select * from dp_mstr   
--Pr_Rpt_charge 'NSDL',4,'may 17 2008','may 20 2008',1,'HO|*~|','S','' 
--Pr_Rpt_charge 'NSDL',4,'2008-05-17 00:00:00.000','2008-05-20 00:00:00.000',1,'TNIA|*~|','D','' 
--Pr_Rpt_charge 'NSDL',4,'2008-05-17 00:00:00.000','2008-05-20 00:00:00.000',1,'TNIA|*~|','DS','' 
 --D -- detail report 
 --S -- summarywise report 
 --DS-- detail summarywise report 
 
CREATE Proc [citrus_usr].[Pr_Rpt_charge]  
			@pa_dptype varchar(4),  
			@pa_excsmid int,     --  
			@pa_fromdate varchar(11),    
			@pa_todate  varchar(11),   
			@pa_login_pr_entm_id numeric,  --  
			@pa_login_entm_cd_chain  varchar(8000),  
			@pa_rtype varchar(10),  --  
			@pa_output varchar(8000) output   --  
 as  
 begin  
   declare 
   @@dpmid int,  
   @@tmpholding_dt datetime,
   @@l_child_entm_id  numeric  
    
    
    select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1  
    select @@l_child_entm_id = citrus_usr.fn_get_child(@pa_login_pr_entm_id, @pa_login_entm_cd_chain)  
 
    CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)  
    INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) 
  
	if @pa_fromdate  = ''  
	begin  
		set @pa_fromdate = 'jan  1 1900'  
		set @pa_todate = 'dec 31 2100'  
	end  
	if @pa_todate = ''  
	begin  
		set @pa_todate = @pa_fromdate  
	end  
  
  

		 IF @pa_rtype = 'D' 
		 BEGIN
		 -- 
			CREATE TABLE #TBLTRANS(TRANS_DT DATETIME,DPAM_ID BIGINT,QUANTITY NUMERIC(18,3),ISIN VARCHAR(12),TRANS_NO VARCHAR(12),NARR_CD VARCHAR(3),CLIENT_CHARGE NUMERIC(18,4),DP_CHARGE NUMERIC(18,4),TRN_DESCP VARCHAR(100))

					IF @pa_dptype = 'NSDL'  
					BEGIN
						INSERT INTO #TBLTRANS(TRANS_DT,DPAM_ID,QUANTITY,ISIN,TRANS_NO,NARR_CD,CLIENT_CHARGE,DP_CHARGE,TRN_DESCP)
						SELECT NSDHM_TRANSACTION_DT,NSDHM_DPAM_ID,NSDHM_QTY,NSDHM_ISIN,NSDHM_DPM_TRANS_NO,NSDHM_BOOK_NAAR_CD,isnull(NSDHM_CHARGE,0),isnull(NSDHM_DP_CHARGE,0),NSDHM_TRN_DESCP
						FROM NSDL_HOLDING_DTLS
						WHERE NSDHM_TRANSACTION_DT between @pa_fromdate and @pa_todate and NSDHM_DPM_ID = @@dpmid and (isnull(NSDHM_CHARGE,0) <> 0 or isnull(NSDHM_DP_CHARGE,0) <> 0)

						INSERT INTO #TBLTRANS(TRANS_DT,DPAM_ID,QUANTITY,ISIN,TRANS_NO,NARR_CD,CLIENT_CHARGE,DP_CHARGE,TRN_DESCP)
						SELECT CLIC_TRANS_DT,CLIC_DPAM_ID,0,CLIC_CHARGE_NAME,'','',SUM(CLIC_CHARGE_AMT),SUM(DPCH_CHARGE_AMT),CLIC_CHARGE_NAME
						FROM 
						(
						SELECT CLIC_TRANS_DT,CLIC_DPAM_ID,CLIC_CHARGE_NAME,CLIC_CHARGE_AMT=isnull(CLIC_CHARGE_AMT,0),DPCH_CHARGE_AMT=0
						FROM CLIENT_CHARGES_NSDL
						WHERE CLIC_TRANS_DT between @pa_fromdate and @pa_todate AND CLIC_DPM_ID = @@dpmid AND CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES' AND CLIC_DELETED_IND = 1
						UNION
						SELECT DPCH_TRANC_DT,DPCH_DPAM_ID,DPCH_CHARGE_NAME,CLIC_CHARGE_AMT=0,DPCH_CHARGE_AMT=isnull(DPCH_CHARGE_AMT,0)
						FROM DP_CHARGES_NSDL
						WHERE DPCH_TRANC_DT between @pa_fromdate and @pa_todate AND DPCH_DPM_ID = @@dpmid AND DPCH_CHARGE_NAME <> 'TRANSACTION CHARGES' AND DPCH_DELETED_IND = 1
						) TMPVIEW
						GROUP BY CLIC_TRANS_DT,CLIC_DPAM_ID,CLIC_CHARGE_NAME

						SELECT  NSDHM_TRANSACTION_DT= CONVERT(VARCHAR(11),TRANS_DT,103)
						,T.DPAM_ID
						,DPAM_SBA_NAME 
						,DPAM_SBA_NO 
						,QUANTITY 
						,ISIN = ISNULL(ISIN_NAME,ISIN)
						,ISNULL(NAAR.DESCP,NARR_CD) NARRATION
						,isnull(CLIENT_CHARGE,0) NSDHM_CHARGE   
						,isnull(DP_CHARGE,0) NSDHM_DP_CHARGE  
						,TRN_DESCP NSDHM_TRN_DESCP  
						FROM  #TBLTRANS T 
						LEFT OUTER JOIN CITRUS_USR.FN_GETSUBTRANSDTLS('NARR_CODE') NAAR  ON NARR_CD = NAAR.CD
						LEFT OUTER JOIN ISIN_MSTR ON T.ISIN = ISIN_CD
						,#ACLIST account
						WHERE T.DPAM_ID = account.DPAM_ID
						ORDER BY DPAM_SBA_NAME,DPAM_SBA_NO,ISIN_NAME

					END
					ELSE
					BEGIN -- CDSL
						INSERT INTO #TBLTRANS(TRANS_DT,DPAM_ID,QUANTITY,ISIN,TRANS_NO,NARR_CD,CLIENT_CHARGE,DP_CHARGE,TRN_DESCP)
						SELECT CDSHM_TRAS_DT,CDSHM_DPAM_ID,CDSHM_QTY,CDSHM_ISIN,CDSHM_TRANS_NO,CDSHM_TRATM_CD,isnull(CDSHM_CHARGE,0),isnull(CDSHM_DP_CHARGE,0),CDSHM_TRATM_DESC
						FROM CDSL_HOLDING_DTLS
						WHERE CDSHM_TRAS_DT between @pa_fromdate and @pa_todate and CDSHM_DPM_ID = @@dpmid and (isnull(CDSHM_CHARGE,0) <> 0 or isnull(CDSHM_DP_CHARGE,0) <> 0)

						INSERT INTO #TBLTRANS(TRANS_DT,DPAM_ID,QUANTITY,ISIN,TRANS_NO,NARR_CD,CLIENT_CHARGE,DP_CHARGE,TRN_DESCP)
						SELECT CLIC_TRANS_DT,CLIC_DPAM_ID,0,CLIC_CHARGE_NAME,'','',SUM(CLIC_CHARGE_AMT),SUM(DPCH_CHARGE_AMT),CLIC_CHARGE_NAME
						FROM 
						(
						SELECT CLIC_TRANS_DT,CLIC_DPAM_ID,CLIC_CHARGE_NAME,CLIC_CHARGE_AMT=isnull(CLIC_CHARGE_AMT,0),DPCH_CHARGE_AMT=0
						FROM   CLIENT_CHARGES_CDSL
						WHERE  CLIC_TRANS_DT between @pa_fromdate and @pa_todate AND CLIC_DPM_ID = @@dpmid AND CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES' AND CLIC_DELETED_IND = 1
						UNION
						SELECT DPCH_TRANC_DT,DPCH_DPAM_ID,DPCH_CHARGE_NAME,CLIC_CHARGE_AMT=0,DPCH_CHARGE_AMT=isnull(DPCH_CHARGE_AMT,0)
						FROM   DP_CHARGES_CDSL
						WHERE  DPCH_TRANC_DT between @pa_fromdate and @pa_todate AND DPCH_DPM_ID = @@dpmid AND DPCH_CHARGE_NAME <> 'TRANSACTION CHARGES' AND DPCH_DELETED_IND = 1
						) TMPVIEW
						GROUP BY CLIC_TRANS_DT,CLIC_DPAM_ID,CLIC_CHARGE_NAME

						SELECT  NSDHM_TRANSACTION_DT= CONVERT(VARCHAR(11),TRANS_DT,103)
						,T.DPAM_ID
						,DPAM_SBA_NAME 
						,DPAM_SBA_NO 
						,QUANTITY 
						,ISIN = ISNULL(ISIN_NAME,ISIN)
						,ISNULL(NAAR.DESCP,NARR_CD) NARRATION
						,isnull(CLIENT_CHARGE,0) NSDHM_CHARGE   
						,isnull(DP_CHARGE,0) NSDHM_DP_CHARGE  
						,TRN_DESCP NSDHM_TRN_DESCP  
						FROM  #TBLTRANS T 
						LEFT OUTER JOIN CITRUS_USR.FN_GETSUBTRANSDTLS('TRANS_TYPE_CDSL') NAAR  ON NARR_CD = NAAR.CD
						LEFT OUTER JOIN ISIN_MSTR ON T.ISIN = ISIN_CD
						,#ACLIST account
						WHERE T.DPAM_ID = account.DPAM_ID
						ORDER BY DPAM_SBA_NAME,DPAM_SBA_NO,ISIN_NAME
					END


			TRUNCATE TABLE #TBLTRANS
			DROP TABLE #TBLTRANS		

		 --
		 END


  
		IF @pa_rtype = 'S'
		BEGIN
		--  


			CREATE TABLE #TBLSUMMARY(DPAM_ID BIGINT,CLIENT_CHARGE NUMERIC(18,4),DP_CHARGE NUMERIC(18,4))

					IF @pa_dptype = 'NSDL'  
					BEGIN
							INSERT INTO #TBLSUMMARY(DPAM_ID,CLIENT_CHARGE,DP_CHARGE)
							SELECT CLIC_DPAM_ID,SUM(CLIC_CHARGE_AMT),SUM(DPCH_CHARGE_AMT)
							FROM 
							(
								SELECT CLIC_DPAM_ID,CLIC_CHARGE_AMT=isnull(CLIC_CHARGE_AMT,0),DPCH_CHARGE_AMT=0
								FROM CLIENT_CHARGES_NSDL
								WHERE CLIC_TRANS_DT between @pa_fromdate and @pa_todate AND CLIC_DPM_ID = @@dpmid AND CLIC_DELETED_IND = 1
								UNION
								SELECT DPCH_DPAM_ID,CLIC_CHARGE_AMT=0,DPCH_CHARGE_AMT=isnull(DPCH_CHARGE_AMT,0)
								FROM DP_CHARGES_NSDL
								WHERE DPCH_TRANC_DT between @pa_fromdate and @pa_todate AND DPCH_DPM_ID = @@dpmid AND DPCH_DELETED_IND = 1
							) TMPVIEW
							GROUP BY CLIC_DPAM_ID

							 SELECT DPAM_SBA_NAME 
							,DPAM_SBA_NO 
							,isnull(CLIENT_CHARGE,0) NSDHM_CHARGE   
							,isnull(DP_CHARGE,0) NSDHM_DP_CHARGE  
							FROM  #TBLSUMMARY T,#ACLIST account
							WHERE T.DPAM_ID = account.DPAM_ID
							ORDER BY DPAM_SBA_NAME,DPAM_SBA_NO
					END
					ELSE
					BEGIN
							INSERT INTO #TBLSUMMARY(DPAM_ID,CLIENT_CHARGE,DP_CHARGE)
							SELECT CLIC_DPAM_ID,SUM(CLIC_CHARGE_AMT),SUM(DPCH_CHARGE_AMT)
							FROM 
							(
								SELECT CLIC_DPAM_ID,CLIC_CHARGE_AMT=isnull(CLIC_CHARGE_AMT,0),DPCH_CHARGE_AMT=0
								FROM CLIENT_CHARGES_CDSL
								WHERE CLIC_TRANS_DT between @pa_fromdate and @pa_todate AND CLIC_DPM_ID = @@dpmid AND CLIC_DELETED_IND = 1
								UNION
								SELECT DPCH_DPAM_ID,CLIC_CHARGE_AMT=0,DPCH_CHARGE_AMT=isnull(DPCH_CHARGE_AMT,0)
								FROM DP_CHARGES_CDSL
								WHERE DPCH_TRANC_DT between @pa_fromdate and @pa_todate AND DPCH_DPM_ID = @@dpmid AND DPCH_DELETED_IND = 1
							) TMPVIEW
							GROUP BY CLIC_DPAM_ID

							 SELECT DPAM_SBA_NAME 
							,DPAM_SBA_NO 
							,isnull(CLIENT_CHARGE,0) NSDHM_CHARGE   
							,isnull(DP_CHARGE,0) NSDHM_DP_CHARGE  
							FROM  #TBLSUMMARY T,#ACLIST account
							WHERE T.DPAM_ID = account.DPAM_ID
                            UNION 
							SELECT 'a' DPAM_SBA_NAME 
							,'SERVICE TAX' DPAM_SBA_NO 
							,isnull(sum(CLIC_CHARGE_AMT),0) 
							,isnull(0,0) 
							FROM  client_charges_cdsl 
							WHERE CLIC_TRANS_DT between @pa_fromdate and @pa_todate and CLIC_CHARGE_NAME like '%service%tax%'
							UNION 
							SELECT 'b' DPAM_SBA_NAME 
							,'Transaction/AMC/Others Charges' DPAM_SBA_NO 
							,isnull(sum(CLIC_CHARGE_AMT),0) 
							,isnull(0,0) 
							FROM  client_charges_cdsl 
							WHERE CLIC_TRANS_DT between @pa_fromdate and @pa_todate and CLIC_CHARGE_NAME not like '%service%tax%'
							
							UNION 
							SELECT 'c' DPAM_SBA_NAME 
							,'DP SERVICE TAX' DPAM_SBA_NO 
							,isnull(0,0) 
							,isnull(sum(DPCH_CHARGE_AMT),0) 
							FROM  dp_charges_cdsl 
							WHERE DPCH_TRANC_DT between @pa_fromdate and @pa_todate and DPCH_CHARGE_NAME like '%service%tax%'
							UNION 
							SELECT 'd' DPAM_SBA_NAME 
							,'DP Transaction/AMC/Others Charges' DPAM_SBA_NO 
							,isnull(0,0) 
							,isnull(sum(DPCH_CHARGE_AMT),0) 
							FROM  dp_charges_cdsl 
							WHERE DPCH_TRANC_DT between @pa_fromdate and @pa_todate and DPCH_CHARGE_NAME not like '%service%tax%'
							ORDER BY DPAM_SBA_NAME,DPAM_SBA_NO

					END

			TRUNCATE TABLE #TBLSUMMARY
			DROP TABLE #TBLSUMMARY		
		--
		END

		IF @pa_rtype = 'DS' 
		BEGIN
		--
			CREATE TABLE #TBLDS(TRANS_DT DATETIME,DPAM_ID BIGINT,CLIENT_CHARGE NUMERIC(18,4),DP_CHARGE NUMERIC(18,4),charge_name varchar(1000))

					IF @pa_dptype = 'NSDL'  
					BEGIN
								INSERT INTO #TBLDS(TRANS_DT,DPAM_ID,CLIENT_CHARGE,DP_CHARGE,charge_name)
								SELECT NSDHM_TRANSACTION_DT,NSDHM_DPAM_ID,isnull(NSDHM_CHARGE,0),isnull(NSDHM_DP_CHARGE,0),'Transaction Charges'
								FROM NSDL_HOLDING_DTLS
								WHERE NSDHM_TRANSACTION_DT between @pa_fromdate and @pa_todate and NSDHM_DPM_ID = @@dpmid and (isnull(NSDHM_CHARGE,0) <> 0 or isnull(NSDHM_DP_CHARGE,0) <> 0)

								INSERT INTO #TBLDS(TRANS_DT,DPAM_ID,CLIENT_CHARGE,DP_CHARGE,charge_name)
								SELECT CLIC_TRANS_DT,CLIC_DPAM_ID,SUM(CLIC_CHARGE_AMT),SUM(DPCH_CHARGE_AMT),CHARGE_NAME
								FROM 
								(
									SELECT CLIC_TRANS_DT,CLIC_DPAM_ID,CLIC_CHARGE_AMT=isnull(CLIC_CHARGE_AMT,0),DPCH_CHARGE_AMT=0,CHARGE_NAME = CLIC_CHARGE_NAME
									FROM CLIENT_CHARGES_NSDL
									WHERE CLIC_TRANS_DT between @pa_fromdate and @pa_todate AND CLIC_DPM_ID = @@dpmid AND CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES' AND CLIC_DELETED_IND = 1
									UNION
									SELECT DPCH_TRANC_DT,DPCH_DPAM_ID,CLIC_CHARGE_AMT=0,DPCH_CHARGE_AMT=isnull(DPCH_CHARGE_AMT,0),CHARGE_NAME = DPCH_CHARGE_NAME
									FROM DP_CHARGES_NSDL
									WHERE DPCH_TRANC_DT between @pa_fromdate and @pa_todate AND DPCH_DPM_ID = @@dpmid AND DPCH_CHARGE_NAME <> 'TRANSACTION CHARGES' AND DPCH_DELETED_IND = 1
								) TMPVIEW
								GROUP BY CLIC_TRANS_DT,CLIC_DPAM_ID,CHARGE_NAME
						 
								 SELECT  NSDHM_TRANSACTION_DT= CONVERT(VARCHAR(11),TRANS_DT,103)
								,DPAM_SBA_NAME 
								,DPAM_SBA_NO 
								,isnull(CLIENT_CHARGE,0) NSDHM_CHARGE   
								,isnull(DP_CHARGE,0) NSDHM_DP_CHARGE,CHARGE_NAME  
								FROM  #TBLDS T ,#ACLIST account
								WHERE T.DPAM_ID = account.DPAM_ID
								ORDER BY DPAM_SBA_NAME,DPAM_SBA_NO,TRANS_DT
					END
					ELSE
					BEGIN --CDSL
								INSERT INTO #TBLDS(TRANS_DT,DPAM_ID,CLIENT_CHARGE,DP_CHARGE,CHARGE_NAME)
								SELECT CDSHM_TRAS_DT,CDSHM_DPAM_ID,isnull(CDSHM_CHARGE,0),isnull(CDSHM_DP_CHARGE,0),cdshm_tratm_type_desc
								FROM CDSL_HOLDING_DTLS
								WHERE CDSHM_TRAS_DT between @pa_fromdate and @pa_todate and CDSHM_DPM_ID = @@dpmid and (isnull(CDSHM_CHARGE,0) <> 0 or isnull(CDSHM_DP_CHARGE,0) <> 0)

								INSERT INTO #TBLDS(TRANS_DT,DPAM_ID,CLIENT_CHARGE,DP_CHARGE,CHARGE_NAME)
								SELECT CLIC_TRANS_DT,CLIC_DPAM_ID,SUM(CLIC_CHARGE_AMT),SUM(DPCH_CHARGE_AMT),CHARGE_NAME
								FROM 
								(
									SELECT CLIC_TRANS_DT,CLIC_DPAM_ID,CLIC_CHARGE_AMT=isnull(CLIC_CHARGE_AMT,0),DPCH_CHARGE_AMT=0,CHARGE_NAME=CLIC_CHARGE_NAME
									FROM CLIENT_CHARGES_CDSL
									WHERE CLIC_TRANS_DT between @pa_fromdate and @pa_todate AND CLIC_DPM_ID = @@dpmid AND CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES' AND CLIC_DELETED_IND = 1
									UNION
									SELECT DPCH_TRANC_DT,DPCH_DPAM_ID,CLIC_CHARGE_AMT=0,DPCH_CHARGE_AMT=isnull(DPCH_CHARGE_AMT,0),CHARGE_NAME=DPCH_CHARGE_NAME
									FROM DP_CHARGES_CDSL
									WHERE DPCH_TRANC_DT between @pa_fromdate and @pa_todate AND DPCH_DPM_ID = @@dpmid AND DPCH_CHARGE_NAME <> 'TRANSACTION CHARGES' AND DPCH_DELETED_IND = 1
								) TMPVIEW
								GROUP BY CLIC_TRANS_DT,CLIC_DPAM_ID,CHARGE_NAME
						 
								 SELECT  NSDHM_TRANSACTION_DT= CONVERT(VARCHAR(11),TRANS_DT,103)
								,DPAM_SBA_NAME 
								,DPAM_SBA_NO 
								,isnull(CLIENT_CHARGE,0) NSDHM_CHARGE   
								,isnull(DP_CHARGE,0) NSDHM_DP_CHARGE ,CHARGE_NAME 
								FROM  #TBLDS T ,#ACLIST account
								WHERE T.DPAM_ID = account.DPAM_ID
								ORDER BY dPam_Sba_name , DPAM_SBA_NO,TRANS_DT
					END
					

			TRUNCATE TABLE #TBLDS
			DROP TABLE #TBLDS

   --
   END



		TRUNCATE TABLE #ACLIST
		DROP TABLE #ACLIST
END

GO
