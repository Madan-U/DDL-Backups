-- Object: PROCEDURE citrus_usr.PR_UPD_ISIN_BROKERTRX
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*

begin tran
ROLLBACK
	SELECT		4	0005130		
EXEC PR_UPD_ISIN_BROKERTRX 'SELECT','',3,'0005130','',''
EXEC PR_UPD_ISIN_BROKERTRX 'SELECT','',4,'0005130','',''


EXEC PR_UPD_ISIN_BROKERTRX	'DEL','1063|*~|INE397D01016|*~|*|~*',4,0005130,'',''	

EXEC PR_UPD_ISIN_BROKERTRX	'EDT','1064|*~|INE019A01020|*~|*|~*',4,0005130,'',''
	

*/

CREATE PROC [citrus_usr].[PR_UPD_ISIN_BROKERTRX]  
   (  
   @PA_ACTION VARCHAR(1000),  
   @PA_VALUES VARCHAR(8000),  
   @PA_EXCH NUMERIC,   
   @PA_BROKERBATCH VARCHAR(1000),  
   @PA_BROKERSLIP VARCHAR(1000),    
   @PA_OUT VARCHAR(8000) OUT   
   )  
AS  
BEGIN  

    DECLARE @L_EXCH VARCHAR(50)
	DECLARE @l_errorstr            varchar(8000)
        , @l_error               numeric
        , @delimeterlength       int
    SELECT @L_EXCH = EXCSM_EXCH_CD FROM EXCH_SEG_MSTR, DP_MSTR WHERE DEFAULT_DP =DPM_EXCSM_ID AND DPM_EXCSM_ID = EXCSM_ID AND EXCSM_DELETED_IND = 1 AND DPM_DELETED_IND = 1   AND DPM_EXCSM_ID = @PA_EXCH
 
 IF @PA_ACTION = 'SELECT'  
 BEGIN   
        IF @L_EXCH = 'NSDL'  
        BEGIN  
print('nsdl')
        SELECT DPTD_ID ID, DPTD_SLIP_NO SLIP_NO, DPTD_ISIN ISIN_CD, DPTD_QTY QTY, isin_name FROM DP_TRX_DTLS , isin_mstr   
        WHERE dptd_isin = isin_Cd and DPTD_BROKERBATCH_NO = CASE WHEN @PA_BROKERBATCH <> '' THEN @PA_BROKERBATCH ELSE DPTD_BROKERBATCH_NO END   
        AND   DPTD_SLIP_NO = CASE WHEN @PA_BROKERSLIP <> '' THEN @PA_BROKERSLIP ELSE DPTD_SLIP_NO END   
        and   isnull(DPTD_BROKERBATCH_NO  ,'') <> ''
        and   DPTD_DELETED_IND = 1   
        END     
        ELSE IF @L_EXCH = 'CDSL'  
        BEGIN
         print('cdsl')
        SELECT DPTDC_ID ID, DPTDC_SLIP_NO SLIP_NO, DPTDC_ISIN ISIN_CD, DPTDC_QTY QTY, isin_name FROM DP_TRX_DTLS_CDSL   , isin_mstr 
        WHERE dptdc_isin = isin_Cd and  DPTDC_BROKERBATCH_NO = CASE WHEN @PA_BROKERBATCH <> '' THEN @PA_BROKERBATCH ELSE DPTDC_BROKERBATCH_NO END   
        AND   DPTDC_SLIP_NO = CASE WHEN @PA_BROKERSLIP <> '' THEN @PA_BROKERSLIP ELSE DPTDC_SLIP_NO END   
        and   isnull(DPTDC_BROKERBATCH_NO  ,'') <> ''
        and   DPTDC_DELETED_IND = 1   
        END     
  
 END   

 ELSE   
 
BEGIN  
      DECLARE @L_COUNTER NUMERIC  
      ,@L_COUNT NUMERIC  
       
      DECLARE @L_STRING VARCHAR(1000)  
  
      SET @L_COUNTER  = CITRUS_USR.UFN_COUNTSTRING(@PA_VALUES,'*|~*')  
      SET @L_COUNT = 1   
        
      WHILE @L_COUNTER >= @L_COUNT   
      BEGIN  
        SET @L_STRING  = CITRUS_USR.FN_SPLITVAL_ROW(@PA_VALUES,@L_COUNT)  
        IF @L_EXCH = 'NSDL'  
        BEGIN  

		PRINT('UPDATE NSDL')
        BEGIN TRANSACTION
        if @pa_action ='EDT'
        UPDATE DP_TRX_DTLS SET DPTD_ISIN = CITRUS_USR.FN_SPLITVAL(@L_STRING,2) WHERE DPTD_ID = CITRUS_USR.FN_SPLITVAL(@L_STRING,1) AND DPTD_DELETED_IND = 1  
        if @pa_action ='DEL'
        UPDATE DP_TRX_DTLS SET dptd_deleted_ind  = 9 WHERE DPTD_ID = CITRUS_USR.FN_SPLITVAL(@L_STRING,1) and dptd_isin = CITRUS_USR.FN_SPLITVAL(@L_STRING,2) AND DPTD_DELETED_IND = 1  

        SET @l_error = @@error
        --
        IF @l_error > 0
        BEGIN
        --
          SET @PA_OUT  = 'PLEASE CONTACT ADMINISTRATOR'
          --
          ROLLBACK TRANSACTION
          --
          RETURN
        --
        END
        ELSE
        BEGIN
        --
          SET @PA_OUT  = 'SUCCESS'
          --
          COMMIT TRANSACTION
        --
        END

        END     
        ELSE IF @L_EXCH = 'CDSL'  
        BEGIN  

		PRINT('UPDATE CDSL')
        BEGIN TRANSACTION

        if @pa_action ='EDT'
        UPDATE DP_TRX_DTLS_CDSL SET DPTDC_ISIN = CITRUS_USR.FN_SPLITVAL(@L_STRING,2) WHERE DPTDC_ID = CITRUS_USR.FN_SPLITVAL(@L_STRING,1) AND DPTDC_DELETED_IND = 1  
        if @pa_action ='DEL'
        UPDATE DP_TRX_DTLS_CDSL SET DPTDC_DELETED_IND  = 9 WHERE DPTDC_ID = CITRUS_USR.FN_SPLITVAL(@L_STRING,1) and dptdc_isin = CITRUS_USR.FN_SPLITVAL(@L_STRING,2) AND DPTDC_DELETED_IND = 1  
        SET @l_error = @@error
        --
        IF @l_error > 0
        BEGIN
        --
          SET @PA_OUT  = 'PLEASE CONTACT ADMINISTRATOR'
          --
          ROLLBACK TRANSACTION
          --
          RETURN
        --
        END
        ELSE
        BEGIN
        --
          SET @PA_OUT  = 'SUCCESS'
          --
          COMMIT TRANSACTION
        --
        END

       END     
       set @L_COUNT = @L_COUNT + 1 
     END   
   END   
  END

GO
