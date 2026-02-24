-- Object: PROCEDURE dbo.clterr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.clterr    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.clterr    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.clterr    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.clterr    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.clterr    Script Date: 12/27/00 8:58:47 PM ******/

/****** Object:  Stored Procedure dbo.clterr    Script Date: 12/18/99 8:24:03 AM ******/
CREATE PROCEDURE clterr AS
select party_code , user_id  from trade where party_code not in (select distinct party_code from client2)

GO
