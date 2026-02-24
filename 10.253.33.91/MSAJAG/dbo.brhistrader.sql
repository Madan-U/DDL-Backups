-- Object: PROCEDURE dbo.brhistrader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brhistrader    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brhistrader    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brhistrader    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brhistrader    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brhistrader    Script Date: 12/27/00 8:58:44 PM ******/

/* Report : Bill Report
   File : Bill.asp
*/
CREATE PROCEDURE brhistrader
@br varchar(3),
@trader varchar(15)
AS
select distinct s.party_code,c1.short_name,s.sett_no,s.sett_type  
from history s, client1 c1,client2 c2, sett_mst st, branches b  
where c1.cl_code = c2.cl_code and c2.party_code = s.party_code 
and b.short_name = c1.trader and b.branch_cd = @br
and c1.trader like ltrim(@trader)
and getdate() between st.start_date and st.end_date 
order by c1.short_name , s.party_code

GO
