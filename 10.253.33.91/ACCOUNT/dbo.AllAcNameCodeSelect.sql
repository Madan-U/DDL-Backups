-- Object: PROCEDURE dbo.AllAcNameCodeSelect
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.AllAcNameCodeSelect    Script Date: 11/12/2002 4:38:57 PM ******/

/****** Object:  Stored Procedure dbo.AllAcNameCodeSelect    Script Date: 06/05/2002 12:03:45 PM ******/
/****** Object:  Stored Procedure dbo.AcNameCodeSelect    Script Date: 05/04/2002 12:57:04 PM ******/
/*
MODIFIED BY SHEETAL ON 05/05/2002 as the branch code is present in acmast also 
*/
CREATE Proc AllAcNameCodeSelect
@branch varchar(10),
@flag int

AS

if @flag = 1 
begin
	SELECT DISTINCT acname,cltcode FROM ACMAST WHERE branchcode like @branch+'%' and accat <> '4'
	order by acname
end
else
if @flag = 2
begin
	SELECT DISTINCT acname,cltcode FROM ACMAST WHERE branchcode like @branch+'%' 
	order by acname
end

GO
