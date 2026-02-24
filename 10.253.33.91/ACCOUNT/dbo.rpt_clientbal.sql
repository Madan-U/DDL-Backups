-- Object: PROCEDURE dbo.rpt_clientbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clientbal    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_clientbal    Script Date: 11/28/2001 12:23:49 PM ******/


/*
modified by neelambari on 17 oct 2001
changed date format
*/
/*
   report :  allpartyledger
   file : singleparty.asp
*/

CREATE PROCEDURE rpt_clientbal
@todt datetime,
@cltcode varchar(10),
@sortbydate varchar(4)
AS

if @sortbydate = 'vdt'
begin

	select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger 
	WHERE  VDT <=@todt + ' 23:59:59'
	and CLTCODE=@cltcode
	group by drcr 
end

if @sortbydate = 'edt'
begin

	select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger 
	WHERE  edt <=@todt + ' 23:59:59'
	and CLTCODE=@cltcode
	group by drcr 
end

GO
