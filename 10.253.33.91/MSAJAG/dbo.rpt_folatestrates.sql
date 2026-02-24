-- Object: PROCEDURE dbo.rpt_folatestrates
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_folatestrates    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_folatestrates    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_folatestrates    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_folatestrates    Script Date: 5/5/2001 1:24:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_folatestrates    Script Date: 4/30/01 5:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_folatestrates    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_folatestrates    Script Date: 12/27/00 8:59:10 PM ******/
CREATE PROCEDURE rpt_folatestrates
@inst varchar(6)
AS
select Inst_type,symbol,convert(varchar,expirydate,106)'expirydate',price,sell_buy 
from fotrade4432
where inst_type like ltrim(@inst)+'%'

GO
