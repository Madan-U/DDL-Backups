-- Object: PROCEDURE dbo.brparty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brparty    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brparty    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brparty    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brparty    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brparty    Script Date: 12/27/00 8:58:45 PM ******/

/* Report  : Before Bill
    File : sbillclients.asp
   Displays names and partycodes of clients 
*/
CREATE PROCEDURE brparty
@br varchar(3)
AS
select distinct s.party_code,c1.short_name,s.sett_no,s.sett_type
from Settlement s, client1 c1,client2 c2, sett_mst st, branches b  where
c1.cl_code = c2.cl_code and c2.party_code = s.party_code and 
start_date <= getdate() and end_date >= getdate() and 
c1.trader=b.short_name  and b.branch_cd =@br  and s.sett_no = st.sett_no and s.sett_Type = st.sett_type
order by c1.short_name , s.party_code

GO
