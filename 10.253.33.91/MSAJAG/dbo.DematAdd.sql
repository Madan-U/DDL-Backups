-- Object: PROCEDURE dbo.DematAdd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DematAdd    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DematAdd    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.DematAdd    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.DematAdd    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DematAdd    Script Date: 12/27/00 8:59:07 PM ******/

/****** Object:  Stored Procedure dbo.DematAdd    Script Date: 11/29/2000 10:49:27 AM ******/
CREATE PROCEDURE    DematAdd
@Flag int,
@scripcd varchar(20),
@series varchar(10),
@Isin varchar(20)
AS
if @flag=1
 insert into multiisin values (@scripcd ,@series ,@isin)
else if @flag=2
 update multiisin set Scrip_cd = @Scripcd,Series = @Series where Isin = @Isin

GO
