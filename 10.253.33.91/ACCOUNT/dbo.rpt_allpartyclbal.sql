-- Object: PROCEDURE dbo.rpt_allpartyclbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_allpartyclbal    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_allpartyclbal    Script Date: 11/28/2001 12:23:46 PM ******/


/* report : allpartyledger
   file : allpartyclbal
 calculates debit  and credit  totals  of  all accounts of a client code*/

/* 
Modified by neelambari on 17 oct 2001
changed dateformat ti datetime

chnaged by neelamari on 5 sept 2001
made modifications for sortbydate = vdt /dt as chosen by the user
*/

/*changed by mousami on 16/08/2001
    removed client1 and client2 join from query
    as there is no need to cross check with client2
   for query other than  family login 
*/    

/*changed by mousami on  25/06/2001
    added a condition that don't take opening balance entry as we have 
    taken its effect in previous entry
*/
/*changed by mousami on 01/03/2001
removed hardcoding 
for sharedatabase and added hardcoding for account databse*/

/* changed by mousami on 09/02/2001
     added family login
*/
 

CREATE PROCEDURE rpt_allpartyclbal
@sortbydate varchar(4),
@acname varchar(35),
@fromdt  datetime ,
@todt datetime ,
@statusid varchar(15),
@statusname varchar(25)

AS
if @sortbydate ='vdt'
begin
if @statusid='family'
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo. ledger l ,account.dbo. vmast, client2 c2 ,client1 c1 
	where l.acname = c1.short_Name and c1.cl_code = c2.cl_code 
	and c2.party_code=l.cltcode and c1.family=@statusname 
	and vtyp=vtype and vdt >= @fromdt and vdt<=@todt + ' 23:59:59'  /* put space before 23:59:59pm' */
	and l.vtyp <> '18'
	group by drcr 

end 
else
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo. ledger l ,account.dbo. vmast
	where  l.acname = @acname 
	and vtyp=vtype and vdt >= @fromdt and vdt<=@todt + ' 23:59:59'  /* put space before 23:59:59' */
	and l.vtyp <> '18'
	group by drcr 
end

end


if @sortbydate ='edt'
begin
if @statusid='family'
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo. ledger l ,account.dbo. vmast, client2 c2 ,client1 c1 
	where l.acname = c1.short_Name 
	and c1.cl_code = c2.cl_code 
	and c2.party_code=l.cltcode
	and c1.family=@statusname 
	and vtyp=vtype and edt >= @fromdt 
	and edt<=@todt + ' 23:59:59'  /* put space before 23:59:59' */
	and l.vtyp <> '18'
	group by drcr 

end 
else
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo. ledger l ,account.dbo. vmast
	where  l.acname = @acname 
	and vtyp=vtype 
	and edt >= @fromdt 
	and edt<=@todt + ' 23:59:59'  /* put space before 23:59:59' */
	and l.vtyp <> '18'
	group by drcr 
end

end

GO
