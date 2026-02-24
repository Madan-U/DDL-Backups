-- Object: PROCEDURE dbo.edeqtsubtype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.edeqtsubtype    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.edeqtsubtype    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.edeqtsubtype    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.edeqtsubtype    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.edeqtsubtype    Script Date: 12/27/00 8:59:07 PM ******/

/****** Object:  Stored Procedure dbo.edeqtsubtype    Script Date: 12/18/99 8:24:09 AM ******/
create procedure edeqtsubtype
@eqt_sub_type varchar(3),
@Description varchar(25),
@code varchar(3) OUTPUT,
@desc varchar(30) OUTPUT  AS
update eqtsubtype
Set 
eqt_sub_type = @eqt_sub_type,
description = @description
where 
  eqt_sub_type = @eqt_sub_type
Select * from eqtsubtype where eqt_sub_type like @eqt_sub_type

GO
