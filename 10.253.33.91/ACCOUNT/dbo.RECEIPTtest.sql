-- Object: PROCEDURE dbo.RECEIPTtest
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

              
--RECEIPTtest '20/08/2015','04/09/2015'                      
                                  
CREATE PROC [dbo].[RECEIPTtest]                                            
(                                            
@FROMDATE varchar(11) ,                                            
@TODATE   varchar(11)                                       
                                          
)                                            
AS                                             
                        
                        
IF LEN(@FROMDATE) = 10 AND CHARINDEX('/', @FROMDATE) > 0                        
                        
BEGIN                        
                        
      SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103), 109)                        
                        
END                        
                        
IF LEN(@TODATE) = 10 AND CHARINDEX('/', @TODATE) > 0                        
                        
BEGIN                        
                        
      SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103), 109)                        
                        
END                        
                        
                         
 print @FROMDATE                        
                        
                        
BEGIN                                             
--SELECT *   
--INTO #TEMP FROM (                                            
                                  
SELECT                                            
                                           
--[CLTCODE]=CLTCODE,                                            
--[VDT]    =VDT,                                            
--[VNO]    =VNO,                                  
[NARRATION]=left(REPLACE(LTRIM(RTRIM(NARRATION)), '"', ''),300)                                        
--[VAMT]   =VAMT,                                            
--[DRCR]   =DRCR,                                            
----[DDNO]   =DDNO,                                            
--[VTYP]   =VTYP,                                            
----[RELDT]  =RELDT,                                            
--[BOOKTYPE]=BOOKTYPE,                                  
--[EXCHANGE]='BSE'                                            
                                    
FROM ANAND.ACCOUNT_AB.DBO.LEDGER                                           
WHERE                                    
 DRCR ='D' AND VTYP ='2' AND VDT >= @FROMDATE AND VDT < =@TODATE + ' 23:59'                                
                                    
--UNION ALL                                            
                                            
--SELECT CLTCODE,L.VDT,L.VNO,[NARRATION]=left(REPLACE(LTRIM(RTRIM(L.NARRATION)), '"', ''),100),L.VAMT,L.DRCR,L1.DDNO,                                            
-- L.VTYP,L1.RELDT,L.BOOKTYPE,[EXCHANGE]='BSE'                                            
-- FROM ANAND.ACCOUNT_AB.DBO.LEDGER L(NOLOCK),ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                                            
--WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                                          
--AND L.DRCR ='C' AND L.VTYP ='2'  AND L.VDT >=@FROMDATE AND L.VDT < =@TODATE + ' 23:59'                                     
                                  
--  )A                                            
                                      
                                    

                                        
 END

GO
