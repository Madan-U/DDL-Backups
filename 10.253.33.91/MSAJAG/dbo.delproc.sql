-- Object: PROCEDURE dbo.delproc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure [dbo].[delproc] (@sett_no varchar(7),@sett_Type Varchar(3) ) as

delete from delnet where sett_no = @sett_no and sett_Type =  @sett_type 
If UPPER(LTRIM(RTRIM(@SETT_TYPE))) NOT IN ('W','Z') 
BEGIN
insert into delnet
select  sett_no ,sett_type , scrip_cd , series,abs(sum(pqty)-sum(sqty)) 'tradeqty',
inout = case when (sum(pqty)-sum(sqty)) > 0
					    then  'O'
					    when (sum(pqty)-sum(sqty))< 0
					    then  'I'
			  end
from DelPos  where sett_no = @sett_no and sett_type = @sett_Type
Group By sett_no ,sett_type , scrip_cd , series
having abs(sum(pqty)-sum(sqty)) > 0 
END
ELSE
BEGIN
insert into delnet
select sett_no ,sett_type , scrip_cd , series,sum(pqty) 'tradeqty',inout = 'O'
from DelPos where sett_no = @sett_no and sett_type = @sett_Type
Group By sett_no ,sett_type , scrip_cd , series
having sum(pqty) > 0 

insert into delnet
select sett_no ,sett_type , scrip_cd , series,sum(sqty) 'tradeqty',inout = 'I'
from DelPos where sett_no = @sett_no and sett_type = @sett_Type
Group By sett_no ,sett_type , scrip_cd , series
having sum(sqty) > 0 
END



EXEC DELIVERY_INTEROP @SETT_NO,@SETT_TYPE

GO
