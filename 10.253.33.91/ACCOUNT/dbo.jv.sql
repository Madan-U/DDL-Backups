-- Object: PROCEDURE dbo.jv
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure [dbo].[jv] (    
@CDT VARCHAR (15)    
    
    
)    
    
AS
BEGIN    
select
 [VTYP]=VTYP,   
[vno] = VNO,    
[EDT] = EDT,    
[VDT] = VDT,    
[CDT] = CDT,    
[ENTEREDBY] = ENTEREDBY,    
[NARRATION] = NARRATION ,
[EXCHANGE]='NSE'
from ledger with (nolock)
WHERE CDT LIKE @CDT + '%' AND VTYP='8'     
---ORDER BY CDT 

---BSE---
UNION ALL

select
 [VTYP]=VTYP,   
[vno] = VNO,    
[EDT] = EDT,    
[VDT] = VDT,    
[CDT] = CDT,    
[ENTEREDBY] = ENTEREDBY,    
[NARRATION] = NARRATION ,
[EXCHANGE]='BSE'
from [AngelBSECM].ACCOUNT_AB.DBO.ledger with (nolock)
WHERE CDT LIKE @CDT + '%' AND VTYP='8'     

---NSEFO---

UNION ALL

select
 [VTYP]=VTYP,   
[vno] = VNO,    
[EDT] = EDT,    
[VDT] = VDT,    
[CDT] = CDT,    
[ENTEREDBY] = ENTEREDBY,    
[NARRATION] = NARRATION ,
[EXCHANGE]='NSEFO'
from [ANGELFO].ACCOUNTFO.DBO.ledger with (nolock)
WHERE CDT LIKE @CDT + '%' AND VTYP='8'     

---NSECURFO---

UNION ALL

select
 [VTYP]=VTYP,   
[vno] = VNO,    
[EDT] = EDT,    
[VDT] = VDT,    
[CDT] = CDT,    
[ENTEREDBY] = ENTEREDBY,    
[NARRATION] = NARRATION ,
[EXCHANGE]='NSECURFO'
from [ANGELFO].ACCOUNTCURFO.DBO.ledger with (nolock)
WHERE CDT LIKE @CDT + '%' AND VTYP='8'  

---MCDX---
UNION ALL

select
 [VTYP]=VTYP,   
[vno] = VNO,    
[EDT] = EDT,    
[VDT] = VDT,    
[CDT] = CDT,    
[ENTEREDBY] = ENTEREDBY,    
[NARRATION] = NARRATION ,
[EXCHANGE]='MCDX'
from [ANGELCOMMODITY].ACCOUNTMCDX.DBO.ledger with (nolock)
WHERE CDT LIKE @CDT + '%' AND VTYP='8'  

---MCDXCDS---


UNION ALL

select
 [VTYP]=VTYP,   
[vno] = VNO,    
[EDT] = EDT,    
[VDT] = VDT,    
[CDT] = CDT,    
[ENTEREDBY] = ENTEREDBY,    
[NARRATION] = NARRATION ,
[EXCHANGE]='MCDXCDS'
from [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.ledger with (nolock)
WHERE CDT LIKE @CDT + '%' AND VTYP='8'  

---NCDX---
UNION ALL

select
 [VTYP]=VTYP,   
[vno] = VNO,    
[EDT] = EDT,    
[VDT] = VDT,    
[CDT] = CDT,    
[ENTEREDBY] = ENTEREDBY,    
[NARRATION] = NARRATION ,
[EXCHANGE]='NCDX'
from [ANGELCOMMODITY].ACCOUNTNCDX.DBO.ledger with (nolock)
WHERE CDT LIKE @CDT + '%' AND VTYP='8'  

ORDER BY EXCHANGE

END

----JV 'MAY 25 2015'

GO
