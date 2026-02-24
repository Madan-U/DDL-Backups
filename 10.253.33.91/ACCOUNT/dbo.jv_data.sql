-- Object: PROCEDURE dbo.jv_data
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE proc jv_data         
(        
      
@fromdate varchar (20),        
@todate varchar (20)        
     
)        
as        
BEGIN        
select          
[vno] = vno,          
[EDT] = EDT,          
[VDATE] = VDT,          
[CDT] = CDT,      
[vtyp]=vtyp,          
[ENTEREDBY] = ENTEREDBY,          
[NARRATION] = NARRATION        
     
from ledger        
where  CDT>= @FROMDATE AND CDT <=@TODATE            
and VTYP='8'        
order by CDT      
end 


--exec jv_data 'mar 20 2015', 'mar 31 2015'

GO
