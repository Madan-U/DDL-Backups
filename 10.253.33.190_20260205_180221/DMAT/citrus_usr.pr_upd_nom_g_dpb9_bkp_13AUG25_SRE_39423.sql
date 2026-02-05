-- Object: PROCEDURE citrus_usr.pr_upd_nom_g_dpb9_bkp_13AUG25_SRE_39423
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE proc [citrus_usr].[pr_upd_nom_g_dpb9_bkp_13AUG25_SRE_39423]
as
begin

update a
set nom_fname	=Name
,nom_mname=	MiddleName
,nom_tname	=SearchName
,nom_fthname	=FthName
,nom_adr1	=Addr1
,nom_adr2	=Addr2
,nom_adr3	=Addr3
,nom_city	=City
,nom_state	=State
,nom_country	=Country
,nom_zip	=PinCode
,nom_phone1_ind=	PriPhInd
,nom_phone1	=PriPhNum
,nom_phone2_ind	=AltPhInd
,nom_phone2=	AltPhNum
,nom_Addphone	=AddPhones
,nom_fax	=Fax
,nom_pan	=PANGIR
,nom_Uid	=ItCircle
,nom_email	=EMailid
,nom_dob	=substring(dateofbirth,5,4)+'-'+substring(dateofbirth,3,2)+'-'+substring(dateofbirth,1,2)+' 00:00:00.000'
,Nom_DPAM_SBA_NO=	BOId
,nom_res_sec_flag=	RES_SEC_FLg
,nom_srno	=NOM_Sr_No+3
,nom_relation	=case when len(rel_WITH_BO) = '1' then '0'+rel_WITH_BO else rel_WITH_BO end 
,nom_percentage=	0
 from Nominee_Multi a 
,dpb9_pc8 where BOId	=Nom_DPAM_SBA_NO
and NOM_Sr_No	=isnull( nom_srno,0) -3


select identity(numeric,1,1) id ,  Name,MiddleName,SearchName,FthName,Addr1,Addr2
,Addr3,City,State,Country,PinCode,PriPhInd,PriPhNum
,AltPhInd,AltPhNum,AddPhones,Fax,PANGIR,ItCircle
,EMailid--,DateOfBirth
,substring(dateofbirth,5,4)+'-'+substring(dateofbirth,3,2)+'-'+substring(dateofbirth,1,2)+' 00:00:00.000' DateOfBirth
,BOId,RES_SEC_FLg,NOM_Sr_No,rel_WITH_BO
,perc_OF_SHARES into #missingnom
from dpb9_pc8 where not exists (select 1 from Nominee_Multi  where BOId	=Nom_DPAM_SBA_NO
and  NOM_Sr_No	= isnull( nom_srno,0) -3)

declare @l_nom_id numeric
declare @l_count numeric
set @l_count = 0 
select @l_count = count(1) from #missingnom  

 SELECT @l_nom_id      = bitrm_bit_location  
         FROM   bitmap_ref_mstr WITH(NOLOCK)  
         WHERE  bitrm_parent_cd = 'NOM_ID'  
         AND    bitrm_child_cd  = 'NOM_ID'  
         --  
         UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
         SET    bitrm_bit_location = bitrm_bit_location+@l_count+1  
         WHERE  bitrm_parent_cd    = 'NOM_ID'  
         AND    bitrm_child_cd     = 'NOM_ID'  
         --  
         INSERT INTO Nominee_Multi  
         (nom_id		,Nom_dpam_id		,Nom_DPAM_SBA_NO		,nom_srno		,nom_fname		,nom_mname		,nom_tname
		,nom_fthname		,nom_dob		,nom_adr1		,nom_adr2		,nom_adr3		,nom_city
		,nom_state		,nom_country		,nom_zip		,nom_phone1_ind		,nom_phone1		,nom_phone2_ind
		,nom_phone2		,nom_Addphone		,nom_fax		,nom_pan		,nom_Uid		,nom_email
		,nom_relation		,nom_percentage		,nom_res_sec_flag		,NOm_CREATED_BY		,NOm_CREATED_DT
		,NOm_LST_UPD_BY		,Nom_LST_UPD_DT		,Nom_DELETED_IND        )
		select @l_nom_id + id, dpam_id , boid , NOM_Sr_No+3,  Name,MiddleName,SearchName,FthName,DateOfBirth,Addr1,Addr2
,Addr3,City,State,Country,PinCode,PriPhInd,PriPhNum
,AltPhInd,AltPhNum,AddPhones,Fax,PANGIR,ItCircle
,EMailid,case when len(rel_WITH_BO) = '1' then '0'+rel_WITH_BO else rel_WITH_BO end ,0,RES_SEC_FLg,'MIG',getdate(),'MIG',getdate(),1
from #missingnom , dp_Acct_mstr where boid = dpam_sba_no 

end

GO
