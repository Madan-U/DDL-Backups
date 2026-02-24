-- Object: PROCEDURE dbo.Add_client_proc_share_client_insert
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE   Proc Add_client_proc_share_client_insert As
Insert Into Client1
	Select
		Tmppartycode,left(tmpshortname,21),tmplongname,tmpaddr1,tmpaddr2,tmpcity,tmpstate,
		L_nation='',tmpzip,
		Tmpfax,
		Tmptelnor,
		Res_phone2='',
		Tmptelnoo,
		Off_phone2='',
		Tmpemail,
		Tmpbranchcode,credit_limit='0',tmpclienttype,tmpclientstatus,gl_code='',fd_code='',
		Tmpfamilycode,penalty='0',tmpsubbrokercode,confirm_fax='0',phoneold='',tmpaddr3,
		Tmpcellno,
		Tmppanno,tmptradercode, '', Tmpregion, Tmparea, '' From Msajag.dbo.tmp_client_details
	Where
		Tmppartycode Not In (select Cl_code From Client1)

Insert Into Client2
	Select
		Tmppartycode,exchange='nse',tmptranscat,scrip_cat=0,tmppartycode,tmptrdtableno,tmpdeltableno,margin='0',
		Turnover_tax='1',sebi_turn_tax='1',insurance_chrg='1',tmpservicetax,std_rate='0',p_to_p='0',exposure_lim='0',
		Tmpdeltableno,bankid='',cltdpno='',printf=tmpprint,albmdelchrg='0',albmdelivery='0',albmcf_tableno='0',
		Mf_tableno='0',sb_tableno='0',brok1_tableno='0',brok2_tableno='0',brok3_tableno='0',brokernote='1',
		Other_chrg='1',brok_scheme=tmpbrokscheme,contcharge='0',mincontamt='0',addledgerbal='0',
		Dummy1='',dummy2='',inscont='n',sertaxmethod='0',dummy6='',dummy7='',dummy8='',dummy9='',dummy10=tmpgroupcode
	From
		Msajag.dbo.tmp_client_details
	Where
		Tmppartycode Not In (select Party_code From Client2)

Insert Into Pobank (bank_name,branch_name)
	Select
		Tmpbankname,tmpbranchname From Msajag.dbo.tmp_client_details
	Where
		Tmpbankname Not In (select Bank_name From Pobank Where Branch_name = Tmpbranchname)

Insert Into Client4
	Select
		Tmppartycode,tmppartycode,'0',tmpdpid,tmpclientdpid,tmpdepository,tmpdefaultdp
		From
			Msajag.dbo.tmp_client_details
		Where
			Tmppartycode Not In (select Party_code From Client4 Where Tmppartycode = Party_code And Tmpdpid = Bankid And Tmpclientdpid = Cltdpid)

Insert Into Client4
	Select
		Tmppartycode,tmppartycode,'1',bankid,tmpacno,tmpactype,'0'
	From
		Msajag.dbo.tmp_client_details, (select Bankid=min(bankid),bank_name, Branch_name From Pobank 
	Group By
		Bank_name, Branch_name ) A
	Where
		Bank_name = Tmpbankname And Branch_name = Tmpbranchname

Insert Into Client5
	Select
		Tmppartycode,tmpdob,tmpsex,
		Activefrom = Convert(varchar, Getdate(), 106),
		Interactmode='0',
		Repatriatac='1',repatriatbank='0',repatriatacno='',introducer='',tmpapprover,kycform='0',bankcert='0',
		Passport=(case When Tmppassportno<>'' Then 1 Else 0 End),tmppassportno,
		Votersid=(case When Tmpvoteridno <>'' Then 1 Else 0 End),
		Tmpvoteridno,
		Itreturn='0',itreturndtl='',
		Drivelicen=(case When Tmplicenceno<>'' Then 1 Else 0 End),tmplicenceno,
		Rationcard=(case When Tmprationcardno<>'' Then 1 Else 0 End),tmprationcardno,
		Corpdtlrecd='0',corpdeed='0',anualreport='0',networthcert='0',inactivefrom=convert(varchar,tmpinactivefrom,106),
		P_address1='',p_address2='',p_address3='',p_city='',p_state='',p_nation='',p_phone='',p_zip='',addemailid='',
		Tmppassportissuedon,tmppassportissuedat,
		Tmpvoteridissuedon,
		Tmpvoteridissuedat,
		Itreturndateoffiling='',tmplicenceissuedon,tmplicenceissuedat,tmprationcardissuedon,tmprationcardissuedat ,
		Client_agre_dt='',tmpregnno,regr_place='',tmpdateofinc,regr_auth='',introd_client_id='',introd_relation='',
		Any_other_acc='',sett_mode='0',dealing_with_othrer_tm='',systumdate=getdate(),
		Tmppassportexpireson,
		Tmplicenceexpireson
	From
		Msajag.dbo.tmp_client_details
	Where
		Tmppartycode Not In (select Cl_code From Client5)

Insert Into Clienttaxes_new
	Select
		/*exchange*/ 'nse', 
		/*scidentity*/ '1', 
		/*party_code*/ Tmppartycode, 
		/*cl_type*/ Tmpclienttype, 
		/*trans_cat*/ 'trd', 
		/*insurance_chrg*/ 0.015, 
		/*turnover_tax*/ Tmptransactionchargestrd, 
		/*other_chrg*/ 0, 
		/*sebiturn_tax*/ 0, 
		/*broker_note*/ Tmpstampdutytrd, 
		/*demat_insure*/ 0, 
		/*service_tax*/ Tmpservicetax, 
		/*tax1*/ 0, 
		/*tax2*/ 0, 
		/*tax3*/ 0, 
		/*tax4*/ 0, 
		/*tax5*/ 0, 
		/*tax6*/ 0, 
		/*tax7*/ 0, 
		/*tax8*/ 0, 
		/*tax9*/ 0, 
		/*tax10*/ 0, 
		/*latest*/ 1, 
		/*state*/ 1, 
		/*fromdate*/ Left(convert(varchar, Dateadd(day, -30, Getdate()), 109), 11) /*+ ' 00:00:00'*/ , 
		/*todate*/ 'dec 31 2049' /*+ ' 23:59:59'*/, 
		Tmproundtodigit, 
		Tmproundtopaisa,
		Tmperrnum, 
		Tmpnozero 
	From
		Msajag.dbo.tmp_client_details
	Where
		Tmppartycode Not In (select Party_code From Msajag.dbo.clientmaster)

Insert Into Clienttaxes_new
	Select
		/*exchange*/ 'nse', 
		/*scidentity*/ '1', 
		/*party_code*/ Tmppartycode, 
		/*cl_type*/ Tmpclienttype, 
		/*trans_cat*/ 'del', 
		/*insurance_chrg*/ 0.075, 
		/*turnover_tax*/ Tmptransactionchargesdel, 
		/*other_chrg*/ 0, 
		/*sebiturn_tax*/ 0, 
		/*broker_note*/ Tmpstampdutydel, 
		/*demat_insure*/ 0, 
		/*service_tax*/ Tmpservicetax, 
		/*tax1*/ 0, 
		/*tax2*/ 0, 
		/*tax3*/ 0, 
		/*tax4*/ 0, 
		/*tax5*/ 0, 
		/*tax6*/ 0, 
		/*tax7*/ 0, 
		/*tax8*/ 0, 
		/*tax9*/ 0, 
		/*tax10*/ 0, 
		/*latest*/ 1, 
		/*state*/ 1, 
		/*fromdate*/ Left(convert(varchar, Dateadd(day, -30, Getdate()), 109), 11) /*+ ' 00:00:00'*/ , 
		/*todate*/ 'dec 31 2049' /*+ ' 23:59:59'*/, 
		Tmproundtodigit, 
		Tmproundtopaisa,
		Tmperrnum, 
		Tmpnozero
	From
		Msajag.dbo.tmp_client_details
	Where
		Tmppartycode Not In (select Party_code From Msajag.dbo.clientmaster)

Insert Into Clientbrok_scheme
	Select
		/*party_code*/ Tmppartycode, 
		/*table_no*/ Tmptrdtableno, 
		/*scheme_type*/'trd', 
		/*scrip_cd*/'all', 
		/*trade_type*/'nrm', 
		/*brokscheme*/tmpbrokscheme, 
		/*fromdate*/ Left(convert(varchar, Dateadd(day, -30, Getdate()), 109), 11) /*+ ' 00:00:00'*/ , 
		/*todate*/ 'dec 31 2049' /*+ ' 23:59:59'*/
	From
		Msajag.dbo.tmp_client_details
	Where
		Tmppartycode Not In (select Party_code From Msajag.dbo.clientmaster) And
		Tmpclienttype <> 'ins'

Insert Into Clientbrok_scheme
	Select
		/*party_code*/ Tmppartycode, 
		/*table_no*/ Tmpdeltableno, 
		/*scheme_type*/'del', 
		/*scrip_cd*/'all', 
		/*trade_type*/'nrm', 
		/*brokscheme*/tmpbrokscheme, 
		/*fromdate*/ Left(convert(varchar, Dateadd(day, -30, Getdate()), 109), 11) /*+ ' 00:00:00'*/ , 
		/*todate*/ 'dec 31 2049' /*+ ' 23:59:59'*/
	From
		Msajag.dbo.tmp_client_details
	Where
		Tmppartycode Not In (select Party_code From Msajag.dbo.clientmaster) And
		Tmpclienttype <> 'ins'

Insert Into Clientbrok_scheme
	Select
		/*party_code*/ Tmppartycode, 
		/*table_no*/ Tmptrdtableno, 
		/*scheme_type*/'trd', 
		/*scrip_cd*/'all', 
		/*trade_type*/'ins', 
		/*brokscheme*/tmpbrokscheme, 
		/*fromdate*/ Left(convert(varchar, Dateadd(day, -30, Getdate()), 109), 11) /*+ ' 00:00:00'*/ , 
		/*todate*/ 'dec 31 2049' /*+ ' 23:59:59'*/
	From
		Msajag.dbo.tmp_client_details
	Where
		Tmppartycode Not In (select Party_code From Msajag.dbo.clientmaster) And
		Tmpclienttype = 'ins'

Insert Into Clientbrok_scheme
	Select
		/*party_code*/ Tmppartycode, 
		/*table_no*/ Tmpdeltableno, 
		/*scheme_type*/'del', 
		/*scrip_cd*/'all', 
		/*trade_type*/'ins', 
		/*brokscheme*/tmpbrokscheme, 
		/*fromdate*/ Left(convert(varchar, Dateadd(day, -30, Getdate()), 109), 11) /*+ ' 00:00:00'*/ , 
		/*todate*/ 'dec 31 2049' /*+ ' 23:59:59'*/
	From
		Msajag.dbo.tmp_client_details
	Where
		Tmppartycode Not In (select Party_code From Msajag.dbo.clientmaster) And
		Tmpclienttype = 'ins'

Insert Into	Multicltid
	Select
		Tmppartycode,tmpclientdpid,tmpdpid,tmplongname,tmpdepository, Tmppoa
	From
		Msajag.dbo.tmp_client_details 
	Where
		Tmppartycode Not In (select Party_code From Multicltid M Where Tmppartycode = Party_code And Tmpdpid = Dpid And Tmpclientdpid = Cltdpno)

Insert Into	Multicltid
	Select
		Tmppartycode,tmpclientdpid,tmpdpid,tmplongname,tmpdepository, Tmppoa
	From
		Msajag.dbo.tmp_client_details_multiclientdpid 
	Where
		Tmppartycode Not In (select Party_code From Multicltid M Where Tmppartycode = Party_code And Tmpdpid = Dpid And Tmpclientdpid = Cltdpno)

Insert Into Delpartyflag
	Select
		Tmppartycode, Tmpdebitbalance, Tmpintersettlement
	From 
		Msajag.dbo.tmp_client_details
	Where
		Tmppartycode Not In (select Party_code From Msajag.dbo.delpartyflag)

GO
