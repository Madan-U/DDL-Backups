-- Object: PROCEDURE dbo.LEDGER_GL_MFSS_NXT_11
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/*

EXEC usp_get_Financial_Ledger_OneTime '48GRW','Apr 1 2016','mar 31 2017'
			EXEC LEDGER_GL_MFSS_NXT 'Apr 1 2019','mar 31 2020', 'Apr 1 2019','mar 31 2020','48ADHC', '48ADHC'
		 EXEC LEDGER_GL_MFSS_NXT 'Apr 1 2017','mar 31 2018', 'Apr 1 2017','mar 31 2018','48ADHC', '48ADHC'
		 EXEC LEDGER_GL_MFSS_NXT 'Apr 1 2016','mar 31 2017','Apr 1 2016','mar 31 2017', '48ROK', '48ROK'
*/


	CREATE  PROC LEDGER_GL_MFSS_NXT_11

		(

	@SDATE VARCHAR(11),                    
	@EDATE VARCHAR(11),                     
	@FDATE VARCHAR(11),                   
	@TDATE VARCHAR(11), 
	@FCODE VARCHAR(10),
	@TCODE VARCHAR(10)

		 

		) 

		 AS



DECLARE          
@@OPENDATE   AS VARCHAR(11) 
--DECLARE  
--@SDATE VARCHAR(11) = 'Apr  1 2019'

--declare @FDATE VARCHAR(11) = 'Apr  1 2019'

--declare @FCODE VARCHAR(10) = '48dsb'

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


select  @FCODE,@SDATE,@EDATE

Insert into #Financial_Ledger_OneTime
EXEC usp_get_Financial_Ledger_OneTime @FCODE,@SDATE,@EDATE

--select * from #Financial_Ledger_OneTime
 
 SELECT @@OPENDATE = (SELECT LEFT(CONVERT(VARCHAR,ISNULL(SDTCUR,0),109),11) FROM PARAMETER (NOLOCK) WHERE @SDATE BETWEEN SDTCUR AND LDTCUR) 
         
   IF @SDATE = @FDATE          
   BEGIN          
    IF @@OPENDATE = @FDATE           
    BEGIN          
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
     SELECT CLTCODE, OPBAL = SUM( CASE WHEN UPPER(DRCR) = 'D' THEN VAMT ELSE -VAMT END)          
     FROM LEDGER  (NOLOCK)           
     WHERE CLTCODE = @FCODE AND VDT LIKE @@OPENDATE + '%' AND VTYP = 18          
     GROUP BY CLTCODE          
    UNION
	SELECT [SBCode] , OPBAL = ( CASE WHEN (DebitAmt) <> 0 THEN DebitAmt ELSE CreditAmt*-1.0 END)          
     FROM #Financial_Ledger_OneTime (NOLOCK)           
     WHERE [SBCode] = @FCODE --AND VDT LIKE @@OPENDATE + '%' AND VTYP = 18          
	 and  Particulars ='Opening Balance'    
     --GROUP BY [SBCode]     
	
	
	
	END          
    ELSE          
    BEGIN          
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED            
     SELECT CLTCODE, OPBAL = SUM( CASE WHEN UPPER(DRCR) = 'D' THEN VAMT ELSE -VAMT END)          
     FROM LEDGER  (NOLOCK)           
     WHERE CLTCODE = @FCODE AND VDT >= @@OPENDATE + ' 00:00:00' AND VDT < @FDATE           
     GROUP BY CLTCODE          
    UNION

	SELECT [SBCode] , OPBAL = ( CASE WHEN (DebitAmt) <> 0 THEN DebitAmt ELSE CreditAmt*-1.0 END)          
     FROM #Financial_Ledger_OneTime (NOLOCK)           
     WHERE [SBCode] = @FCODE --AND VDT LIKE @@OPENDATE + '%' AND VTYP = 18          
	 and  Particulars ='Opening Balance'    
     --GROUP BY [SBCode]     
	
	
	END          
   END          
   ELSE          
   BEGIN          
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
    SELECT CLTCODE, OPBAL = SUM( CASE WHEN UPPER(DRCR) = 'D' THEN VAMT ELSE -VAMT END)          
    FROM LEDGER  (NOLOCK)           
    WHERE CLTCODE = @FCODE AND VDT >= @@OPENDATE + ' 00:00:00' AND VDT < @FDATE           
    GROUP BY CLTCODE         
	
	UNION
	SELECT [SBCode] , OPBAL = ( CASE WHEN (DebitAmt) <> 0 THEN DebitAmt ELSE CreditAmt*-1.0 END)          
     FROM #Financial_Ledger_OneTime (NOLOCK)           
     WHERE [SBCode] = @FCODE --AND VDT LIKE @@OPENDATE + '%' AND VTYP = 18     
	 and  Particulars ='Opening Balance'    
     --GROUP BY [SBCode]     
	 
   END          


		

		BEGIN 

		Print 'AA'

         SELECT  L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, 
		 		 DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),  
				  CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), 
				   L.VNO,
				 DDNO= ISNULL((SELECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VTYP=L.VTYP 
		 AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''),
		 NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') ,
		  L.CLTCODE, A.LONGNAME, VTYP, L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, 
		  CONVERT(VARCHAR,L.EDT,103) EDT, L.ACNAME, EDIFF=DATEDIFF(D,L.EDT,GETDATE()) 

		  
			  FROM LEDGER L  (NOLOCK) LEFT OUTER JOIN ACMAST A  (NOLOCK) 

			ON L.CLTCODE = A.CLTCODE , VMAST  (NOLOCK)     

				WHERE L.VDT >= @FDATE  AND   L.VDT <= @TDATE +' 23:59:59'                      
		  AND L.VTYP <> 18 
		  AND L.CLTCODE = A.CLTCODE 
		--AND ACCAT = '4'
		  AND L.CLTCODE >= @FCODE   AND L.CLTCODE <= @TCODE  
		  AND L.VTYP = VTYPE 
		  

		  UNION

		  Select 
		  	  '01' BOOKTYPE,Date VOUDT,Date EFFDT,replace(VoucherType,'-','') SHORTDESC,DebitAmt DRAMT,CreditAmt CRAMT,VrNo VNO,'' DDNO,Particulars NARRATION,SBCode CLTCODE,'' LONGNAME,'' VTYP,'' BOOKTYPE,convert(varchar(100),Date) VDT,'' EDT,''  ACNAME,'' EDIFF

		   From 
			#Financial_Ledger_OneTime
			Where Particulars not in ('Closing Balance','Opening Balance')

			--UNION

		 -- Select 
		 -- 	  '01' BOOKTYPE,Date VOUDT,Date EFFDT,replace(VoucherType,'-','') SHORTDESC,DebitAmt DRAMT,CreditAmt CRAMT,VrNo VNO,'' DDNO,Particulars NARRATION,SBCode CLTCODE,'' LONGNAME,'' VTYP,'' BOOKTYPE,convert(varchar(100),Date) VDT,'' EDT,''  ACNAME,'' EDIFF
		 --  From 
			--#Financial_Ledger_OneTime
			--Where Particulars='Closing Balance'
		  ORDER BY L.CLTCODE, VOUDT,  L.VNO 

 END

GO
