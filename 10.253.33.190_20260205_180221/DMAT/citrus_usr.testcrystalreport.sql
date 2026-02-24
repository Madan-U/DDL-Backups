-- Object: PROCEDURE citrus_usr.testcrystalreport
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec testcrystalreport
CREATE proc [citrus_usr].[testcrystalreport]
       as
		drop table table1
		drop table table2
 create table table1
	(
		status1 varchar(100),
		category varchar(100),
		sub_category varchar(100),
		type1 varchar(100),
		ADDRESS1 varchar(50),
		ADDRESS2 varchar(50),
		ADDRESS3 varchar(50),
		city varchar(50),
		STATE1 varchar(50),
		COUNTRY varchar(25),
		PINCODE varchar(100),
		SecondHolderName varchar(100),
		ThirdHolderName varchar(100),
		SecondHolderName1 varchar(100),
		off_ph  varchar(100),
		mobile varchar(100),
		CMBPID varchar(100),
	 )
create table table2
	(
		orderby varchar(2),
		dpam_id varchar(50),
		dpam_sba_name varchar(100),
		dpam_acctno varchar(100),
		dpam_desc varchar(500),
		dpam_trans_no varchar(100),
		trans_date varchar(100),
		isin_cd varchar(50),
		isin_name varchar(500),
		opening_bal varchar(20),
		debit_qty varchar(20),
		credit_qty varchar(20),
		closing_bal varchar(20),
		trans_date1 varchar(50),
		cdshm_trg_settm_no varchar(50)
	)

	insert into table1 exec pr_dp_select_mstr '0','CLIENT_INFO','HO','61171','','','','','0','*|~*','|*~|',''
    insert into table2 exec  Pr_rpt_statement 'CDSL','3','jan 01 2008','Aug 14 2009','N','N','','','','','n','Y',1,'HO|*~|','','','',''
	Select * from table1,table2

GO
