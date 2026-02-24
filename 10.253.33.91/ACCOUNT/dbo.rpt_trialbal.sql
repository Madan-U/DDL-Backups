-- Object: PROCEDURE dbo.rpt_trialbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_trialbal    Script Date: 20-Mar-01 11:43:36 PM ******/

/* report : trial balance
   file : trialbal.asp
*/
/* displays trial balance */
     
CREATE PROCEDURE rpt_trialbal 
@statusid varchar(15),
@statusname varchar(25),
@vdt varchar(10)
AS
	if @statusid = 'broker'
	begin
		select l.cltcode , clcode=isnull((select cl_code from msajag.dbo.client2 c2 
		where c2.party_code=l.cltcode),''),l.acname, 
		Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode 
		and vdt <= @vdt + ' 23:59:59') - 
		(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') 
		From Ledger l where vdt <= @vdt + ' 23:59:59' 
		group by l.Cltcode, l.acname order by l.cltcode
	end 
	
	if @statusid = 'branch'
	begin
		select l.cltcode , clcode=isnull((select cl_code from msajag.dbo.client2 c2 
		where c2.party_code=l.cltcode),''),l.acname, 
		Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode 
		and vdt <= @vdt + ' 23:59:59') - 
		(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') 
		From Ledger l, msajag.dbo.branches b, msajag.dbo.client1 c1, msajag.dbo.client2 c2
		where vdt <= @vdt + ' 23:59:59' 
		and b.branch_cd=@statusname
		and b.short_name=c1.trader
		and c1.cl_code=c2.cl_code
		and c2.party_code=l.cltcode
		group by l.Cltcode, l.acname 
	end 
	
	if @statusid = 'trader'
	begin
		select l.cltcode , clcode=isnull((select cl_code from msajag.dbo.client2 c2 
		where c2.party_code=l.cltcode),''),l.acname, 
		Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode 
		and vdt <= @vdt + ' 23:59:59')- 
		(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') 
		From Ledger l,  msajag.dbo.client1 c1, msajag.dbo.client2 c2
		where vdt <= @vdt + ' 23:59:59' 
		and c1.trader=@statusname
		and c1.cl_code=c2.cl_code
		and c2.party_code=l.cltcode
		group by l.Cltcode, l.acname 
	end 

	if @statusid='subbroker'
	begin
		select l.cltcode , clcode=isnull((select cl_code from msajag.dbo.client2 c2 
		where c2.party_code=l.cltcode),''),l.acname, 
		Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode 
		and vdt <= @vdt + ' 23:59:59')- 
		(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') 
		From Ledger l, msajag.dbo.client1 c1, msajag.dbo.client2 c2, msajag.dbo.subbrokers sb
		where vdt <= @vdt + ' 23:59:59' 
		and sb.sub_broker=@statusname
		and sb.sub_broker=c1.sub_broker
		and c1.cl_code=c2.cl_code
		and c2.party_code=l.cltcode
		group by l.Cltcode, l.acname 
	end

	if @statusid='client'
	begin
		select l.cltcode , clcode=isnull((select cl_code from msajag.dbo.client2 c2 
		where c2.party_code=l.cltcode),''),l.acname, 
		Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode 
		and vdt <= @vdt + ' 23:59:59')- 
		(select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode and vdt <= @vdt + ' 23:59:59') 
		From Ledger l , msajag.dbo.client1 C1, msajag.dbo.client2 C2
		where vdt <= @vdt + ' 23:59:59' and
		c1.cl_code=c2.cl_code
		and c2.party_code=l.cltcode
		and l.cltcode=@statusname
		group by l.Cltcode, l.acname 
	end

GO
