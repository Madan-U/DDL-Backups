-- Object: PROCEDURE dbo.Upd_master
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE procedure Upd_master      
as      
      
set nocount on      
----- Account Master      
truncate table acmast      
insert into acmast       
select * from account.dbo.acmast with (nolock) --  00:18 secs      
      
truncate table vmast      
insert into vmast      
select * from account.dbo.vmast with (nolock) --  00:01 secs      
      
truncate table parameter       
insert into parameter       
select * from account.dbo.parameter with (nolock) --  00:01 secs      
      
truncate table globals   
insert into globals   
select * from msajag.dbo.globals with (nolock) --  00:01 secs      
  
--- Party Bank      
truncate table Party_Bank_Details       
insert into Party_Bank_Details       
select * from msajag.dbo.Party_Bank_Details with (nolock)      
      
--- Settlement      
truncate table sett_mst      
insert into sett_mst      
select * from msajag.dbo.sett_mst with (nolock)      
      
      
--- Scrip Master      
truncate table scrip1      
insert into scrip1      
select * from msajag.dbo.scrip1 with (nolock)      
      
truncate table scrip2      
insert into scrip2      
select * from msajag.dbo.scrip2 with (nolock)      
      
      
--- Client Master       
truncate table client1      
insert into client1      
select * from msajag.dbo.client1 with (nolock)      
      
truncate table client2      
insert into client2      
select * from msajag.dbo.client2 with (nolock)      
      
truncate table client3      
insert into client3      
select * from msajag.dbo.client3 with (nolock)      
      
truncate table client4      
insert into client4      
select * from msajag.dbo.client4 with (nolock)      
      
truncate table client5      
insert into client5      
select * from msajag.dbo.client5 with (nolock)      
      
truncate table client6      
insert into client6      
select * from msajag.dbo.client6 with (nolock)      
      
      
--- Client Details      
truncate table client_brok_Details       
insert into client_brok_Details       
select * from msajag.dbo.client_brok_Details with (nolock)      
      
truncate table client_Details      
insert into client_Details      
select * from msajag.dbo.client_Details with (nolock)      
      
--- Sub-broker      
truncate table subbrokers       
insert into subbrokers       
select * from msajag.dbo.subbrokers with (nolock)      
      
--- Branch      
truncate table branches      
insert into branches      
select * from msajag.dbo.branches with (nolock)      
      
--- Region      
truncate table region      
insert into region      
select * from msajag.dbo.region with (nolock)      
      
--- Brokerage      
truncate table Broktable      
insert into Broktable      
select * from msajag.dbo.Broktable with (nolock)      
      
set nocount off

GO
