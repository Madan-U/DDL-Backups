-- Object: PROCEDURE dbo.sbtrademtom1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtrademtom1    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtrademtom1    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtrademtom1    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtrademtom1    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtrademtom1    Script Date: 12/27/00 8:59:02 PM ******/

CREATE Procedure sbtrademtom1 (@short_name varchar(20),@partycode varchar(10)) as
     select * from trademtom WHERE short_name like @short_name  and party_code like @partycode 
     union 
     select * from settmtom WHERE short_name like @short_name and party_code like @partycode

GO
