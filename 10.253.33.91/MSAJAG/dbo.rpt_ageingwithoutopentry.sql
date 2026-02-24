-- Object: PROCEDURE dbo.rpt_ageingwithoutopentry
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ageingwithoutopentry    Script Date: 01/19/2002 12:15:12 ******/

/****** Object:  Stored Procedure dbo.rpt_ageingwithoutopentry    Script Date: 01/04/1980 5:06:25 AM ******/



/* report : ageing report 
    file : ageing report 
*/

/* calculates balance of a party on a particular date */

CREATE procedure rpt_ageingwithoutopentry   

@backdate varchar(12)

as
select cltcode,drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
crtot=isnull((case drcr when 'c' then sum(vamt) end),0) , acname
from rpt_ageingview  
WHERE  VDT <=@backdate + ' 11:59 pm'
group by cltcode,acname,drcr 
order by cltcode,acname,drcr

GO
