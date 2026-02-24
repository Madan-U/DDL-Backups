-- Object: PROCEDURE dbo.ChqAckVdtSelectSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ChqAckVdtSelectSp    Script Date: 01/04/1980 1:40:36 AM ******/


Create Proc ChqAckVdtSelectSp 
@Cltcode varchar(10)
As
Select Distinct  Convert(varchar,vdt,103) vdt
from Ledger 
where Vtyp = '2' and drcr = 'c' and cltcode like @Cltcode +'%'
union
Select distinct Convert(varchar,vdt,103) vdt
from acmast,marginledger 
where Vtyp = '19' and party_code = @Cltcode+'%' and party_code = cltcode 
Order By vdt

GO
