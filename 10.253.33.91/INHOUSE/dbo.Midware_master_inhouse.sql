-- Object: PROCEDURE dbo.Midware_master_inhouse
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE procedure Midware_master_inhouse      
as      
      
set nocount on      
----- Account Master      
truncate table INHOUSE.dbo.acmast      
insert into INHOUSE.dbo.acmast       
select * from ACCOUNT.DBO.acmast with (nolock) --  00:18 secs      
      
truncate table INHOUSE.dbo.vmast      
insert into INHOUSE.dbo.vmast      
select * from ACCOUNT.DBO.vmast with (nolock) --  00:01 secs      
      
truncate table INHOUSE.dbo.parameter       
insert into INHOUSE.dbo.parameter       
select * from ACCOUNT.DBO.parameter with (nolock) --  00:01 secs      
    
truncate table INHOUSE.dbo.costmast    
insert into INHOUSE.dbo.costmast       
select * from ACCOUNT.DBO.costmast with (nolock) 

--- Settlement      
truncate table INHOUSE.DBO.sett_mst      
insert into INHOUSE.DBO.sett_mst      
select * from MSAJAG.DBO.sett_mst with (nolock)      
      
      
--- Scrip Master      
truncate table INHOUSE.DBO.scrip1      
insert into INHOUSE.DBO.scrip1      
select * from MSAJAG.DBO.scrip1 with (nolock)      
      
truncate table INHOUSE.DBO.scrip2      
insert into INHOUSE.DBO.scrip2      
select * from MSAJAG.DBO.scrip2 with (nolock)      
      
      
--- Client Master       
truncate table INHOUSE.DBO.CLIENT_DETAILS      
insert into INHOUSE.DBO.CLIENT_DETAILS
select * from MSAJAG.DBO.CLIENT_DETAILS with (nolock)      
      
truncate table INHOUSE.DBO.CLIENT_bROK_DETAILS 
insert into INHOUSE.DBO.CLIENT_bROK_DETAILS
select * from MSAJAG.dbo.CLIENT_bROK_DETAILS with (nolock)      

--- Sub-broker      
truncate table INHOUSE.DBO.subbrokers       
insert into INHOUSE.DBO.subbrokers       
select * from MSAJAG.dbo.subbrokers with (nolock)      
      
--- Branch      
truncate table INHOUSE.DBO.branches      
insert into INHOUSE.DBO.branches      
select * from MSAJAG.dbo.branches with (nolock)      
      
--- Region      
truncate table INHOUSE.DBO.region      
insert into INHOUSE.DBO.region      
select * from MSAJAG.dbo.region with (nolock)      
      
--- Brokerage      
truncate table INHOUSE.DBO.Broktable      
insert into INHOUSE.DBO.Broktable      
select * from MSAJAG.dbo.Broktable with (nolock)      
    
----Global    
truncate table INHOUSE.DBO.globals    
insert into INHOUSE.DBO.globals       
select * from MSAJAG.dbo.globals with (nolock)       
    
      
set nocount off

GO
