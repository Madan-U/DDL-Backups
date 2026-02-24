-- Object: PROCEDURE dbo.BRANCH_SUBBROKER_UPDATE
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE [dbo].[BRANCH_SUBBROKER_UPDATE]                              
 @FILENAME VARCHAR(1000),                              
 @UNAME VARCHAR(50)                              
AS                              
                            
                              
                              
TRUNCATE TABLE BRANCH_SUBBROKER    

                              
CREATE TABLE #BRANCH_SUBBROKER
(                              
 FILE_DATA VARCHAR(MAX),                              
 SRNO INT IDENTITY(1, 1)                              
)                              
                              
--INSERT INTO #VIRTUAL_MIS_LEDGER  EXEC MASTER.DBO.XP_CMDSHELL 'TYPE D:\BACKOFFICE\VIRTUAL_BANK_FORMAT.CSV'                              
                              
DECLARE                              
 @@SQL VARCHAR(MAX)                              
                               
SET @@SQL = "INSERT INTO  #BRANCH_SUBBROKER "                              
SET @@SQL = @@SQL + " EXEC MASTER.DBO.XP_CMDSHELL 'TYPE " + @FILENAME + "'"                              
        --SELECT * FROM    #VIRTUAL_MIS_LEDGER                         
--RETURN                          
--PRINT @@SQL                              
                              
EXEC(@@SQL)


select * from     #BRANCH_SUBBROKER                          
                                 
                            
INSERT INTO BRANCH_SUBBROKER                               
SELECT                               
  .DBO.PIECE(FILE_DATA, ',', 1), 
 .DBO.PIECE(FILE_DATA, ',', 2),                              
 .DBO.PIECE(FILE_DATA, ',', 3),                              
 .DBO.PIECE(FILE_DATA, ',', 4),                              
 .DBO.PIECE(FILE_DATA, ',', 5)                              
                            
FROM #BRANCH_SUBBROKER


drop table #BRANCH_SUBBROKER
select * from BRANCH_SUBBROKER

GO
