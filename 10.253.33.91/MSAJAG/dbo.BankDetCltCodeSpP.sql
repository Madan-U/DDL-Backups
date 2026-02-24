-- Object: PROCEDURE dbo.BankDetCltCodeSpP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankDetCltCodeSpP    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BankDetCltCodeSpP    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BankDetCltCodeSpP    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BankDetCltCodeSpP    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.BankDetCltCodeSpP    Script Date: 12/27/00 8:58:43 PM ******/

CREATE PROCEDURE BankDetCltCodeSpP  
@acname varchar(35)
AS
select  distinct cltcode from acmast where acname =@acname

GO
