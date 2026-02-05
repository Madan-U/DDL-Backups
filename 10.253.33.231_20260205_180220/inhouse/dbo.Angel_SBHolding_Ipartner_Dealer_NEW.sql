-- Object: PROCEDURE dbo.Angel_SBHolding_Ipartner_Dealer_NEW
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

CREATE PROC  Angel_SBHolding_Ipartner_Dealer_NEW (              
@CODE AS VARCHAR(25)='', @PARTY AS VARCHAR(15)='', @ACCESSTO AS VARCHAR(10)=''              
)    
  
As  
  
Create Table #CLTHOLD   
(CLCODE Varchar(15),AC_CODE Varchar(16) ,NAME Varchar(100) ,HLD_AC_TYPE Varchar(25) ,ISIN Varchar(20), SCRIPNAME Varchar(100),HOLDQTY Float, VALUE Money)  
  
  
INSERT INTO #CLTHOLD  
exec AGMUBODPL3.inhouse.dbo.Angel_SBHolding_Ipartner_Dealer_NEW  
@CODE  , @PARTY , @ACCESSTO   
  
INSERT INTO #CLTHOLD  
exec AngelDP5.inhouse.dbo.Angel_SBHolding_Ipartner_Dealer_new  
@CODE  , @PARTY , @ACCESSTO    
    
  
Select * from #CLTHOLD  
  
  
  select '0'

GO
