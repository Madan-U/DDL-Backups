-- Object: PROCEDURE dbo.rpt_bsetraderwise
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bsetraderwise    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bsetraderwise    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetraderwise    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetraderwise    Script Date: 8/8/01 1:37:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetraderwise    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetraderwise    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetraderwise    Script Date: 2/17/01 3:34:17 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bsetraderwise    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : traderwise ledger
    file : traderwise.asp
 */
/* displays list of party  short names as per the selection made by user */
CREATE PROCEDURE rpt_bsetraderwise
@statusid varchar(15),
@statusname varchar(25),
@trader varchar(15)
AS
if @statusid = 'broker' 
begin
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM bsedb.DBO.CLIENT1 C1, bsedb.DBO.CLIENT2 C2, ledger l
WHERE C1.TRADER=@trader
AND C1.CL_CODE=C2.CL_CODE and c2.party_code=l.cltcode 
ORDER BY C1.SHORT_NAME  
end
if @statusid = 'branch' 
begin
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM bsedb.DBO.CLIENT1 C1, bsedb.DBO.CLIENT2 C2, ledger l,  bsedb.DBO.branches b 
WHERE C1.TRADER=@trader
AND C1.CL_CODE=C2.CL_CODE and c2.party_code=l.cltcode 
and b.branch_cd=@statusname and b.short_name=c1.trader
ORDER BY C1.SHORT_NAME  
end
if @statusid = 'trader' 
begin
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM bsedb.DBO.CLIENT1 C1, bsedb.DBO.CLIENT2 C2, ledger l
WHERE C1.TRADER=@trader
AND C1.CL_CODE=C2.CL_CODE and c2.party_code=l.cltcode 
ORDER BY C1.SHORT_NAME  
end 
if @statusid = 'subbroker' 
begin
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM bsedb.DBO.CLIENT1 C1, bsedb.DBO.CLIENT2 C2, ledger l,  bsedb.DBO.subbrokers sb
WHERE C1.TRADER=@trader
AND C1.CL_CODE=C2.CL_CODE and c2.party_code=l.cltcode 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
ORDER BY C1.SHORT_NAME  
end 
if @statusid = 'client' 
begin
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM bsedb.DBO.CLIENT1 C1, bsedb.DBO.CLIENT2 C2, ledger l
WHERE C1.TRADER=@trader and l.cltcode=@statusname
AND C1.CL_CODE=C2.CL_CODE and c2.party_code=l.cltcode 
ORDER BY C1.SHORT_NAME  
end

GO
