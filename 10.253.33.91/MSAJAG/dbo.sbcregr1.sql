-- Object: PROCEDURE dbo.sbcregr1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbcregr1    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbcregr1    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbcregr1    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbcregr1    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbcregr1    Script Date: 12/27/00 8:59:14 PM ******/

CREATE PROCEDURE 
sbcregr1
 @id  varchar(10)
as
select fldparty,fldgrno,fldgrname 
from tblscripsel 
where fldparty =ltrim(@id)
 order by fldgrno

GO
