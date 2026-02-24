-- Object: PROCEDURE dbo.CLS_SQLJOB_STATUS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



--   CLS_SQLJOB_STATUS '1',1,''
--   CLS_SQLJOB_STATUS '2',1,''

CREATE PROC [dbo].[CLS_SQLJOB_STATUS]
@MODE CHAR(1),
@STATUSID INT = '',
@JOBDATE VARCHAR(12) = ''
AS

BEGIN
IF(@MODE = '1') -- FOR RETRIEVING LATEST RUN JOB
BEGIN
SELECT 	UPPER([SJOB].[NAME]) AS [JOBNAME], ISNULL(CASE 
        WHEN [SJOBH].[RUN_DATE] IS NULL OR [SJOBH].[RUN_TIME] IS NULL THEN NULL
        ELSE CAST(
                CAST([SJOBH].[RUN_DATE] AS CHAR(8))
                + ' ' 
                + STUFF(
                    STUFF(RIGHT('000000' + CAST([SJOBH].[RUN_TIME] AS VARCHAR(6)),  6)
                        , 3, 0, ':')
                    , 6, 0, ':')
                AS DATETIME)
      END,'') AS [LASTRUNDATETIME]
    , ISNULL(CASE [SJOBH].[RUN_STATUS]
        WHEN 0 THEN 'FAILED'
        WHEN 1 THEN 'SUCCEEDED'
        WHEN 2 THEN 'RETRY'
        WHEN 3 THEN 'CANCELED'
        WHEN 4 THEN 'RUNNING' -- IN PROGRESS
      END,'') AS [LASTRUNSTATUS]
    , ISNULL(STUFF(
            STUFF(RIGHT('000000' + CAST([SJOBH].[RUN_DURATION] AS VARCHAR(6)),  6)
                , 3, 0, ':')
            , 6, 0, ':'),'') 
        AS [LASTRUNDURATION]
   
    , ISNULL(CASE [SJOBSCH].[NEXTRUNDATE]
        WHEN 0 THEN NULL
        ELSE CAST(
                CAST([SJOBSCH].[NEXTRUNDATE] AS CHAR(8))
                + ' ' 
                + STUFF(
                    STUFF(RIGHT('000000' + CAST([SJOBSCH].[NEXTRUNTIME] AS VARCHAR(6)),  6)
                        , 3, 0, ':')
                    , 6, 0, ':')
                AS DATETIME)
      END,'') AS [NEXTRUNDATETIME]
	   , ISNULL([SJOBH].[MESSAGE],'') AS [LASTRUNSTATUSMESSAGE]
FROM 
    [MSDB].[DBO].[SYSJOBS] AS [SJOB]
    LEFT JOIN (
                SELECT
                    [JOB_ID]
                    , MIN([NEXT_RUN_DATE]) AS [NEXTRUNDATE]
                    , MIN([NEXT_RUN_TIME]) AS [NEXTRUNTIME]
                FROM [MSDB].[DBO].[SYSJOBSCHEDULES]
                GROUP BY [JOB_ID]
            ) AS [SJOBSCH]
        ON [SJOB].[JOB_ID] = [SJOBSCH].[JOB_ID]
    LEFT JOIN (
                SELECT 
                    [JOB_ID]
                    , [RUN_DATE]
                    , [RUN_TIME]
                    , [RUN_STATUS]
                    , [RUN_DURATION]
                    , [MESSAGE]
                    , ROW_NUMBER() OVER (
                                            PARTITION BY [JOB_ID] 
                                            ORDER BY [RUN_DATE] DESC, [RUN_TIME] DESC
                      ) AS ROWNUMBER
                FROM [MSDB].[DBO].[SYSJOBHISTORY]
                WHERE [STEP_ID] = 0
            ) AS [SJOBH]
        ON [SJOB].[JOB_ID] = [SJOBH].[JOB_ID]
        AND [SJOBH].[ROWNUMBER] = 1
ORDER BY [SJOBH].[RUN_STATUS]

END
ELSE IF (@MODE = '2') -- FOR DETAILS JOB IN 7 DAYS 
BEGIN

SELECT 	UPPER([SJOB].[NAME]) AS [JOBNAME], ISNULL(CASE 
        WHEN [SJOBH].[RUN_DATE] IS NULL OR [SJOBH].[RUN_TIME] IS NULL THEN NULL
        ELSE CAST(
                CAST([SJOBH].[RUN_DATE] AS CHAR(8))
                + ' ' 
                + STUFF(
                    STUFF(RIGHT('000000' + CAST([SJOBH].[RUN_TIME] AS VARCHAR(6)),  6)
                        , 3, 0, ':')
                    , 6, 0, ':')
                AS DATETIME)
      END,'') AS [LASTRUNDATETIME]
    , ISNULL(CASE [SJOBH].[RUN_STATUS]
        WHEN 0 THEN 'FAILED'
        WHEN 1 THEN 'SUCCEEDED'
        WHEN 2 THEN 'RETRY'
        WHEN 3 THEN 'CANCELED'
        WHEN 4 THEN 'RUNNING' -- IN PROGRESS
      END,'') AS [LASTRUNSTATUS]
    , ISNULL(STUFF(
            STUFF(RIGHT('000000' + CAST([SJOBH].[RUN_DURATION] AS VARCHAR(6)),  6)
                , 3, 0, ':')
            , 6, 0, ':') ,'')
        AS [LASTRUNDURATION]
   
    , ISNULL(CASE [SJOBSCH].[NEXTRUNDATE]
        WHEN 0 THEN NULL
        ELSE CAST(
                CAST([SJOBSCH].[NEXTRUNDATE] AS CHAR(8))
                + ' ' 
                + STUFF(
                    STUFF(RIGHT('000000' + CAST([SJOBSCH].[NEXTRUNTIME] AS VARCHAR(6)),  6)
                        , 3, 0, ':')
                    , 6, 0, ':')
                AS DATETIME)
      END,'') AS [NEXTRUNDATETIME]
	   , ISNULL([SJOBH].[MESSAGE],'') AS [LASTRUNSTATUSMESSAGE]
FROM 
    [MSDB].[DBO].[SYSJOBS] AS [SJOB]
    LEFT JOIN (
                SELECT
                    [JOB_ID]
                    , MIN([NEXT_RUN_DATE]) AS [NEXTRUNDATE]
                    , MIN([NEXT_RUN_TIME]) AS [NEXTRUNTIME]
                FROM [MSDB].[DBO].[SYSJOBSCHEDULES]
                GROUP BY [JOB_ID]
            ) AS [SJOBSCH]
        ON [SJOB].[JOB_ID] = [SJOBSCH].[JOB_ID]
    LEFT JOIN (
                SELECT 
                    [JOB_ID]
                    , [RUN_DATE]
                    , [RUN_TIME]
                    , [RUN_STATUS]
                    , [RUN_DURATION]
                    , [MESSAGE]
                    , ROW_NUMBER() OVER (
                                            PARTITION BY [JOB_ID] 
                                            ORDER BY [RUN_DATE] DESC, [RUN_TIME] DESC
                      ) AS ROWNUMBER
                FROM [MSDB].[DBO].[SYSJOBHISTORY]
                WHERE [STEP_ID] = 0
            ) AS [SJOBH]
        ON [SJOB].[JOB_ID] = [SJOBH].[JOB_ID]
       -- AND [SJOBH].[ROWNUMBER] = 1
WHERE run_date = CONVERT(VARCHAR,CONVERT(DATETIME,@JOBDATE,103),112) 
  AND run_status=@STATUSID 
ORDER BY [JOBNAME]
END
END

GO
