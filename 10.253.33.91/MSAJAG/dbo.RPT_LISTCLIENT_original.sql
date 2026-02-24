-- Object: PROCEDURE dbo.RPT_LISTCLIENT_original
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE   PROCEDURE RPT_LISTCLIENT   
  (          
  @statusid varchar(15),            
  @statusname varchar(25),  
  @partycode varchar(15),            
  @topartycode varchar(15),          
  @branch_frm varchar(15),  
  @branch_to  varchar(15),  
  @SubBroker_frm varchar(20),  
  @SubBroker_to  varchar(20)
         )          
   AS   
  
     if @branch_frm = '' begin set @branch_frm = '0'  end    
     if @branch_to = '' begin set @branch_to = 'zzzzzz' end    
     if @SubBroker_frm = '' begin set @SubBroker_frm = '0'  end    
     if @SubBroker_to = '' begin set @SubBroker_to = 'zzzzzz' end           
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
   SELECT           
    
    C2.PARTY_CODE          
   FROM                   
    CLIENT1 C1 WITH(NOLOCK),             
    CLIENT2 C2 WITH(NOLOCK)             
   WHERE           
          C2.CL_CODE = C1.CL_CODE  
  AND BRANCH_CD  >=  @branch_frm  
  AND BRANCH_CD  <=  @branch_to              
  AND SUB_BROKER  >= @SubBroker_frm  
  AND SUB_BROKER  <= @SubBroker_to  
                AND  PARTY_CODE >= @partycode  
  AND  PARTY_CODE <= @topartycode  
  
         AND @STATUSNAME =             
        (  
  CASE             
              WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD            
              WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER            
              WHEN @STATUSID = 'TRADER' THEN C1.TRADER            
              WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY            
              WHEN @STATUSID = 'AREA' THEN C1.AREA            
              WHEN @STATUSID = 'REGION' THEN C1.REGION            
              WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE            
          ELSE             
       'BROKER'            
         END  
        )            

            ORDER BY           
              1

GO
