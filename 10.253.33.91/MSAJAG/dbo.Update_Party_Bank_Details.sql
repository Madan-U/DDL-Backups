-- Object: PROCEDURE dbo.Update_Party_Bank_Details
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[Update_Party_Bank_Details]          
AS         
BEGIN             
IF OBJECT_ID('tempdb..#Party_Bank_Detailstemp') IS NOT NULL
  DROP TABLE #Party_Bank_Detailstemp        
SELECT * INTO #Party_Bank_Detailstemp    
              FROM MSAJAG.DBO.Party_Bank_Details WITH(NOLOCK) WHERE 1=0   
--Added clustered index on 6th May 2020
CREATE CLUSTERED INDEX cl_idx on #Party_Bank_Detailstemp(Party_Code)
        
IF OBJECT_ID('tempdb..#POBank_Temp') IS NOT NULL
  DROP TABLE #POBank_Temp  
CREATE TABLE [dbo].[#POBank_Temp](
	[BankId] VARCHAR(20) ,
	[Bank_Name] [varchar](50) NOT NULL,
	[Branch_Name] [varchar](40) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](25) NULL,
	[Nation] [varchar](25) NULL,
	[Zip] [varchar](15) NULL,
	[Phone1] [varchar](15) NULL,
	[Phone2] [varchar](15) NULL,
	[Fax] [varchar](15) NULL,
	[Email] [varchar](50) NULL,
	[IFSCCODE] [varchar](12) NULL,
	[MICRNO] [varchar](10) NULL
  )

CREATE NONCLUSTERED INDEX cl_#POBank_Temp_BankId on #POBank_Temp(BankId) 
INSERT INTO #POBank_Temp
SELECT * FROM PoBank WITH(NOLOCK)

IF OBJECT_ID('tempdb..#POBank_Temp_BSE') IS NOT NULL
  DROP TABLE #POBank_Temp_BSE  
CREATE TABLE [dbo].[#POBank_Temp_BSE](
	[BankId] VARCHAR(20) ,
	[Bank_Name] [varchar](50) NOT NULL,
	[Branch_Name] [varchar](40) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](25) NULL,
	[Nation] [varchar](25) NULL,
	[Zip] [varchar](15) NULL,
	[Phone1] [varchar](15) NULL,
	[Phone2] [varchar](15) NULL,
	[Fax] [varchar](15) NULL,
	[Email] [varchar](50) NULL,
	[IFSCCODE] [varchar](12) NULL,
	[MICRNO] [varchar](10) NULL
  )
CREATE NONCLUSTERED INDEX cl_#POBank_Temp_BSE_BankId on #POBank_Temp_BSE(BankId) 
INSERT INTO #POBank_Temp_BSE
SELECT * FROM AngelBSECM.bsedb_ab.dbo.PoBank WITH(NOLOCK)
  
  
IF OBJECT_ID('tempdb..#POBank_Temp_nsefo') IS NOT NULL
  DROP TABLE #POBank_Temp_nsefo  
CREATE TABLE [dbo].[#POBank_Temp_nsefo](
	[BankId] VARCHAR(20) ,
	[Bank_Name] [varchar](50) NOT NULL,
	[Branch_Name] [varchar](40) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](25) NULL,
	[Nation] [varchar](25) NULL,
	[Zip] [varchar](15) NULL,
	[Phone1] [varchar](15) NULL,
	[Phone2] [varchar](15) NULL,
	[Fax] [varchar](15) NULL,
	[Email] [varchar](50) NULL,
	[IFSCCODE] [varchar](12) NULL,
	[MICRNO] [varchar](10) NULL
  )
CREATE NONCLUSTERED INDEX cl_#POBank_Temp_nsefo_BankId on #POBank_Temp_nsefo(BankId) 
INSERT INTO #POBank_Temp_nsefo
SELECT * FROM angelfo.nsefo.dbo.PoBank p WITH(nolock) 
 ------------------------------ Step 1
 IF OBJECT_ID('tempdb..#Party_Bank_Details_NSECAP') IS NOT NULL
  DROP TABLE #Party_Bank_Details_NSECAP  
SELECT               
c.Party_code, 'NSE-CAPITAL' AS Exchange, BankName = ISNULL(p.Bank_Name,''),              
Branch = ISNULL(p.Branch_Name,''), AcNum = ISNULL(c.CltDpId,''), AcType = ISNULL(c.Depository,'')  
INTO #Party_Bank_Details_NSECAP
FROM  Client4 c WITH(NOLOCK)              
INNER JOIN              
#POBank_Temp p WITH(NOLOCK) ON  p.BankId = c.BankID             
WHERE c.Depository NOT IN ('CDSL','NSDL') 
UNION  
SELECT               
c.cltcode,              
'NSE-CAPITAL' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
FROM               
Account.dbo.MultiBankId c WITH(NOLOCK)              
INNER JOIN #POBank_Temp p WITH(NOLOCK)  ON p.BankId = c.BankID  

--- UPDATE NSE OVER ---  
IF OBJECT_ID('tempdb..#Party_Bank_Details_BSECAP') IS NOT NULL
  DROP TABLE #Party_Bank_Details_BSECAP 
SELECT               
c.Party_code,              
'BSE-CAPITAL' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')  
INTO #Party_Bank_Details_BSECAP
From               
AngelBSECM.bsedb_ab.dbo.Client4 c WITH(NOLOCK)              
INNER JOIN  #POBank_Temp_BSE p WITH(NOLOCK) ON P.BankId = c.BankID            
Where c.Depository NOT IN ('CDSL','NSDL')              
UNION
SELECT               
c.cltcode,              
'BSE-CAPITAL' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')  
--INTO #2
FROM               
AngelBSECM.Account_ab.dbo.MultiBankId c WITH(NOLOCK)              
INNER JOIN #POBank_Temp_BSE p WITH(NOLOCK) ON p.BankId = c.BankID 
               
 IF OBJECT_ID('tempdb..#Party_Bank_Details_NSEFUT') IS NOT NULL
  DROP TABLE #Party_Bank_Details_NSEFUT             
Select               
c.Party_code,              
'NSE-FUTURES' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'') 
INTO #Party_Bank_Details_NSEFUT
From               
angelfo.nsefo.dbo.Client4 c WITH(nolock)              
INNER JOIN #POBank_Temp_nsefo p WITH(nolock)  ON P.BankId  = c.BankID             
Where              
c.Depository not in ('CDSL','NSDL')               
UNION  
Select               
c.cltcode,              
'NSE-FUTURES' as Exchange,              
BankName = ISNULL(p.Bank_Name,''),              
Branch =   ISNULL(p.Branch_Name,''),              
AcNum =    ISNULL(c.AccNo,''),              
AcType =   ISNULL(c.AccType,'')               
FROM               
angelfo.accountfo.dbo.MultiBankId c WITH(NOLOCK)              
INNER JOIN #POBank_Temp_nsefo p WITH(NOLOCK)  ON p.BankId =c.BankID 
               
--- UPDATE NSEFO OVER ---              
IF OBJECT_ID('tempdb..#POBank_Temp_nsecurfo') IS NOT NULL
  DROP TABLE #POBank_Temp_nsecurfo 
CREATE TABLE [dbo].[#POBank_Temp_nsecurfo](
	[BankId] VARCHAR(20) ,
	[Bank_Name] [varchar](50) NOT NULL,
	[Branch_Name] [varchar](40) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](25) NULL,
	[Nation] [varchar](25) NULL,
	[Zip] [varchar](15) NULL,
	[Phone1] [varchar](15) NULL,
	[Phone2] [varchar](15) NULL,
	[Fax] [varchar](15) NULL,
	[Email] [varchar](50) NULL,
	[IFSCCODE] [varchar](12) NULL,
	[MICRNO] [varchar](10) NULL
  )
CREATE NONCLUSTERED INDEX cl_#POBank_Temp_nsecurfo on #POBank_Temp_nsecurfo(BankId) 
INSERT INTO #POBank_Temp_nsecurfo
SELECT * FROM  angelfo.nsecurfo.dbo.PoBank  p WITH(nolock) 
 

IF OBJECT_ID('tempdb..#Party_Bank_Details_NSX') IS NOT NULL
DROP TABLE #Party_Bank_Details_NSX              
SELECT               
c.Party_code,              
'NSX-CURR' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')  
INTO #Party_Bank_Details_NSX
FROM               
angelfo.nsecurfo.dbo.Client4 c WITH(NOLOCK)              
INNER JOIN  #POBank_Temp_nsecurfo p  WITH(NOLOCK) ON P.BankId = c.BankID            
Where c.Depository not in ('CDSL','NSDL')               
UNION  
Select               
c.cltcode,              
'NSX-CURR' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From               
angelfo.accountcurfo.dbo.MultiBankId c WITH(NOLOCK)              
INNER JOIN #POBank_Temp_nsecurfo p WITH(NOLOCK) ON P.BankId  = c.BankID  
            
--- UPDATE NSEFO OVER ---             
IF OBJECT_ID('tempdb..#POBank_Temp_bsefo') IS NOT NULL
  DROP TABLE #POBank_Temp_bsefo
CREATE TABLE [dbo].[#POBank_Temp_bsefo](
	[BankId] VARCHAR(20) ,
	[Bank_Name] [varchar](50) NOT NULL,
	[Branch_Name] [varchar](40) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](25) NULL,
	[Nation] [varchar](25) NULL,
	[Zip] [varchar](15) NULL,
	[Phone1] [varchar](15) NULL,
	[Phone2] [varchar](15) NULL,
	[Fax] [varchar](15) NULL,
	[Email] [varchar](50) NULL,
	[IFSCCODE] [varchar](12) NULL,
	[MICRNO] [varchar](10) NULL
  )
CREATE NONCLUSTERED INDEX cl_#POBank_Temp_bsefo on #POBank_Temp_bsefo(BankId) 
INSERT INTO #POBank_Temp_bsefo
SELECT * FROm angelcommodity.bsefo.dbo.PoBank p WITH(nolock)               

 IF OBJECT_ID('tempdb..#Party_Bank_Details_BSEFUTURES') IS NOT NULL
  DROP TABLE #Party_Bank_Details_BSEFUTURES              
              
Select               
c.Party_code,              
'BSE-FUTURES' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')   
INTO #Party_Bank_Details_BSEFUTURES
From               
angelcommodity.bsefo.dbo.Client4 c WITH(NOLOCK)              
INNER JOIN #POBank_Temp_bsefo p WITH(nolock)  ON p.BankId = c.BankID             
WHERE c.Depository not in ('CDSL','NSDL')              

UNION --INSERT INTO #Party_Bank_Details_BSEFUTURES
Select               
c.cltcode,              
'BSE-FUTURES' as Exchange,              
BankName = ISNULL(p.Bank_Name,''),              
Branch   = ISNULL(p.Branch_Name,''),              
AcNum    = ISNULL(c.AccNo,''),              
AcType   = ISNULL(c.AccType,'')               
FROM            
angelcommodity.accountbfo.dbo.MultiBankId c WITH(NOLOCK)              
INNER JOIN #POBank_Temp_bsefo p WITH(NOLOCK)  ON p.BankId  = c.BankID
              
--- UPDATE BSEFO OVER ---            
IF OBJECT_ID('tempdb..#POBank_Temp_mcdx') IS NOT NULL
  DROP TABLE #POBank_Temp_mcdx
CREATE TABLE [dbo].[#POBank_Temp_mcdx](
	[BankId] VARCHAR(20) ,
	[Bank_Name] [varchar](50) NOT NULL,
	[Branch_Name] [varchar](40) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](25) NULL,
	[Nation] [varchar](25) NULL,
	[Zip] [varchar](15) NULL,
	[Phone1] [varchar](15) NULL,
	[Phone2] [varchar](15) NULL,
	[Fax] [varchar](15) NULL,
	[Email] [varchar](50) NULL,
	[IFSCCODE] [varchar](12) NULL,
	[MICRNO] [varchar](10) NULL
  )
CREATE NONCLUSTERED INDEX cl_#POBank_Temp_mcdx on #POBank_Temp_mcdx(BankId) 
INSERT INTO #POBank_Temp_mcdx
SELECT * FROm angelcommodity.mcdx.dbo.PoBank p WITH(nolock)  
 

 IF OBJECT_ID('tempdb..#Party_Bank_Details_MCXCOMM') IS NOT NULL
  DROP TABLE #Party_Bank_Details_MCXCOMM                          
Select               
c.Party_code,              
'MCX-COMM' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')   
INTO #Party_Bank_Details_MCXCOMM
From               
angelcommodity.mcdx.dbo.Client4 c WITH(nolock)              
INNER JOIN #POBank_Temp_mcdx p WITH(nolock) ON p.BankId   = c.BankID             
Where c.Depository not in ('CDSL','NSDL')              
UNION
Select               
c.cltcode,              
'MCX-COMM' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From               
angelcommodity.accountmcdx.dbo.MultiBankId c WITH(nolock)              
INNER JOIN #POBank_Temp_mcdx p WITH(nolock) ON p.BankId = c.BankID
            
--- UPDATE MCDX OVER ---            
IF OBJECT_ID('tempdb..#POBank_Temp_ncdx') IS NOT NULL
  DROP TABLE #POBank_Temp_ncdx
CREATE TABLE [dbo].[#POBank_Temp_ncdx](
	[BankId] VARCHAR(20) ,
	[Bank_Name] [varchar](50) NOT NULL,
	[Branch_Name] [varchar](40) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](25) NULL,
	[Nation] [varchar](25) NULL,
	[Zip] [varchar](15) NULL,
	[Phone1] [varchar](15) NULL,
	[Phone2] [varchar](15) NULL,
	[Fax] [varchar](15) NULL,
	[Email] [varchar](50) NULL,
	[IFSCCODE] [varchar](12) NULL,
	[MICRNO] [varchar](10) NULL
  )
CREATE NONCLUSTERED INDEX cl_#POBank_Temp_ncdx on #POBank_Temp_ncdx(BankId) 
 INSERT INTO #POBank_Temp_ncdx
 SELECT *   FROM angelcommodity.ncdx.dbo.PoBank p WITH(NOLOCK)  
   

 IF OBJECT_ID('tempdb..#Party_Bank_Details_NCXCOMM') IS NOT NULL
  DROP TABLE #Party_Bank_Details_NCXCOMM            
Select               
c.Party_code,              
'NCX-COMM' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'')  
INTO #Party_Bank_Details_NCXCOMM
From               
angelcommodity.ncdx.dbo.Client4 c WITH(nolock)              
INNER JOIN #POBank_Temp_ncdx p WITH(nolock)  on  p.BankId  = c.BankID            
Where              
c.Depository not in ('CDSL','NSDL') 
UNION
Select               
c.cltcode,              
'NCX-COMM' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
FROM               
angelcommodity.accountncdx.dbo.MultiBankId c WITH(nolock)              
INNER JOIN #POBank_Temp_ncdx p WITH(nolock)  on  p.BankId  = c.BankID            
             
--- UPDATE NCDX OVER ---            

IF OBJECT_ID('tempdb..#POBank_Temp_mcdxcds') IS NOT NULL
  DROP TABLE #POBank_Temp_mcdxcds
CREATE TABLE [dbo].[#POBank_Temp_mcdxcds](
	[BankId] VARCHAR(20) ,
	[Bank_Name] [varchar](50) NOT NULL,
	[Branch_Name] [varchar](40) NOT NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[State] [varchar](25) NULL,
	[Nation] [varchar](25) NULL,
	[Zip] [varchar](15) NULL,
	[Phone1] [varchar](15) NULL,
	[Phone2] [varchar](15) NULL,
	[Fax] [varchar](15) NULL,
	[Email] [varchar](50) NULL,
	[IFSCCODE] [varchar](12) NULL,
	[MICRNO] [varchar](10) NULL
  )
CREATE NONCLUSTERED INDEX cl_#POBank_Temp_mcdxcds on #POBank_Temp_mcdxcds(BankId) 
INSERT INTO #POBank_Temp_mcdxcds
 SELECT * FROM angelcommodity.mcdxcds.dbo.PoBank p WITH(nolock)  
    
 IF OBJECT_ID('tempdb..#Party_Bank_Details_MCXCURR') IS NOT NULL
  DROP TABLE #Party_Bank_Details_MCXCURR                                    
Select               
c.Party_code,              
'MCX-CURR' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.CltDpId,''),              
AcType = isnull(c.Depository,'') 
INTO #Party_Bank_Details_MCXCURR
From               
angelcommodity.mcdxcds.dbo.Client4 c WITH(nolock)              
INNER JOIN #POBank_Temp_mcdxcds p WITH(nolock)  ON p.BankId   = c.BankID            
WHERE              
c.Depository NOT IN ('CDSL','NSDL')              
UNION
Select        
c.cltcode,              
'MCX-CURR' as Exchange,              
BankName = isnull(p.Bank_Name,''),              
Branch = isnull(p.Branch_Name,''),              
AcNum = isnull(c.AccNo,''),              
AcType = isnull(c.AccType,'')               
From  angelcommodity.accountmcdxcds.dbo.MultiBankId c WITH(nolock)              
INNER JOIN #POBank_Temp_mcdxcds p WITH(nolock)  ON p.BankId  = c.BankID 
            
--- UPDATE MCDXCDS OVER ---      
DELETE FROM #Party_Bank_Details_BSECAP where bankname='UNKNOWN'  
DELETE FROM #Party_Bank_Details_BSEFUTURES where bankname='UNKNOWN'  
DELETE FROM #Party_Bank_Details_MCXCOMM where bankname='UNKNOWN'  
DELETE FROM #Party_Bank_Details_MCXCURR where bankname='UNKNOWN'  
DELETE FROM #Party_Bank_Details_NSECAP where bankname='UNKNOWN'  
DELETE FROM #Party_Bank_Details_NSEFUT where bankname='UNKNOWN'  
DELETE FROM #Party_Bank_Details_NSX where bankname='UNKNOWN'  
DELETE FROM #Party_Bank_Details_NCXCOMM where bankname='UNKNOWN'  

--SELECT * INTO tbl_Party_Bank_Details_NEW FROm Party_Bank_Details  WITH(NOLOCK) WHERE 1=0

  TRUNCATE TABLE MSAJAG.DBO.Party_Bank_Details
   
  INSERT INTO MSAJAG.DBO.Party_Bank_Details
  SELECT * FROM #Party_Bank_Details_BSECAP

  INSERT INTO MSAJAG.DBO.Party_Bank_Details  
  SELECT * FROM #Party_Bank_Details_BSEFUTURES   

  INSERT INTO MSAJAG.DBO.Party_Bank_Details
  SELECT * FROM #Party_Bank_Details_MCXCOMM  

  INSERT INTO MSAJAG.DBO.Party_Bank_Details
  SELECT * FROM #Party_Bank_Details_MCXCURR  

  INSERT INTO MSAJAG.DBO.Party_Bank_Details
  SELECT * FROM #Party_Bank_Details_NSECAP   

  INSERT INTO MSAJAG.DBO.Party_Bank_Details
  SELECT * FROM #Party_Bank_Details_NSEFUT

  INSERT INTO MSAJAG.DBO.Party_Bank_Details
  SELECT * FROM #Party_Bank_Details_NSX 

  INSERT INTO MSAJAG.DBO.Party_Bank_Details 
  SELECT * FROM #Party_Bank_Details_NCXCOMM    

 IF OBJECT_ID('tempdb..#CCCC') IS NOT NULL
DROP TABLE #CCCC
 IF OBJECT_ID('tempdb..#Party_Bank_Details_BSECAP') IS NOT NULL
DROP TABLE #Party_Bank_Details_BSECAP      
 IF OBJECT_ID('tempdb..#Party_Bank_Details_BSEFUTURES') IS NOT NULL
DROP TABLE #Party_Bank_Details_BSEFUTURES  
 IF OBJECT_ID('tempdb..#Party_Bank_Details_MCXCOMM') IS NOT NULL
DROP TABLE #Party_Bank_Details_MCXCOMM  
 IF OBJECT_ID('tempdb..#Party_Bank_Details_MCXCURR') IS NOT NULL
DROP TABLE #Party_Bank_Details_MCXCURR  
 IF OBJECT_ID('tempdb..#Party_Bank_Details_NSECAP') IS NOT NULL
DROP TABLE #Party_Bank_Details_NSECAP  
 IF OBJECT_ID('tempdb..#Party_Bank_Details_NSEFUT') IS NOT NULL
DROP TABLE #Party_Bank_Details_NSEFUT 
 IF OBJECT_ID('tempdb..#Party_Bank_Details_NSX') IS NOT NULL
DROP TABLE #Party_Bank_Details_NSX   
 IF OBJECT_ID('tempdb..#Party_Bank_Details_NCXCOMM') IS NOT NULL
DROP TABLE #Party_Bank_Details_NCXCOMM     

END

GO
