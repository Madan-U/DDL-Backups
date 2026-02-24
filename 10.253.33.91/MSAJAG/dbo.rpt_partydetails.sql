-- Object: PROCEDURE dbo.rpt_partydetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create procedure rpt_partydetails

@partycode as varchar(20),
@partyname as varchar(25)

as


if (@partycode <> '' and @partyname = '') or (@partycode <> '' and @partyname <> '')
begin
select cl2.cl_code,cl2.party_code,cl2.dummy1,
turnover_tax= 	(case when cl2.Turnover_tax=0 then 'Y'
			when cl2.Turnover_tax=1 then 'N'
		end),
sebi_turn_tax= 	(case when cl2.sebi_turn_tax=0 then 'Y'
			when cl2.sebi_turn_tax=1 then 'N'
		end),
Service_chrg=(case when cl2.service_chrg=0 then 'Exclusive'
			when cl2.service_chrg=1 then 'Incl in Brok'
			when cl2.service_chrg=2 then 'Inclusive Exclusive'
		end),
cl2.table_no,cl2.sub_tableno,cl2.demat_tableno,cl2.p_to_p,
brokernote= (case when cl2.brokernote=0 then 'Y'
			when cl2.brokernote=1 then 'N'
		end),
brok_scheme = (case when cl2.brok_scheme=0 then 'Default'
			when cl2.brok_scheme=1 then 'Max Logic (F/S) - Buy Side'
			when cl2.brok_scheme=3 then 'Max Logic (F/S) - Sell Side'
			when cl2.brok_scheme=4 then 'Flat Brokerage Default'
			when cl2.brok_scheme=5 then 'Flat Brokerage (Max Logic) - Buy Side'
			when cl2.brok_scheme=6 then 'Flat Brokerage (Max Logic) - Sell Side'
		end),
brok3_table_no= (case when cl2.brok3_tableno=0 then 'Treat as Brokerage'
			when cl2.brok3_tableno=1 then 'Treat as Charges'
		else
		 'Not Selected'
		end),
dummy1= (case when cl2.dummy1=0 then 'Premium'
			when cl2.dummy1=1 then 'Strike'
			when cl2.dummy1=2 then 'Strike + Premium'
		else
		 'Not Selected'
		end),
cl2.Dummy2,
cl1.long_name,cl1.l_address1,cl1.l_address2,
cl1.L_city,cl1.L_State,cl1.L_Nation,cl1.L_Zip,cl1.Fax,cl1.Res_Phone1,cl1.Email,
cl1.Branch_cd,cl1.Cl_type,cl1.Cl_Status,cl1.Family,cl1.Sub_Broker,cl1.Mobile_Pager,cl1.pan_gir_no,cl1.trader,
s1.name,b1.branch          
from client2 cl2, client1 cl1,subbrokers s1,branch b1
where cl1.cl_code = cl2.cl_code
and cl2.party_code = @partycode
and s1.sub_broker = cl1.sub_broker
and b1.branch_code = cl1.branch_cd
end




if @partyname <> '' and @partycode = ''
begin
select cl2.cl_code,cl2.party_code,cl2.dummy1,
turnover_tax= 	(case when cl2.Turnover_tax=0 then 'Y'
			when cl2.Turnover_tax=1 then 'N'
		end),
sebi_turn_tax= 	(case when cl2.sebi_turn_tax=0 then 'Y'
			when cl2.sebi_turn_tax=1 then 'N'
		end),
Service_chrg=(case when cl2.service_chrg=0 then 'Exclusive'
			when cl2.service_chrg=1 then 'Incl in Brok'
			when cl2.service_chrg=2 then 'Inclusive Exclusive'
		end),
cl2.table_no,cl2.sub_tableno,cl2.demat_tableno,cl2.p_to_p,
brokernote= (case when cl2.brokernote=0 then 'Y'
			when cl2.brokernote=1 then 'N'
		end),
brok_scheme = (case when cl2.brok_scheme=0 then 'Default'
			when cl2.brok_scheme=1 then 'Max Logic (F/S) - Buy Side'
			when cl2.brok_scheme=3 then 'Max Logic (F/S) - Sell Side'
			when cl2.brok_scheme=4 then 'Flat Brokerage Default'
			when cl2.brok_scheme=5 then 'Flat Brokerage (Max Logic) - Buy Side'
			when cl2.brok_scheme=6 then 'Flat Brokerage (Max Logic) - Sell Side'
		end),
brok3_table_no= (case when cl2.brok3_tableno=0 then 'Treat as Brokerage'
			when cl2.brok3_tableno=1 then 'Treat as Charges'
		else
		 'Not Selected'
		end),
dummy1= (case when cl2.dummy1=0 then 'Premium'
			when cl2.dummy1=1 then 'Strike'
			when cl2.dummy1=2 then 'Strike + Premium'
		else
		 'Not Selected'
		end),
cl2.Dummy2,
cl1.long_name,cl1.l_address1,cl1.l_address2,
cl1.L_city,cl1.L_State,cl1.L_Nation,cl1.L_Zip,cl1.Fax,cl1.Res_Phone1,cl1.Email,
cl1.Branch_cd,cl1.Cl_type,cl1.Cl_Status,cl1.Family,cl1.Sub_Broker,cl1.Mobile_Pager,cl1.pan_gir_no,cl1.trader,
s1.name,b1.branch  
from client2 cl2, client1 cl1,subbrokers s1,branch b1
where cl2.cl_code = cl1.cl_code
and cl1.short_name = @partyname
and s1.sub_broker = cl1.sub_broker
and b1.branch_code = cl1.branch_cd
end

GO
