-- Object: PROCEDURE dbo.rpt_listclient
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  PROCEDURE RPT_LISTCLIENT
	(
	@statusid varchar(15),  
	@statusname varchar(25),  
	@partycode varchar(15),  
	@topartycode varchar(15),
	@rptType varchar(10) ='PARTYCODE'
	)
	
	AS  
  
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT 
		DISTINCT 
		CASE 
			WHEN (@rptType = 'PARTYCODE' OR @rptType = '') 
			THEN C2.Party_Code
			WHEN @rptType = 'PARTYNAME' 
			THEN C1.Long_Name
		END,
		C2.PARTY_CODE
	FROM 
		CLIENT1 C1 WITH(NOLOCK),   
		CLIENT2 C2 WITH(NOLOCK)   
	WHERE 
		C2.CL_CODE = C1.CL_CODE   
		AND @STATUSNAME =   
			(CASE   
				WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD  
				WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER  
				WHEN @STATUSID = 'TRADER' THEN C1.TRADER  
				WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY  
				WHEN @STATUSID = 'AREA' THEN C1.AREA  
				WHEN @STATUSID = 'REGION' THEN C1.REGION  
				WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE  
			ELSE   
				'BROKER'  
			END)  
		AND (CASE @rptType 
			WHEN 'PARTYCODE' THEN PARTY_CODE
			WHEN 'PARTYNAME' THEN LONG_NAME
			WHEN '' THEN PARTY_CODE
			END) BETWEEN @partycode AND @topartycode

	ORDER BY 
		1

GO
