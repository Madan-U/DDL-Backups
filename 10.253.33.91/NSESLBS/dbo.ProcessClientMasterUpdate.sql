-- Object: PROCEDURE dbo.ProcessClientMasterUpdate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Proc ProcessClientMasterUpdate (
@dbname varchar(50),
@servername varchar(50),
@uid varchar(50),
@pwd varchar(50),
@branch varchar(10),
@fromparty varchar(50),
@toparty varchar(50) )
AS

DECLARE @object int
DECLARE @hr int
DECLARE @return varchar(255)
DECLARE @src varchar(255), @desc varchar(255)

-- Create a SQLServer object.
SET NOCOUNT ON

-- First, create the object.
EXEC @hr = sp_OACreate 'prjClientUpload.clsClientUpload', @object OUT
IF @hr <> 0
BEGIN
   -- Report the error.
   EXEC sp_OAGetErrorInfo @object, @src OUT, @desc OUT 
   SELECT hr=convert(varbinary(4),@hr), Source=@src, Description=@desc
   GOTO END_ROUTINE
END
ELSE
   -- An object is successfully created.
   BEGIN
      -- Set a property.
      EXEC @hr = sp_OASetProperty @object, 'db_name', @dbname
      IF @hr <> 0 GOTO CLEANUP

      EXEC @hr = sp_OASetProperty @object, 'Server_Name', @servername
      IF @hr <> 0 GOTO CLEANUP      

      EXEC @hr = sp_OASetProperty @object, 'Server_Uid', @uid
      IF @hr <> 0 GOTO CLEANUP

      EXEC @hr = sp_OASetProperty @object, 'Server_PWD', @pwd
      IF @hr <> 0 GOTO CLEANUP

      EXEC @hr = sp_OASetProperty @object, 'Branch', @branch
      IF @hr <> 0 GOTO CLEANUP

      EXEC @hr = sp_OASetProperty @object, 'FromParty', @fromparty
      IF @hr <> 0 GOTO CLEANUP

      EXEC @hr = sp_OASetProperty @object, 'ToParty', @toparty
      IF @hr <> 0 GOTO CLEANUP
      
      -- SECURITY NOTE - When possible, use Windows Authentication.
      EXEC @hr = sp_OAMethod @object, 'ProcessClientMasterUpdate'
      IF @hr <> 0 GOTO CLEANUP
     
   END

CLEANUP:
   -- Check whether an error occurred.
   IF @hr <> 0
   BEGIN
      -- Report the error.
      EXEC sp_OAGetErrorInfo @object, @src OUT, @desc OUT 
      SELECT hr=convert(varbinary(4),@hr), Source=@src, Description=@desc
   END

   -- Destroy the object.
   BEGIN
      EXEC @hr = sp_OADestroy @object
      -- Check if an error occurred.
      IF @hr <> 0 
      BEGIN
         -- Report the error.
         EXEC sp_OAGetErrorInfo @object, @src OUT, @desc OUT 
         SELECT hr=convert(varbinary(4),@hr), Source=@src, Description=@desc
      END
   END

END_ROUTINE:
RETURN

GO
