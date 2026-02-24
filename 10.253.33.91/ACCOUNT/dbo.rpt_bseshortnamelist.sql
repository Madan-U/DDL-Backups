-- Object: PROCEDURE dbo.rpt_bseshortnamelist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseshortnamelist    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseshortnamelist    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseshortnamelist    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseshortnamelist    Script Date: 8/8/01 1:37:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseshortnamelist    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseshortnamelist    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseshortnamelist    Script Date: 2/17/01 3:34:17 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseshortnamelist    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : allpartyledger
   file : namelist.asp
*/
/*shows list of names of clients from ledger corresponding to an alphabet*/
CREATE PROCEDURE rpt_bseshortnamelist
@statusid varchar(15),
@statusname varchar(25),
@shortname varchar(21)
AS
if @statusid = 'broker' 
begin
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM bsedb.DBO.CLIENT1 C1, bsedb.DBO.CLIENT2 C2, ledger l
WHERE c1.short_name like ltrim(@shortname)+'%' and C1.CL_CODE=C2.CL_CODE
and c2.party_code=l.cltcode 
order by c1.short_name 
end
if @statusid = 'branch' 
begin
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM bsedb.DBO.CLIENT1 C1, bsedb.DBO.CLIENT2 C2, ledger l, bsedb.dbo.branches b
WHERE c1.short_name like ltrim(@shortname)+'%' and C1.CL_CODE=C2.CL_CODE
and c2.party_code=l.cltcode 
and b.short_name=c1.trader and b.branch_cd=@statusname
order by c1.short_name 
end
if @statusid = 'trader' 
begin
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM bsedb.DBO.CLIENT1 C1, bsedb.DBO.CLIENT2 C2, ledger l
WHERE c1.short_name like ltrim(@shortname)+'%' and C1.CL_CODE=C2.CL_CODE
and c2.party_code=l.cltcode 
and c1.trader=@statusname
order by c1.short_name 
end 
if @statusid = 'subbroker' 
begin
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM bsedb.DBO.CLIENT1 C1, bsedb.DBO.CLIENT2 C2, ledger l , bsedb.dbo.subbrokers sb
WHERE c1.short_name like ltrim(@shortname)+'%' and C1.CL_CODE=C2.CL_CODE
and c2.party_code=l.cltcode 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
order by c1.short_name 
end 
if @statusid = 'client' 
begin
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM bsedb.DBO.CLIENT1 C1, bsedb.DBO.CLIENT2 C2, ledger l
WHERE c1.short_name like ltrim(@shortname)+'%' and C1.CL_CODE=C2.CL_CODE
and c2.party_code=l.cltcode and l.cltcode=@statusname
order by c1.short_name 
end

GO
