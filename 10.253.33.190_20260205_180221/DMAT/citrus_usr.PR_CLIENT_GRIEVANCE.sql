-- Object: PROCEDURE citrus_usr.PR_CLIENT_GRIEVANCE
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--EXEC PR_CLIENT_GRIEVANCE '00000019','GENERATECOMPID','00000019','2','checktest','check2','check3','April 20 2010','April 24 2010',''

CREATE PROCEDURE [citrus_usr].[PR_CLIENT_GRIEVANCE]
(
    @CLIG_BOID         VARCHAR(20),
    @CLIG_ACTION       VARCHAR(20), 
    @CLIG_LOGIN_NAME   VARCHAR(20),
    @CLIG_COMPLAINNOS  VARCHAR(20),
    @CLIG_HOLDING      VARCHAR(1000),
    @CLIG_TRX          VARCHAR(1000),
    @CLIG_OTHER_ISSUE  VARCHAR(1000),
    @CLIG_FROM_DT      VARCHAR(20),
    @CLIG_TO_DT        VARCHAR(20),
    @CLIG_ERRMSG       VARCHAR(8000) OUTPUT 
)
AS
BEGIN
    SET NOCOUNT ON    
  --    
  DECLARE
       @@CLIG_COMPLAINNOS NUMERIC,
       @@L_ERROR          BIGINT,
       @@T_ERRORSTR       VARCHAR(8000)        
       
	--    
	 SET @@L_ERROR = 0 
     SET @@T_ERRORSTR = ''     

   IF @CLIG_ACTION = 'INS' --ACTION TYPE = INS BEGINS HERE    
     BEGIN    
       --    
         BEGIN TRANSACTION
--
		IF (SELECT COUNT(*)  FROM CLIENT_GRIEVANCE) = '0'
		BEGIN
			SET @@CLIG_COMPLAINNOS = 1
		END
		ELSE
		BEGIN 
		  SET @@CLIG_COMPLAINNOS = (SELECT MAX(CLIG_SRNO) + 1 FROM CLIENT_GRIEVANCE)
		END   
           
         INSERT INTO CLIENT_GRIEVANCE    
         (     
           CLIG_BOID    
         , CLIG_COMPLAINNOS    
         , CLIG_HOLDING  
         , CLIG_TRX  
         , CLIG_OTHER_ISSUE    
         , CLIG_CREATED_BY    
         , CLIG_CREATED_DT    
         , CLIG_LST_UPD_BY    
         , CLIG_LST_UPD_DT    
         , CLIG_DELETED_IND    
         )    
         VALUES    
         ( @CLIG_BOID    
         , @@CLIG_COMPLAINNOS   
         , @CLIG_HOLDING    
         , @CLIG_TRX  
         , @CLIG_OTHER_ISSUE  
         , @CLIG_LOGIN_NAME    
         , GETDATE()    
         , @CLIG_LOGIN_NAME    
         , GETDATE()    
         , 1    
         )    
         --    
         SET @@L_ERROR = @@ERROR    
         --    
         IF @@L_ERROR  > 0    
         BEGIN    
           --    
           ROLLBACK TRANSACTION    
           --    
           SET @@T_ERRORSTR=CONVERT(VARCHAR,@@L_ERROR)
           --    
         END    
         ELSE    
         BEGIN    
           --    
           COMMIT TRANSACTION    
           --    
         END    
        --  
        END 
    ELSE IF @CLIG_ACTION = 'EDT'
     BEGIN    
            
         BEGIN TRANSACTION    
         --    
         UPDATE CLIENT_GRIEVANCE WITH(ROWLOCK)    
         SET    CLIG_HOLDING        = @CLIG_HOLDING    
              , CLIG_TRX            = @CLIG_TRX    
              , CLIG_OTHER_ISSUE    = @CLIG_OTHER_ISSUE   
              , CLIG_LST_UPD_BY     = @CLIG_LOGIN_NAME    
              , CLIG_LST_UPD_DT     = GETDATE()    
         WHERE  CLIG_BOID           = CLIG_BOID 
               AND CLIG_COMPLAINNOS   = @CLIG_COMPLAINNOS
         --    
         SET @@L_ERROR = @@ERROR    
         --    
         IF @@L_ERROR > 0    
         BEGIN    
           --    
            SET @@T_ERRORSTR=CONVERT(VARCHAR,@@L_ERROR)
           --    
         END    
         ELSE    
         BEGIN    
           --    
           COMMIT TRANSACTION    
           --    
         END    
         --    
       END    
       --  
       IF @CLIG_ACTION = 'SELECT' --ACTION TYPE = INS BEGINS HERE   
       BEGIN
          SELECT CLIG_SRNO,CLIG_COMPLAINNOS, CLIG_HOLDING, CLIG_TRX, CLIG_OTHER_ISSUE
          FROM CLIENT_GRIEVANCE
          WHERE CLIG_COMPLAINNOS = @CLIG_COMPLAINNOS
       END 
       IF @CLIG_ACTION = 'FINDSEARCH' --ACTION TYPE = INS BEGINS HERE   
       BEGIN
          IF @CLIG_FROM_DT <> '' AND @CLIG_TO_DT <> ''
          BEGIN
			  SELECT CLIG_COMPLAINNOS, CLIG_HOLDING, CLIG_TRX, CLIG_OTHER_ISSUE
			  FROM CLIENT_GRIEVANCE
			  WHERE CLIG_COMPLAINNOS LIKE CASE WHEN  @CLIG_COMPLAINNOS = '0' THEN '%' ELSE @CLIG_COMPLAINNOS END
			  AND CLIG_CREATED_DT BETWEEN @CLIG_FROM_DT AND @CLIG_TO_DT
          END
          ELSE
          BEGIN
			  SELECT CLIG_COMPLAINNOS, CLIG_HOLDING, CLIG_TRX, CLIG_OTHER_ISSUE
			  FROM CLIENT_GRIEVANCE
			  WHERE CLIG_COMPLAINNOS LIKE CASE WHEN  @CLIG_COMPLAINNOS = '0' THEN '%' ELSE @CLIG_COMPLAINNOS END
	      END 
       END
       IF @CLIG_ACTION = 'GENERATECOMPID' --ACTION TYPE = INS BEGINS HERE  
       BEGIN
           IF @CLIG_COMPLAINNOS = '0'
           BEGIN
				SET @CLIG_ERRMSG = (SELECT CLIG_COMPLAINNOS FROM CLIENT_GRIEVANCE WHERE CLIG_SRNO=(SELECT MAX(CLIG_SRNO) FROM CLIENT_GRIEVANCE))
                PRINT @CLIG_ERRMSG  
           END 
           ELSE
           BEGIN
				SET @CLIG_ERRMSG =  @CLIG_COMPLAINNOS
                PRINT @CLIG_ERRMSG  
           END
       END 
END

GO
