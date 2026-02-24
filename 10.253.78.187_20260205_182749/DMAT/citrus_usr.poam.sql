-- Object: VIEW citrus_usr.poam
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


  
CREATE  view [citrus_usr].[poam]     
  
as    
  
select poam_name1,poam_name2,poam_name3,poam_adr1,poam_adr2,poam_adr3,poam_city,poam_state,poam_country,poam_zip,  
  
poam_master_id, poam_name1 as dpam_sba_name,poam_master_id as dpam_sba_no  from poa_mstr     
WHERE NOT EXISTS (SELECT 1 FROM DP_ACCT_MSTR WHERE poam_master_id = DPAM_SBA_NO )    
and  poam_master_id like '22033201%'
union     
  
select dpam_sba_no,'' poam_name2,'' poam_name3,Addr1 poam_adr1,Addr2 poam_adr2,Addr3 poam_adr3,City poam_city,State poam_state,Country   
  
poam_country,PinCode poam_zip,dpam_sba_no,dpam_sba_name poam_master_id,dpam_sba_no   from dp_Acct_mstr  ,DPS8_PC1    
  
where left(dpam_sba_no,2)='22'  AND BOId = DPAM_SBA_NO

GO
