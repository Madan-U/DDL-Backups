-- Object: PROCEDURE dbo.ECN_REPORT_PRINT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[ECN_REPORT_PRINT]        
              
 @STATUSID VARCHAR(15),              
 @STATUSNAME VARCHAR(25),        
  @FROMBRANCHCODE VARCHAR(10),        
@TOBRANCHCODE VARCHAR(10),    
@FROMDATE DATETIME,        
@TODATE DATETIME        
AS        
        
Select distinct party_code into #bse from AngelBSECM.bsedb_ab.dbo.cmbillvalan with (nolock)          
where  sauda_date BETWEEN @FROMDATE AND @TODATE and Sett_type in ('C','D')  and Branch_cd BETWEEN @FROMBRANCHCODE AND @TOBRANCHCODE        
Select distinct party_code into #nse from anand1.msajag.dbo.cmbillvalan with (nolock) where   sauda_date BETWEEN @FROMDATE AND @TODATE and Sett_type in ('N','W') and Branch_cd BETWEEN @FROMBRANCHCODE AND @TOBRANCHCODE        
Select distinct party_code into #nsefo from angelfo.nsefo.dbo.fobillvalan with (nolock)  where   sauda_date BETWEEN @FROMDATE AND @TODATE and Branch_code BETWEEN @FROMBRANCHCODE AND @TOBRANCHCODE        
Select distinct party_code into #nsx from angelfo.nsecurfo.dbo.fobillvalan with (nolock)  where   sauda_date BETWEEN @FROMDATE AND @TODATE  and Branch_code BETWEEN @FROMBRANCHCODE AND @TOBRANCHCODE        
Select distinct party_code into #mcx from angelcommodity.mcdx.dbo.fobillvalan with (nolock) where    sauda_date BETWEEN @FROMDATE AND @TODATE  and Branch_code BETWEEN @FROMBRANCHCODE AND @TOBRANCHCODE        
Select distinct party_code into #ncdex from angelcommodity.ncdx.dbo.fobillvalan with (nolock) where   sauda_date BETWEEN @FROMDATE AND @TODATE  and Branch_code BETWEEN @FROMBRANCHCODE AND @TOBRANCHCODE        
Select distinct party_code into #mcd from angelcommodity.mcdxcds.dbo.fobillvalan with (nolock) where   sauda_date BETWEEN @FROMDATE AND @TODATE  and Branch_code BETWEEN @FROMBRANCHCODE AND @TOBRANCHCODE        
        
-------  drop table #cltcode        
        
Select * into #cltcode from        
(        
Select * from #nse        
union        
Select * from #bse        
union        
Select * from #nsefo        
union        
Select * from #mcx        
union        
Select * from #ncdex        
union        
Select * from #mcd        
union        
Select * from #nsx        
)x,  anand1.msajag.dbo.client_details c1    
where x.party_code = c1.party_code
     AND @STATUSNAME = (                    
                        CASE                     
                                WHEN @STATUSID = 'BRANCH'                     
                                THEN C1.BRANCH_CD                     
                               -- WHEN @STATUSID = 'SUBBROKER'                     
                               -- THEN C1.SUB_BROKER                     
                               -- WHEN @STATUSID = 'TRADER'                     
                              --  THEN C1.TRADER                     
                              --  WHEN @STATUSID = 'FAMILY'                     
                              --  THEN C1.FAMILY                     
                             --   WHEN @STATUSID = 'AREA'                     
                            --    THEN C1.AREA                     
          -- WHEN @STATUSID = 'REGION'                     
                               -- THEN C1.REGION                     
                               -- WHEN @STATUSID = 'CLIENT'                     
                               -- THEN x.PARTY_CODE                     
                                ELSE 'BROKER' END)         
-------        
          
--Select Branch_cd,Sub_Broker,Party_code,Short_name,L_Address1+' '+L_address2+' '+L_address3 as Address,        
Select Branch_cd,Sub_Broker,Party_code,Short_name,L_Address1 as Address,        
l_city,l_zip,l_State,Res_Phone1,Mobile_pager        
from AngelBSECM.pradnya.dbo.TBl_ecncash with (nolock) where Party_code in (Select party_code from #cltcode)      
  
       
union        
--Select Branch_cd,Sub_Broker,Party_code,Short_name,L_Address1+' '+L_address2+' '+L_address3 as Address,       
Select Branch_cd,Sub_Broker,Party_code,Short_name,L_Address1 as Address,         
l_city,l_zip,l_State,Res_Phone1,Mobile_pager        
 from AngelBSECM.pradnya.dbo.TBl_ecnfo with (nolock) where Party_code in (Select party_code from #cltcode )              
   
order by Branch_cd,Party_code

GO
