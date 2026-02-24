-- Object: PROCEDURE dbo.albmprtheadsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.albmprtheadsett    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.albmprtheadsett    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.albmprtheadsett    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.albmprtheadsett    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.albmprtheadsett    Script Date: 12/27/00 8:58:42 PM ******/

/* this sp is used inalbmprintctlprj contol. variable sdate,settno,partycode is used to get the 
shortname,partycode,address1,2,3 l_city,l_zip,ContractNo,c2.BankId,CltDpNo from client1,client2,settlement table*/
CREATE PROCEDURE  albmprtheadsett
@sdate varchar(12),
@settno varchar(10),
@partcode varchar(10)
AS
select distinct short_name,c2.party_code,
L_Address1,l_address2,L_address3, L_city,l_zip,
ContractNo,c2.BankId,CltDpNo=isnull(c4.CltDpid,'') 
from client1 c1,client2 c2,settlement s ,client4 c4
where c1.cl_code=c2.cl_code  and s.sauda_date like @sdate + '%'
and c2.party_code=c4.party_code and c2.cl_code =c4.cl_code  and c4.Instru='1' and c4.Depository='NSDL'
and sett_type = 'l'  and s.party_code = c2.party_code and s.sett_no =@settno
and s.party_code =@partcode and c2.printf = 0 
order by c2.party_code

GO
