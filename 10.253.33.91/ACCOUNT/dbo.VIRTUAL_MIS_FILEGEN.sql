-- Object: PROCEDURE dbo.VIRTUAL_MIS_FILEGEN
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE [dbo].[VIRTUAL_MIS_FILEGEN]  
(  
 @SQLQRY varchar(1000),  
 @DATASERVER varchar(50) ,  
 @FNAME VARCHAR(500)  
)  
AS  
  
DECLARE  
 @@SQL VARCHAR(MAX),
 @@FILE_QRY VARCHAR(1000)
 
   SET  @@FILE_QRY = " SELECT ''SRNO'', ''EDATE'', ''VDATE'', ''CLTCODE'', ''AMOUNT'', ''DRCR'', ''NARRATION'', ''BANK_CODE'', ''BANK_NAME'',''REF_NO'', ''BRANCHCODE'', ''BRANCH_NAME'', ''CHQ_MODE'', ''CHQ_DATE'', ''CHQ_NAME'', ''CL_MODE'', ''ACCOUNTNO'' "
   SET  @@FILE_QRY = @@FILE_QRY + " UNION ALL "
   SET  @@FILE_QRY = @@FILE_QRY + @SQLQRY

  
 SELECT @@SQL = "DECLARE @@ERR AS INT EXEC @@ERR = MASTER.DBO.XP_CMDSHELL 'BCP " + CHAR(34) + @@FILE_QRY + " " + CHAR(34) + " queryout " + CHAR(34) + @FNAME + CHAR(34) + " -c -q -t " + CHAR(34) + "," + CHAR(34) + " -T -S "+ CHAR(34) + CHAR(34) + @DATASERVER + CHAR(34) + "', no_output"  
 PRINT @@SQL  
 EXEC (@@SQL)

GO
