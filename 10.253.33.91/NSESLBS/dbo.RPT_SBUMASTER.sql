-- Object: PROCEDURE dbo.RPT_SBUMASTER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--EXEC RPT_SBUMASTER '0','zzz'
CREATE PROC RPT_SBUMASTER 
(
	@Sbu_CodeFROM VARCHAR(10),
	@Sbu_CodeTO   VARCHAR(10)
	
)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
IF @Sbu_CodeFROM = '' BEGIN SET @Sbu_CodeFROM = '0' END
IF @Sbu_CodeTO = '' BEGIN SET @Sbu_CodeTO = 'ZZZ' END

BEGIN
	Select 
		Sbu_Code,Sbu_Name,Sbu_Addr1,Sbu_Addr2,Sbu_Addr3,Sbu_State,Sbu_City,Sbu_Zip,Sbu_Phone1,Sbu_Phone2,Sbu_Type,Sbu_Party_Code  
	From 
		SBU_MASTER (nolock)
	Where 
		sbu_code >= @Sbu_CodeFROM
		And sbu_code <= @Sbu_CodeTO
END

GO
