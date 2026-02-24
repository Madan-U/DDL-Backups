-- Object: PROCEDURE dbo.rpt_ageingclbal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ageingclbal    Script Date: 01/19/2002 12:15:12 ******/

/****** Object:  Stored Procedure dbo.rpt_ageingclbal    Script Date: 01/04/1980 5:06:25 AM ******/



/* ageing report 
     file : ageingreport
*/
/* finds balance of a party on a date starting from opening entry date */

CREATE procedure rpt_ageingclbal

@openingentry varchar(12),
@backdate varchar(12)

as

select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0) ,
	cltcode, acname
	from rpt_ageingview
	WHERE (VDT >= @openingentry AND VDT <=@backdate + ' 11:59 pm')
	group by cltcode,acname,drcr 
	order by cltcode,acname,drcr

GO
