-- Object: PROCEDURE dbo.edeqttype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.edeqttype    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.edeqttype    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.edeqttype    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.edeqttype    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.edeqttype    Script Date: 12/27/00 8:59:07 PM ******/

/****** Object:  Stored Procedure dbo.edeqttype    Script Date: 12/18/99 8:24:09 AM ******/
create procedure edeqttype
@eqt_type varchar(3),
@Description varchar(25),
@code varchar(3) OUTPUT AS
update eqttype
Set 
eqt_type = @eqt_type,
description = @description
where 
  eqt_type = @eqt_type
Select eqt_type from eqttype where eqt_type like @eqt_type

GO
