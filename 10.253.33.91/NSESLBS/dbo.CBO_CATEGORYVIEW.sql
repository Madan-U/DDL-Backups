-- Object: PROCEDURE dbo.CBO_CATEGORYVIEW
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





/****** Object:  Stored Procedure CBO_CATEGORYVIEW  Script Date: 5/18/04 1:04:54 PM ******/  
  
CREATE   PROCEDURE CBO_CATEGORYVIEW
 as 
/*SELECT * FROM  

tblcategory 
ORDER BY  

Fldadminauto


*/

select r.fldreportcode,
	        r.fldreportname, 
		r.flddesc,
		g.fldgrpname
		from tblreports r (nolock),
		tblreportgrp g (nolock) 
		where r.fldreportgrp =g.fldreportgrp and (r.fldstatus = 'All' or r.fldstatus = 'Broker') 
		order by r.fldreportgrp

GO
