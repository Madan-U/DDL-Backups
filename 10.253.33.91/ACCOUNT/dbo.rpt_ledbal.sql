-- Object: PROCEDURE dbo.rpt_ledbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ledbal    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : cheques
    file: todayscheques.asp
*/
/* displays ledger balance of a client till a particular date */
CREATE PROCEDURE rpt_ledbal
@vdt smalldatetime,
@partycode varchar(10)
 AS
select l.cltcode,amount=isnull(((select sum(l1.vamt) from ledger l1 where l1.drcr='d' and l.cltcode=l1.cltcode 
and l1.vdt <= @vdt + ' 23:59:59' 
group by l1.cltcode ,l1.drcr ) -
(select sum(l1.vamt) from ledger l1 where l1.drcr='c' and l.cltcode=l1.cltcode and l1.vdt <= @vdt + ' 23:59:59'
 group by l1.cltcode, l1.drcr)),0) from ledger l where l.vdt <= @vdt + ' 23:59:59'  /* put spaces before 23:59:59 */
and l.cltcode=@partycode
group by l.cltcode

GO
