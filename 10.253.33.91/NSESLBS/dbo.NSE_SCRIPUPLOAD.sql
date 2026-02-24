-- Object: PROCEDURE dbo.NSE_SCRIPUPLOAD
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC NSE_SCRIPUPLOAD (@FilePath Varchar(100)) AS

Select * into TempScrip2 From Scrip2 

Select * into TempScrip1 From Scrip1 

TRUNCATE TABLE Scrip_IMP
TRUNCATE TABLE Scrip1
TRUNCATE TABLE Scrip2
TRUNCATE TABLE COMPANY

SELECT SCRIP_CD=CONVERT(VARCHAR(12),''),
SERIES=CONVERT(VARCHAR(3),''),
SCRIP_NAME=CONVERT(VARCHAR(50),''),
FILLER1=CONVERT(VARCHAR(12),''),
ISIN=CONVERT(VARCHAR(12),'')
INTO #Scrip_imp

--Bulk insert #Scrip_imp from @FilePath with  ( FIELDTERMINATOR = ',', ROWTERMINATOR = '\n' ) 
EXEC Proc_Bulk_Ins '#Scrip_imp', @FilePath, ','

INSERT INTO Scrip_imp
SELECT * FROM #Scrip_imp

INSERT INTO Scrip_imp
Select Distinct Scrip_Cd, S2.Series, Long_Name, FILLER1='', ISIN  from TempScrip1 S1, TempScrip2 S2
Where S1.Co_Code = S2.Co_Code And S1.Series = S2.Series
And Scrip_Cd not in ( Select Scrip_cd From Scrip_imp 
Where Scrip_imp.Scrip_Cd = S2.Scrip_Cd AND Scrip_imp.Series = S2.Series )

Insert Into Company 
Select Sno, Left(SCRIP_NAME,20),SCRIP_NAME,'','','','','','','','','','','','' 
From Scrip_imp

Insert Into Scrip1 
Select Sno, Series,Left(SCRIP_NAME,20),SCRIP_NAME,1,10,'','','','','EQ','EQ','','','Dec 31 2049','','','','' 
From Scrip_imp

Insert Into Scrip2 
Select Sno,Series,'NSE',Scrip_CD,'HIG','','',0,0,0,'','','NRM','','','','','','','','','', '', '', '', '', '', '', 0, '', 0, 0, 0, '', 0 
From Scrip_imp
            
Update Scrip2 Set Sector = S2.Sector,Track = S2.Track, CDOL_No = S2.CDol_No,
Res1 = S2.Res1, Res2= S2.Res2, Res3 = S2.Res3, Res4 = S2.Res4, Globalcustodian = S2.Globalcustodian, 
Common_Code = IsNull(S2.Common_Code,''), IndexName = S2.IndexName, Industry = S2.Industry, 
Bloomberg = S2.Bloomberg, RicCode = S2.RicCode, Reuters = S2.Reuters, IES = S2.IES, 
NoofIssuedshares = S2.NoofIssuedshares, Status = S2.Status, ADRGDRRatio = S2.ADRGDRRatio, 
GEMultiple = S2.GEMultiple, GroupforGE = S2.GroupforGE, RBICeilingIndicatorFlag = S2.RBICeilingIndicatorFlag,
RBICeilingIndicatorValue = S2.RBICeilingIndicatorValue 
From TempScrip2 S2 Where S2.Scrip_Cd = Scrip2.Scrip_Cd And S2.Series = Scrip2.Series

DROP TABLE TempScrip1
DROP TABLE TempScrip2

GO
