-- Object: PROCEDURE dbo.rpt_clientopenbal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clientopenbal    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_clientopenbal    Script Date: 01/04/1980 5:06:26 AM ******/

/*
modified by neelambari on 17 oct 2001
changed te dat type of todt from varchar to datetime
*/
/*
   report :  allpartyledger
   file : ledgerview.asp
 
calculates balance till date */
CREATE  procedure rpt_clientopenbal
@todt datetime ,
@cltcode varchar (10),
@sortby varchar(3)
AS
if @sortby='vdt' 
begin
	select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger 
	WHERE  VDT < @todt 
	and CLTCODE=@cltcode
	group by drcr 
end 
else
begin
	select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger 
	WHERE  edt < @todt 
	and CLTCODE=@cltcode
	group by drcr 

end

GO
