-- Object: PROCEDURE dbo.OFFLINE_POST_LEDGER_BAK_11042017
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------





CREATE PROC [dbo].[OFFLINE_POST_LEDGER_BAK_11042017]                
(                
           @UNAME     VARCHAR(25),                                    
           @USERCAT   INT,                                    
           @EXCHANGE  VARCHAR(3),                                    
           @SEGMENT   VARCHAR(10),                                    
           @RECOFLAG  CHAR(1) = 'N'                                   
)                
                
AS
DECLARE @@LEDVDT VARCHAR(11)                
DECLARE @@VTYP SMALLINT            
            
DECLARE LEDPOST CURSOR FOR                
 --SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                
 SELECT DISTINCT LEFT(VDATE,11) AS VDT, VOUCHERTYPE             
 FROM ANAND.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES                
 WHERE EXCHANGE = @EXCHANGE                
 AND SEGMENT = @SEGMENT                
 AND ROWSTATE = 0                
 AND VDATE NOT LIKE 'JAN  1 1900%'                
                
OPEN LEDPOST                
                
-- Perform the first fetch.                
FETCH NEXT FROM LEDPOST INTO @@LEDVDT, @@VTYP                 
                
-- Check @@FETCH_STATUS to see if there are any more rows to fetch.                
WHILE @@FETCH_STATUS = 0                
BEGIN                
       
IF @@VTYP = 3             
 BEGIN            
   EXEC V2_OFFLINE_PAYMENTUPLOAD @UNAME,@USERCAT,@EXCHANGE, @SEGMENT,@@LEDVDT, @RECOFLAG                
 END   
 
 
IF @@VTYP = 8             
 BEGIN            
   EXEC V2_OFFLINE_JVDRCRUPLOAD_RND @UNAME,@USERCAT,@EXCHANGE, @SEGMENT,@@LEDVDT, @RECOFLAG,@@VTYP                
 END        
           
 IF @@VTYP = 2             
 BEGIN            
   EXEC V2_OFFLINE_RECPAYUPLOAD @UNAME,@USERCAT,@EXCHANGE, @SEGMENT,@@LEDVDT, @RECOFLAG                
 END          

 /*IF @@VTYP = 8             
 BEGIN            
   EXEC V2_OFFLINE_JVDRCRUPLOAD @UNAME,@USERCAT,@EXCHANGE, @SEGMENT,@@LEDVDT, @RECOFLAG,@@VTYP                
 END           
*/                 
-- This is executed as long as the previous fetch succeeds.                
   FETCH NEXT FROM LEDPOST INTO @@LEDVDT, @@VTYP                 
END                
                
CLOSE LEDPOST                
DEALLOCATE LEDPOST

GO
