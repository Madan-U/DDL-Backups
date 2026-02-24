-- Object: PROCEDURE dbo.Asian_Proc_Margin
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE     PROC Asian_Proc_Margin (@Sauda_Date Varchar(11))    
As    

      SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'C' Then VAmt Else -VAmt End),
      Margin = convert(Numeric(18,4),0)      
      INTO #AMR_LEDGER FROM    
            Account.DBO.Ledger L with(nolock),     
            Account.DBO.Parameter P,
	    Account.DBO.ACMAST A with(nolock)         
      Where     
            EDt <= @Sauda_Date + ' 23:59:59'            
            And Edt >= SdtCur        
            And Edt <= LdtCur         
            And Curyear = 1
	    And A.CLTCODE = L.CLTCODE
	    AND ACCAT = 4 	         
      Group by L.CLTCODE    
    
      INSERT INTO #AMR_LEDGER    
      SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'D' Then VAmt Else -VAmt End),0
      from     
            Account.DBO.Ledger L,     
            Account.DBO.Parameter P,
	    Account.DBO.ACMAST A with(nolock)            
      Where     
            EDt <= @Sauda_Date + ' 23:59:59'            
            And Vdt < SdtCur        
            And Edt >= SdtCur         
            And Curyear = 1         
	    And A.CLTCODE = L.CLTCODE
	    AND ACCAT = 4 
      Group by L.CLTCODE    
    
      INSERT INTO #AMR_LEDGER    
      SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'C' Then VAmt Else -VAmt End),0    
      FROM    
            AccountBSE.DBO.Ledger L with(index(ledind),nolock),     
            AccountBSE.DBO.Parameter P,
	    AccountBSE.DBO.ACMAST A with(nolock)            
      Where     
            EDt <= @Sauda_Date + ' 23:59:59'            
            And Edt >= SdtCur        
            And Edt <= LdtCur         
            And Curyear = 1        
	    And A.CLTCODE = L.CLTCODE
	    AND ACCAT = 4  
      Group by L.CLTCODE    
    
      INSERT INTO #AMR_LEDGER    
      SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'D' Then VAmt Else -VAmt End),0    
      from     
            AccountBSE.DBO.Ledger L,     
            AccountBSE.DBO.Parameter P,
	    AccountBSE.DBO.ACMAST A with(nolock)            
      Where     
            EDt <= @Sauda_Date + ' 23:59:59'            
            And Vdt < SdtCur        
            And Edt >= SdtCur         
            And Curyear = 1         
	    And A.CLTCODE = L.CLTCODE
	    AND ACCAT = 4 
      Group by L.CLTCODE    
    
      INSERT INTO #AMR_LEDGER    
      SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'C' Then VAmt Else -VAmt End),0    
      FROM    
            AccountFO.DBO.Ledger L with(index(ledind),nolock),     
            AccountFO.DBO.Parameter P,
	    Accountfo.DBO.ACMAST A with(nolock)            
      Where     
            EDt <= @Sauda_Date + ' 23:59:59'            
            And Edt >= SdtCur        
            And Edt <= LdtCur         
            And Curyear = 1         
	    And A.CLTCODE = L.CLTCODE
	    AND ACCAT = 4 
      Group by L.CLTCODE    
    
      INSERT INTO #AMR_LEDGER    
      SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'D' Then VAmt Else -VAmt End),0    
      from     
            AccountFO.DBO.Ledger L,     
            AccountFO.DBO.Parameter P,
	    AccountFO.DBO.ACMAST A with(nolock)            
      Where     
            EDt <= @Sauda_Date + ' 23:59:59'            
            And Vdt < SdtCur        
            And Edt >= SdtCur         
            And Curyear = 1         
	    And A.CLTCODE = L.CLTCODE
	    AND ACCAT = 4 
      Group by L.CLTCODE    
/*    
      INSERT INTO #AMR_LEDGER    
      SELECT HEADER = '03', CLTCODE = PARTY_CODE, AMR = Sum(CASH),0   
      from COLLATERAL     
      WHERE TRANS_DATE LIKE @Sauda_Date + '%'   
      GROUP BY PARTY_CODE    
    
      INSERT INTO #AMR_LEDGER
      SELECT HEADER = '03', PARTY_CODE, AMR = 0, MARGIN = SUM(TOTALMARGIN+MTOM+ADDMARGIN)
      FROM NSEFO.DBO.FOMARGINNEW
      WHERE MDATE LIKE @Sauda_Date + '%'   
      GROUP BY PARTY_CODE
*/
      SELECT HEADER, CLTCODE, AMR=SUM(AMR)--, MARGIN = SUM(MARGIN)
      FROM #AMR_LEDGER    
      GROUP BY HEADER, CLTCODE    
      ORDER BY CLTCODE

GO
