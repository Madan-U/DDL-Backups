-- Object: PROCEDURE dbo.Angel_upd_ScripGroupwise_TO
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create procedure Angel_upd_ScripGroupwise_TO(@sdate as varchar(11))  
as  
set transaction isolation level read uncommitted  
select scripcode=scripid,groupname into #scrip from mis.nbfc.dbo.scripgroupmaster   

  
truncate table Angel_ScripGroupwise_TO  
insert into Angel_ScripGroupwise_TO  
select segment='NSECM',sauda_Date,party_code,NSECM_TO=sum(pamtdel+pamttrd+samtdel+samttrd),b.groupname   
from cmbillvalan a (nolock),   
#scrip b   
where a.sauda_Date=@sdate and a.scrip_cd=b.scripcode collate Latin1_General_CI_AS  
and a.billno <> '0' and contractno <> '0'  
group by sauda_Date,party_code,b.groupname

GO
