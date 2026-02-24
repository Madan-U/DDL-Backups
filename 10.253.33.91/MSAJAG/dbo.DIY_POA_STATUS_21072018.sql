-- Object: PROCEDURE dbo.DIY_POA_STATUS_21072018
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE Proc [dbo].[DIY_POA_STATUS_21072018] (@PARTY_CODE VARCHAR(10))
AS

declare @cnt int 

IF (LEFT(@PARTY_CODE,4)='DIYD' )
	BEGIN 
	select @cnt = count(1) from (
	select * from MultiCltId  WHERE LEFT(PARTY_CODE ,4)='DIYD' AND DEF ='0' AND DPID='12033200' AND @PARTY_CODE=PARTY_CODE 
	UNION 
	select * from ANAND.BSEDB_AB.DBO.MultiCltId  WHERE LEFT(PARTY_CODE ,4)='DIYD' AND DEF ='0' AND DPID='12033200' AND @PARTY_CODE=PARTY_CODE )a
	

	end 

	 if @cnt >= 1 
   begin 
     SELECT @PARTY_CODE AS PARTY_CODE , 'I' POA_STATUS
   RETURN
    END
    ELSE 
	  BEGIN 
	  	 SELECT @PARTY_CODE AS PARTY_CODE , 'A' POA_STATUS
	  RETURN 
	  END

GO
