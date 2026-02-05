-- Object: PROCEDURE citrus_usr.PR_INS_UPD_REPMSG
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/**create table "REPORT_MESSAGE" ( 
	"MSG_ID" numeric(10,0) identity not null,
	"REPORT_NAME" varchar(50) not null,
	"PAGE_HDR_MSG_SIZE" INTEGER not null,
	"PAGE_FTR_MSG_SIZE" INTEGER not null,
	"PAGE_SPL_MSG" varchar(8000) not null,
	"REPMSG_CREATED_BY" varchar(25) not null,
	"REPMSG_CREATED_DT" datetime not null,
	"REPMSG_LST_UPD_BY" varchar(25) not null,
	"REPMSG_LST_UPD_DT" datetime not null,
	"REPMSG_DELETED_IND" smallint not null
	)

DROP TABLE REPORT_MESSAGE
SELECT * FROM REPORT_MESSAGE
SP_HELP REPORT_MESSAGE
SP_HELPTEXT PR_INS_UPD_REPMSG 
*/



CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_REPMSG](@PA_ID                   VARCHAR(8000)
				  ,@PA_ACTION		    VARCHAR(20) 
                                  ,@PA_LOGIN_NAME           VARCHAR(20)
                                  ,@PA_REPORT_NAME          VARCHAR(50)
                                  ,@PA_PAGE_HDR_MSG_SIZE    INTEGER
                                  ,@PA_PAGE_FTR_MSG_SIZE    INTEGER
				  ,@PA_PAGE_SPL_MSG         VARCHAR(50)
				  ,@PA_CHK_YN               INT
                                  ,@ROWDELIMETER            CHAR(4)       = '*|~*'
                                  ,@COLDELIMETER            CHAR(4)       = '|*~|'
                                  ,@PA_ERRMSG               VARCHAR(8000) OUTPUT
)

AS
/*
*********************************************************************************
 SYSTEM         : DP
 MODULE NAME    : PR_INS_UPD_REPMSG
 DESCRIPTION    : 
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    ANOOP KHARADKAR   12-APRIL-2008    VERSION.
-----------------------------------------------------------------------------------*/
--
BEGIN--1
  --
  SET NOCOUNT ON
  --
  DECLARE @@T_ERRORSTR      VARCHAR(8000),
          @@L_ERROR         BIGINT,
          @DELIMETER        VARCHAR(10),
          @@REMAININGSTRING VARCHAR(8000),
          @@CURRSTRING      VARCHAR(8000),
          @@FOUNDAT         INTEGER,
          @@DELIMETERLENGTH INT,
	  @L_MSG_ID         NUMERIC
  --
  SET @@L_ERROR = 0
  SET @@T_ERRORSTR=''
  SET @DELIMETER = '%'+ @ROWDELIMETER + '%'
  
  SET @@DELIMETERLENGTH = LEN(@ROWDELIMETER)
 
  SET @@REMAININGSTRING = @PA_ID
  
  WHILE @@REMAININGSTRING <> ''
  BEGIN--2
   
   SET @@FOUNDAT = 0
   SET @@FOUNDAT =  PATINDEX('%'+@DELIMETER+'%',@@REMAININGSTRING)
   
   IF @@FOUNDAT > 0
   
   BEGIN
     
     SET @@CURRSTRING      = SUBSTRING(@@REMAININGSTRING, 0,@@FOUNDAT)
     
     SET @@REMAININGSTRING = SUBSTRING(@@REMAININGSTRING, @@FOUNDAT+@@DELIMETERLENGTH,LEN(@@REMAININGSTRING)- @@FOUNDAT+@@DELIMETERLENGTH)
     --
   END
   ELSE		--FOR LAST ROW TO PROCESS
   BEGIN
    
     SET @@CURRSTRING      = @@REMAININGSTRING
     SET @@REMAININGSTRING = ''		--@@REMAININGSTRING TO ''
     --
   END
   
   IF @@CURRSTRING <> ''
   BEGIN--3
     --
     IF @PA_CHK_YN = 0 
     BEGIN--4
       --
       IF @PA_ACTION = 'INS'  --ACTION TYPE = INS BEGINS HERE
       BEGIN--5
         SELECT @L_MSG_ID = ISNULL(MAX(MSG_ID),0)+ 1
         FROM  REPORT_MESSAGE WITH (NOLOCK)
         
         BEGIN TRANSACTION
         --
         INSERT INTO REPORT_MESSAGE
            (    --MSG_ID
		 REPORT_NAME
		,PAGE_HDR_MSG_SIZE
		,PAGE_FTR_MSG_SIZE
		,PAGE_SPL_MSG
		,REPMSG_CREATED_BY
		,REPMSG_CREATED_DT
		,REPMSG_LST_UPD_BY
		,REPMSG_LST_UPD_DT 
		,REPMSG_DELETED_IND 
         )
         VALUES
         ( --@L_MSG_ID
           @PA_REPORT_NAME
         , @PA_PAGE_HDR_MSG_SIZE
         , @PA_PAGE_FTR_MSG_SIZE
         , @PA_PAGE_SPL_MSG
         , @PA_LOGIN_NAME
         , GETDATE() 
         , @PA_LOGIN_NAME
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
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMETER+@PA_REPORT_NAME+@COLDELIMETER+CONVERT(VARCHAR, @PA_PAGE_HDR_MSG_SIZE)+@COLDELIMETER+CONVERT(VARCHAR, @PA_PAGE_FTR_MSG_SIZE)+@COLDELIMETER+@PA_PAGE_SPL_MSG+@ROWDELIMETER
         --
         END
         ELSE
         BEGIN
         --
           COMMIT TRANSACTION
         --
         END
       --
       END--5

      IF @PA_ACTION = 'DEL'
       BEGIN--6
         --
         BEGIN TRANSACTION
         --
         UPDATE REPORT_MESSAGE WITH (ROWLOCK)
         SET    REPMSG_DELETED_IND = 0
              , REPMSG_LST_UPD_BY  = @PA_LOGIN_NAME
              , REPMSG_LST_UPD_DT  = GETDATE()
         WHERE  MSG_ID          = CONVERT(INT,@@CURRSTRING)
         --
         SET @@L_ERROR = @@ERROR
         --
         IF @@L_ERROR > 0
         BEGIN
           --
           SELECT @@T_ERRORSTR =  @@T_ERRORSTR+@@CURRSTRING+@COLDELIMETER+@PA_REPORT_NAME+@COLDELIMETER+CONVERT(VARCHAR, @PA_PAGE_HDR_MSG_SIZE)+@COLDELIMETER+CONVERT(VARCHAR, @PA_PAGE_FTR_MSG_SIZE)+@COLDELIMETER+@PA_PAGE_SPL_MSG+@ROWDELIMETER
           FROM   REPORT_MESSAGE WITH (NOLOCK)
           WHERE  MSG_ID       = CONVERT(INT,@@CURRSTRING)
           AND    REPMSG_DELETED_IND  = 1
           --
           ROLLBACK TRANSACTION
           --
         END
         ELSE
         BEGIN
         --
           COMMIT TRANSACTION
         --
         END
         --
       END--6
       --

       IF @PA_ACTION = 'EDT'  --ACTION TYPE = EDT BEGINS HERE
       BEGIN--7
       --
         BEGIN TRANSACTION
         --
            --

             UPDATE REPORT_MESSAGE WITH (ROWLOCK)
             SET    REPORT_NAME         = @PA_REPORT_NAME
                  , PAGE_HDR_MSG_SIZE   = @PA_PAGE_HDR_MSG_SIZE 
                  , PAGE_FTR_MSG_SIZE   = @PA_PAGE_FTR_MSG_SIZE 
                  , PAGE_SPL_MSG        = @PA_PAGE_SPL_MSG
		  , REPMSG_LST_UPD_BY   = @PA_LOGIN_NAME
                  , REPMSG_LST_UPD_DT   = GETDATE()
             WHERE  MSG_ID              = CONVERT(INT, @@CURRSTRING)
	     
             
           --
           
           SET @@L_ERROR = @@ERROR
           --
           IF @@L_ERROR > 0
           BEGIN
           --
           SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMETER+@PA_REPORT_NAME+@COLDELIMETER+CONVERT(VARCHAR, @PA_PAGE_HDR_MSG_SIZE)+@COLDELIMETER+CONVERT(VARCHAR, @PA_PAGE_FTR_MSG_SIZE)+@COLDELIMETER+@PA_PAGE_SPL_MSG+@ROWDELIMETER
             --
           ROLLBACK TRANSACTION
           --
           END
           ELSE
           BEGIN
           --
           COMMIT TRANSACTION
           --
           END
       --
       END--7 
   --
   END--4

   ELSE
   IF @PA_CHK_YN = 1

   BEGIN
   PRINT ''
   END

   --
     
   --
   END--3
  --
  END--2
--
END--1

GO
