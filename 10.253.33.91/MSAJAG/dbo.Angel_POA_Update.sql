-- Object: PROCEDURE dbo.Angel_POA_Update
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc [dbo].[Angel_POA_Update]                
as                
                
select * into #poa from   
--dpbackoffice.acercross.dbo.Tbl_New_Clients                 
[ABCSOORACLEMDLW].synergy.dbo.Tbl_New_Clients   where  cm_poaforpayin<>'N'
if (select count(*) from #poa) > 0      
begin      
      
select cm_blsavingcd into #notupdate from                
(                
select x.*,Y.* from                
(select * from #poa) x                
left outer join                
(select * from multicltid (nolock) where Dpid = '12033200') y                
on x.cm_blsavingcd = y.party_code                 
) x group by cm_blsavingcd having count(*) > 1                
                
select x.*,y.def into #upd_1 from                
(select * from #poa) x                
left outer join                
(select * from multicltid (nolock) where Dpid = '12033200') y                
on x.cm_blsavingcd = y.party_code                 
                
select * into #upd_Poa from #upd_1 where cm_blsavingcd not in                
(                
select * from #notupdate                
)                
                
begin tran                
                
update multicltid set def = 1 from #upd_Poa x inner join multicltid y on x.cm_blsavingcd = y.party_code and x.cm_cd = y.cltdpno and x.def = 0                
                
insert into multicltid                
select y.party_code,x.cm_cd,y.DpId,y.Introducer,Y.DpType,1 from                
(select * from #upd_Poa where def = 0)  x                
inner join                
(select * from multicltid (nolock) where def = 0 and DpType = 'CDSL' and Dpid = '12033200') y                
on x.cm_blsavingcd = y.party_code and x.cm_cd <> y.CltDpNo                
                
insert into multicltid                
select left(cm_blsavingcd,10),cm_cd,'12033200',cm_name,'CDSL',1 from #upd_Poa where def is null                
                
commit              
end      
Update intranet.misc.dbo.Tbl_search set dummy1 = 'Y' where id = 96          
    
Exec ANGEL_UPDATE_TBL_SEARCH

GO
