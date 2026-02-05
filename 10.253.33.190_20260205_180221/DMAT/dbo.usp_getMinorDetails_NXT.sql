-- Object: PROCEDURE dbo.usp_getMinorDetails_NXT
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


Create procedure usp_getMinorDetails_NXT
(@client_code varchar(100))
as
begin

select 
	FIRST_HOLD_NAME	,isnull(First_Holder_Addr	,FOREIGN_Addr) First_Holder_Addr	

 from 
(

select FIRST_HOLD_NAME,
FIRST_HOLD_ADD1+ ' ' +FIRST_HOLD_ADD2+ ' ' +FIRST_HOLD_ADD3+' ' +FIRST_HOLD_STATE+' ' +FIRST_HOLD_CNTRY+' ' +FIRST_HOLD_PIN First_Holder_Addr,	
FOREIGN_ADDR1+' '+ FOREIGN_ADDR2+' '+ FOREIGN_ADDR3+' '+ FOREIGN_CITY+' '+ FOREIGN_STATE+' '+ FOREIGN_CNTRY+' '+FOREIGN_ZIP FOREIGN_Addr
 from tbl_client_master with (nolock) where CLIENT_CODE=@client_code
 ) T 

END

GO
