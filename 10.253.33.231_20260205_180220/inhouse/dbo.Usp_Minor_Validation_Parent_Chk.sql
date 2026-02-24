-- Object: PROCEDURE dbo.Usp_Minor_Validation_Parent_Chk
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

CREATE procedure Usp_Minor_Validation_Parent_Chk      
(@client_code varchar(100))      
as      
begin      
      
--EXEC Usp_Minor_Validation_Parent_Chk '1203320001334482'      
--EXEC Usp_Minor_Validation_Parent_Chk '1203320001330718'      
--EXEC Usp_Minor_Validation_Parent_Chk '12033200013307181'      
      
      
--Declare @client_code varchar(100)='1203320001334482'     
    
select count(1) Cnt into #temp from AGMUBODPL3.dmat.citrus_usr.Minor_Account_Details A with (nolock) where client_code=@client_code    
union all    
select count(1) from AngelDP5.dmat.citrus_usr.Minor_Account_Details A with (nolock) where client_code=@client_code    
    
      
If (select count(1) from #temp )>0      
Begin      
  select case when isnull(parent_code,'')='' then 'Parent_no_Email_Sent' else 'Parent_yes_Display_Button' END Msg from     
  AGMUBODPL3.dmat.citrus_usr.Minor_Account_Details A with (nolock)      
  where       
  client_code=@client_code  And  client_code <='1203320099999999'      
  Union all    
    select case when isnull(parent_code,'')='' then 'Parent_no_Email_Sent' else 'Parent_yes_Display_Button' END Msg from     
  AngelDP5.dmat.citrus_usr.Minor_Account_Details A with (nolock)      
  where       
  client_code=@client_code And  client_code  >'1203320099999999'      
    
    
    
END      
else      
begin      
      
      
Select 'not minor client' Msg      
      
end      
      
END

GO
