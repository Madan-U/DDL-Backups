-- Object: PROCEDURE dbo.bridno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.bridno    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.bridno    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.bridno    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.bridno    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.bridno    Script Date: 12/27/00 8:58:44 PM ******/

/* Report : Market report
    File : right.asp
*/
CREATE PROCEDURE bridno
@id varchar(10)
AS
select distinct sett_no from history where party_code = @id
group by sett_no

GO
