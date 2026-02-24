-- Object: PROCEDURE dbo.PaymentCalAmt
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROCEDURE PaymentCalAmt   @advicedate   datetime ,  
@tvdt datetime ,
@effdate datetime,
@LimitAmt    money
As
select  l.cltcode, acname=a.longname, EffCrAmt  =  abs(sum(CVamt) - Sum(DVamt)),
        	creditAmt= isNULL( (SELECT ISNULL(SUM(VAMT),0)    
                                                       FROM LEDGER L1
                           		WHERE  L.CLTCODE=L1.CLTCODE  AND DRCR='C'   
                            		AND  EDT Like @EFFDATE + '%'
                            		and  VDT <= LEFT(CONVERT(VARCHAR,@ADVICEDATE,109),11) + ' ' + '23:59:59'),0),              	shortage = 0  into temppayadv
	from PartyBalAmt l ,acmast a	where l.cltcode=a.cltcode and a.accat= '4' 
	group by l.cltcode, a.longname	having abs(sum(DVamt) - Sum(CVamt)) >= @LimitAmt and (sum(DVamt) - Sum(CVamt)) < 0 	order by l.cltcode 
	insert into payadv   select cltcode ,acname, @tvdt   ,effcramt - creditamt ,'',acname,'',0,effcramt,shortage,	'3','','01'
	from temppayadv where abs(effcramt - creditamt) > 0	GROUP BY cltcode ,acname, effcramt,shortage ,effcramt , creditamt	HAVING  effcramt - creditamt   > =  @limitamt
 	drop  table temppayadv

GO
