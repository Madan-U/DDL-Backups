-- Object: PROCEDURE dbo.sbinfo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbinfo    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbinfo    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbinfo    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbinfo    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbinfo    Script Date: 12/27/00 8:59:15 PM ******/

CREATE PROCEDURE 
sbinfo
@cocode varchar(6),
@series varchar(3)
AS
Select m1.* from MBPINFO1 m1,scrip2 s2 where s2.co_code =ltrim( @cocode) and s2.series= ltrim(@series)
       and m1.scrip_cd = s2.scrip_cd and m1.series= s2.series
      order by s2.scrip_cd,s2.series

GO
