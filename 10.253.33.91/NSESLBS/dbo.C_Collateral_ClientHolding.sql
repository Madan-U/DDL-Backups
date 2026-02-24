-- Object: PROCEDURE dbo.C_Collateral_ClientHolding
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc C_Collateral_ClientHolding    
(    
@statusid             varchar(15) ,     
@statusname       varchar(25) ,    
@rptType            varchar(2) ,    
@strExchange     varchar(3) ,    
@strSegment       varchar(10),    
@dtAsOnDate    varchar(11),    
@strPartyFrom   varchar(10),    
@strPartyTo        varchar(10)    
)    
AS    
    
If @StatusId = 'broker'     
Begin    
If @rptType <> '1'    
    Begin    
                         Select distinct c.Scrip_Cd, c.Series, c.ISIN, c.exchange, segment     
                             FROM msajag.dbo.CollateralDetails c , clientmaster c2
                             Where c.party_code = c2.party_code 
                             AND c.exchange like  @strExchange + '%' AND segment like  @strSegment + '%' AND Effdate like @dtAsOnDate + '%' and Coll_Type = 'SEC' and Qty <> 0      
                             AND c.Party_code >=  @strPartyFrom  AND c.Party_code <= @strPartyTo      
    End    
Else    
    Begin    
            --    ***    PARTYWISE    
                            Select distinct c.party_code, c.exchange, segment      
                             FROM msajag.dbo.CollateralDetails c , clientmaster c2
                             Where c.party_code = c2.party_code 
                             AND c.exchange like  @strExchange + '%' AND segment like  @strSegment + '%' AND Effdate like @dtAsOnDate + '%' and Coll_Type = 'SEC' and Qty <> 0      
                             AND c.Party_code >=  @strPartyFrom  AND c.Party_code <= @strPartyTo      
   End    
End    
Else    
Begin    
If @rptType <> '1'    
    Begin    

                         Select distinct c.Scrip_Cd, c.Series, c.ISIN, c.exchange, segment     
                             FROM msajag.dbo.CollateralDetails c , client1 c1, client2 c2
                             Where c1.cl_Code = c2.cl_code and c.party_code = c2.party_code   
                             AND c.exchange like  @strExchange + '%' AND segment like  @strSegment + '%' AND Effdate like @dtAsOnDate + '%' and Coll_Type = 'SEC' and Qty <> 0      
                             AND c.Party_code >=  @strPartyFrom  AND c.Party_code <= @strPartyTo      
         And   
                @StatusName =   
                     (case   
                           when @StatusId = 'BRANCH' then c1.branch_cd  
                           when @StatusId = 'SUBBROKER' then c1.sub_broker  
                           when @StatusId = 'Trader' then c1.Trader  
                           when @StatusId = 'Family' then c1.Family  
                           when @StatusId = 'Area' then c1.Area  
                           when @StatusId = 'Region' then c1.Region  
                           when @StatusId = 'Client' then c2.party_code  
                     else   
                           'BROKER'  
                     End)     
                         Union Select distinct c.Scrip_Cd, c.Series, c.ISIN, c.exchange, segment     
                             FROM msajag.dbo.CollateralDetails c , NSEFO.DBO.client1 c1, NSEFO.DBO.client2 c2    
                             Where c1.cl_Code = c2.cl_code and c.party_code = c2.party_code     
                             AND c.exchange like  @strExchange + '%' AND segment like  @strSegment + '%' AND Effdate like @dtAsOnDate + '%' and Coll_Type = 'SEC' and Qty <> 0      
                             AND c.Party_code >=  @strPartyFrom  AND c.Party_code <= @strPartyTo      
         And   
                @StatusName =   
                     (case   
                           when @StatusId = 'BRANCH' then c1.branch_cd  
                           when @StatusId = 'SUBBROKER' then c1.sub_broker  
                           when @StatusId = 'Trader' then c1.Trader  
                           when @StatusId = 'Family' then c1.Family  
                           when @StatusId = 'Area' then c1.Area  
                           when @StatusId = 'Region' then c1.Region  
                           when @StatusId = 'Client' then c2.party_code  
                     else   
                           'BROKER'  
                     End)    
    End    
Else    
    Begin    
            --    ***    PARTYWISE    
                             Select distinct c.party_code, c.exchange, segment      
                             FROM msajag.dbo.CollateralDetails c , client1 c1, client2 c2    
                             Where c1.cl_Code = c2.cl_code and c.party_code = c2.party_code     
                             AND c.exchange like  @strExchange + '%' AND segment like  @strSegment + '%'     
           AND Effdate like @dtAsOnDate + '%' and Coll_Type = 'SEC' and Qty <> 0      
                             AND c.Party_code >=  @strPartyFrom  AND c.Party_code <= @strPartyTo      
         And   
                @StatusName =   
                     (case   
                           when @StatusId = 'BRANCH' then c1.branch_cd  
                           when @StatusId = 'SUBBROKER' then c1.sub_broker  
                           when @StatusId = 'Trader' then c1.Trader  
                           when @StatusId = 'Family' then c1.Family  
                           when @StatusId = 'Area' then c1.Area  
                           when @StatusId = 'Region' then c1.Region  
                           when @StatusId = 'Client' then c2.party_code  
                     else   
                           'BROKER'  
                     End)    
           Union     
                             Select distinct c.party_code, c.exchange, segment      
                             FROM msajag.dbo.CollateralDetails c , NSEFO.DBO.client1 c1, NSEFO.DBO.client2 c2    
                             Where c1.cl_Code = c2.cl_code and c.party_code = c2.party_code     
                             AND c.exchange like  @strExchange + '%' AND segment like  @strSegment + '%'     
                  AND Effdate like @dtAsOnDate + '%' and Coll_Type = 'SEC' and Qty <> 0      
                             AND c.Party_code >=  @strPartyFrom  AND c.Party_code <= @strPartyTo      
         And   
                @StatusName =   
                     (case   
                           when @StatusId = 'BRANCH' then c1.branch_cd  
                           when @StatusId = 'SUBBROKER' then c1.sub_broker  
                           when @StatusId = 'Trader' then c1.Trader  
                           when @StatusId = 'Family' then c1.Family  
                           when @StatusId = 'Area' then c1.Area  
                           when @StatusId = 'Region' then c1.Region  
                           when @StatusId = 'Client' then c2.party_code  
                     else   
                           'BROKER'  
                     End)  
    
   End    
End

GO
