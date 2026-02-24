-- Object: PROCEDURE dbo.selectbranch2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.selectbranch2    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.selectbranch2    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.selectbranch2    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.selectbranch2    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.selectbranch2    Script Date: 12/27/00 8:59:02 PM ******/

/****** Object:  Stored Procedure dbo.selectbranch2    Script Date: 12/18/99 8:24:11 AM ******/
create procedure selectbranch2
@findtext varchar(30) = "%"
as
select * from branches where branch_cd like @findtext
order by branch_cd  
EXEC selectbranch1 "A"

GO
