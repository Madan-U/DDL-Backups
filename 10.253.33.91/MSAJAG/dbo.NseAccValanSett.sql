-- Object: PROCEDURE dbo.NseAccValanSett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------








/****** Object:  Stored Procedure dbo.NseAccValanSett    Script Date: 09/07/2001 11:08:59 PM ******/

/****** Object:  Stored Procedure dbo.NseAccValanSett    Script Date: 7/1/01 2:26:28 PM ******/

/****** Object:  Stored Procedure dbo.NseAccValanSett    Script Date: 06/26/2001 8:48:15 PM ******/

/****** Object:  Stored Procedure dbo.NseAccValanSett    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.NseAccValanSett    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.NseAccValanSett    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.NseAccValanSett    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.NseAccValanSett    Script Date: 12/27/00 8:58:52 PM ******/


/****** Object:  Stored Procedure dbo.NseAccValanSett    Script Date: 1/6/2001 3:59:12 PM ******/
CREATE proc NseAccValanSett (@sett_no varchar(7),@sett_type varchar(2)) as
select * from NseSettSum where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from NseSettoppalbm where sett_no = @sett_no  and sett_type = @sett_type
union all
select * from Nseplusonealbm where sett_no = (Case when @sett_type = 'N' then 
( Select Min(sett_no) from sett_mst where sett_no > @sett_no   and sett_type = @sett_type ) else @Sett_No end ) and sett_type = @sett_type

GO
