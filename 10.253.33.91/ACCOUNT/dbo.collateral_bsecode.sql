-- Object: PROCEDURE dbo.collateral_bsecode
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

    
    
    
CREATE proc [dbo].[collateral_bsecode] (    
    
@FROMDATE VARCHAR (11),    
@TODATE   VARCHAR (11)    
) AS BEGIN     
    
SELECT * INTO #TEMP FROM (    
    
SELECT a.*,    
[[SCRIP_CD BSECODE]=B.SCRIP_CD,    
'NSEFO' AS EXCHANGE    
FROM [AngelFO].NSEFO.DBO.TBL_COLLATERAL_MARGIN a with (nolock)    
,angeldemat.BSEDB.dbo.multiisin b with(nolock)    
WHERE a.ISIN=b.isin and    
a.EFFDATE >=@FROMDATE AND A.EFFDATE <=@TODATE     
--ORDER BY a.EFFDATE    
----------NSEURFO---------    
UNION ALL    
SELECT a.*,    
[[SCRIP_CD BSECODE]=B.SCRIP_CD,    
'NSECURFO' AS EXCHANGE    
FROM [AngelFO].NSECURFO.DBO.TBL_COLLATERAL_MARGIN a with (nolock)    
,angeldemat.BSEDB.dbo.multiisin b with(nolock)    
WHERE a.ISIN=b.isin and    
a.EFFDATE >=@FROMDATE AND A.EFFDATE <=@TODATE     
    
-----------MCDX------    
UNION ALL    
SELECT a.*,    
[[SCRIP_CD BSECODE]=B.SCRIP_CD,    
'MCDX' AS EXCHANGE    
FROM [AngelCommodity].MCDX.DBO.TBL_COLLATERAL_MARGIN a with (nolock)    
,angeldemat.BSEDB.dbo.multiisin b with(nolock)    
WHERE a.ISIN=b.isin and    
a.EFFDATE >=@FROMDATE AND A.EFFDATE <=@TODATE    
    
-----MCDXCDS--------    
UNION ALL    
SELECT a.*,    
[[SCRIP_CD BSECODE]=B.SCRIP_CD,    
'MCDXCDS' AS EXCHANGE    
FROM [AngelCommodity].MCDXCDS.DBO.TBL_COLLATERAL_MARGIN a with (nolock)    
,angeldemat.BSEDB.dbo.multiisin b with(nolock)    
WHERE a.ISIN=b.isin and    
a.EFFDATE >=@FROMDATE AND A.EFFDATE <=@TODATE    
    
----------NCDX---------    
    
UNION ALL    
SELECT a.*,    
[[SCRIP_CD BSECODE]=B.SCRIP_CD,    
'NCDX' AS EXCHANGE    
FROM [AngelCommodity].NCDX.DBO.TBL_COLLATERAL_MARGIN a with (nolock)    
,angeldemat.BSEDB.dbo.multiisin b with(nolock)    
WHERE a.ISIN=b.isin and    
a.EFFDATE >=@FROMDATE AND A.EFFDATE <=@TODATE    
    
    
    
)A    
    
SELECT * FROM #TEMP A ORDER BY EXCHANGE    
    
END

GO
