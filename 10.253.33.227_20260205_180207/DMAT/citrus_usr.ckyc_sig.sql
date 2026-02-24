-- Object: PROCEDURE citrus_usr.ckyc_sig
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[ckyc_sig]
as 
			
			select PARTYCODE,ACCD_BINARY_IMAGE 
	  
			from VW_CLIENT_SIG_DATA with(nolock),INTRANET.risk.dbo.tbl_Ckyc_sign
			where PARTYCODE =Party_Code

GO
