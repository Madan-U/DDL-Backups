-- Object: PROCEDURE dbo.CBO_CheckAdmin
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


-- =============================================
-- Author:		<Author,,Name>
-- ALTER  date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE CBO_CHECKADMIN 
	-- Add the parameters for the stored procedure here
	@userID varchar(25), @password varchar(25), @loginStatus varchar(50) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

    -- Insert statements for procedure here
	set transaction isolation level read uncommitted select * from tbladmin 
(nolock) where ltrim(rtrim(fldname)) = @userID and ltrim(rtrim(fldpassword)) = PRADNYA.dbo.CLASS_PWDENCRY(@PASSWORD)
if @@ROWCOUNT=1
BEGIN
	SET @loginStatus=''
END
ELSE
BEGIN
	SET @loginStatus='Login Failed'
END 


END

GO
