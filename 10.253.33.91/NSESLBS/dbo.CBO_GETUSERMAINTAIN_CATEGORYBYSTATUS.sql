-- Object: PROCEDURE dbo.CBO_GETUSERMAINTAIN_CATEGORYBYSTATUS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE    PROC CBO_GETUSERMAINTAIN_CATEGORYBYSTATUS
	@fldcate int,
	@STATUSID VARCHAR(25) = 'ADMINISTRATOR',
	@STATUSNAME VARCHAR(25) = 'ADMINISTRATOR'
AS
	IF @STATUSID <> 'ADMINISTRATOR'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END				
	select 

      ltrim(rtrim(str(fldadminauto)))+','+ltrim(rtrim(str(fldcategorycode)))+','+ltrim(rtrim(fldstname)) as fldcolmn ,* from tbladmin ta, tblcategory tc          
        
      where 
  
      ta.fldauto_admin = tc.fldadminauto and ta.fldauto_admin =@fldcate

GO
