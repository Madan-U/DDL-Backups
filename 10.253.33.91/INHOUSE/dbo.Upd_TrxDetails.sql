-- Object: PROCEDURE dbo.Upd_TrxDetails
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

Create procedure Upd_TrxDetails
as
set nocount on          
TRUNCATE TABLE settlement 
insert into settlement 
select * from msajag.dbo.settlement where sauda_date >=convert(varchar(11),getdate()) and sauda_date <=convert(varchar(11),getdate())+' 23:59:59'

truncate table CMBILLVALAN 
insert into CMBILLVALAN
select * from msajag.dbo.CMBILLVALAN where sauda_date >=convert(varchar(11),getdate()) and sauda_date <=convert(varchar(11),getdate())+' 23:59:59'

set nocount off

GO
