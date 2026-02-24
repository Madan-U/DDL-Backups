-- Object: PROCEDURE dbo.pr_CreateBOUsers_Pop
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE   Proc  pr_CreateBOUsers_Pop (@PartyFrom VARCHAR (10),@PartyTo as varchar(10),@Password Varchar(10)='S64')
As      
  
Declare      
	@PartyCur Cursor,      
	@PartyCode  varchar(10),
	@PartyName  varchar(10)
      
Set @PartyCur = Cursor for  
							Select 
								Party_Code,Short_Name
							From
								Client1, Client2
							Where 
								Client1.Cl_Code = Client2.Cl_Code
								And Client2.Party_Code Between @PartyFrom and @PartyTo
								And Party_Code Not In 
														(
															Select FldUserName from TblPradnyaUsers
														) 
Open @PartyCur                
Fetch Next From @PartyCur into @PartyCode,@PartyName
While @@Fetch_Status = 0       
Begin      
	EXECUTE pCreateBOUsers  'I','CLIENT','CLIENTS',@PartyCode,@Password,@PartyName,'',''
    
 Fetch Next From @PartyCur into @PartyCode,@PartyName
End      
Close @PartyCur      
DeAllocate @PartyCur

GO
