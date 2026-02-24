-- Object: PROCEDURE dbo.ACM_PartyCodePrefix
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Proc [dbo].[ACM_PartyCodePrefix]    
(    
 @BranchCd varchar(10),    
 @SubBroker varchar(10),    
 @Trader varchar(10),    
 @ClientType varchar(5)    
)    
    
as    
    
/*    
    
ACM_PartyCodePrefix 'HO','AN0014','HOTRD','CLI'    
exec ACM_PartyCodePrefix 'HO','HOSUB','HOTRD','CLI'    
    
    
*/    
    
Declare @@RecCount int    
    
CREATE TABLE #CCS (    
 [SNO] [bigint] NOT NULL,    
 [BranchCd] [varchar](20) NULL,    
 [SubBroker] [varchar](20) NULL,    
 [Trader] [varchar](20) NULL,    
 [ClientType] [varchar](3) NULL,    
 [AutoCodeFlag] [varchar](1) NULL,    
 [ClientPrefix] [varchar](5) NULL,    
 [PartyLength] [tinyint] NULL,    
 [FilterCols]  int    
) ON [PRIMARY]    
    
    
Insert into #CCS    
    
Select * From Client_Code_Settings (Nolock)    
where BranchCd = @BranchCd OR BranchCd = 'ALL'    
Union    
Select * From Client_Code_Settings (Nolock)    
where SubBroker = @SubBroker OR SubBroker = 'ALL'    
Union    
Select * From Client_Code_Settings (Nolock)    
where Trader = @Trader OR Trader = 'ALL'    
Union    
Select * From Client_Code_Settings (Nolock)     
where ClientType = @ClientType OR ClientType = 'ALL'    
Union    
Select * From Client_Code_Settings (Nolock)    
Where BranchCd = 'ALL' and SubBroker = 'ALL' and Trader = 'ALL' and ClientType = 'ALL'    
 /*  
select * from #CCS    
order By FilterCols asc    
*/    
--=========FILTERING RECORDS STARTED===========--    
    
 DELETE FROM #CCS    
 WHERE CLIENTTYPE NOT IN (@CLIENTTYPE,'ALL')    
 DELETE FROM #CCS    
 WHERE TRADER NOT IN (@TRADER,'ALL')    
 DELETE FROM #CCS    
 WHERE SUBBROKER NOT IN (@SUBBROKER,'ALL')    
 DELETE FROM #CCS    
 WHERE BRANCHCD NOT IN (@BRANCHCD,'ALL')    
    
    
 /*   
select * from #CCS    
order By FilterCols asc    
 */  
--=========FILTERING RECORDS COMPLETED===========--    
    
select TOP 1 CLIENTPREFIX,AutoCodeFlag, PartyLength, FILTERCOLS from #CCS    
order By FilterCols asc    
    
    
TRUNCATE TABLE #CCS    
    
DROP TABLE #CCS

GO
