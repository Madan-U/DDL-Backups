-- Object: PROCEDURE dbo.EFFECTIVE_BALANCE
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

CREATE proc [dbo].[EFFECTIVE_BALANCE]

 (  

@TODATE   VARCHAR (11)  

) AS BEGIN   



select L.CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from ledger L (nolock) ,ACMAST A (nolock) 

where  VDT>='apr  1 2017' and  

edt<=@TODATE + ' 23:59:59' AND A.CLTCODE=L.CLTCODE AND A.accat =4  
AND A.CLTCODE IN (SELECT * FROM OLDNEW) 

group by L.cltcode 

--having SUM(case when drcr='D'then vamt else -vamt end)<>0

order by L.CLTCODE 

  

END

GO
