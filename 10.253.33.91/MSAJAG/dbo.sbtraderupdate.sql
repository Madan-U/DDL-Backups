-- Object: PROCEDURE dbo.sbtraderupdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtraderupdate    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtraderupdate    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtraderupdate    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtraderupdate    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtraderupdate    Script Date: 12/27/00 8:59:02 PM ******/

/** file : traderorder.asp
 report : online trading ***/
CREATE PROCEDURE 
sbtraderupdate
@auto numeric(9),
@id varchar(10)
 AS
Update tblorders set fldflag = 2 where fldauto =@auto and fldparty=@id

GO
