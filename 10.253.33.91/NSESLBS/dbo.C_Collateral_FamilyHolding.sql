-- Object: PROCEDURE dbo.C_Collateral_FamilyHolding
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC C_Collateral_FamilyHolding    
	(
	@statusid         varchar(15),     
	@statusname       varchar(25),    
	@rptType          varchar(2),    
	@strExchange      varchar(3),    
	@strSegment       varchar(10),    
	@dtAsOnDate    	  varchar(11),    
	@strPartyFrom     varchar(9),    
	@strPartyTo       varchar(9)    
	)

	AS

	If @StatusId = 'broker'     
	Begin    
	If @rptType <> '1'    
	    Begin
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SET NOCOUNT ON

		Select distinct c.Scrip_Cd, c.Series, c.ISIN, c.exchange, segment     
		FROM msajag.dbo.CollateralDetails c , clientmaster c2, scrip1 s1, scrip2 s2       
		Where c.party_code = c2.party_code 
		and c.Series = s1.Series 
		and s1.co_code = s2.co_code 
		and c.scrip_cd = s2.scrip_cd      
		AND c.exchange like @strExchange + '%' 
		AND segment like @strSegment + '%' 
		AND Effdate like @dtAsOnDate + '%' 
		and Coll_Type = 'SEC' and Qty <> 0      
		AND c2.Family >= @strPartyFrom  
		AND c2.Family <= @strPartyTo      
		order by c.scrip_cd     
	    End    
	Else    
	    Begin    
	            --    ***    FAMILYWISE     
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SET NOCOUNT ON

		Select distinct party_code=C2.Family, c.exchange, segment      
		FROM msajag.dbo.CollateralDetails c , clientmaster c2, scrip1 s1, scrip2 s2       
		Where c.party_code = c2.Party_Code
		and c.Series = s1.Series 
		and s1.co_code = s2.co_code 
		and c.scrip_cd = s2.scrip_cd      
		AND c.exchange like @strExchange + '%'
		AND segment like @strSegment + '%'
		AND Effdate like @dtAsOnDate + '%'
		And Coll_Type = 'SEC' And Qty <> 0
		AND c2.Family >=  @strPartyFrom
		AND c2.Family <= @strPartyTo
		order by c2.Family
	   End    
	End    
	Else    
	Begin    
	If @rptType <> '1'    
	    Begin    
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SET NOCOUNT ON

		Select distinct c.Scrip_Cd, c.Series, c.ISIN, c.exchange, segment     
		FROM msajag.dbo.CollateralDetails c , client1 c1, client2 c2, scrip1 s1, scrip2 s2       
		Where c1.cl_Code = c2.cl_code 
		and c.party_code = c2.Party_Code
		and c.Series = s1.Series 
		and s1.co_code = s2.co_code 
		and c.scrip_cd = s2.scrip_cd      
		AND c.exchange like  @strExchange + '%' 
		AND segment like  @strSegment + '%' 
		AND Effdate like @dtAsOnDate + '%' 
		and Coll_Type = 'SEC' and Qty <> 0      
		AND c1.Family >= @strPartyFrom  
		AND c1.Family <= @strPartyTo      
		And C1.Branch_Cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)      
		And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)      
		And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)      
		And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)      
		And C2.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)   
		order by c.scrip_cd     
	    End    
	Else    
	    Begin    
	            --    ***    FAMILY    
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SET NOCOUNT ON

		Select distinct party_code = c1.Family, c.exchange, segment      
		FROM msajag.dbo.CollateralDetails c , client1 c1, client2 c2, scrip1 s1, scrip2 s2       
		Where c1.cl_Code = c2.cl_code 
		and c.party_code = c2.Party_code
		and c.Series = s1.Series 
		and s1.co_code = s2.co_code 
		and c.scrip_cd = s2.scrip_cd      
		AND c.exchange like @strExchange + '%' 
		AND segment like @strSegment + '%' 
		AND Effdate like @dtAsOnDate + '%' 
		and Coll_Type = 'SEC' and Qty <> 0      
		AND c1.Family >= @strPartyFrom  
		AND c1.Family <= @strPartyTo      
		And C1.Branch_Cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)      
		And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)      
		And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)      
		And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)      
		And C2.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)      
		order by c1.Family   
	   End    
	End

GO
