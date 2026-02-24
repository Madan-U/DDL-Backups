-- Object: PROCEDURE dbo.INACTIVE_CLIENT_ENTRIES
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--INACTIVE_CLIENT_ENTRIES 'DEC  1 2020','DEC  1 2020'  
  
  
CREATE PROCEDURE  INACTIVE_CLIENT_ENTRIES  
(          
@FROMDATE varchar (11),          
@TODATE  varchar(11)          
)AS          
BEGIN   
  
  
  
select Cltcode,vamt,Vdt,ddno  
into #data1  
 from Ledger l,ledger1 l1, msajag.dbo.client5 c  
where --vdt >=Convert(varchar(11),Getdate()-1,120) and
 l.vtyp=2  
and l.BookType='01' and l.drcr ='C' and  l.vno=l1.vno and l.VTYP=l1.vtyp  
and l.BOOKTYPE=l1.BookType and  
cltcode =cl_code and InactiveFrom <getdate()--AND CLTCODE='AGRA2869'  
AND vdt>= @fromdate AND  vdt< = @todate + ' 23:59:59:999'  
order by vdt  
  
  
---(379 row(s) affected)as dscussed with nirmal for mcx and nsefo segment  
SELECT DISTINCT A.*,Exchange,Segment,Active_Date,InActive_From   FROM #data1 A  
LEFT OUTER JOIN  
MSAJAG..CLIENT_BROK_DETAILS B  
ON A.CLTCODE=B.Cl_Code  
AND Exchange IN ('MCX','NSE')AND Segment='FUTURES'and InActive_From>GETDATE() ---AND CLTCODE='A111545'  
ORDER BY A.CLTCODE  
  
END

GO
