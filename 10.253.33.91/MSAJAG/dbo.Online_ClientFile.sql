-- Object: PROCEDURE dbo.Online_ClientFile
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Online_ClientFile    Script Date: 04/13/2004 2:28:35 PM ******/
CREATE Proc Online_ClientFile As

select c2.party_code,long_name,('xxxxxxxxxxxx') as branch_cd,Email=IsNull(Email,''),isnull(l_address1,'') as l_address1,
isnull(l_address2,'') as l_address2,isnull(l_address3,'') as l_address3,isnull(l_city,'')+IsNull(L_Zip,'') as l_city,
Res_Phone1=IsNull(Res_Phone1,''),Fax=IsNull(Fax,'') , isnull(family,'') as family,BankId=IsNull(c4.bankid,''),cltdpid=IsNull(cltdpid,'') 
from Client1 C1, Client2 C2 Left Outer Join Client4 C4
On ( C4.Party_Code = C2.Party_Code And DefDp = 1 And Depository in ('CDSL','NSDL'))
Where c1.cl_code = c2.cl_code
and c2.dummy10 ='ONLINE'

GO
