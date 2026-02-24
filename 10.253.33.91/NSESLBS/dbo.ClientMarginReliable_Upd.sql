-- Object: PROCEDURE dbo.ClientMarginReliable_Upd
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc ClientMarginReliable_Upd 
	(
		@mdate varchar(11) 
	) AS    
BEGIN     
	DECLARE @@opendate  AS VARCHAR(11)      
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
	SELECT * INTO #Tbl_ClientMarginReliable FROM Tbl_ClientMarginReliable WHERE 1=2    

	--- Get the Party Code Details	
	INSERT INTO #Tbl_ClientMarginReliable
	(
		Party_Code,
		Short_Name,
		Margindate,
		Billamount,
		Ledgeramount,
		Cash_Coll,
		Noncash_Coll,
		Initialmargin,
		Lst_Update_Dt,
		Mtmmargin
	)     
	SELECT DISTINCT  
		c2.party_code,
		C1.Short_Name,
		@mdate + ' 00:00',
		0 AS Billamount,
		0 AS Ledgeramount,
		0 AS Cash_Coll,
		0 AS Noncash_Coll,
		0 AS Initialmargin,
		GetDate() AS Lst_Update_Dt,
		0 AS Mtmmargin
	FROM Client2 C2, Client1 C1    
	WHERE LTrim(RTrim(C1.Cl_Code)) = LTrim(RTrim(C2.Cl_Code))    
	
	--- Get the Bill Amount
	SELECT 
		Party_Code,
		Amount = ISNULL(SUM((CASE WHEN sell_buy=2 THEN isnull(amount,0) ELSE (0-isnull(amount,0)) END)),0)      
	INTO #PartyBill    
	FROM FoAccBill
	WHERE	Party_Code IN (SELECT DISTINCT party_code FROM #Tbl_ClientMarginReliable) 
	AND BillDate LIKE @mdate +'%'    
	GROUP BY party_Code    
	
	UPDATE T SET BillAmount = Amount 
		FROM #Tbl_ClientMarginReliable T, #PartyBill P
		WHERE P.Party_Code = T.Party_Code    
	
	/*Getting Closing balance from Ledger with out  today's bill*/    
	SELECT * INTO #Ledger  
		FROM AccountFO.dbo.ledger 
		WHERE CltCode IN (SELECT DISTINCT Party_Code FROM #Tbl_ClientMarginReliable)    
	
	SELECT @@OpenDate = ( Select left(convert(varchar,isnull(max(vdt),0),109),11) FROM #Ledger WHERE vtyp= 18 AND vdt <= @mdate +' 23:59' )      
	
	SELECT CltCode, OppBal=Vamt INTO #OppBalance FROM #Ledger WHERE 1=2      
	
	IF @@opendate <> ''    
	BEGIN      
		INSERT INTO  #OppBalance       
		SELECT CltCode,Sum(OppBal) OppBal FROM     
		(    
			SELECT CltCode, OppBal = ISNULL(SUM( CASE WHEN UPPER(b.DrCr) = 'C' THEN B.Vamt ELSE -B.Vamt END),0)      
			FROM #Ledger B WHERE B.vdt LIKE @@opendate + '%' AND vtyp = 18  
			GROUP BY CltCode      
			
			UNION ALL   
			
			Select CltCode,oppbal = ISNULL(SUM( CASE WHEN UPPER(b.drcr) = 'C' THEN b.vamt ELSE -b.vamt END),0)        
			FROM #Ledger b  WHERE B.vdt >=  @@opendate AND vdt < @mdate AND vtyp <> 18     
			GROUP BY CltCode  
		) T    
		GROUP BY CltCode      
	END    
	ELSE    
	BEGIN    
		INSERT INTO  #OppBalance       
		SELECT CltCode,oppbal = ISNULL(SUM( CASE WHEN UPPER(b.drcr) = 'C' THEN b.vamt ELSE -b.vamt END),0)        
		FROM #Ledger b  WHERE  vdt < @mdate     
		GROUP BY CltCode      
	END    
	
	SELECT CltCode,ROUND(SUM(OppBal),2) OppBal     
	INTO  #OppBalanceFinal    
	FROM    
	(    
	SELECT cltcode,Sum(OppBal) OppBal FROM #OppBalance      
	GROUP BY CltCode      
	
	UNION ALL    
	
	SELECT CltCode,oppbal = ISNULL(SUM( CASE WHEN UPPER(b.drcr) = 'C' THEN b.vamt ELSE -b.vamt END),0)        
	FROM #Ledger b  WHERE  vdt LIKE  @mdate + '%'  AND  vtyp NOT IN (18,15)     
	GROUP BY CltCode      
	) T    
	GROUP BY CltCode      
	
	UPDATE T SET ledgeramount=OppBal FROM #Tbl_ClientMarginReliable t,#OppBalanceFinal p WHERE p.cltcode = t.Party_Code    
	
	/*getting collateral from msajag*/    
	SELECT 
		party_code, 
		cash = isnull(cash,0), 
		noncash=isnull(noncash,0)  
	INTO #collateral    
	FROM msajag.dbo.collateral      
	WHERE Exchange = 'NSE'      
	AND segment like 'FUT%'      
	AND party_code in (SELECT DISTINCT party_code FROM #Tbl_ClientMarginReliable)  
	AND trans_date like @mdate + '%'      
	
	UPDATE T SET 
		cash_coll = cash, 
		noncash_coll = noncash 
	FROM #Tbl_ClientMarginReliable t, #collateral p   
	WHERE p.Party_Code = t.Party_Code    
	
	/*getting reliable margin details*/    
	SELECT  
		party_code, 
		sum(pspanmargin) marginamount, 
		mtmmargin = sum(mtom)  
	INTO #Margin    
	FROM FoMarginReliable
	WHERE cl_type like 'C%' and Mdate like  (select Left(max(mdate),11) FROM FoMarginReliable  WHERE mdate <=  @mdate) + '%'  
	GROUP BY party_code     
	
	UPDATE T SET 
		initialmargin=p.marginamount,
		MTMMargin=p.mtmmargin 
	FROM #Tbl_ClientMarginReliable t, #Margin p   
	WHERE p.Party_Code = t.Party_Code    
	
	/*updating Tbl_ClientMarginReliable*/    
	DELETE Tbl_ClientMarginReliable WHERE margindate LIKE @mdate + '%'    

	INSERT  INTO Tbl_ClientMarginReliable 
	(
		Party_Code,
		Short_Name,
		Margindate,
		Billamount,
		Ledgeramount,
		Cash_Coll,
		Noncash_Coll,
		Initialmargin,
		Lst_Update_Dt,
		Mtmmargin,
		ShortFallMargin
	)
	SELECT
		Party_Code,
		Short_Name,
		Margindate,
		Billamount,
		Ledgeramount,
		Cash_Coll,
		Noncash_Coll,
		Initialmargin,
		Lst_Update_Dt,
		Mtmmargin,
		ABS((BillAmount + LedgerAmount + Cash_Coll + NonCash_Coll) - (InitialMargin + MtmMargin)) AS ShortFallMargin
	FROM #Tbl_ClientMarginReliable  
	WHERE	(billamount<>0 OR initialmargin <> 0 OR ledgeramount <> 0 OR cash_coll <> 0 OR noncash_coll <> 0)    
	ORDER BY party_code    
	
END

/*

Exec ClientMarginReliable_Upd 'Jul 17 2007'

Select * From Account.Dbo.Ledger

Select Distinct VTyp, BookType From Account.Dbo.Ledger Order By VTyp, BookType

Select * From Account.Dbo.BookType Order By VTyp


*/

GO
