-- Object: PROCEDURE dbo.test_proc_55
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure test_proc_55

@abc varchar(25)
as

select 	a.long_name as LONG_NAME, a.cl_code as CLIENT_CODE, 
	b.exchange as EXCHANGE,b.table_no as TRED_BROKNO, b.SUB_TABLENO AS DEL_BROKNO 
	from client1 a, client2 b 
	where a.cl_code like @abc 

select * from client_brok_details where trd_brok in (select table_no from client2 where cl_code like @abc) 
select * from client_brok_details where del_brok in (select sub_tableno from client2 where cl_code like @abc)

GO
