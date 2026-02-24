-- Object: PROCEDURE dbo.AUTO_OMNESYS_MARGIN_SQ_OFF
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[AUTO_OMNESYS_MARGIN_SQ_OFF]
(
 @DA VARCHAR(11),  @EXCH VARCHAR(5)
)
AS 
BEGIN
	 INSERT INTO OMNESYS_MARGIN_SQ_OFF_LOG 
	 SELECT @EXCH,GETDATE(),'START'
--SET @EXCH ='COMM'
	 IF @EXCH ='EQ'
	 BEGIN
	 /*Commented on 2022 - Jan -11*/
		--EXEC ABVSINSURANCEBO.msdb.DBO.SP_START_JOB 'OMNESYS_CASH_SQ_OFF'
	 /*End the code comment*/
	 
		--EXEC ABVSINSURANCEBO.msdb.DBO.SP_START_JOB 'OMNESYS_CASH_SQ_OFF_NEW'
		--WAITFOR DELAY '00:05:00'; 
		
		--/*Adding  new code */
		--Truncate table CNT_OMNESYS
		
		--INSERT INTO CNT_OMNESYS
		--(
		--	EXCHG_ORDER_NO,
		--	REMARKS,
		--	USERID,
		--	TIME,
		--	EXCHG,
		--	FILE_DATE,
		--	ACC_ID
		--)
		--SELECT 
		--	EXCHG_ORDER_NO,
		--	REMARKS,
		--	USERID,
		--	CONVERT(TIME,TIME),
		--	EXCHG,
		--	CONVERT(DATE,FILE_DATE),
		--	ACC_ID
		--FROM tbl_CNT_Omnesys_temp
      EXEC ABVSINSURANCEBO.SSISDB.dbo.USP_CNT_OMNESYS_BULKUPLOAD_ALL --@OnDate
		
      TRUNCATE TABLE CNT_OMNESYS
      INSERT INTO CNT_OMNESYS
      (
        EXCHG_ORDER_NO,
        REMARKS,
        USERID,
        TIME,
        EXCHG,
        FILE_DATE,
        ACC_ID
        )
      SELECT 
        ExchangeOrderNo, Remarks ,UserId,[Trade Time], 
        [Exhg  Seg], [Trade Date], [Account Id] 
      FROM ABVSINSURANCEBO.SSISDB.DBO.tbl_CNT_Omnesys_all_temp WITH(NOLOCK) 
 		
	    EXEC OMNESYS_MARGIN_SQ_OFF @EXCH

	 SELECT  'PROCESS FOR '+@EXCH  +' COMPLETED SUCESSFULLY...!!!!!' AS STATUS


	END
	 IF @EXCH ='CURR'
	 BEGIN

	 /*Commented on 2022 - Jan -11*/
		--EXEC ABVSINSURANCEBO.msdb.DBO.SP_START_JOB 'OMNESYS_CASH_SQ_OFF'
	 /*End the code comment*/
	 
	 
		--EXEC ABVSINSURANCEBO.msdb.DBO.SP_START_JOB 'OMNESYS_CASH_SQ_OFF_NEW'
		--WAITFOR DELAY '00:05:00'; 
		--Truncate table CNT_OMNESYS
		
		--INSERT INTO CNT_OMNESYS
		--(
		--	EXCHG_ORDER_NO,
		--	REMARKS,
		--	USERID,
		--	TIME,
		--	EXCHG,
		--	FILE_DATE,
		--	ACC_ID
		--)
		--SELECT 
		--	EXCHG_ORDER_NO,
		--	REMARKS,
		--	USERID,
		--	CONVERT(TIME,TIME),
		--	EXCHG,
		--	CONVERT(DATE,FILE_DATE),
		--	ACC_ID
		--FROM tbl_CNT_Omnesys_temp
     EXEC ABVSINSURANCEBO.SSISDB.dbo.USP_CNT_OMNESYS_BULKUPLOAD_ALL --@OnDate
      TRUNCATE TABLE CNT_OMNESYS
      INSERT INTO CNT_OMNESYS
      (
        EXCHG_ORDER_NO,
        REMARKS,
        USERID,
        TIME,
        EXCHG,
        FILE_DATE,
        ACC_ID
        )
      SELECT 
        ExchangeOrderNo, Remarks ,UserId,[Trade Time], 
        [Exhg  Seg], [Trade Date], [Account Id] 
      FROM ABVSINSURANCEBO.SSISDB.DBO.tbl_CNT_Omnesys_all_temp WITH(NOLOCK) 
 		
		EXEC OMNESYS_MARGIN_SQ_OFF @EXCH

		SELECT  'PROCESS FOR '+@EXCH  +' COMPLETED SUCESSFULLY...!!!!!' AS STATUS
	END
	 IF @EXCH ='COMM'
	 BEGIN

	 /*Commented on 2022 - Jan -18*/
		
		--EXEC ABVSINSURANCEBO.msdb.DBO.SP_START_JOB 'OMNESYS_COMM_SQ_OFF'
		--WAITFOR DELAY '00:05:00'; 
    /*End The Code Addition*/

    /*Below Code Added By Ahsan Farooqui on 18 Jan 2022*/
  --  EXEC ABVSINSURANCEBO.msdb.DBO.SP_START_JOB 'OMNESYS_CASH_SQ_OFF_NEW_COMM'
		--WAITFOR DELAY '00:05:00'; 

  --  Truncate table CNT_OMNESYS
		
		--INSERT INTO CNT_OMNESYS
		--(
		--	EXCHG_ORDER_NO,
		--	REMARKS,
		--	USERID,
		--	TIME,
		--	EXCHG,
		--	FILE_DATE,
		--	ACC_ID
		--)
		--SELECT 
		--	EXCHG_ORDER_NO,
		--	REMARKS,
		--	USERID,
		--	CONVERT(TIME,TIME),
		--	EXCHG,
		--	CONVERT(DATE,FILE_DATE),
		--	ACC_ID
		--FROM tbl_CNT_Omnesys_temp
	EXEC ABVSINSURANCEBO.SSISDB.dbo.USP_CNT_OMNESYS_BULKUPLOAD_ALL --@OnDate

  DECLARE @OnDate_1 Date 
  SELECT TOP 1  @OnDate_1= [Trade Date] FROM ABVSINSURANCEBO.SSISDB.DBO.tbl_CNT_Omnesys_all_temp WITH(NOLOCK) 
  
  DELETE FROM tbl_CNT_Omnesys_Final WHERE FILE_DATE =@OnDate_1
  INSERT INTO tbl_CNT_Omnesys_Final
  (
   EXCHG_ORDER_NO,REMARKS,USERID,TIME
  ,EXCHG,FILE_DATE,ACC_ID,OrderSource
  ,FileNo
  )
  SELECT 
  ExchangeOrderNo, Remarks ,UserId,[Trade Time], 
  [Exhg  Seg], [Trade Date], [Account Id],[Order Source] ,
  FileNo
  FROM ABVSINSURANCEBO.SSISDB.DBO.tbl_CNT_Omnesys_all_temp WITH(NOLOCK) 
  WHERE ISDATE([Trade Date]) <>1

IF OBJECT_ID('tempdb..#tbl_CNT_Omnesys_Final') IS NOT NULL
  DROP TABLE #tbl_CNT_Omnesys_Final
SELECT *INTO #tbl_CNT_Omnesys_Final FROM tbl_CNT_Omnesys_Final WITH(NOLOCK)  WHERE FILE_DATE = @OnDate_1
 
  /*For time being This Code added */
        TRUNCATE TABLE CNT_OMNESYS
        INSERT INTO CNT_OMNESYS
        (
          EXCHG_ORDER_NO,
          REMARKS,
          USERID,
          TIME,
          EXCHG,
          FILE_DATE,
          ACC_ID
        )
        SELECT 
          EXCHG_ORDER_NO,
          REMARKS,
          USERID,
          CONVERT(TIME,TIME),
          EXCHG,
          CONVERT(DATE,FILE_DATE),
          ACC_ID
        FROM #tbl_CNT_Omnesys_Final
------------------ END -------------------
 
		EXEC OMNESYS_MARGIN_SQ_OFF @EXCH
		SELECT  'PROCESS FOR '+@EXCH  +' COMPLETED SUCESSFULLY...!!!!!' AS STATUS

	END
	 
	 IF @EXCH ='CNT'
	 BEGIN
	 
   /*Commented on 2022 - Jan -18*/
		
		--EXEC ABVSINSURANCEBO.msdb.DBO.SP_START_JOB 'OMNESYS_COMM_SQ_OFF'
		--WAITFOR DELAY '00:00:30'; 

  --  EXEC ABVSINSURANCEBO.msdb.DBO.SP_START_JOB 'OMNESYS_CASH_SQ_OFF_NEW_COMM'
		--WAITFOR DELAY '00:05:00'; 

  --  Truncate table CNT_OMNESYS
		
		--INSERT INTO CNT_OMNESYS
		--(
		--	EXCHG_ORDER_NO,
		--	REMARKS,
		--	USERID,
		--	TIME,
		--	EXCHG,
		--	FILE_DATE,
		--	ACC_ID
		--)
		--SELECT 
		--	EXCHG_ORDER_NO,
		--	REMARKS,
		--	USERID,
		--	CONVERT(TIME,TIME),
		--	EXCHG,
		--	CONVERT(DATE,FILE_DATE),
		--	ACC_ID
		--FROM tbl_CNT_Omnesys_temp


		EXEC CNT_Omnesys_UPDATE
		SELECT  'PROCESS FOR '+@EXCH  +' COMPLETED SUCESSFULLY...!!!!!' AS STATUS

	END
	 
	  
	 IF (@EXCH IS NULL OR @DA IS NULL)
	 BEGIN

		SELECT 'NO RECORDS UPDATED'   AS STATUS
	END
	 
	 
	 INSERT INTO OMNESYS_MARGIN_SQ_OFF_LOG
	 SELECT @EXCH,GETDATE(),'END'

	

END

GO
