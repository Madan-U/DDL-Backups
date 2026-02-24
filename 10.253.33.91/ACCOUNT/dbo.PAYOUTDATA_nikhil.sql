-- Object: PROCEDURE dbo.PAYOUTDATA_nikhil
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE proc PAYOUTDATA_nikhil (  
  
@FROMDATE VARCHAR(11),  
@TODATE   VARCHAR(11)  
)AS  
BEGIN   
SELECT   
  
[CLTCODE]=A.CLTCODE,  
[Short_Name]=B.Short_Name,  
[REGION]=B.Region,  
[Branch_cd]=B.Branch_cd,  
[Sub_Broker]=B.Sub_Broker,  
[VDT]=A.VDT,  
[vno]= A.VNO,  
[NARRATION]=A.NARRATION,  
[VAMT]=A.VAMT,  
[DDNO]=C.ddno,  
[vtyp]=A.VTYP,  
[reldt]=C.reldt,  
[EXCHANGE]='NSE'  
  
  
  
  
  
INTO #TEMP  
FROM LEDGER A LEFT OUTER JOIN MSAJAG..client1 B ON a.cltcode = b.cl_code   
right outer join ledger1 C on a.vno = c.vno and a.vtyp = c.vtyp   
  
where a.vtyp='3' and a.vdt>=@FROMDATE   
AND  a.vdt< =@TODATE+ ' 23:59:59:999' and c.reldt='1900-01-01 00:00:00.000'  
and isnumeric(a.cltcode)  ='0'  
and a.cltcode in (select cltcode from acmast where accat=4)  
order by a.cltcode  
  
select * into #ledger from ledger a with (nolock) where  
a.vtyp='3' and a.vdt> =@FROMDATE   
and a.vdt< = @TODATE+ ' 23:59:59:999' and vno in (select vno from #temp)  
  
SELECT B.CLTCODE,B.ACNAME,A.REGION,A.BRANCH_CD,A.SUB_BROKER,A.VDT,A.VNO,A.VAMT,B.DRCR,A.DDNO,A.NARRATION,a.RELDT,'NSE' AS EXCHANGE  
FROM #TEMP A INNER JOIN #LEDGER B ON A.VNO=B.VNO  
  
END  
  
  
---EXEC PAYOUTDATA 'MAY  1 2015','MAY 28 2015'

GO
