-- Object: PROCEDURE dbo.DPC_NBFC
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[DPC_NBFC]
(
@SOM VARCHAR (20)
)
AS BEGIN



---DECLARE @SOM DATETIME='2020-07-01'

DECLARE @FromDate DATETIME=@SOM
DECLARE @ToDate DATETIME=DATEADD(MONTH,1,@SOM)

----------------------------------- dpc Start here --------------------------------
SELECT DATEADD(mm,DATEDIFF(mm,0,BalanceDate),0) StartOfMonth
,party_code,SUM(DPC)DPC,SUM(NetDebit)OutStandingAmt
Into #DPC--drop table #dpc
FROM INTRANET.Misc.Dbo.Vw_DPC WITH(NOLOCK)
Where (DPC>0) AND (BalanceDate>=@FromDate AND BalanceDate<@ToDate)
GROUP BY DATEADD(mm,DATEDIFF(mm,0,BalanceDate),0),party_code

----------------------------------- dpc end here --------------------------------
----------------------------------- NBFc Logic Start here ------------------------------

SELECT   DATEADD(mm,DATEDIFF(mm,0,EodDate),0) StartOfMonth
,BackOfficeCodeEquity as party_code,SUM(IntAmount)IntAmount,SUM(OutStandingAmt)OutStandingAmt
INTO #NBFC
FROM ABVSINSURANCEBO.IspaceScoreCard.dbo.NBFC_Live_ClientDaywise nbfc
Where (EodDate>=@FromDate AND EodDate<@ToDate)
GROUP BY   DATEADD(mm,DATEDIFF(mm,0,EodDate),0),BackOfficeCodeEquity

----------------------------------Nbfc logic end here--------------------------------
---------------------------------- dpc and nbfc merge--------------------------------
SELECT  party_code,sum(Dpc) AS Dpc_NBFC
INTO #DPC_NBFC
FROM
( SELECT party_code,Dpc from #DPC
UNION ALL
SELECT party_code,IntAmount as Dpc from #NBFC
) a
GROUP BY party_code


select * from #DPC_NBFC

END

GO
