-- Object: PROCEDURE citrus_usr.pr_upd_nom_dpb9_bak07102019
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create  proc [citrus_usr].[pr_upd_nom_dpb9_bak07102019]
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
,nom_dob	=case when DateOfBirth = '' then '1900-01-01 00:00:00.000'  else  substring (DateOfBirth,5,4)+'-'+substring (DateOfBirth,3,2)+'-'+substring (DateOfBirth,1,2)+ ' ' +'00:00:00.000' end
,Nom_DPAM_SBA_NO=	BOId
,nom_res_sec_flag=	RES_SEC_FLg
,nom_srno	=NOM_Sr_No
,nom_relation	=case when len(rel_WITH_BO) = '1' then '0'+rel_WITH_BO else rel_WITH_BO end 
,nom_percentage=	perc_OF_SHARES
 from Nominee_Multi a 
,dpb9_pc6 where BOId	=Nom_DPAM_SBA_NO
and NOM_Sr_No	= nom_srno


select identity(numeric,1,1) id ,  Name,MiddleName,SearchName,FthName,Addr1,Addr2
,Addr3,City,State,Country,PinCode,PriPhInd,PriPhNum
,AltPhInd,AltPhNum,AddPhones,Fax,PANGIR,ItCircle
,EMailid,DateOfBirth,BOId,RES_SEC_FLg,NOM_Sr_No,rel_WITH_BO
,perc_OF_SHARES into #missingnom
from dpb9_pc6 where not exists (select 1 from Nominee_Multi  where BOId	=Nom_DPAM_SBA_NO
and NOM_Sr_No	= nom_srno)

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
         (nom_id		
         ,Nom_dpam_id		
         ,Nom_DPAM_SBA_NO		,nom_srno		,nom_fname		,nom_mname		,nom_tname
		,nom_fthname		,nom_dob		,nom_adr1		,nom_adr2		,nom_adr3		,nom_city
		,nom_state		,nom_country		,nom_zip		,nom_phone1_ind		,nom_phone1		,nom_phone2_ind
		,nom_phone2		,nom_Addphone		,nom_fax		,nom_pan		,nom_Uid		,nom_email
		,nom_relation		,nom_percentage		,nom_res_sec_flag		,NOm_CREATED_BY		,NOm_CREATED_DT
		,NOm_LST_UPD_BY		,Nom_LST_UPD_DT		,Nom_DELETED_IND        )
		select @l_nom_id + id, dpam_id , boid , NOM_Sr_No,  Name,MiddleName,SearchName,FthName,
		case when DateOfBirth = '' then '1900-01-01 00:00:00.000' else  substring (DateOfBirth,5,4)+'-'+substring (DateOfBirth,3,2)+'-'+substring (DateOfBirth,1,2)+ ' ' +'00:00:00.000' end,
		Addr1,Addr2
,Addr3,City,State,Country,PinCode,PriPhInd,PriPhNum
,AltPhInd,AltPhNum,AddPhones,Fax,PANGIR,ItCircle
,EMailid,case when len(rel_WITH_BO) = '1' then '0'+rel_WITH_BO else rel_WITH_BO end ,isnull(perc_OF_SHARES,'0'),RES_SEC_FLg,'MIG',getdate(),'MIG',getdate(),1
from #missingnom , dp_Acct_mstr where boid = dpam_sba_no 

end

GO
