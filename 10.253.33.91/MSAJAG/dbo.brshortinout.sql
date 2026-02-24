-- Object: PROCEDURE dbo.brshortinout
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brshortinout    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brshortinout    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brshortinout    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brshortinout    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brshortinout    Script Date: 12/27/00 8:58:46 PM ******/

/* Report : rec shortage
   File : recshortage
displays internal obligation of a scrip for a branch
*/
CREATE PROCEDURE brshortinout
@br varchar(3),
@settno varchar(7),
@settype varchar(3),
@scripcd varchar(12)
AS
select inout,scrip_cd,sum(qty) from deliveryclt clt, client1 c1, client2 c2, branches b 
where sett_no=@settno  and sett_type=@settype  and scrip_Cd=@scripcd and 
b.short_name=c1.trader and c2.party_code=clt.party_code and c1.cl_code=c2.cl_code and b.branch_cd=@br
group by inout,scrip_Cd ,series
order by inout

GO
