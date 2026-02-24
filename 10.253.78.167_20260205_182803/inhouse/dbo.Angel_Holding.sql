-- Object: VIEW dbo.Angel_Holding
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

  
CREATE view [dbo].[Angel_Holding]      
as      
--select b.cm_blsavingcd,hld_Ac_Code,hld_isin_code,hld_ac_pos      
--from holding a with (nolock) join client_master b with (nolock)      
--on a.hld_Ac_Code=b.cm_cd       
--where cm_blsavingcd <> '' 

select b.cm_blsavingcd,hld_Ac_Code,hld_isin_code,hld_ac_pos      
from holding a with (nolock) INNER JOIN 
 DMAT.citrus_usr.[Synergy_Client_Master] b with (nolock)      
on a.hld_Ac_Code=b.cm_cd       
where cm_blsavingcd <> ''

GO
