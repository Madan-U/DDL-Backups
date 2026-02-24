-- Object: PROCEDURE dbo.rpt_shortnamelist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_shortnamelist    Script Date: 2/17/01 5:19:54 PM ******/

/* report : allpartyledger
   file : namelist.asp
*/
/*shows list of names of clients from ledger corresponding to an alphabet*/
/*changed by mousami on 01/03/2001
  removed hardcoding  for sharedatabase and added hardcoding for account databse */
 
CREATE PROCEDURE rpt_shortnamelist
@statusid varchar(15),
@statusname varchar(25),
@shortname varchar(21)
AS
 if @statusid = 'broker' 
 begin
  SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
  FROM CLIENT1 C1, CLIENT2 C2, account.dbo.ledger l
  WHERE c1.short_name like ltrim(@shortname)+'%' and C1.CL_CODE=C2.CL_CODE
  and c2.party_code=l.cltcode 
  order by c1.short_name 
 end
 if @statusid = 'branch' 
 begin
  SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
  FROM CLIENT1 C1, CLIENT2 C2, account.dbo.ledger l, branches b
  WHERE c1.short_name like ltrim(@shortname)+'%' and C1.CL_CODE=C2.CL_CODE
  and c2.party_code=l.cltcode 
  and b.short_name=c1.trader and b.branch_cd=@statusname
  order by c1.short_name 
 end 
 if @statusid = 'trader' 
 begin
  SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
  FROM CLIENT1 C1, CLIENT2 C2, account.dbo.ledger l
  WHERE c1.short_name like ltrim(@shortname)+'%' and C1.CL_CODE=C2.CL_CODE
  and c2.party_code=l.cltcode 
  and c1.trader=@statusname
  order by c1.short_name 
 end 
 if @statusid = 'subbroker' 
 begin
  SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
  FROM CLIENT1 C1,CLIENT2 C2,account.dbo. ledger l , subbrokers sb
  WHERE c1.short_name like ltrim(@shortname)+'%' and C1.CL_CODE=C2.CL_CODE
  and c2.party_code=l.cltcode 
  and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
  order by c1.short_name 
 end 
 if @statusid = 'client' 
 begin
  SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
  FROM CLIENT1 C1, CLIENT2 C2,account.dbo. ledger l
  WHERE c1.short_name like ltrim(@shortname)+'%' and C1.CL_CODE=C2.CL_CODE
  and c2.party_code=l.cltcode and l.cltcode=@statusname
  order by c1.short_name 
 end

GO
