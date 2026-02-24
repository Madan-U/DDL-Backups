-- Object: PROCEDURE dbo.RPT_COLLATERALSTOCKREPORT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_COLLATERALSTOCKREPORT    
 (    
 @SDATE VARCHAR(11),    
 @FROMFAMILY VARCHAR(15),    
 @FROMPARTY VARCHAR(15),    
 @SCRIPCD VARCHAR(15),    
 @STATUSNAME VARCHAR(25),    
 @STATUSID VARCHAR(15)    
 )    
    
 AS    
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
	SELECT     
		Family, 
		C.Party_Code, 
		Long_Name,
		Scrip_Name = Rtrim(Scrip_Cd) + '/' + Series, 
		Qty, 
		Cl_Rate,
		BeforeHairCut = Amount, 
		HairCut, 
		AfterHairCut = FinalAmount
	FROM
		Collateraldetails C (NOLOCK), 
		Client_Details D (NOLOCK)
	WHERE 
		C.Party_Code = D.Party_Code
		AND EffDate Like @SDATE + '%'
		AND C.PARTY_CODE like @FROMPARTY + '%'    
		AND Family Like @FROMFAMILY + '%'  
		AND Coll_Type = 'SEC'
		AND Scrip_Cd like @SCRIPCD + '%'
                AND @STATUSNAME = (       
                CASE     
                 WHEN @STATUSID = 'BRANCH'     
                 THEN D.BRANCH_CD     
                 WHEN @STATUSID = 'SUBBROKER'     
                 THEN D.SUB_BROKER     
                 WHEN @STATUSID = 'TRADER'     
                 THEN D.TRADER     
                 WHEN @STATUSID = 'FAMILY'     
                 THEN D.FAMILY     
                 WHEN @STATUSID = 'AREA'     
                 THEN D.AREA     
                 WHEN @STATUSID = 'REGION'     
                 THEN D.REGION     
                 WHEN @STATUSID = 'CLIENT'     
                 THEN D.PARTY_CODE     
                 ELSE 'BROKER' END)     
	Order By     
		Family, 
		C.Party_Code

GO
