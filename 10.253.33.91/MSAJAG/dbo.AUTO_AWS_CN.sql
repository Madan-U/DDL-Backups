-- Object: PROCEDURE dbo.AUTO_AWS_CN
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 
 CREATE PROC [dbo].[AUTO_AWS_CN]

 AS

 BEGIN 
 Declare @D varchar(11)

  Declare @V varchar(11)

	 select @D  = EXEC_DATE from TBL_CN_DATE	

	 select @V  = VAL from TBL_CN_DATE
	 
	 INSERT INTO AWS_CN_ALL_PROCESS_LOG
	 SELECT @V,@D,GETDATE(),'',''
	  
	 EXEC aws_contract_note @D ,@V
	 
	 UPDATE AWS_CN_ALL_PROCESS_LOG SET END_TIME = GETDATE() WHERE PROCESS_FOR =@V AND 	PROCESS_DATE =@D

	 UPDATE AWS_CN_ALL_PROCESS_LOG SET TOTAL_TIME = DATEDIFF(MINUTE,START_TIME,END_TIME) WHERE PROCESS_FOR =@V AND 	PROCESS_DATE =@D

END

GO
