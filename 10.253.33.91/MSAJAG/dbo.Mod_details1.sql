-- Object: PROCEDURE dbo.Mod_details1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc Mod_details1 
as 

begin 

truncate table [Automate_Mod_details_Segment]
truncate table [Automate_Mod_details_Address]
truncate table [Automate_Mod_details_Mobile]
truncate table [Automate_Mod_details_Email]
truncate table [Automate_Mod_details_BANK]

	Declare @fromdate datetime , @todate datetime
	set @fromdate =convert(vARCHAR(11),GETDATE()-4,109)
	set @todate =convert(vARCHAR(11),GETDATE(),109) 
	
INSERT INTO [MSAJAG].[dbo].[Automate_Mod_details_Segment]
           ([CREATED_DT]
           ,[CRN_NO]
           ,[BO_PARTYCODE]
           ,[EXCHANGE]
           ,[SEGMENT]
           ,[MODIFICATION_REQUEST]
           ,[Activation_Status])
	exec  Mod_details @fromdate, @todate,'S'
	
INSERT INTO [MSAJAG].[dbo].[Automate_Mod_details_Address]
           ([CREATED_DT]
           ,[CRN_NO]
           ,[BO_PARTYCODE]
           ,[MOD_TYPE]
           ,[CITRUS_COR_ADD]
           ,[BO_COR_ADD]
           ,[CITRUS_PER_ADD]
           ,[BO_PER_ADD]
           ,[MODIFICATION_REQUEST]
           ,[DP_ADDRESS])
	
	exec  Mod_details  @fromdate, @todate  ,'A'
	
	
	INSERT INTO [MSAJAG].[dbo].[Automate_Mod_details_Mobile]
           ([CREATED_DT]
           ,[CRN_NO]
           ,[BO_PARTYCODE]
           ,[MOD_TYPE]
           ,[APP_MOB_NO]
           ,[MODIFICATION_REQUEST]
           ,[ASPER_BO]
           ,[DP_MOBILE]
           ,[FIRST_HOLD_PHONE])
           
    exec  Mod_details  @fromdate, @todate  ,'M'       
	
	
	INSERT INTO [MSAJAG].[dbo].[Automate_Mod_details_Email]
           ([CREATED_DT]
           ,[CRN_NO]
           ,[BO_PARTYCODE]
           ,[MOD_TYPE]
           ,[APP_EMAIL]
           ,[MODIFICATION_REQUEST]
           ,[EMAIL]
           ,[repatriat_bank_ac_no]
           ,[DP_ADDRESS])

 exec  Mod_details  @fromdate, @todate  ,'E'    
 
 INSERT INTO [MSAJAG].[dbo].[Automate_Mod_details_BANK]
           ([BO_PARTYCODE]
           ,[PER_CITRUS]
           ,[ACNUM_PER_CITRUS]
           ,[PER_BO]
           ,[PER_BOACNUM]
           ,[MODIFICATION_REQUEST]
           ,[Mod_type]
           ,[DP_BANK])
           
  exec  Mod_details  @fromdate, @todate  ,'B'

end

GO
