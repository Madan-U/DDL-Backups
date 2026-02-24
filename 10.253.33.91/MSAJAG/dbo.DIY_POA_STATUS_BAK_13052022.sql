-- Object: PROCEDURE dbo.DIY_POA_STATUS_BAK_13052022
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
CREATE Proc [dbo].[DIY_POA_STATUS_BAK_13052022] (@PARTY_CODE VARCHAR(10))  
AS  
  
declare @cnt int   
  
   
 /*  
 select @cnt = count(1) from (  
 select PARTY_CODE from ANGELDEMAT.MSAJAG.DBO.MultiCltId  WHERE   DEF ='0' AND DPID='12033200' AND @PARTY_CODE=PARTY_CODE   
 UNION   
 select PARTY_CODE from  ANGELDEMAT.BSEDB.DBO.MultiCltId  WHERE   DEF ='0' AND DPID='12033200' AND @PARTY_CODE=PARTY_CODE )a */  
  
   
 select @cnt = count(1) from (  
 select PARTY_CODE from   MSAJAG.DBO.MultiCltId  WHERE   DEF ='0' AND DPID in ('12033200','12033201') AND @PARTY_CODE=PARTY_CODE   
 UNION   
 select PARTY_CODE from  ANAND.BSEDB_aB.DBO.MultiCltId  WHERE   DEF ='0' AND DPID in ('12033200','12033201') AND @PARTY_CODE=PARTY_CODE )a  
    
   
  
IF (@PARTY_CODE IN ('N61558','A115390','A126749','M103737','P104922','S203000','H45178','T21077','S250357','S194943','S227494','J41740','R123896','A133377'))  
  BEGIN  
    SELECT @PARTY_CODE AS PARTY_CODE , 'I' POA_STATUS  
   RETURN    
  END  
  
  
  
 if (ISNULL(@cnt,0) >= 1 )  
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
