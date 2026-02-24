-- Object: PROCEDURE dbo.usp_tbl_200_curfo
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_tbl_200_curfo
@f varchar(30)
AS
begin
select * from tbl_200_curfo where f=@f
END

GO
