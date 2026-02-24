-- Object: PROCEDURE dbo.insproc_bak_nov282019
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Procedure insproc  @settno  varchar (7) , @sett_type char(3)  as  
  
Exec DelpositionUp  @settno,@sett_type,'',''    
delete from deliveryclt where sett_no = @settno and sett_Type =  @sett_type    
If UPPER(LTRIM(RTRIM(@SETT_TYPE))) <> 'W'   
BEGIN  
INSERT INTO DELIVERYCLT   
select  sett_no ,sett_type , scrip_cd , series , party_code,abs(sum(pqty)-sum(sqty)) 'tradeqty',inout = case  
  when (sum(pqty)-sum(sqty)) > 0  
  then  
  'O'  
    when (sum(pqty)-sum(sqty))< 0  
     then   
  'I'  
    else  
  'N'  
    end, 'HO' ,PartiPantCode  
from delpos where sett_no = @settno and sett_Type =  @sett_type   
Group By sett_no ,sett_type , scrip_cd , series , party_code,PartiPantCode  
Having Sum(PQty) <> Sum(SQty)  
End  
Else  
BEGIN  
INSERT INTO DELIVERYCLT   
select  sett_no ,sett_type , scrip_cd , series , party_code,sum(pqty) 'tradeqty',inout = 'O', 'HO' ,PartiPantCode  
from delpos where sett_no = @settno and sett_Type =  @sett_type   
Group By sett_no ,sett_type , scrip_cd , series , party_code,PartiPantCode  
Having Sum(PQty) > 0  

INSERT INTO DELIVERYCLT     
select  sett_no ,sett_type , scrip_cd , series , party_code,sum(sqty) 'tradeqty',inout = 'I', 'HO' ,PartiPantCode  
from delpos where sett_no = @settno and sett_Type =  @sett_type   
Group By sett_no ,sett_type , scrip_cd , series , party_code,PartiPantCode  
Having Sum(SQty) > 0  
END

GO
