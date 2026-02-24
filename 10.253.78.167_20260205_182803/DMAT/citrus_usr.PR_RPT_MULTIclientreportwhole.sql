-- Object: PROCEDURE citrus_usr.PR_RPT_MULTIclientreportwhole
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



------exec PR_RPT_MULTIclientreportwhole 'jan  1 2000','JUN 21 2020','HO'
-------exec PR_RPT_MULTIclientreportwhole @pa_from_dt='JUL  1 2000',@pa_to_dt='JUL 22 2020',@pa_login_name='NEWHO'  ---- profiler 



CREATE    procedure [citrus_usr].[PR_RPT_MULTIclientreportwhole]
(
@pa_from_dt DATETIME
, @pa_to_dt DATETIME  
,@pa_login_name varchar(100)    
)
as 
begin
print 'dsadasd'
declare @l_sql  varchar(100)
set @l_sql  = '|*~||*~||*~||*~||*~||*~||*~|N|*~|'+convert(varchar(11),@pa_from_dt,109)+'|*~|'+convert(varchar(11),@pa_to_dt,109)+'|*~|%|*~|1'
print @l_sql
exec pr_client_multireport @pa_id='3',@pa_hiercy='HO|*~|HO|*~|*|~*',
@pa_main_filters_values=@l_sql,
------@pa_select_values='77|*~|78|*~|79|*~|80|*~|81|*~|82|*~|83|*~|84|*~|85|*~|86|*~|87|*~|88|*~|89|*~|90|*~|91|*~|92|*~|93|*~|94|*~|95|*~|96|*~|97|*~|98|*~|99|*~|100|*~|101|*~|102|*~|103|*~|104|*~|105|*~|106|*~|107|*~|108|*~|109|*~|110|*~|111|*~|112|*~|113|*~|114|*~|115|*~|116|*~|117|*~|118|*~|119|*~|120|*~|121|*~|122|*~|123|*~|125|*~|126|*~|134|*~|130|*~|132|*~|133|*~|135|*~|136|*~|',

@pa_select_values='1|*~|2|*~|3|*~|4|*~|6|*~|8|*~|9|*~|10|*~|11|*~|12|*~|16|*~|17|*~|18|*~|26|*~|28|*~|29|*~|31|*~|35|*~|36|*~|39|*~|41|*~|',
@pa_filter_values='',@pa_grp_by='HO'


--select * from tbl_select_criteria 



--ALTER procedure [citrus_usr].[PR_RPT_MULTIclientreportwhole]
--(
--@pa_from_dt DATETIME
--, @pa_to_dt DATETIME  
--,@pa_login_name varchar(100)    
--)
--as 
--begin

--exec pr_client_multireport @pa_id='3',@pa_hiercy='HO|*~|HO|*~|*|~*',
--@pa_main_filters_values='|*~||*~||*~||*~||*~||*~||*~|N|*~||*~||*~|%|*~|162',
--@pa_select_values='162|*~|163|*~|164|*~|167|*~|169|*~|171|*~|172|*~|173|*~|176|*~|177|*~|178|*~|196|*~|197|*~|',
--@pa_filter_values='',@pa_grp_by='HO'


--------------------------exec pr_client_multireport @pa_id='3',@pa_hiercy='HO|*~|HO|*~|*|~*',
--------------------------@pa_main_filters_values='|*~||*~||*~||*~||*~||*~||*~|N|*~||*~||*~|%|*~|162',
--------------------------@pa_select_values='206|*~|207|*~|208|*~|209|*~|162|*~|163|*~|164|*~|165|*~|167|*~|169|*~|170|*~|171|*~|172|*~|173|*~|174|*~|176|*~|177|*~|178|*~|181|*~|182|*~|184|*~|185|*~|186|*~|187|*~|188|*~|189|*~|190|*~|192|*~|194|*~|195|*~|196|*~|197|*~|198|*~|199|*~|200|*~|202|*~|203|*~|',
--------------------------@pa_filter_values='',@pa_grp_by='HO'



end

GO
