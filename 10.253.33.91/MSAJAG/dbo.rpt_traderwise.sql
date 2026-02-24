-- Object: PROCEDURE dbo.rpt_traderwise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_traderwise    Script Date: 01/19/2002 12:15:16 ******/

/****** Object:  Stored Procedure dbo.rpt_traderwise    Script Date: 01/04/1980 5:06:28 AM ******/




/****** Object:  Stored Procedure dbo.rpt_traderwise    Script Date: 2/17/01 5:19:55 PM ******/


/****** Object:  Stored Procedure dbo.rpt_traderwise    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_traderwise    Script Date: 20-Mar-01 11:39:04 PM ******/


/*Modified by amolika on 1st march'2001 : removed msajag.dbo. & added account.dbo. to all account tables*/
/* report : traderwise ledger
    file : traderwise.asp
 */
/* displays list of party  short names as per the selection made by user */
CREATE PROCEDURE rpt_traderwise
@statusid varchar(15),
@statusname varchar(25),
@trader varchar(15)
AS
if @statusid = 'broker' 
begin
SELECT DISTINCT C1.CL_CODE, ltrim(C1.SHORT_NAME )
FROM  CLIENT1 C1,  CLIENT2 C2, account.dbo.ledger l
WHERE C1.TRADER=@trader
AND C1.CL_CODE=C2.CL_CODE and c2.party_code=l.cltcode 
ORDER BY   ltrim(C1.SHORT_NAME )
end
if @statusid = 'branch' 
begin
SELECT DISTINCT C1.CL_CODE, ltrim(C1.SHORT_NAME ) 
FROM CLIENT1 C1, CLIENT2 C2, account.dbo.ledger l,  branches b 
WHERE C1.TRADER=@trader
AND C1.CL_CODE=C2.CL_CODE and c2.party_code=l.cltcode 
and b.branch_cd=@statusname and b.short_name=c1.trader
ORDER BY  ltrim(C1.SHORT_NAME )
end
if @statusid = 'trader' 
begin
SELECT DISTINCT C1.CL_CODE,  ltrim(C1.SHORT_NAME ) 
FROM CLIENT1 C1, CLIENT2 C2, account.dbo.ledger l
WHERE C1.TRADER=@trader
AND C1.CL_CODE=C2.CL_CODE and c2.party_code=l.cltcode 
ORDER BY  ltrim(C1.SHORT_NAME )  
end 
if @statusid = 'subbroker' 
begin
SELECT DISTINCT C1.CL_CODE,  ltrim(C1.SHORT_NAME ) 
FROM CLIENT1 C1, CLIENT2 C2, account.dbo.ledger l,  subbrokers sb
WHERE C1.TRADER=@trader
AND C1.CL_CODE=C2.CL_CODE and c2.party_code=l.cltcode 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
ORDER BY  ltrim(C1.SHORT_NAME )  
end 
if @statusid = 'client' 
begin
SELECT DISTINCT C1.CL_CODE,  ltrim(C1.SHORT_NAME ) 
FROM CLIENT1 C1, CLIENT2 C2, account.dbo.ledger l
WHERE C1.TRADER=@trader and l.cltcode=@statusname
AND C1.CL_CODE=C2.CL_CODE and c2.party_code=l.cltcode 
ORDER BY  ltrim(C1.SHORT_NAME )  
end

GO
