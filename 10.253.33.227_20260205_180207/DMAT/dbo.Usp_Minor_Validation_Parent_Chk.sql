-- Object: PROCEDURE dbo.Usp_Minor_Validation_Parent_Chk
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE procedure Usp_Minor_Validation_Parent_Chk
(@client_code varchar(100))
as
begin

--EXEC Usp_Minor_Validation_Parent_Chk '1203320001334482'
--EXEC Usp_Minor_Validation_Parent_Chk '1203320001330718'
--EXEC Usp_Minor_Validation_Parent_Chk '12033200013307181'


--Declare @client_code varchar(100)='1203320001334482'

If (select count(1) from dmat.citrus_usr.Minor_Account_Details A with (nolock) where client_code=@client_code)>0
Begin
		select case when isnull(parent_code,'')='' then 'Parent_no_Email_Sent' else 'Parent_yes_Display_Button' END Msg from dmat.citrus_usr.Minor_Account_Details A with (nolock)
		where 
		--isnull(parent_code,'')=''
		--and 
		client_code=@client_code
END
else
begin


Select 'not minor client' Msg

end

END

GO
