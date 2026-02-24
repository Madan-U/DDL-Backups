-- Object: PROCEDURE dbo.rpt_clcodeopentry
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcodeopentry    Script Date: 01/19/2002 12:15:13 ******/

/****** Object:  Stored Procedure dbo.rpt_clcodeopentry    Script Date: 01/04/1980 5:06:26 AM ******/




/****** Object:  Stored Procedure dbo.rpt_clcodedrcr2    Script Date: 2/17/01 5:19:40 PM ******/

/* report :allpartyledger report
   file : allparty.asp 
*/
/* 
Modified by neelambari on 17 oct 2001
changed date data type to datetime

changed by mousami on 16th aug 2001
     removed client1, client2 from broker and other login query as 
    per discussion with sheetal that there is no need to check that party code exists in master table or not */
/*displays vamt of opening entry*/

CREATE PROCEDURE rpt_clcodeopentry
@acname varchar(35),
@vdt datetime,
@statusid varchar(15),
@statusname varchar(25)

AS

if @statusid='family' 
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
	 from account.dbo.ledger l, client2 c2,client1 c1 
	where c1.cl_code = c2.cl_code and c2.party_code=l.cltcode
	and c1.family=@statusname and vdt like ltrim(@vdt)+'%'
	and l.vtyp='18'
	group by drcr 
end 
else
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
	 from account.dbo.ledger l
	where  l.acname =@acname and  vdt like ltrim(@vdt)+'%'
	and l.vtyp='18'
	group by drcr 
end

GO
