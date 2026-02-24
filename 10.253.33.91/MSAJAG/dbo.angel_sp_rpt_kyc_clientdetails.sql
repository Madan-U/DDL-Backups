-- Object: PROCEDURE dbo.angel_sp_rpt_kyc_clientdetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  CREATE   proc   
 [dbo].[angel_sp_rpt_kyc_clientdetails] (  
  
  @strPartyCodeFrom varchar(10),  
  @strPartyCodeTo varchar(10)  
 )  
  
as   
  
/*  
 angel_sp_rpt_kyc_clientdetails 'BH14', 'BH14'  
*/  
  
set transaction isolation level read uncommitted  
select distinct  
/* c2.cl_code,*/  
 c2.party_code,   
 c1.long_name,  
 c2.dummy1,   
 t.turnover_tax,   
 sebi_turn_tax = t.sebiturn_tax,   
 service_chrg =   
  (  
   case   
    when c2.service_chrg = 0 then 'exclusive'   
    when c2.service_chrg = 1 then 'incl in brok'   
    when c2.service_chrg = 2 then 'inclusive'   
   end  
  ),   
 t.insurance_chrg,   
 t.other_chrg,   
 c2.table_no,   
 c2.sub_tableno,   
 c2.demat_tableno,   
 c2.p_to_p,   
 c2.std_rate,   
 c2.demat_tableno,   
 c2.albmdelchrg,   
 c2.albmdelivery,   
 c2.albmcf_tableno,   
 c2.mf_tableno,   
 c2.sb_tableno,   
 c2.brok1_tableno,   
 c2.brok2_tableno,   
 brok3_table_no =   
  (  
   case   
    when c2.brok3_tableno = 0 then 'treat as brokerage'   
    when c2.brok3_tableno = 1 then 'treat as charges'   
    else 'not selected'   
   end  
  ),   
 dummy1 =   
  (  
   case   
    when c2.dummy1 = 0 then 'premium'   
    when c2.dummy1 = 1 then 'strike'   
    when c2.dummy1 = 2 then 'strike + premium'   
    else 'not selected'   
   end  
  ),   
 c2.dummy2,   
 brokernote = t.broker_note,   
 brok_scheme =   
  (  
   case   
    when c2.brok_scheme = 0 then 'default'   
    when c2.brok_scheme = 1 then 'max logic (f/s) - buy side'   
    when c2.brok_scheme = 2 then 'max rate'   
    when c2.brok_scheme = 3 then 'max logic (f/s) - sell side'   
    when c2.brok_scheme = 4 then 'flat brokerage default'   
    when c2.brok_scheme = 5 then 'flat brokerage (max logic) - buy side'   
    when c2.brok_scheme = 6 then 'flat brokerage (max logic) - sell side'   
   end  
  ),   
 brok3_table_no =   
  (  
   case   
    when c2.brok3_tableno = 0 then 'treat as brokerage'   
    when c2.brok3_tableno = 1 then 'treat as charges'   
    else 'not selected'   
   end  
  ),   
 dummy1 =   
  (  
   case   
    when c2.dummy1 = 0 then 'premium'   
    when c2.dummy1 = 1 then 'strike'   
    when c2.dummy1 = 2 then 'strike + premium'   
    else 'not selected'   
   end  
  ),   
 c2.dummy2,   
 c1.long_name, c1.l_address1, c1.l_address2, c1.l_address3,   
 c1.l_city, c1.l_state, c1.l_nation, c1.l_zip, c1.fax, c1.res_phone1, res_phone2, off_phone1, off_phone2, c1.email,   
 c1.branch_cd, c1.cl_type, c1.cl_status, c1.family, c1.sub_broker, c1.mobile_pager, c1.pan_gir_no, c1.trader,   
 sb.name, br.branch,   
 conttype =   
  (  
   case   
    when c2.inscont = 's' then 'scripwise'   
    when c2.inscont = 'o' then 'orderwise'   
    when c2.inscont = 'n' then 'normal'   
    else 'not available'   
   end  
  ),   
 participant = (case when c1.cl_type = 'ins' then c2.bankid else '' end),   
 custodian = (case when c1.cl_type = 'ins' then c2.cltdpno else '' end),   
 printf = (case when c2.printf = 0 then 'print' else 'dont print' end),   
 contprt =   
  (  
   case   
    when c2.printf = 0 then 'detail bill and contract'   
    when c2.printf = 1 then 'dont print bill and contract'   
    when c2.printf = 2 then 'summarised contract and detail bill'   
    when c2.printf = 3 then 'summarised bill and detail contract'   
    when c2.printf = 4 then 'both summarised'   
   end  
  ),   
 convert(varchar(11), c5.activefrom) as activefrom,   
 inactivefrom = (case when convert(varchar(11), c5.inactivefrom) = 'jan 1 1900' then 'n.a.' else convert(varchar(11), c5.inactivefrom) end),   
 c5.introducer,   
 c5.approver,   
 scheme_type = c1.cl_type,   
 trade_type = 'nrm',  
 bank_name = ltrim(rtrim(isnull(p.bank_name, ''))),  
 branch_name = ltrim(rtrim(isnull(p.branch_name, ''))),  
 ac_no = isnull(c4.cltdpid, ''),  
 ac_type = ltrim(rtrim(isnull(c4.depository, '')))  
  
from   
 client1 c1 with (nolock)  
 left outer join   
  client5 c5 with (nolock)   
 on (c5.cl_code = c1.cl_code)   
 left outer join   
  (client4 c4 with (nolock) join pobank p with (nolock) on convert(varchar, c4.bankid) = convert(varchar, p.bankid) and ltrim(rtrim(c4.depository)) in ('SAVING','CURRENT','OTHER'))   
 on (c1.cl_code = c4.cl_code),  
/*  
 client1 c1 with (nolock) left outer join client5 c5 with (nolock) on (c5.cl_code = c1.cl_code),  
*/  
 client2 c2 with (nolock),   
 subbrokers sb with (nolock),  
 branch br with (nolock),  
 taxes t with (nolock)  
  
where   
  
 c1.cl_code = c2.cl_code and   
 c2.party_code >= @strPartyCodeFrom and  
 c2.party_code <= @strPartyCodeTo and  
  
 c2.tran_cat = t.trans_cat and   
  
 Ltrim(Rtrim(c1.branch_cd)) = br.branch_code and  
 c1.sub_broker = sb.sub_broker and  
  
 c5.inactivefrom > getdate() and  
  
 t.from_date <= left(convert(varchar, getdate(), 109), 11) + ' 23:59:00' and t.to_date >= left(convert(varchar, getdate(), 109), 11) + ' 00:00:00'  
  
order by   
 c2.party_code

GO
