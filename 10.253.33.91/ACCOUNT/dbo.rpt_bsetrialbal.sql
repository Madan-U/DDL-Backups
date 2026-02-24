-- Object: PROCEDURE dbo.rpt_bsetrialbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bsetrialbal    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bsetrialbal    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetrialbal    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetrialbal    Script Date: 8/8/01 1:37:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetrialbal    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetrialbal    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsetrialbal    Script Date: 2/17/01 3:34:17 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bsetrialbal    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : trial balance
   file : trialbal.asp
*/
/* displays trial balance */
     
CREATE PROCEDURE rpt_bsetrialbal 
@statusid varchar(15),
@statusname varchar(25),
@vdt varchar(10)
AS
if @statusid = 'broker'
begin
select l.cltcode , clcode=(select cl_code from bsedb.dbo.client2 c2 
where c2.party_code=l.cltcode),l.acname, 
Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode 
and vdt <= @vdt + ' 23:59:59') - 
(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') 
From Ledger l where vdt <= @vdt + ' 23:59:59' 
group by l.Cltcode, l.acname 
end 
if @statusid = 'branch'
begin
select l.cltcode , clcode=(select cl_code from bsedb.dbo.client2 c2 
where c2.party_code=l.cltcode),l.acname, 
Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode 
and vdt <= @vdt + ' 23:59:59')- 
(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') 
From Ledger l, bsedb.dbo.branches b, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2
where vdt <= @vdt + ' 23:59:59' 
and b.branch_cd=@statusname
and b.short_name=c1.trader
and c1.cl_code=c2.cl_code
and c2.party_code=l.cltcode
group by l.Cltcode, l.acname 
end 
if @statusid = 'trader'
begin
select l.cltcode , clcode=(select cl_code from bsedb.dbo.client2 c2 
where c2.party_code=l.cltcode),l.acname, 
Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode 
and vdt <= @vdt + ' 23:59:59')- 
(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') 
From Ledger l,  bsedb.dbo.client1 c1, bsedb.dbo.client2 c2
where vdt <= @vdt + ' 23:59:59' 
and c1.trader=@statusname
and c1.cl_code=c2.cl_code
and c2.party_code=l.cltcode
group by l.Cltcode, l.acname 
end 
if @statusid='subbroker'
begin
select l.cltcode , clcode=(select cl_code from bsedb.dbo.client2 c2 
where c2.party_code=l.cltcode),l.acname, 
Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode 
and vdt <= @vdt + ' 23:59:59')- 
(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') 
From Ledger l, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2, bsedb.dbo.subbrokers sb
where vdt <= @vdt + ' 23:59:59' 
and sb.sub_broker=@statusname
and sb.sub_broker=c1.sub_broker
and c1.cl_code=c2.cl_code
and c2.party_code=l.cltcode
group by l.Cltcode, l.acname 
end
if @statusid='client'
begin
select l.cltcode , clcode=(select cl_code from bsedb.dbo.client2 c2 
where c2.party_code=l.cltcode),l.acname, 
Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode 
and vdt <= @vdt + ' 23:59:59')- 
(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') 
From Ledger l , bsedb.dbo.client1 C1, bsedb.dbo.client2 C2
where vdt <= @vdt + ' 23:59:59' and
c1.cl_code=c2.cl_code
and c2.party_code=l.cltcode
and l.cltcode=@statusname
group by l.Cltcode, l.acname 
end

GO
