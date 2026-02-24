-- Object: PROCEDURE dbo.CBO_GETSETT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






--EXEC CBO_GETSETT '2005538','D','ALBK','0A143','BROKER','BROKER'


CREATE        PROCEDURE [dbo].[CBO_GETSETT]
(
	@SETT_NO VARCHAR(15),
   @SETT_TYPE VARCHAR(25),
   @SCRIP_CODE VARCHAR(10),
   @PARTY_CODE VARCHAR(10),
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
DECLARE
	@SQL Varchar(2000)
		
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
			BEGIN
				SELECT Party_Code,Scrip_Cd,TransNo,Qty,DpId,CltAccno,SNo from 
					 bsedb.dbo.DematTrans where  Party_Code = @PARTY_CODE 
					And Scrip_Cd = @SCRIP_CODE 
					And Sett_No = @SETT_NO 
					And Sett_Type = @SETT_TYPE
					--And TrType <> 906
					--And IsIn In (Select IsIn From MultiIsIn Where Scrip_Cd = DematTrans.Scrip_Cd 
										--And Valid = 1 And Series = DematTrans.Series And IsIn = DematTrans.IsIn)
					--Order By Party_Code,Scrip_Cd,TransNo,Qty,DpId,CltAccno

			END

SET QUOTED_IDENTIFIER OFF

GO
