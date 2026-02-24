-- Object: PROCEDURE dbo.SPX_KRA_CHARGES_GST_CLIENTS
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

-- =============================================      
-- Author:  Ankita Kelaiya      
-- Create date: 09-03-2018      
-- Description: <Every month GST charges clients details to return GST. Requested by Prayag shah>      
-- =============================================      
CREATE PROCEDURE SPX_KRA_CHARGES_GST_CLIENTS      
       
AS      
BEGIN      
       
truncate table KRA_CHARGES_DATA_FOR_GST      
      
insert into KRA_CHARGES_DATA_FOR_GST      
select segment,VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION,''       
from      
(      
SELECT 'NSE' as segment,VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM account.dbo.ledger      
WHERE   drcr in ( 'D')       
                     AND vtyp = 8       
                     and NARRATION like ('KRA CHRGS DR TO CLT%')      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
UNION ALL      
SELECT 'NSE' as segment,VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM account.dbo.ledger      
WHERE   drcr = 'C'       
                     AND vtyp = 8       
                     and CLTCODE in ('131000008','131000006','131000007','99610')      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
      
union all      
      
SELECT 'BSE',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelBSECM].Account_Ab.dbo.ledger      
WHERE drcr in ( 'D')       
                     AND vtyp = 8       
                     and NARRATION like ('KRA CHRGS DR TO CLT%')      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
union all      
SELECT 'BSE',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelBSECM].Account_Ab.dbo.ledger      
WHERE drcr = 'C'       
                     AND vtyp = 8       
                     and CLTCODE in ('131000008','131000006','131000007','99610')      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
      
UNION ALL      
      
SELECT 'NSX',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelFO].AccountCurFO.dbo.ledger      
WHERE drcr in ( 'D')       
                     AND vtyp = 8 and NARRATION LIKE 'KRA CHRGS DR TO CLT%'      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
UNION ALL      
SELECT 'NSX',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelFO].AccountCurFO.dbo.ledger      
WHERE drcr = 'C'       
                     AND vtyp = 8       
                     and CLTCODE in ('131000008','131000006','131000007','99610')      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
      
      
UNION ALL      
      
SELECT 'NSEFO',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelFO].ACCOUNTFO.DBO.LEDGER      
WHERE drcr in ( 'D')       
                     AND vtyp = 8 and NARRATION LIKE 'KRA CHRGS DR TO CLT%'      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
UNION ALL      
SELECT 'NSEFO',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelFO].ACCOUNTFO.DBO.LEDGER      
WHERE drcr = 'C'       
                     AND vtyp = 8       
                     and CLTCODE in ('131000008','131000006','131000007','99610')      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
      
UNION ALL      
      
SELECT 'MCD',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelCommodity].Inhouse.dbo.ledger      
WHERE drcr in ( 'D')       
                     AND vtyp = 8 and NARRATION LIKE 'KRA CHRGS DR TO CLT%'      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
UNION ALL      
SELECT 'MCD',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelCommodity].Inhouse.dbo.ledger      
WHERE drcr = 'C'       
                     AND vtyp = 8       
                     and CLTCODE in ('131000008','131000006','131000007','99610')      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
      
UNION ALL      
      
SELECT 'MCDX',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelCommodity].AccountMcdx.dbo.ledger      
WHERE drcr in ( 'D')       
                     AND vtyp = 8 and NARRATION LIKE 'KRA CHRGS DR TO CLT%'      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
UNION ALL      
SELECT 'MCDX',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelCommodity].AccountMcdx.dbo.ledger      
WHERE drcr = 'C'       
                     AND vtyp = 8       
                     and CLTCODE in ('131000008','131000006','131000007','99610')      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
      
UNION ALL      
      
SELECT 'NCDX',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelCommodity].AccountNcdx.dbo.ledger      
WHERE drcr in ( 'D')       
                     AND vtyp = 8 and NARRATION LIKE 'KRA CHRGS DR TO CLT%'       
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
      
UNION ALL      
SELECT 'NCDX',VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
--INTO #nse_ledger      
FROM [AngelCommodity].AccountNcdx.dbo.ledger      
WHERE drcr = 'C'       
                     AND vtyp = 8       
                     and CLTCODE in ('131000008','131000006','131000007','99610')      
AND VDT >=DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0)   and VDT <=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0))      
GROUP BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
) a      
ORDER BY VTYP,VNO,EDT,ACNAME,DRCR,VAMT,VDT,BALAMT,CDT,CLTCODE,ENTEREDBY,CHECKEDBY,NARRATION      
      
      
update KRA_CHARGES_DATA_FOR_GST set [state]=l_state from MSAJAG.dbo.client_details a,KRA_CHARGES_DATA_FOR_GST b      
where a.party_code=b.cltcode      
      
END

GO
