-- Object: PROCEDURE dbo.Asian_Proc_MarginComm
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE    PROC Asian_Proc_MarginComm (@Sauda_Date Varchar(11))      
As      
  
      SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'C' Then VAmt Else -VAmt End),  
      Margin = convert(Numeric(18,4),0)  
      INTO #AMR_LEDGER       
      FROM      
            ACCCOMMODITY.DBO.Ledger L with(nolock),       
            ACCCOMMODITY.DBO.Parameter P,  
     ACCCOMMODITY.DBO.ACMAST A with(nolock)           
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
            ACCCOMMODITY.DBO.Ledger L,       
            ACCCOMMODITY.DBO.Parameter P,  
     ACCCOMMODITY.DBO.ACMAST A with(nolock)              
      Where       
            EDt <= @Sauda_Date + ' 23:59:59'              
            And Vdt < SdtCur          
            And Edt >= SdtCur           
            And Curyear = 1           
     And A.CLTCODE = L.CLTCODE  
     AND ACCAT = 4   
      Group by L.CLTCODE   
  
      INSERT INTO #AMR_LEDGER  
      SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'C' Then VAmt Else -VAmt End),  
      Margin = convert(Numeric(18,4),0)        
      FROM      
            AccountNCDX.DBO.Ledger L with(nolock),       
            AccountNCDX.DBO.Parameter P,  
     AccountNCDX.DBO.ACMAST A with(nolock)           
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
            AccountNCDX.DBO.Ledger L,       
            AccountNCDX.DBO.Parameter P,  
     AccountNCDX.DBO.ACMAST A with(nolock)              
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
            AccountMCDX.DBO.Ledger L with(index(ledind),nolock),       
            AccountMCDX.DBO.Parameter P,  
     AccountMCDX.DBO.ACMAST A with(nolock)              
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
            AccountMCDX.DBO.Ledger L,       
            AccountMCDX.DBO.Parameter P,  
     AccountMCDX.DBO.ACMAST A with(nolock)              
      Where       
            EDt <= @Sauda_Date + ' 23:59:59'              
            And Vdt < SdtCur          
            And Edt >= SdtCur           
            And Curyear = 1           
     And A.CLTCODE = L.CLTCODE  
     AND ACCAT = 4   
      Group by L.CLTCODE            
   
      
      INSERT INTO #AMR_LEDGER      
      SELECT HEADER = '03', CLTCODE = PARTY_CODE, AMR = Sum(CASH),0     
      from COLLATERAL       
      WHERE TRANS_DATE LIKE @Sauda_Date + '%'     
      AND EXCHANGE IN ('NCX','MCX')
      GROUP BY PARTY_CODE      

/*      
      INSERT INTO #AMR_LEDGER  
      SELECT HEADER = '03', PARTY_CODE, AMR = 0, MARGIN = SUM(TOTALMARGIN+MTOM+ADDMARGIN)  
      FROM NCDX.DBO.FOMARGINNEW  
      WHERE MDATE LIKE @Sauda_Date + '%'     
      GROUP BY PARTY_CODE  

      INSERT INTO #AMR_LEDGER  
      SELECT HEADER = '03', PARTY_CODE, AMR = 0, MARGIN = SUM(TOTALMARGIN+MTOM+ADDMARGIN)  
      FROM MCDX.DBO.FOMARGINNEW  
      WHERE MDATE LIKE @Sauda_Date + '%'     
      GROUP BY PARTY_CODE    
*/
  
      SELECT HEADER, CLTCODE, AMR=SUM(AMR), MARGIN = 'COM'
      FROM #AMR_LEDGER      
      GROUP BY HEADER, CLTCODE      
      ORDER BY CLTCODE

GO
