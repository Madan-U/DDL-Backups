-- Object: PROCEDURE dbo.COMM_PRAK_SHRT_ANG
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC COMM_PRAK_SHRT_ANG ( @PEAKDATE VARCHAR(11))  
  
AS  
  
SELECT * INTO #MCX_SHRT_PEAK_FILE FROM MCX_SHRT_PEAK_FILE WHERE [Short allocation] <> 0 AND [date] = @PEAKDATE  
  
SELECT [Client ID],MAX([Short allocation]) AS Short_allocation_MAX INTO #MCX_SHRT_PEAK_FILE1 FROM #MCX_SHRT_PEAK_FILE  
GROUP BY [Client ID]  
  
SELECT B.[date] AS MCDXDATE,MIN(B.[Snapshot Interval]) AS [Snapshot Interval],B.[Client ID] As [ClientCode] ,B.[Short allocation] AS Short_allocation_SnapShot,
MIN(Batch)  AS Batch  
INTO #MCX_SHRT_PEAK_FILE2  
FROM #MCX_SHRT_PEAK_FILE1 A , #MCX_SHRT_PEAK_FILE B WHERE A.[Client ID] = B.[Client ID]  
AND A.Short_allocation_MAX = B.[Short allocation]  
GROUP BY B.[date],B.[Client ID],B.[Short allocation]  
  
SELECT * INTO #NCX_SHRT_PEAK_FILE  FROM NCX_SHRT_PEAK_FILE WHERE Short_allocation_SnapShot <> 0 AND [date] = @PEAKDATE  
  
SELECT [Client Code],MAX(Short_allocation_SnapShot) AS Short_allocation_SnapShot_MAX INTO #NCX_SHRT_PEAK_FILE1 FROM #NCX_SHRT_PEAK_FILE  
GROUP BY [Client Code]  
  
SELECT B.[Date] AS NCDXDATE,MIN(B.SNAPSHOT_TIME) AS [Snapshot Interval],B.[Client Code] As [ClientCode],
B.Short_allocation_SnapShot,MIN(SNAPSHOT_NUMBER)  AS Batch  
INTO #NCX_SHRT_PEAK_FILE2  
FROM #NCX_SHRT_PEAK_FILE1 A , #NCX_SHRT_PEAK_FILE B WHERE A.[Client Code] = B.[Client Code]  
AND A.Short_allocation_SnapShot_MAX = B.Short_allocation_SnapShot  
GROUP BY B.[Date],B.[Client Code],B.Short_allocation_SnapShot  
  
  
SELECT CONVERT(VARCHAR(10),MCDXDATE,105)AS [DATE], CONVERT(VARCHAR(10),FORMAT([Snapshot Interval],'hh:mm:ss')) AS [SnapshotInterval],
CONVERT(VARCHAR(10),ClientCode) AS ClientCode,  
CONVERT(NUMERIC(18,2),Short_allocation_SnapShot) AS Short_allocation_SnapShot,Batch,EXCH = 'MCX'  INTO #CHECK
FROM #MCX_SHRT_PEAK_FILE2   
union all  
SELECT CONVERT(VARCHAR(10),NCDXDATE,105)AS [DATE], CONVERT(VARCHAR(10),FORMAT([Snapshot Interval],'hh:mm:ss')) AS [SnapshotInterval],
CONVERT(VARCHAR(10),ClientCode) AS ClientCode,  
CONVERT(NUMERIC(18,2),Short_allocation_SnapShot) AS Short_allocation_SnapShot,Batch,EXCH = 'NCX'  
FROM #NCX_SHRT_PEAK_FILE2 order by 3  

SELECT [DATE],[SnapshotInterval],ClientCode,Short_allocation_SnapShot,Batch,EXCH FROM #CHECK 
  
DROP TABLE #CHECK  
DROP TABLE #MCX_SHRT_PEAK_FILE  
DROP TABLE #NCX_SHRT_PEAK_FILE  
DROP TABLE #MCX_SHRT_PEAK_FILE1  
DROP TABLE #NCX_SHRT_PEAK_FILE1  
DROP TABLE #MCX_SHRT_PEAK_FILE2  
DROP TABLE #NCX_SHRT_PEAK_FILE2

GO
