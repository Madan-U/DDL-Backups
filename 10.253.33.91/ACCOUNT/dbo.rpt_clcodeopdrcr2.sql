-- Object: PROCEDURE dbo.rpt_clcodeopdrcr2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcodeopdrcr2    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_clcodeopdrcr2    Script Date: 11/28/2001 12:23:49 PM ******/



/* report :allpartyledger report
   file : allparty.asp 
*/
/*
Modified by neelambari on 17 oct 2001
changed  date data type to date time
Modified by neelambari on 5 sept 2001
Made modification if the user choses sort by date =vdt /edt then added parameter accordingly
*/
/*changed by mousami on 16/08/2001
    removed client1 and client2 from login other than family
    as there is no need to compare against master
*/
/*displays debit and credit of  totals of all accounts of a client code till a particular date*/

CREATE PROCEDURE rpt_clcodeopdrcr2
@sortbydate varchar(4),
@acname varchar(35),
@vdt datetime ,
@statusid varchar(15),
@statusname varchar(25)
AS
if @sortbydate ='vdt'
begin
if @statusid='family' 
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
	 from account.dbo.ledger l, client2 c2,client1 c1 
	where c1.cl_code=c2.cl_code and c2.party_code=l.cltcode
	and c1.family=@statusname and  vdt < @vdt
	group by drcr 
end 
else
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
	 from account.dbo.ledger l
	where  l.acname =@acname and  vdt < @vdt
	group by drcr 
end 
end /* if sort by dtae = vdt*/

/*if sort by date chosen = edt the part below is executed*/
if @sortbydate ='edt'
begin
if @statusid='family' 
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
	 from account.dbo.ledger l, client2 c2,client1 c1 
	where c1.cl_code=c2.cl_code and c2.party_code=l.cltcode
	and c1.family=@statusname and  edt < @vdt
	group by drcr 
end 
else
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
	 from account.dbo.ledger l
	where  l.acname =@acname and  edt < @vdt
	group by drcr 
end 
end

GO
