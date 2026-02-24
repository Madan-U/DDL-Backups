-- Object: PROCEDURE dbo.EFFECTIVE_BALANCE_MFSS
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

CREATE proc [dbo].[EFFECTIVE_BALANCE_MFSS]  
 (    
@TODATE   VARCHAR (11)    
) AS BEGIN     
SELECT CLTCODE ,SUM(CASE WHEN DRCR='D' THEN VAMT ELSE VAMT*-1 END) BAL INTO #BAL4  
FROM LEDGER WHERE VDT >='2019-04-01'   AND EDT <= @TODATE + ' 23:59:59'   
GROUP BY CLTCODE   
INSERT INTO #BAL4  
SELECT CLTCODE ,SUM(CASE WHEN DRCR='D' THEN VAMT*-1 ELSE VAMT END) FROM LEDGER  
 WHERE VDT < '2019-04-01'  AND EDT > @TODATE + ' 23:59:59'   AND  VTYP in ( '15' ,'35')  
 GROUP BY CLTCODE   
  
select 'MFSS'as SEGMENT,L.CLTCODE,SUM(CRAMOUNT-DRAMOUNT) BALANCE INTO #DATA from ANGELFO.BBO_FA.DBO.MFSS_LEDGER_BSE L (nolock) ,[AngelFO].BBO_FA.DBO.ACMAST A (nolock)   
where  VDT>='apr  1 2018' and    
edt<= @TODATE + ' 23:59:59' AND A.CLTCODE=L.CLTCODE AND A.accat =4    
 AND A.CLTCODE IN (SELECT * FROM MTFTRADE.dbo.oldnew  
)  
group by L.cltcode   
--having SUM(case when drcr='D'then vamt else -vamt end)<>0  
order by L.CLTCODE   
INSERT  INTO #DATA   
 select 'MTF'as SEGMENT,CLTCODE,SUM(BAL) BAL from #BAL4     
where    cltcode IN (SELECT * FROM oldnew)   
GROUP BY CLTCODE  
order by CLTCODE  
SELECT * into data12 FROM #DATA   
SELECT * FROM DATA12   
order by SEGMENT  
drop table DATA12  
END

GO
