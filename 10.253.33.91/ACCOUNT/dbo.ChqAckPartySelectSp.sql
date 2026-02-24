-- Object: PROCEDURE dbo.ChqAckPartySelectSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ChqAckPartySelectSp    Script Date: 01/04/1980 1:40:36 AM ******/


Create Proc ChqAckPartySelectSp 
@Vdt varchar(11)
As
Select Distinct Acname, Cltcode 
from Ledger 
where Vtyp = '2' and drcr = 'c' and Vdt like @Vdt+'%'
union
Select Distinct Acname, party_code 
from acmast,marginledger 
where Vtyp = '19' and party_code = cltcode and Vdt like @Vdt+'%'
order by acname

GO
