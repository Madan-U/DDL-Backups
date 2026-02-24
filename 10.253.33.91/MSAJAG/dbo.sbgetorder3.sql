-- Object: PROCEDURE dbo.sbgetorder3
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbgetorder3    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbgetorder3    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbgetorder3    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbgetorder3    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbgetorder3    Script Date: 12/27/00 8:59:00 PM ******/

CREATE PROCEDURE
 sbgetorder3
@id varchar(10),
@shortname varchar(21),
@scripname varchar(12),
@series varchar(3),
@quantity int,
@rate varchar(10),
@sellbuy varchar(10),
@market varchar(7),
@orderflag char(1)
AS
Insert into tblorders 
select isnull(max(fldauto),0)+1,
ltrim(@id),
ltrim(@shortname) ,
ltrim(@scripname),
ltrim(@series),
ltrim(@quantity),
ltrim(@rate),
ltrim(@sellbuy),
ltrim(@market),
ltrim(@orderflag)from tblorders

GO
