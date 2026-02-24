-- Object: PROCEDURE citrus_usr.Pr_bulk_OnlineLoginCreation_bakaug072019
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--Begin tran  
--exec Pr_bulk_OnlineLoginCreation 'MIG'  
--Select count(1) from login_names -- 531065  
--rollback  
create procedure [citrus_usr].[Pr_bulk_OnlineLoginCreation_bakaug072019]  
(  
@pa_loginnames varchar(30)  
)  
as  
Begin  
truncate table  TEMP_CLIENT_DATA_FOR_LOGIN  
  
  
insert into TEMP_CLIENT_DATA_FOR_LOGIN  
Select dpam_sba_no,'Tut9HyBycNwiwp/WSN5KPmG5cREufSrUsK6fQSvJ+I4=' from dp_acct_mstr where right(dpam_sba_no,8) not in (  
Select logn_name from login_names where logn_deleted_ind=1)  
and dpam_stam_cd='Active'  
and dpam_sba_no not in (Select boid from dps8_pc2 where isnull(name,'')<>''

union all
Select boid from dps8_pc3 where isnull(name,'')<>''


)  
and dpam_crn_no not in (1065611) and dpam_subcm_cd in ('012103','012169')  
and dpam_sba_no not in (  
  
Select distinct boid from dps8_pc1 where isnull(emailid,'')=''  
union   
--Select distinct boid from dps8_pc1 where priphind='M' and isnull(priphnum,'')=''  
Select distinct boid from dps8_pc16 where  isnull(mobilenum,'')=''  
union   
select boid from dps8_pc1 where emailid in (  
Select  emailid from dps8_pc1,dp_acct_mstr where isnull(emailid,'')<>''  
and dpam_sba_no=boid and dpam_stam_cd='Active'  
 group by emailid  
having count(1)>1 )   
union  
--select boid from dps8_pc1 where priphnum in (  
--Select  priphnum from dps8_pc1,dp_acct_mstr where priphind='M' and isnull(priphnum,'')<>''  
--and dpam_sba_no=boid and dpam_stam_cd='Active'  
-- group by priphnum  
--having count(1)>1 )   
select boid from dps8_pc16 where mobilenum in (  
Select  mobilenum from dps8_pc16,dp_acct_mstr where  isnull(mobilenum,'')<>''  
and dpam_sba_no=boid and dpam_stam_cd='Active'  
group by mobilenum  
having count(1)>1 )  
)  

delete FROM TEMP_CLIENT_DATA_FOR_LOGIN where sba_no in (select BOID from DPS8_PC2 WHERE ISNULL(NAME,'')<>'')

delete FROM TEMP_CLIENT_DATA_FOR_LOGIN where sba_no in (select BOID from DPS8_PC3 WHERE ISNULL(NAME,'')<>'')

if exists (Select sba_no from TEMP_CLIENT_DATA_FOR_LOGIN)  
begin  
EXEC PR_GET_INFO_FOR_CLIENTLOGIN 3,'SAVE','01/04/2001', '02/04/2027','','','',''  
end   
end

GO
