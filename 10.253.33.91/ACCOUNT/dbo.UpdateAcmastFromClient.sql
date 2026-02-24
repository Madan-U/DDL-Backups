-- Object: PROCEDURE dbo.UpdateAcmastFromClient
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.UpdateAcmastFromClient    Script Date: 20-Mar-01 11:43:37 PM ******/

CREATE PROCEDURE    UpdateAcmastFromClient 
 AS
/*inserts clients from client to acmast table */
insert into acmast
select short_name,   long_name ,'Asset','4','',party_code ,'','A0307000000'
from MSAJAG.DBO.client1 c1,MSAJAG.DBO.client2 c2 where c1.cl_code=c2.cl_code 
and  party_code not in
(select cltcode from account.dbo.acmast)
/*updates the acname in acmast to that of short_names from clients */
update acmast set acname = short_name 
from MSAJAG.DBO.client1 c1,MSAJAG.DBO.client2 c2 ,acmast
 where c1.cl_code=c2.cl_code 
and  party_code =cltcode
 and short_name <> acname
/* if any change is made in acmast the same has to be reflected  in ledger */
update ledger set acname = a.acname
from acmast a ,ledger l  where 
l.cltcode =a.cltcode and l.acname <> a.acname

GO
