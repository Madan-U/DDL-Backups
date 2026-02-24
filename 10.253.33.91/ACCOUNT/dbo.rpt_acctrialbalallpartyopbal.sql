-- Object: PROCEDURE dbo.rpt_acctrialbalallpartyopbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acctrialbalallpartyopbal    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_acctrialbalallpartyopbal    Script Date: 11/28/2001 12:23:46 PM ******/


/* report : trial balance */
/* finds total debit and credit of all client accounts as on a particular date */


CREATE PROCEDURE  rpt_acctrialbalallpartyopbal

@vdt  datetime,
@openentry varchar(12),
@sortbydate varchar(3)


AS

/*openning entry found */

if @sortbydate='vdt'
begin
if @openentry <>  '' 
begin
	select dramt = ( select isnull(sum(vamt),0) from account.dbo.ledger l3, account.dbo.acmast a  
	where drcr = 'D'  and vdt  like  ltrim(@openentry) + '%'  and a.cltcode=l3.cltcode and a.accat=4) ,

	cramt = (select isnull(sum(vamt),0) from account.dbo.ledger l3 ,account.dbo.acmast a
	where drcr = 'C' and  vdt like  ltrim(@openentry) + '%'   and a.cltcode=l3.cltcode and a.accat=4) 
	From account.dbo.Ledger l 
	group by drcr
	order by drcr
end 
else
begin
	select dramt = ( select isnull(sum(vamt),0) from account.dbo.ledger l3, account.dbo.acmast a  
	where drcr = 'D'  and vdt <= @vdt + ' 23:59:59' and a.cltcode=l3.cltcode and a.accat=4) ,

	cramt = (select isnull(sum(vamt),0) from account.dbo.ledger l3 ,account.dbo.acmast a
	where drcr = 'C' and  vdt <= @vdt + ' 23:59:59'  and a.cltcode=l3.cltcode and a.accat=4) 
	From account.dbo.Ledger l  
	group by drcr
	order by drcr
end
end 
else 
begin
if @openentry <>  '' 
begin
	select dramt = ( select isnull(sum(vamt),0) from account.dbo.ledger l3, account.dbo.acmast a  
	where drcr = 'D'  and edt  like  ltrim(@openentry) + '%'  and a.cltcode=l3.cltcode and a.accat=4) ,

	cramt = (select isnull(sum(vamt),0) from account.dbo.ledger l3 ,account.dbo.acmast a
	where drcr = 'C' and edt like  ltrim(@openentry) + '%'   and a.cltcode=l3.cltcode and a.accat=4) 
	From account.dbo.Ledger l 
	group by drcr
	order by drcr
end 
else
begin
	select dramt = ( select isnull(sum(vamt),0) from account.dbo.ledger l3, account.dbo.acmast a  
	where drcr = 'D'  and edt <= @vdt + ' 23:59:59' and a.cltcode=l3.cltcode and a.accat=4) ,

	cramt = (select isnull(sum(vamt),0) from account.dbo.ledger l3 ,account.dbo.acmast a
	where drcr = 'C' and  edt <= @vdt + ' 23:59:59'  and a.cltcode=l3.cltcode and a.accat=4) 
	From account.dbo.Ledger l  
	group by drcr
	order by drcr
end

end

GO
