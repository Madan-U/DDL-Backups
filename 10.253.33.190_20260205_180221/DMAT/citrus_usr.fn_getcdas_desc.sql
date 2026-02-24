-- Object: FUNCTION citrus_usr.fn_getcdas_desc
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_getcdas_desc](@pa_id numeric)
returns varchar(8000)
begin 

declare @l_trans_code varchar(10)
, @l_trans_desc varchar(8000) 
select @l_trans_code = citrus_usr.fn_splitval_by(value,2,'~') from tmp_dp57_o where id = @pa_id 

if @l_trans_code in ('2','3')
begin 

--ON-DR TD:564560 TX:541741 1206210000001680 SET:N2010045

select @l_trans_desc   = case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and citrus_usr.fn_splitval_by(value,13,'~') <> ''  then 'ON-CR'
when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and citrus_usr.fn_splitval_by(value,13,'~') <> ''  then 'ON-DR'
when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and citrus_usr.fn_splitval_by(value,13,'~') = ''  then 'OF-CR'
when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and citrus_usr.fn_splitval_by(value,13,'~') = ''  then 'OF-DR' end 
+ ' TD:'+citrus_usr.fn_splitval_by(value,15,'~') +' '
+ 'TX:'+citrus_usr.fn_splitval_by(value,5,'~') +' '
+ citrus_usr.fn_splitval_by(value,11,'~') +' '
+ case when citrus_usr.fn_splitval_by(value,13,'~') <> ''   then 'SET:'+ citrus_usr.fn_splitval_by(value,13,'~') else '' end 
from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id 

end 
else if @l_trans_code in ('1')
begin 

--EARMARK-CR SETT 1110000910233 EX 11 118248
--EARMARK-DR SETT 1110000910233 EX 11 118248

select @l_trans_desc   = case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'EARMARK-CR'
							  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'EARMARK-DR' end 
+ ' SETT '+citrus_usr.fn_splitval_by(value,13,'~') +' '
+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','')  +' '
+ citrus_usr.fn_splitval_by(value,5,'~') +' '
from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id and citrus_usr.fn_splitval_by(value,7,'~') in ('102','111')

select @l_trans_desc   = case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'BSEBOPAYIN-CR'
							  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'BSEBOPAYIN-DR' end 
+ ' SETT '+citrus_usr.fn_splitval_by(value,13,'~') +' '
+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','')  +' '
+ citrus_usr.fn_splitval_by(value,5,'~') +' '
from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id and citrus_usr.fn_splitval_by(value,7,'~') in ('109')

select @l_trans_desc   = case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'NSCCL-CR'
							  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'NSCCL-DR' end 
+ ' SETT '+citrus_usr.fn_splitval_by(value,13,'~') +' '
+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','')  +' '
+ citrus_usr.fn_splitval_by(value,5,'~') +' '
from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id and citrus_usr.fn_splitval_by(value,7,'~') in ('107')



end 
else if @l_trans_code in ('16')
begin 
--
--D~16~1201200000022971~INE213A01029~1699~50.000~1603~06012012000000~06012012000000~~1100001100005652~00132~1211002012003~~~06012012112816~0~~~106012012C01~0~0~~~~B~0~~0.000~0.000~0.000~0.000~1~22~2246~0~~~~CDAS~5~06012012112913~~~~~~~
--NSCCL-CR IN001002 12106012012C01 SETT N2012003N

select @l_trans_desc   = case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'NSCCL-CR'
							  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'NSCCL-DR' end 
+ ' IN001002 12'+citrus_usr.fn_splitval_by(value,20,'~') +' '
+ ' SETT N'+ left(citrus_usr.fn_splitval_by(value,13,'~'),6)  +'N'
from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id and citrus_usr.fn_splitval_by(value,7,'~') in ('1603')



end 
else if @l_trans_code in ('14')
begin 
--

--D~14~1201200000000681~INE442A01024~10907190~11983.000~1401~06012012132120~06012012000000~~1201200000014903~662~1110001112190~~~06012012132120~0~~~~0~0~~~~B~0~~0.000~0.000~0.000~0.000~1~79~2246~0~~~~CDAS~5~06012012132120~~~~~~~


select @l_trans_desc   = case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'BSE-PAYOUT-CR'
							  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'BSE-PAYOUT-DR' end 
+ ' SETT '+ citrus_usr.fn_splitval_by(value,13,'~')
+ ' BO-'+ citrus_usr.fn_splitval_by(value,11,'~')
from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id and citrus_usr.fn_splitval_by(value,7,'~') in ('1401')
and '26' = (select dpam_clicm_cd from dp_Acct_mstr where dpam_sba_No = citrus_usr.fn_splitval_by(value,3,'~') and dpam_deleted_ind = 1 )


--SETTLEMENT-DR SETT 1110001112190 EX 11 986328

select @l_trans_desc   = case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'SETTLEMENT-CR'
							  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'SETTLEMENT-DR' end 
+ ' SETT '+ citrus_usr.fn_splitval_by(value,13,'~')
+ ' EX-'+ CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','') 
+ ' ' + citrus_usr.fn_splitval_by(value,5,'~')
from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id and citrus_usr.fn_splitval_by(value,7,'~') in ('1401')
and '26' <> (select dpam_clicm_cd from dp_Acct_mstr where dpam_sba_No = citrus_usr.fn_splitval_by(value,3,'~') and dpam_deleted_ind = 1 )



end 

else if @l_trans_code in ('4')
begin 

--EP-DR TXN:798052 CTBO:1100001100018446 N2011090      EXID:12
--EP-CR TXN:798052 CTBO:1100001100018446 N2011090      EXID:12

--select @l_trans_desc   = case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'EP-CR'
--							  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'EP-DR' end 
select @l_trans_desc   = case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and citrus_usr.fn_splitval_by(value,34,'~') not in  ('79','80') then 'EP-CR'
							  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and citrus_usr.fn_splitval_by(value,34,'~')  not in  ('79','80') then 'EP-DR' 
                              when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and citrus_usr.fn_splitval_by(value,34,'~')  in  ('79','80') then 'BSEEPPAYIN-CR'
							  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and citrus_usr.fn_splitval_by(value,34,'~')  in  ('79','80') then 'BSEEPPAYIN-DR'
end 
+ ' TXN:'+citrus_usr.fn_splitval_by(value,5,'~') +' '
+ 'CTBO: '+ citrus_usr.fn_splitval_by(value,11,'~')  +' '
+ citrus_usr.fn_splitval_by(value,13,'~') +' '
+ 'EXID: ' + CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','') +' '
from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id and citrus_usr.fn_splitval_by(value,7,'~') in ('409')


end 
else if @l_trans_code in ('5')
begin 
--

--D~5~1201200000000185~INE002A01018~58148535~9.000~511~06012012133153~06012012000000~B~IN609966~~1110001112190~~~06012012000000~0~~~~0~0~~~~~0~~0.000~0.000~0.000~0.000~1~21~2246~0~~~~CDS~1~06012012133307~~~~~~~
--INTDEP-CR 58148535 CTRBO IN609966 1110001112190

select @l_trans_desc   = case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'INTDEP-CR'
							  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'INTDEP-DR' end 
+ ' '+citrus_usr.fn_splitval_by(value,5,'~') +' '
+ ' CTRBO '+citrus_usr.fn_splitval_by(value,11,'~') +' '
+ ' '+ citrus_usr.fn_splitval_by(value,13,'~')
from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id and citrus_usr.fn_splitval_by(value,7,'~') in ('511','521')





end 

else if @l_trans_code in ('7')
begin 

--DEMAT 05303390 CLOSE - CR CONFIRMED BALANCE


select @l_trans_desc   = 'DEMAT'
+ citrus_usr.fn_splitval_by(value,5,'~') +' '
+ case 
when citrus_usr.fn_splitval_by(value,7,'~') ='601' then 'SETUP-CR PENDING VERIFICATION'
when citrus_usr.fn_splitval_by(value,7,'~') ='607' then 'DELETE-DB PENDING VERIFICATION'
when citrus_usr.fn_splitval_by(value,7,'~') ='602' then 'VERIFY-DB PENDING VERIFICATION'
when citrus_usr.fn_splitval_by(value,7,'~') ='603' then 'VERIFY-CR PENDING CONFIRMATION'
when citrus_usr.fn_splitval_by(value,7,'~') ='604' then 'CLOSE-DB PENDING CONFIRMATION'
when citrus_usr.fn_splitval_by(value,7,'~') ='605' then 'CLOSE-CR CONFIRMED BALANCE'
when citrus_usr.fn_splitval_by(value,7,'~') ='606' then 'CLOSE-CR LOCK-IN BALANCE'          
end 

from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id 


end 
else 
begin 

select @l_trans_desc   = CITRUS_USR.fn_dp57_stuff('desc',citrus_usr.fn_splitval_by(value,2,'~'),'','') + '-'+ CITRUS_USR.fn_dp57_stuff('MAINDESC',citrus_usr.fn_splitval_by(value,7,'~'),'','')
from   tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(value,1,'~')='D' 
and id = @pa_id 

end 

return @l_trans_desc   

end

GO
