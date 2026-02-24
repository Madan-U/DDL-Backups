-- Object: PROCEDURE dbo.LEDGER_GL_MFSS_OPENING_BALANCE_NXT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/*
LEDGER_GL_MFSS_OPENING_BALANCE_NXT 'Apr  1 2022','Mar 31 2023', 'Apr  1 2022','Mar 31 2023','48BBLM', '48BBLM'
*/

CREATE PROCEDURE LEDGER_GL_MFSS_OPENING_BALANCE_NXT
@SDATE VARCHAR(11),                    
@EDATE VARCHAR(11),                     
@FDATE VARCHAR(11),                   
@TDATE VARCHAR(11), 
@FCODE VARCHAR(10),
@TCODE VARCHAR(10)
AS
BEGIN

DECLARE          
@OPENDATE   AS VARCHAR(11) 
Create table #Financial_Ledger_OneTime
(
FY Varchar(200)
,Date date
,VoucherType Varchar(200)
,VrNo Varchar(200)
,ChequeNo Varchar(200)
,Particulars Varchar(2000)
,DebitAmt numeric(18,2)
,CreditAmt numeric(18,2)
,Balance numeric(18,2)
,SBCode Varchar(200)
)
Insert into #Financial_Ledger_OneTime
EXEC usp_get_Financial_Ledger_OneTime @FCODE,@SDATE,@EDATE
 SELECT @OPENDATE = (SELECT LEFT(CONVERT(VARCHAR,ISNULL(SDTCUR,0),109),11) FROM PARAMETER (NOLOCK) WHERE @SDATE BETWEEN SDTCUR AND LDTCUR) 
   
IF @SDATE = @FDATE          
BEGIN          
    IF @OPENDATE = @FDATE   
		BEGIN          
		print 'AA'
			SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
			SELECT CLTCODE, OPBAL = SUM( CASE WHEN UPPER(DRCR) = 'D' THEN VAMT ELSE -VAMT END)          
			FROM LEDGER  (NOLOCK)           
			WHERE CLTCODE = @FCODE AND VDT LIKE @OPENDATE + '%' AND VTYP = 18          
			GROUP BY CLTCODE          
			UNION
			SELECT [SBCode] , OPBAL = ( CASE WHEN (DebitAmt) <> 0 THEN DebitAmt ELSE CreditAmt*-1.0 END)          
			FROM #Financial_Ledger_OneTime (NOLOCK)           
			WHERE [SBCode] = @FCODE --AND VDT LIKE @OPENDATE + '%' AND VTYP = 18          
			and  Particulars ='Opening Balance'    
			--GROUP BY [SBCode]     
		END          
    ELSE          
		BEGIN          
		Print 'BB'
			SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED            
			SELECT CLTCODE, OPBAL = SUM( CASE WHEN UPPER(DRCR) = 'D' THEN VAMT ELSE -VAMT END)          
			FROM LEDGER  (NOLOCK)           
			WHERE CLTCODE = @FCODE AND VDT >= @OPENDATE + ' 00:00:00' AND VDT < @FDATE           
			GROUP BY CLTCODE          
			UNION
			SELECT [SBCode] , OPBAL = ( CASE WHEN (DebitAmt) <> 0 THEN DebitAmt ELSE CreditAmt*-1.0 END)          
			FROM #Financial_Ledger_OneTime (NOLOCK)           
			WHERE [SBCode] = @FCODE --AND VDT LIKE @OPENDATE + '%' AND VTYP = 18          
			and  Particulars ='Opening Balance'    
			--GROUP BY [SBCode]     
		END          
END          
ELSE          

	BEGIN        
	print 'CC'
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
		SELECT CLTCODE, OPBAL = SUM( CASE WHEN UPPER(DRCR) = 'D' THEN VAMT ELSE -VAMT END)          
		FROM LEDGER  (NOLOCK)           
		WHERE CLTCODE = @FCODE AND VDT >= @OPENDATE + ' 00:00:00' AND VDT < @FDATE           
		GROUP BY CLTCODE         
	
		UNION
		SELECT [SBCode] , OPBAL = ( CASE WHEN (DebitAmt) <> 0 THEN DebitAmt ELSE CreditAmt*-1.0 END)          
		FROM #Financial_Ledger_OneTime (NOLOCK)           
		WHERE [SBCode] = @FCODE --AND VDT LIKE @OPENDATE + '%' AND VTYP = 18     
		and  Particulars ='Opening Balance'    
		--GROUP BY [SBCode]     
	END          


END

GO
