-- Object: PROCEDURE dbo.obligation
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.obligation    Script Date: 3/17/01 9:55:54 PM ******/

/****** Object:  Stored Procedure dbo.obligation    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.obligation    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.obligation    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.obligation    Script Date: 12/27/00 8:58:52 PM ******/

CREATE PROCEDURE obligation 
@settno varchar(8),
@settype varchar(3),
@scripcd varchar(12)
as
select inout,scrip_cd,sum(qty) from deliveryclt 
where sett_no=@settno  and sett_type=@settype  and scrip_Cd=@scripcd 
group by inout,scrip_Cd ,series
order by inout

GO
