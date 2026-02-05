-- Object: PROCEDURE dbo.SP_WHO3
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



CREATE PROCEDURE [DBO].[SP_WHO3]    

(    

    @SESSIONID INT = NULL   

)    

AS   

BEGIN   

SELECT   

    SPID                = ER.SESSION_ID    

    ,STATUS             = SES.STATUS    

    ,[LOGIN]            = SES.LOGIN_NAME    

    ,HOST               = SES.HOST_NAME    

    ,BLKBY              = ER.BLOCKING_SESSION_ID    

    ,DBNAME             = DB_NAME(ER.DATABASE_ID)    

    ,COMMANDTYPE        = ER.COMMAND    

    ,SQLSTATEMENT       =    

        SUBSTRING   

        (    

            QT.TEXT,    

            ER.STATEMENT_START_OFFSET/2,    

            (CASE WHEN ER.STATEMENT_END_OFFSET = -1    

                THEN LEN(CONVERT(NVARCHAR(MAX), QT.TEXT)) * 2    

                ELSE ER.STATEMENT_END_OFFSET    

                END - ER.STATEMENT_START_OFFSET)/2    

        )    

    ,OBJECTNAME         = OBJECT_SCHEMA_NAME(QT.OBJECTID,DBID) + '.' + OBJECT_NAME(QT.OBJECTID, QT.DBID)    

    ,ELAPSEDMS          = ER.TOTAL_ELAPSED_TIME    

    ,CPUTIME            = ER.CPU_TIME    

    ,IOREADS            = ER.LOGICAL_READS + ER.READS    

    ,IOWRITES           = ER.WRITES    

    ,LASTWAITTYPE       = ER.LAST_WAIT_TYPE    

    ,STARTTIME          = ER.START_TIME    

    ,PROTOCOL           = CON.NET_TRANSPORT    

    ,CONNECTIONWRITES   = CON.NUM_WRITES    

    ,CONNECTIONREADS    = CON.NUM_READS    

    ,CLIENTADDRESS      = CON.CLIENT_NET_ADDRESS    

    ,AUTHENTICATION     = CON.AUTH_SCHEME    

FROM SYS.DM_EXEC_REQUESTS ER    

LEFT JOIN SYS.DM_EXEC_SESSIONS SES    

ON SES.SESSION_ID = ER.SESSION_ID    

LEFT JOIN SYS.DM_EXEC_CONNECTIONS CON    

ON CON.SESSION_ID = SES.SESSION_ID    

OUTER APPLY SYS.DM_EXEC_SQL_TEXT(ER.SQL_HANDLE) AS QT    

WHERE ER.SESSION_ID > 50  --AND OBJECTNAME<>'DBO.SP_WHO3'  

    AND @SESSIONID IS NULL OR ER.SESSION_ID = @SESSIONID  

ORDER BY   

    ER.BLOCKING_SESSION_ID DESC   

    ,ER.SESSION_ID    

END

GO
