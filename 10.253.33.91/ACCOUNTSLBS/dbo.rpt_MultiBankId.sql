-- Object: PROCEDURE dbo.rpt_MultiBankId
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE  Proc rpt_MultiBankId
(
	@partyfrom varchar(20),  
	@partyto varchar(20),  
	@sortby varchar(20)  
) 
as  
if @partyto ='' begin set @partyto ='zzzzzzz' end

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        
Select   
	strOrder = case 
		when @sortby= 1 then Cltcode 
		when @sortby= 2 then Chequename 
		when @sortby= 3 then Bank_Name 
		when @sortby= 4 then Branch_Name 
		end,

 	Cltcode,
	Chequename,
	Bank_Name,
	Branch_Name,
	Acctype,
	Accno,
	Defaultbank = case when Defaultbank=1 then 'Yes' else '' end
From   
 	MultiBankId (NOLOCK) ,Msajag..PoBank P (NOLOCK)
Where   
	MultiBankId.Bankid=P.Bankid 
	And cltcode Between @partyfrom and @partyto

Order by 1

GO
