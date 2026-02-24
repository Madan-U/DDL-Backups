-- Object: PROCEDURE dbo.AccValanCharge
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.AccValanCharge    Script Date: 3/17/01 9:55:42 PM ******/

/****** Object:  Stored Procedure dbo.AccValanCharge    Script Date: 3/21/01 12:49:58 PM ******/

/****** Object:  Stored Procedure dbo.AccValanCharge    Script Date: 20-Mar-01 11:38:41 PM ******/

CREATE proc AccValanCharge (@sett_no varchar(7),@sett_type varchar(2)) as
select * from NormalCharge where sett_no = @sett_no  and sett_type = @sett_type
union all
select * from PlusCharge where sett_no =  ( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = @sett_Type ) and sett_type = @sett_type

GO
