-- Object: PROCEDURE dbo.Angel_ECN_MASTER
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc Angel_ECN_MASTER    
as    
    
select distinct cl_code  into #t from client_brok_details 
where Active_date >= convert(varchar(11),getdate()-7) and Active_date <= convert(varchar(11),getdate()) + ' 23:59:59'  and 
Exchange not in ('MCX','NCX')    
    
select Distinct cl_code into #t1 from client_details_log where Edit_on >= convert(varchar(11),getdate()-7)  and  Edit_on <= convert(varchar(11),getdate()) + ' 23:59:59'    
    
truncate table Angel_EHast_mast    
    
insert into Angel_EHast_mast    
select party_code,long_Name,L_Address1,L_Address2,L_Address3,L_city,L_State,L_Nation,L_Zip,Off_Phone1,    
Off_Phone2,Fax,Email=(case when left(repatriat_bank_ac_no,3) = 'ECN' then Email else ' ' end),Branch_cd,    
Family,Sub_Broker,trader,pan_gir_no=(case when pan_gir_no is null then 'Y' else 'N' end) from client_details     
where cl_Code In (select cl_code from #t union    
select cl_code from #t1 where left(cl_code,1) not in ('1','2','3','4','5','6','7','8','9')     
and cl_code in (select distinct cl_code from client_brok_details where Exchange not in ('MCX','NCX')) )    
    
--select party_code,long_Name,L_Address1,L_Address2,L_Address3,L_city,L_State,L_Nation,L_Zip,Off_Phone1,Off_Phone2,Fax,Email,Branch_cd,Family,Sub_Broker,trader,pan_gir_no from Angel_EHast_mast

GO
