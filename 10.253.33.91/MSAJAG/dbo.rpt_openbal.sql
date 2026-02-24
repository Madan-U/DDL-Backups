-- Object: PROCEDURE dbo.rpt_openbal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_openbal    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_openbal    Script Date: 01/04/1980 5:06:27 AM ******/



/* report : allpartyledger 
   file : ledgerview.asp
*/
/*
Modified by neelambari on 17 oct 2001
changed datatype for date parameters from varchar to datetime
 changed by mousami on 16/7/2001 */
/* added fromdt parameter which is start date of current financial year */

/*
 calculates opening balance of a party for current financial year till date start date provided by user 
*/

/*changed by mousami on 01/03/2001
added  hardcoding for account databse*/

CREATE PROCEDURE rpt_openbal
@fromdt  datetime,
@cltcode varchar(10),
@finstartdt datetime,
@sortby varchar(3)
AS

if @sortby='vdt' 

begin
	select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger 
	WHERE vdt >= @finstartdt  and VDT <  @fromdt  and CLTCODE= @cltcode 
	group by drcr 
end 

else
begin
	select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger 
	WHERE edt >= @finstartdt  and edt <  @fromdt  and CLTCODE= @cltcode 
	group by drcr 
end 

/*
select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0), 
crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) 
from account.dbo.ledger 
WHERE VDT < @vdt and CLTCODE=@cltcode
group by drcr 
*/

GO
