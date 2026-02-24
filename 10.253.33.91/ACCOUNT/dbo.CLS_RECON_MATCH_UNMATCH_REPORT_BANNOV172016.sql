-- Object: PROCEDURE dbo.CLS_RECON_MATCH_UNMATCH_REPORT_BANNOV172016
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE  PROCEDURE [dbo].[CLS_RECON_MATCH_UNMATCH_REPORT]
		(
         @FROM_DATE NVARCHAR(50)          
        ,@TO_DATE NVARCHAR(50)          
		,@BANKCODE NVARCHAR(30)
		,@MATCHEDFLAG NVARCHAR(30)
		,@FILETYPE NVARCHAR(30)
		,@BANKNAME NVARCHAR(30)
		,@SEGMENT NVARCHAR(30)
		,@PARAM_VAL1 NVARCHAR(MAX)
		,@BULKDELETE NVARCHAR(20)
		--,@LOGINNAME NVARCHAR(50)
		)

AS


--SET @FROM_DATE = '01/05/2016'
--SET @TO_DATE = '01/07/2016'
--SET @BANKCODE = '0101'--'02020'
--SET @MATCHEDFLAG = 'D'
--SET @FILETYPE = 'CMS'
--SET @BANKNAME = 'HDFC BANK'
--SET @SEGMENT = 'NSE-CAPITAL'
--SET @PARAM_VAL1='23914^11/07/2013|23914^11/09/2014|'

BEGIN         

DECLARE @CMS_MATCHBY NVARCHAR(100),
@NONCMS_MATCHBY NVARCHAR(35)

SET @CMS_MATCHBY='CHQNO+AMT+DRCR+CLTCODE+ACCNO'
SET @NONCMS_MATCHBY='CHQNO + AMT'

			CREATE TABLE #TEMP_DATA
			(
			CROSSREFNO VARCHAR(12)			
			,FINAL_DT  VARCHAR(25)
			,VNO VARCHAR(12)
			,VTYP INT
			,BOOKTYPE VARCHAR(3)
			)

			IF(@MATCHEDFLAG='D')
			BEGIN
			INSERT INTO #TEMP_DATA
			SELECT
			.DBO.CLS_PIECE(ITEMS, '^', 1)
			,.DBO.CLS_PIECE(ITEMS, '^', 2)
			,''
			,''
			,''
			FROM.DBO.CLS_SPLIT(@PARAM_VAL1, '|')
			WHERE.DBO.CLS_PIECE(ITEMS, '^', 1) <> ''

			UPDATE T
			SET	T.VNO = L1.VNO
			,T.VTYP = L1.VTYP
			,T.BOOKTYPE = L1.BOOKTYPE
			FROM #TEMP_DATA T, LEDGER1 L1
			WHERE L1.REFNO = T.CROSSREFNO

			END

          CREATE TABLE #TEMP_REPORT
                    (
							ROWID     INT          NOT NULL  IDENTITY(1,1)
                            , FILEUPLOADID        NVARCHAR(50)
                            , UPLOADDATE          DATETIME							
							, VALUEDATE           DATETIME
							, SDATE				  DATETIME
							, EDATE				  DATETIME
							, MATCHEDDATE		  DATETIME
                            , SEGMENT             NVARCHAR(50)
                            , BANK                NVARCHAR(50)
                            , ARRANGEMENTTYPE     NVARCHAR(50)
                            , BANKCODE            NVARCHAR(50)
                            , BANKACCOUNT         NVARCHAR(50)
                            , ACCOUNTNO           NVARCHAR(70)
                            , NARRATION           NVARCHAR(MAX)
                            , CHEQUENO            NVARCHAR(50)
                            , DRCR                NVARCHAR(5)
                            , BANKSTATEMENTAMOUNT MONEY
                            , VOUCHERAMOUNT       MONEY
                            , BANKLOCATION        NVARCHAR(50)
                            , ANGELLOCATION       NVARCHAR(50)
                            , CLIENTCODE          NVARCHAR(50)
                            , CLIENTNAME          NVARCHAR(50)
                            , STATUS              NVARCHAR(50)
                            , CROSSREFNO          NVARCHAR(50)
                            , VOUCHERNO           NVARCHAR(50)
                            , MATCHEDBY           NVARCHAR(50)
                            , VOUCHERDATE         DATETIME
                            , DEPOSITDATE         DATETIME
                            , MATCHEDFLAG         BIT
                            , VNO                 VARCHAR(15)
                            , VTYP                INT
                            , BOOKTYPE            VARCHAR(3)
							, TRAN_STATUS         VARCHAR(12)
							, REPORT_FLAG		  NVARCHAR(100)
							, USERNAME			  NVARCHAR(100)
							--,PRIMARY KEY (ROWID, FILEUPLOADID,MATCHEDFLAG)							
                    )
					CREATE TABLE #TEMP_MATCHED_REPORT
                    (		ROWID     INT 
                            ,FILEUPLOADID        NVARCHAR(50)
                            , UPLOADDATE          DATETIME
							, VALUEDATE           DATETIME
							, SDATE				  DATETIME
							, EDATE				  DATETIME
							, MATCHEDDATE		  DATETIME
                            , SEGMENT             NVARCHAR(50)
                            , BANK                NVARCHAR(50)
                            , ARRANGEMENTTYPE     NVARCHAR(50)
                            , BANKCODE            NVARCHAR(50)
							, BANKACCOUNT		  NVARCHAR(50)
							, ACCOUNTNO           NVARCHAR(70)
                            , NARRATION           NVARCHAR(550)
                            , CHEQUENO            NVARCHAR(50)
                            , DRCR                NVARCHAR(5)
                            , BANKSTATEMENTAMOUNT MONEY
                            , VOUCHERAMOUNT       MONEY
                            , BANKLOCATION        NVARCHAR(50)
                            , ANGELLOCATION       NVARCHAR(50)
                            , CLIENTCODE          NVARCHAR(50)
                            , CLIENTNAME          NVARCHAR(50)
                            , STATUS              NVARCHAR(50)
                            , CROSSREFNO          INT
                            , VOUCHERNO           NVARCHAR(50)
                            , MATCHEDBY           NVARCHAR(50)
                            , VOUCHERDATE         DATETIME
                            , DEPOSITDATE         DATETIME
                            , MATCHEDFLAG         BIT
                            , VNO                 VARCHAR(12)
                            , VTYP                INT
                            , BOOKTYPE            VARCHAR(3)
							, TRAN_STATUS         VARCHAR(12)							
                            , REPORT_FLAG		  NVARCHAR(100)
                            , USERNAME			  NVARCHAR(100)
                    )
					CREATE TABLE #TEMP_UNMATCHED_REPORT
                    (		ROWID     INT 
                            ,FILEUPLOADID        NVARCHAR(50)
                            , UPLOADDATE          DATETIME
							, VALUEDATE           DATETIME
							, SDATE				  DATETIME
							, EDATE				  DATETIME
							, MATCHEDDATE		  DATETIME
                            , SEGMENT             NVARCHAR(50)
                            , BANK                NVARCHAR(50)
                            , ARRANGEMENTTYPE     NVARCHAR(50)
                            , BANKCODE            NVARCHAR(50)
							, BANKACCOUNT         NVARCHAR(50)
							, ACCOUNTNO           NVARCHAR(70)
                            , NARRATION           NVARCHAR(50)
                            , CHEQUENO            NVARCHAR(50)
                            , DRCR                NVARCHAR(5)
                            , BANKSTATEMENTAMOUNT MONEY
                            , VOUCHERAMOUNT       MONEY
                            , BANKLOCATION        NVARCHAR(50)
                            , ANGELLOCATION       NVARCHAR(50)
                            , CLIENTCODE          NVARCHAR(50)
                            , CLIENTNAME          NVARCHAR(50)
                            , STATUS              NVARCHAR(50)
                            , CROSSREFNO          INT
                            , VOUCHERNO           NVARCHAR(50)
                            , MATCHEDBY           NVARCHAR(50)
                            , VOUCHERDATE         DATETIME
                            , DEPOSITDATE         DATETIME
                            , MATCHEDFLAG         BIT
                            , VNO                 VARCHAR(12)
                            , VTYP                INT
                            , BOOKTYPE            VARCHAR(3)
							, TRAN_STATUS         VARCHAR(12)
							, REPORT_FLAG		  NVARCHAR(100)
							, USERNAME			  NVARCHAR(100)							
                    )

					CREATE TABLE #LEDGER_TO_MAP
                    (
                              VNO                 VARCHAR(12)
                            , VTYP                INT
                            , BOOKTYPE            VARCHAR(3)
                            , CLTCODE             VARCHAR(10)
                            , DDNO                VARCHAR(30)
                            , RELAMT              MONEY
                            , DRCR                CHAR(1)
                            , BANKSTATEMENTAMOUNT MONEY
                            , NARRATION           NVARCHAR(250)
                            , CLIENTNAME          NVARCHAR(100)
                            , VOUCHERNO           NVARCHAR(15)
                            , VOUCHERDATE         DATETIME
                    )
				

					INSERT INTO #TEMP_REPORT
					SELECT
						RC.UPLOADID AS FILEUPLOADID
						,RC.UPLOADEDDATE AS UPLOADDATE
						,RC.VALUEDATE
						,RBL.FILEUPLOAD_SDATE
						,RBL.FILEUPLOAD_EDATE
						,RC.MODIFIEDDATE 
						,SEGMENT
						,BANKNAME
						,FILETYPE AS ARRANGEMENTTYPE
						,RC.BANKCODE
						,RC.BANKACCOUNT
						,RC.CLTACCOUNT
						,DESCRIPTION AS NARRATION
						,REFERENCENO AS CHEQUENO
						,DRCR
						,'' AS BANKSTATEMENTAMOUNT
						,AMT AS VOUCHERAMOUNT
						,'' AS BANKLOCATION
						,'' AS ANGELLOCATION
						,'' AS CLIENTCODE
						,'' AS CLIENTNAME
						,'' AS STATUS
						,CROSS_NO AS CROSSREFNO
						,'' AS VOUCHERNO
						,@NONCMS_MATCHBY AS MATCHEDBY
						,'' AS VOUCHERDATE
						,'' AS DEPOSITDATE
						,MATCHEDFLAG
						,VNO
						,VTYP
						,BOOKTYPE
						,RC.UPLOADSTATUS
						,RC.LEDGERBALANCE AS REPORT_FLAG
						,RC.UPLOADBY
					FROM RECON_NONCMS_DATA(NOLOCK) RC
					LEFT OUTER JOIN RECON_BANK_FILEUPLOAD_LOGS RBL
					ON RC.UPLOADID = RBL.UPLOADID
					WHERE RC.VALUEDATE BETWEEN  CONVERT(DATETIME, @FROM_DATE, 105)
                                                AND
                                                CONVERT(DATETIME, @TO_DATE, 105)
					AND RC.LEDGERBALANCE<>'DR'
				
					INSERT INTO #TEMP_REPORT				
					SELECT
						RC.UPLOADID AS FILEUPLOADID
						,RC.UPLOADEDDATE AS UPLOADDATE
						,RC.VALUEDATE
						,RBL.FILEUPLOAD_SDATE
						,RBL.FILEUPLOAD_EDATE
						,RC.MODIFIEDDATE
						,SEGMENT
						,BANKNAME
						,FILETYPE AS ARRANGEMENTTYPE
						,RC.BANKCODE
						,'' AS BANKACCOUNT
						,RC.CLTACCNO
						,'' AS NARRATION
						,RC.INST_NO_CHECK AS CHEQUENO
						,DRCR
						,'' AS BANKSTATEMENTAMOUNT
						,INST_AMT AS VOUCHERAMOUNT
						,'' AS BANKLOCATION
						,'' AS ANGELLOCATION
						,'' AS CLIENTCODE
						,'' AS CLIENTNAME
						,'' AS STATUS
						,CROSS_NO AS CROSSREFNO
						,'' AS VOUCHERNO
						,@CMS_MATCHBY AS MATCHEDBY
						,'' AS VOUCHERDATE
						,'' AS DEPOSITDATE
						,MATCHEDFLAG
						,VNO
						,VTYP
						,BOOKTYPE
						,RC.UPLOADSTATUS
						,RC.ROWTYPE  REPORT_FLAG
						,RC.UPLOADBY
					FROM RECON_CMS_DATA(NOLOCK) RC
					LEFT OUTER JOIN RECON_BANK_FILEUPLOAD_LOGS RBL
						ON RC.UPLOADID = RBL.UPLOADID
					WHERE RC.VALUEDATE BETWEEN CONVERT(DATETIME, @FROM_DATE, 105)
					AND
					CONVERT(DATETIME, @TO_DATE, 105)
					AND RC.ROWTYPE<>'DR'

				SELECT @BANKCODE=F.BANKCODE 
				FROM RECON_BANK_FILEUPLOAD_LOGS F(NOLOCK),#TEMP_REPORT T
				WHERE F.UPLOADID=T.FILEUPLOADID 
				AND F.BANKNAME=@BANKNAME AND F.SEGMENT= @SEGMENT AND F.FILETYPE=@FILETYPE

IF(@MATCHEDFLAG='R' AND @PARAM_VAL1='')
BEGIN
	IF (@MATCHEDFLAG = 'M') --MATCHED
		BEGIN
		
		INSERT INTO #TEMP_MATCHED_REPORT
		SELECT * FROM #TEMP_REPORT WHERE MATCHEDFLAG=1
			
				SELECT
					FILEUPLOADID
					,UPLOADDATE					
					,SEGMENT
					,BANK
					,ARRANGEMENTTYPE
					,BANKCODE
					,NARRATION
					,CHEQUENO
					,DRCR
					,BANKSTATEMENTAMOUNT
					,VOUCHERAMOUNT
					,BANKLOCATION
					,ANGELLOCATION
					,CLIENTCODE
					,CLIENTNAME
					,STATUS
					,CROSSREFNO
					,VOUCHERNO
					,MATCHEDBY
					,VOUCHERDATE
					,DEPOSITDATE
					,USERNAME
				FROM #TEMP_MATCHED_REPORT
				WHERE MATCHEDFLAG = @MATCHEDFLAG
				AND BANKCODE = @BANKCODE
				AND REPORT_FLAG<>'DR'

	END

	IF (@MATCHEDFLAG = 'U')--UNMATCHED
		BEGIN
		SELECT 'U'
			INSERT INTO #TEMP_UNMATCHED_REPORT
			SELECT * FROM #TEMP_REPORT	WHERE MATCHEDFLAG=0

			SELECT
				FILEUPLOADID
				,UPLOADDATE
				,SEGMENT
				,BANK
				,ARRANGEMENTTYPE
				,BANKCODE
				,NARRATION
				,CHEQUENO
				,DRCR
				,VOUCHERAMOUNT AS AMOUNT
				,BANKLOCATION
				,ANGELLOCATION
				,CLIENTCODE
				,CLIENTNAME
				,STATUS
				,USERNAME
			FROM #TEMP_UNMATCHED_REPORT
			WHERE MATCHEDFLAG = @MATCHEDFLAG
			AND BANKCODE = @BANKCODE
			AND REPORT_FLAG<>'DR'
		END

		IF(@MATCHEDFLAG='S')
		BEGIN
			SELECT 'SUMMARY'

					SELECT
					SEGMENT
					,BANK
					,ARRANGEMENTTYPE
					,BANKCODE
					,@FROM_DATE AS UPLOADDATEFROM
					,@TO_DATE AS UPLOADDATETO
					,DRCR
					,COUNT(DRCR) AS  'TOTALENTRIES'
					,SUM(CASE WHEN MATCHEDFLAG =1 THEN 1 ELSE 0 END) AS 'RECONCILED'
					,SUM(CASE WHEN MATCHEDFLAG =0 THEN 1 ELSE 0 END) AS 'UNRECONCILED'
					,(SUM(CASE WHEN MATCHEDFLAG =1 THEN 1 ELSE 0 END)*100/COUNT(DRCR)) 'RECONCILED %'					
					FROM #TEMP_REPORT
					WHERE REPORT_FLAG<>'DR'
					GROUP BY
					 SEGMENT
					,BANK
					,ARRANGEMENTTYPE
					,BANKCODE					
					,DRCR
		END

		--DOWNLOAD FILES
		IF(@MATCHEDFLAG='R')
		BEGIN
		
			SELECT			FILEUPLOADID
							, CONVERT(NVARCHAR, UPLOADDATE, 120) UPLOADDATE
							, EDATE UPLOADENDDATE
							, CONVERT(NVARCHAR, VALUEDATE, 120) VALUEDATE
							--, SDATE
							, MATCHEDDATE							
							, SEGMENT
							, BANK
							, ARRANGEMENTTYPE
							, BANKCODE
							, BANKACCOUNT
							, ACCOUNTNO
							, NARRATION
							, CHEQUENO
							, DRCR  
							, BANKSTATEMENTAMOUNT
                            , VOUCHERAMOUNT     
                            , BANKLOCATION       
                            , ANGELLOCATION       
                            , CLIENTCODE         
                            , CLIENTNAME         
                            , STATUS              
                            , CROSSREFNO          
                            , VOUCHERNO           
                            , MATCHEDBY          
                            , VOUCHERDATE        
                            , DEPOSITDATE        
                            , MATCHEDFLAG        
                            , VNO                 
                            , VTYP              
                            , BOOKTYPE            
							, TRAN_STATUS
							, REPORT_FLAG
							,''
							,''
							,''
							,''
							,USERNAME 
							 FROM #TEMP_REPORT WHERE REPORT_FLAG<>'DR'
			         
		END
		
		END
IF (@MATCHEDFLAG = 'D')
BEGIN 


				IF(@BULKDELETE='BULK')
				BEGIN
				
			ALTER TABLE #TEMP_REPORT
			ADD UPLOADFILENAME VARCHAR(100) ,			
			 UPLOADSTATUS VARCHAR(50) ,			
			 FILEUPLOAD_SDATE VARCHAR(100),		
			 FILEUPLOAD_EDATE VARCHAR(100)


				UPDATE TR SET UPLOADFILENAME=RL.UPLOADFILENAME,UPLOADSTATUS=RL.UPLOADSTATUS
				,FILEUPLOAD_SDATE=RL.FILEUPLOAD_SDATE,FILEUPLOAD_EDATE=RL.FILEUPLOAD_EDATE
				FROM RECON_BANK_FILEUPLOAD_LOGS RL,#TEMP_REPORT TR
				WHERE TR.FILEUPLOADID = RL.UPLOADID
				AND RL.FILETYPE=@FILETYPE
				AND RL.BANKNAME=@BANKNAME
				AND( RL.SEGMENT=@SEGMENT OR @SEGMENT='')
				
				
				SELECT 
				ISNULL(FILEUPLOADID, '') AS UPLOADID
				,ISNULL(SEGMENT,'') AS SEGMENT
				,ISNULL(BANK,'') AS 'BANKNAME'
				,ISNULL(BANKACCOUNT,'') AS BANKACCOUNT 
				,ISNULL(ARRANGEMENTTYPE,'') AS FILETYPE
				,CONVERT(VARCHAR(10), ISNULL(VALUEDATE,''), 105) VALUEDATE --R.VALUEDATE
				,ISNULL(UPLOADFILENAME,'') AS UPLOADFILENAME
				,ISNULL(UPLOADSTATUS,'') AS UPLOADSTATUS
				,MIN(CONVERT(NVARCHAR, ISNULL(FILEUPLOAD_SDATE,''), 120)) FILEUPLOAD_SDATE
				,MAX(CONVERT(NVARCHAR, ISNULL(FILEUPLOAD_EDATE,''), 120)) FILEUPLOAD_EDATE
				FROM #TEMP_REPORT
				WHERE ARRANGEMENTTYPE=@FILETYPE
				AND BANK=@BANKNAME			
				GROUP BY ISNULL(FILEUPLOADID, ''),ISNULL(SEGMENT,''),ISNULL(BANK,''),ISNULL(BANKACCOUNT,''),ISNULL(ARRANGEMENTTYPE,''),ISNULL(VALUEDATE,'')
				,ISNULL(UPLOADFILENAME,''),ISNULL(UPLOADSTATUS,''),ISNULL(FILEUPLOAD_SDATE,''),ISNULL(FILEUPLOAD_EDATE,'')

					SELECT
					FILEUPLOADID
					,CONVERT(NVARCHAR, UPLOADDATE, 120) UPLOADDATE
					,EDATE UPLOADENDDATE
					,CONVERT(NVARCHAR, VALUEDATE, 120) VALUEDATE
					--, SDATE
					,MATCHEDDATE
					,SEGMENT
					,BANK
					,ARRANGEMENTTYPE
					,BANKCODE
					,ACCOUNTNO
					,NARRATION
					,CHEQUENO
					,DRCR
					,BANKSTATEMENTAMOUNT
					,VOUCHERAMOUNT
					,BANKLOCATION
					,ANGELLOCATION
					,CLIENTCODE
					,CLIENTNAME
					,STATUS
					,CROSSREFNO
					,VOUCHERNO
					,MATCHEDBY
					,VOUCHERDATE
					,DEPOSITDATE
					,MATCHEDFLAG
					,VNO
					,VTYP
					,BOOKTYPE
					,TRAN_STATUS
					,USERNAME
				FROM #TEMP_REPORT WHERE ARRANGEMENTTYPE=@FILETYPE
				AND BANK=@BANKNAME			

				END
			ELSE			
				BEGIN			
							SELECT			FILEUPLOADID
							, CONVERT(NVARCHAR, UPLOADDATE, 120) UPLOADDATE
							, EDATE UPLOADENDDATE
							, CONVERT(NVARCHAR, VALUEDATE, 120) VALUEDATE
							--, SDATE
							, MATCHEDDATE							
							, SEGMENT
							, BANK
							, ARRANGEMENTTYPE
							, BANKCODE
							, ACCOUNTNO
							, NARRATION
							, CHEQUENO
							, DRCR  
							, BANKSTATEMENTAMOUNT
                            , VOUCHERAMOUNT     
                            , BANKLOCATION       
                            , ANGELLOCATION       
                            , CLIENTCODE         
                            , CLIENTNAME         
                            , STATUS              
                            , CROSSREFNO          
                            , VOUCHERNO           
                            , MATCHEDBY          
                            , VOUCHERDATE        
                            , DEPOSITDATE        
                            , MATCHEDFLAG        
                            , VNO                 
                            , VTYP              
                            , BOOKTYPE            
							, TRAN_STATUS
							, USERNAME
							 FROM #TEMP_REPORT WHERE REPORT_FLAG <>'DR'
							 AND MATCHEDFLAG=0
							 AND (SEGMENT=@SEGMENT OR @SEGMENT='')
							 AND (ARRANGEMENTTYPE=@FILETYPE OR @FILETYPE='')
							 AND (BANK =@BANKNAME OR @BANKNAME='')
							 

		
		IF(@PARAM_VAL1<>'')
		BEGIN

		/*******BANK RECO DELETE************/
		DELETE B
		FROM BANKRECO B, #TEMP_DATA T	WHERE B.CROSSREFERENCENO = T.CROSSREFNO	 
		
		

		IF(@FILETYPE='CMS')
		BEGIN
		
		INSERT INTO RECON_BANK_DELETION_LOGS (UPLOADID, SEGMENT, BANKCODE, BANKNAME, FILETYPE, BANKACCOUNT, UPLOADFILENAME
			, MODIFIEDDATE, UPLOADSTATUS, UPLOADBY, FILEUPLOAD_SDATE, FILEUPLOAD_EDATE, VALUEDATE, ROWTYPE, DRCR, REFERENCENO
			, AMOUNT, DRAWER_NAME, CLTCODE, CLTACCNO, VNO, VTYP, BOOKTYPE, MATCHEDFLAG, UPLOADEDDATE, BOOKDATE, CROSS_NO
			, DESCRIPTION, LEDGERBALANCE, CUSTOMERREFERENCE, TRANSACTIONDETAIL, USERNAME, PERFORMDATE, ERROR1, ERROR2, ERROR3)

			SELECT UPLOADID,'',C.BANKCODE,'','CMS '+@BANKNAME,'','',MODIFIEDDATE,UPLOADSTATUS,UPLOADBY
			,'','',VALUEDATE,ROWTYPE,DRCR,INST_NO_CHECK,INST_AMT,DRAWER_NAME,CLTCODE,CLTACCNO,C.VNO
			,C.VTYP,C.BOOKTYPE,MATCHEDFLAG,UPLOADEDDATE,BOOKDATE,CROSS_NO,'','','',
			'','',GETDATE(),'','','' 
			FROM RECON_CMS_DATA C,#TEMP_DATA T
			WHERE C.CROSS_NO=T.CROSSREFNO
			--AND C.BANKCODE=T.BANKCODE
			AND C.VALUEDATE=T.FINAL_DT
			
			UPDATE C 
			SET ROWTYPE='DR'
			FROM RECON_CMS_DATA C,#TEMP_DATA T
			WHERE C.CROSS_NO=T.CROSSREFNO
		END

		IF(@FILETYPE='NON-CMS')
		BEGIN
		
			INSERT INTO RECON_BANK_DELETION_LOGS (UPLOADID, SEGMENT, BANKCODE, BANKNAME, FILETYPE, BANKACCOUNT, UPLOADFILENAME
			, MODIFIEDDATE, UPLOADSTATUS, UPLOADBY, FILEUPLOAD_SDATE, FILEUPLOAD_EDATE, VALUEDATE, ROWTYPE, DRCR, REFERENCENO
			, AMOUNT, DRAWER_NAME, CLTCODE, CLTACCNO, VNO, VTYP, BOOKTYPE, MATCHEDFLAG, UPLOADEDDATE, BOOKDATE, CROSS_NO
			, DESCRIPTION, LEDGERBALANCE, CUSTOMERREFERENCE, TRANSACTIONDETAIL, USERNAME, PERFORMDATE, ERROR1, ERROR2, ERROR3)
			SELECT UPLOADID,'',C.BANKCODE,'','NONCMS '+@BANKNAME,BANKACCOUNT,'',MODIFIEDDATE,UPLOADSTATUS,UPLOADBY,
			'','',VALUEDATE,'',DRCR,REFERENCENO,AMT,'','',CLTACCOUNT,C.VNO,
			C.VTYP,C.BOOKTYPE,MATCHEDFLAG,UPLOADEDDATE,BOOKDATE,CROSS_NO,DESCRIPTION,LEDGERBALANCE,CUSTOMERREFERENCE,
			TRANSACTIONDETAIL,'',GETDATE(),'','',''
			FROM RECON_NONCMS_DATA C,#TEMP_DATA T
			WHERE C.CROSS_NO=T.CROSSREFNO
			--AND C.BANKCODE=T.BANKCODE
			AND C.VALUEDATE=T.FINAL_DT
			
			UPDATE C 
			SET LEDGERBALANCE='DR'
			FROM RECON_NONCMS_DATA C,#TEMP_DATA T
			WHERE C.CROSS_NO=T.CROSSREFNO
		END
		END
		END
		
END

	DROP TABLE #TEMP_DATA
	DROP TABLE #TEMP_REPORT
	DROP TABLE #LEDGER_TO_MAP
	DROP TABLE #TEMP_MATCHED_REPORT
	DROP TABLE #TEMP_UNMATCHED_REPORT

END

GO
