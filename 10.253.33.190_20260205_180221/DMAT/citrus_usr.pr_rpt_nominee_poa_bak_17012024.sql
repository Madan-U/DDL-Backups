-- Object: PROCEDURE citrus_usr.pr_rpt_nominee_poa_bak_17012024
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------




/*
520, GURU KRIPA BUILDING,GROUND FLOOR, S.V.P.ROAD,OPERA HOUSE,MUMBAIINDIA400004
EXEC pr_rpt_nominee_poa 3,'NOMINEE','','','01/05/2008','06/06/2009','Y',1,'HO|*~|',''
EXEC pr_rpt_nominee_poa 3,'NOMINEE','','','01/05/2008','06/06/2009','n',1,'HO|*~|',''
EXEC pr_rpt_nominee_poa 3,'CLT_WITHOUT_NOM','','','05/06/2008','05/06/2009','',1,'HO|*~|',''
EXEC pr_rpt_nominee_poa 3,'NOMINEE_ALL','','','05/06/2008','05/06/2009','',1,'HO|*~|',''
EXEC pr_rpt_nominee_poa 3,'poa','','','01/11/2013','03/12/2013','N',1,'HO|*~|',''

exec pr_rpt_nominee_poa 3,'POA|*~|expdt','','','23/12/2013','23/12/2013','N',1,'HO|*~|',''

exec pr_rpt_nominee_poa 3,'POA|*~|expdt','','','dec 23 2013','dec 23 2013','N',1,'HO|*~|',''

select citrus_usr.fn_splitval_by('POA|*~|expdt',2,'|*~|')

*/

--	3	NOMINEE|*~|actdt			07/01/2013	07/01/2014	N	1	HO|*~|	

create  proc [citrus_usr].[pr_rpt_nominee_poa_bak_17012024]
   (
    @pa_excsmid int,
	@pa_rpt_type varchar(50),
	@pa_fromaccid varchar(16),                  
	@pa_toaccid varchar(16),    
    @pa_from_dt varchar(11),
    @pa_to_dt   varchar(11),
    @pa_minor_flg char(1),              
	@pa_login_pr_entm_id numeric,                    
	@pa_login_entm_cd_chain  varchar(8000),                    
	@pa_output varchar(8000) output  
  )
as
BEGIN
--
	declare @@dpmid int , @@dtoption varchar(10)
	
	select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                        
	declare @@l_child_entm_id      numeric                    
	select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                    
	CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150))
	
	if @pa_fromaccid = ''                  
	begin                  
	 set @pa_fromaccid = '0'                  
	 set @pa_toaccid = '99999999999999999'                  
	end                    
	if @pa_toaccid = ''                  
	begin                  
	 set @pa_toaccid = @pa_fromaccid                  
	end 

	INSERT INTO #ACLIST 
	SELECT DPAM_ID,dpam_sba_no,dpam_sba_name 
	FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
	WHERE  isnumeric(DPAM_sba_NO)=1 
	--and (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) 	AND  convert(numeric,@pa_toaccid))
	and DPAM_sba_NO between @pa_fromaccid 	AND  @pa_toaccid
--
set @@dtoption = citrus_usr.fn_splitval_by(@pa_rpt_type,2,'|*~|')
set @pa_rpt_type = citrus_usr.fn_splitval_by(@pa_rpt_type,1,'|*~|')
print @pa_rpt_type
print @@dtoption
 
 
  select *, case when case when pc6.DateOfBirth <> '' then convert(datetime,left(ltrim(rtrim(pc6.DateOfBirth)) ,2)+'/'+substring(ltrim(rtrim(pc6.DateOfBirth)),3,2)+'/'+right(ltrim(rtrim(pc6.DateOfBirth)),4),103)  else '' end  <    'apr 01 2023' then case when pc6.DateOfBirth <> '' then pc6.DateOfBirth else '' end   else case when  pc6.DateOfSetup<> '' then pc6.DateOfSetup else '' end  end dob 
 , case when case when pc6.DateOfBirth <> '' then convert(datetime,left(ltrim(rtrim(pc6.DateOfBirth)) ,2)+'/'+substring(ltrim(rtrim(pc6.DateOfBirth)),3,2)+'/'+right(ltrim(rtrim(pc6.DateOfBirth)),4),103)  else '' end  >=    'apr 01 2023' then case when  pc6.DateOfBirth <>'' then pc6.DateOfBirth else '' end else  case when pc6.DateOfSetup<>'' then pc6.DateOfSetup else '' end    end  dos 
into #tempdata_pc6  from dps8_pc6  pc6


 
	if @pa_rpt_type ='NOMINEE'
	BEGIN
	--


		If @pa_minor_flg='Y'
			Begin 
			select distinct dpacct.dpam_acct_no form_no
			,account.dpam_sba_no client_id 
			, account.dpam_sba_name client_name 
			, ltrim(rtrim(isnull(pc6.Name,''))) + ' ' + ltrim(rtrim(isnull(pc6.MiddleName,''))) + ' ' + ltrim(rtrim(isnull(pc6.SearchName,''))) NAME
			,NAME_id = case when (isnull(NOM_NRN_NO,''))='' then 'N/A' else NOM_NRN_NO end 
			,left(tmpc6.DateOfSetup ,2) + '/' + substring(tmpc6.DateOfSetup ,3,2)+ '/' + right(tmpc6.DateOfSetup ,4) SetupDate
			,Nom_Addr=isnull(pc6.Addr1 ,'') + '' +  isnull(pc6.Addr2,'')+ '' +isnull(pc6.Addr3,'')+ '' +isnull(pc6.City,'')+ '' +isnull(pc6.State,'')+ '' +isnull(pc6.Country,'')+ '' +isnull(pc6.PinCode,'')--replace(citrus_usr.fn_acct_addr_value(dpacct.dpam_id,'NOMINEE_ADR1'),'|*~|',' ')
			, ltrim(rtrim(isnull(pc8.Name,''))) + ' ' + ltrim(rtrim(isnull(pc8.MiddleName,''))) + ' ' + ltrim(rtrim(isnull(pc8.SearchName,''))) NOMGUARDNAME
			,Nom_Guard_Addr=isnull(pc8.Addr1 ,'') + '' +  isnull(pc8.Addr2,'')+ '' +isnull(pc8.Addr3,'')+ '' +isnull(pc8.City,'')+ '' +isnull(pc6.State,'')+ '' +isnull(pc8.Country,'')+ '' +isnull(pc8.PinCode,'')--replace(citrus_usr.fn_acct_addr_value(dpacct.dpam_id,'NOMINEE_ADR1'),'|*~|',' ')
			,isnull(DATEADD(DAY,1,(DATEADD(YEAR,18,convert(datetime,DPHD_NOM_DOB,103)))),'') major_dt
,'' Nom_Flag
		from #ACLIST account, dp_holder_dtls,dp_acct_mstr dpacct 
		 left outer join #tempdata_pc6 tmpc6 on tmpc6.boid = dpam_sba_no and tmpc6.TypeOfTrans in ('1','')
left outer join dps8_pc6 pc6 on pc6.boid = dpam_sba_no and pc6.TypeOfTrans in ('1','')
left outer join dps8_pc8 pc8 on pc8.boid = dpam_sba_no and pc8.TypeOfTrans in ('1','')
            ,account_properties 
			where account.dpam_id = dphd_dpam_id				
			and accp_clisba_id = dpacct.dpam_id 
			and ACCP_ACCPM_PROP_CD = 'bill_start_dt' 
			and   left(accp_value,2) not in ('00','//') 
			and  convert(datetime,left(pc6.DateOfSetup ,2) + '/' + substring(pc6.DateOfSetup ,3,2)+ '/' + right(pc6.DateOfSetup ,4),103) between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)
			and   account.dpam_id = dpacct.dpam_id
			and   isnull(DPHD_NOM_FNAME,'')<>''
			and  dpacct.dpam_deleted_ind = 1
			and  DPHD_DELETED_IND = 1   and  pc6.DateOfSetup <> ''
            AND    DATEDIFF(DAY,CONVERT(DATETIME,DPHD_NOM_DOB,103),CONVERT(DATETIME,GETDATE(),103)) < 6570
			order by account.dpam_sba_no,SetupDate

			end
        else
        Begin
        --print 'major N'
			select distinct dpacct.dpam_acct_no form_no
			,account.dpam_sba_no client_id 
			, account.dpam_sba_name client_name 
			, ltrim(rtrim(isnull(pc6.Name,''))) + ' ' + ltrim(rtrim(isnull(pc6.MiddleName,''))) + ' ' + ltrim(rtrim(isnull(pc6.SearchName,''))) NAME
			, isnull(NOM_NRN_NO,'') NAME_id
			,left(tmpc6.DateOfSetup ,2) + '/' + substring(tmpc6.DateOfSetup ,3,2)+ '/' + right(tmpc6.DateOfSetup ,4) SetupDate
			,Nom_Addr=isnull(pc6.Addr1 ,'')+ '' +  isnull(pc6.Addr2,'')+ '' +isnull(pc6.Addr3,'')+ '' +isnull(pc6.City,'')+ '' +isnull(pc6.State,'')+ '' +isnull(pc6.Country,'')+ '' +isnull(pc6.PinCode,'')--replace(citrus_usr.fn_acct_addr_value(dpacct.dpam_id,'NOMINEE_ADR1'),'|*~|',' ')
			, ltrim(rtrim(isnull(pc8.Name,''))) + ' ' + ltrim(rtrim(isnull(pc8.MiddleName,''))) + ' ' + ltrim(rtrim(isnull(pc8.SearchName,''))) NOMGUARDNAME
			,Nom_Guard_Addr=isnull(pc8.Addr1 ,'') + '' +  isnull(pc8.Addr2,'')+ '' +isnull(pc8.Addr3,'')+ '' +isnull(pc8.City,'')+ '' +isnull(pc6.State,'')+ '' +isnull(pc8.Country,'')+ '' +isnull(pc8.PinCode,'')--replace(citrus_usr.fn_acct_addr_value(dpacct.dpam_id,'NOMINEE_ADR1'),'|*~|',' ')
			,case when isnull(DATEADD(DAY,1,(DATEADD(YEAR,18,convert(datetime,DPHD_NOM_DOB,103)))),'') = '1918-01-02 00:00:00.000' then '1900-01-01 00:00:00.000' 
			--else convert (varchar (11),isnull(DATEADD(DAY,1,(DATEADD(YEAR,18,convert(datetime,DPHD_NOM_DOB,103)))),''),103) end  major_dt
			else isnull(DATEADD(DAY,1,(DATEADD(YEAR,18,convert(datetime,DPHD_NOM_DOB,103)))),'') end  major_dt
,'' Nom_Flag
			from #ACLIST account, dp_holder_dtls,dp_acct_mstr dpacct 
			 left outer join #tempdata_pc6 tmpc6 on tmpc6.boid = dpam_sba_no and tmpc6.TypeOfTrans in ('1','')
			left outer join dps8_pc6 pc6 on pc6.boid = dpam_sba_no and  pc6.TypeOfTrans in ('1','','2')
						left outer join dps8_pc8 pc8 on pc8.boid = dpam_sba_no and  pc8.TypeOfTrans in ('1','')
			, account_properties
			where account.dpam_id = dphd_dpam_id
			and   accp_clisba_id = dpacct.dpam_id
			and   ACCP_ACCPM_PROP_CD = 'bill_start_dt' 
			and   left(accp_value,2) not in ('00','//')
			and   account.dpam_id = dpacct.dpam_id
			and   isnull(DPHD_NOM_FNAME,'')<>''
			and  dpacct.dpam_deleted_ind = 1
			and  DPHD_DELETED_IND = 1         
			and  convert(datetime,left(pc6.DateOfSetup ,2) + '/' + substring(pc6.DateOfSetup ,3,2)+ '/' + right(pc6.DateOfSetup ,4),103) between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)
			and  pc6.DateOfSetup <> ''
			order by account.dpam_sba_no,SetupDate

			end 

	--
	END
    ELSE IF @pa_rpt_type ='NOMINEE_ALL'
	BEGIN
	--
	
		select distinct dpacct.dpam_acct_no form_no
		,account.dpam_sba_no client_id 
		, account.dpam_sba_name client_name 
		, ltrim(rtrim(isnull(pc6.Name,''))) + ' ' + ltrim(rtrim(isnull(pc6.MiddleName,''))) + ' ' + ltrim(rtrim(isnull(pc6.SearchName,''))) NAME
		--, isnull(NOM_NRN_NO,'') NAME_id
		,NAME_id=case when  isnull(NOM_NRN_NO,'')='' then 'N/A' else NOM_NRN_NO end 
      ,left(tmpc6.DateOfSetup ,2) + '/' + substring(tmpc6.DateOfSetup ,3,2)+ '/' + right(tmpc6.DateOfSetup ,4) SetupDate
		,Nom_Addr=case when replace(citrus_usr.fn_acct_addr_value(dpacct.dpam_id,'NOMINEE_ADR1'),'|*~|',' ')= '' then 'N/A' else replace(citrus_usr.fn_acct_addr_value(dpacct.dpam_id,'NOMINEE_ADR1'),'|*~|',' ') end
		--,case when (Nom_Addr=replace(citrus_usr.fn_acct_addr_value(dpacct.dpam_id,'NOMINEE_ADR1'),'|*~|',' '),'') ='' then 'N/A' else  Nom_Addr  end Nom_Addr
	,isnull(DATEADD(DAY,1,(DATEADD(YEAR,18,convert(datetime,DPHD_NOM_DOB,103)))),'') major_dt
		,case when isnull(DPHD_NOM_FNAME,'')<>'' then 'N' else 'Y' end as Nom_Flag
		from #ACLIST account, dp_holder_dtls,dp_acct_mstr dpacct  
		 left outer join #tempdata_pc6 tmpc6 on tmpc6.boid = dpam_sba_no and tmpc6.TypeOfTrans in ('1','')
		left outer join dps8_pc6 pc6 on pc6.boid = dpam_sba_no and pc6.TypeOfTrans in ('1','')
		, account_properties
		where account.dpam_id = dphd_dpam_id
        and   accp_clisba_id = dpacct.dpam_id
        and   ACCP_ACCPM_PROP_CD = 'bill_start_dt' 
        and   accp_Value not in ('00','//')
		and   account.dpam_id = dpacct.dpam_id		and ISNUMERIC(dpacct.DPAM_SBA_NO )= 1
		and  dpacct.dpam_deleted_ind = 1
		and  DPHD_DELETED_IND = 1         
        and  convert(datetime,accp_value,103) between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)

        order by account.dpam_sba_no,SetupDate
	--
	END

    ELSE IF @pa_rpt_type ='CLT_WITHOUT_NOM'

	BEGIN
	--

print('CLT_WITHOUT_NOM')
		select distinct dpacct.dpam_acct_no form_no
		,account.dpam_sba_no client_id 
		, account.dpam_sba_name client_name 
		, isnull(DPHD_NOM_FNAME,'') + ' ' + isnull(DPHD_NOM_MNAME,'') + ' ' + isnull(DPHD_NOM_LNAME,'') NAME
		--,case when (isnull(DPHD_NOM_FNAME,'') + ' ' + isnull(DPHD_NOM_MNAME,'') + ' ' + isnull(DPHD_NOM_LNAME,''))='' then 'N/A' else  NAME
		--, isnull(NOM_NRN_NO,'') NAME_id
		,case when (isnull(NOM_NRN_NO,''))=''then 'N/A' else NOM_NRN_NO end   NAME_id
        ,''  SetupDate
		,Nom_Addr=replace(citrus_usr.fn_acct_addr_value(dpacct.dpam_id,'NOMINEE_ADR1'),'|*~|',' ')
	--,isnull(DATEADD(DAY,1,(DATEADD(YEAR,18,convert(datetime,DPHD_NOM_DOB,103)))),'') major_dt
	,CASE when DPHD_NOM_DOB = '1900-01-01 00:00:00.000' then '' else isnull(DATEADD(DAY,1,(DATEADD(YEAR,18,convert(datetime,DPHD_NOM_DOB,103)))),'') end major_dt
,'' Nom_Flag
		from #ACLIST account, dp_holder_dtls,dp_acct_mstr dpacct, account_properties
		where account.dpam_id = dphd_dpam_id
        and   accp_clisba_id = dpacct.dpam_id
        and   ACCP_ACCPM_PROP_CD = 'bill_start_dt' 
	    and   left(accp_value,2) not in ('00','//')
        and   account.dpam_id = dpacct.dpam_id	 
        and  isnull(DPHD_NOM_FNAME,'')= ''	
		and  dpacct.dpam_deleted_ind = 1
		and  DPHD_DELETED_IND = 1         
      --and  convert(datetime,accp_value,103) between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)
      and  accp_value  between @pa_from_dt and @pa_to_dt
        order by account.dpam_sba_no,SetupDate




-- 		select dpacct.dpam_acct_no form_no
--		,account.dpam_sba_no client_id 
--		, account.dpam_sba_name client_name 
--		, isnull(DPHD_NOM_FNAME,'') + ' ' + isnull(DPHD_NOM_MNAME,'') + ' ' + isnull(DPHD_NOM_LNAME,'') NAME
--		--,case when (isnull(DPHD_NOM_FNAME,'') + ' ' + isnull(DPHD_NOM_MNAME,'') + ' ' + isnull(DPHD_NOM_LNAME,''))='' then 'N/A' else  NAME
--		--, isnull(NOM_NRN_NO,'') NAME_id
--		,case when (isnull(NOM_NRN_NO,''))=''then 'N/A' else NOM_NRN_NO end   NAME_id
--        ,accp_value SetupDate
--		,Nom_Addr=replace(citrus_usr.fn_acct_addr_value(dpacct.dpam_id,'NOMINEE_ADR1'),'|*~|',' ')
--		from #ACLIST account, dp_holder_dtls,dp_acct_mstr dpacct, account_properties
--		where account.dpam_id = dphd_dpam_id
--        and   accp_clisba_id = dpacct.dpam_id
--        and   ACCP_ACCPM_PROP_CD = 'bill_start_dt' 
--        and   left(accp_value,2) not in ('00','//')
--		and   account.dpam_id = dpacct.dpam_id	
--        and   isnull(DPHD_NOM_FNAME,'')= ''	
--		and  dpacct.dpam_deleted_ind = 1
--		and  DPHD_DELETED_IND = 1         
--        and  convert(datetime,accp_value,103) between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103)
--        order by account.dpam_sba_no,SetupDate
--
	END

	ELSE

	BEGIN
	--
  print '11222'
 --print @@dtoption
 --print 'yogesh'
		select distinct dpacct.dpam_acct_no form_no
		,account.dpam_sba_no client_id 
		,account.dpam_sba_name client_name 
--		,citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'PER_ADR1'),1) + ' ' + citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'PER_ADR1'),2)
--		+ ' ' + citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'PER_ADR1'),3) + ' ' + citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'PER_ADR1'),4)
--		+ ' ' + citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'PER_ADR1'),5) + ' ' + citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'PER_ADR1'),6)
--		+ ' ' + citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'PER_ADR1'),7)
,ltrim(rtrim(pc1.Addr1)) + ' ' + 
ltrim(rtrim(pc1.Addr2)) + ' ' + 
ltrim(rtrim(pc1.Addr3)) + ' ' + 
ltrim(rtrim(pc1.City)) + ' ' + 
ltrim(rtrim(pc1.State)) + ' ' + 
ltrim(rtrim(pc1.Country)) + ' ' + 
ltrim(rtrim(pc1.PinCode)) 
 as Client_Addr 
		,isnull(DPPD_FNAME,'') + ' ' + isnull(DPPD_MNAME,'') + ' ' + isnull(DPPD_LNAME,'') NAME
		,isnull(dppd_master_id,'') NAME_id
--        ,convert(datetime,convert(datetime,ltrim(rtrim(substring(setupdate,1,2) + '/' + substring(setupdate,3,2) + '/' 
--+ substring(setupdate,5,4) )),103) ,103)    SetupDate
,ltrim(rtrim(substring(setupdate,1,2) + '/' + substring(setupdate,3,2) + '/' + substring(setupdate,5,4))) SetupDate
        ,POARegNum as dppd_poa_id
        ,poa_addr = IsNull(poam_adr1,'') +''+ IsNull(poam_adr2,'') + ' '+ IsNull(poam_adr3,'')+ ' ' + IsNull(poam_city,'') + ''+ IsNull(poam_state,'') + ' '+ IsNull(poam_country,'') + ' ' + IsNull(poam_zip,'') 
 ,case when isnull(EffToDate,'')<> '' then ltrim(rtrim(substring(EffToDate,1,2) + '/' + substring(EffToDate,3,2) + '/' 
+ substring(EffToDate,5,4) )) else '' end    ExpiryDate
        from #ACLIST account, dp_poa_dtls,dp_acct_mstr dpacct, account_properties ,poam ,dps8_pc5 pc5,dps8_pc1  pc1
        where   accp_clisba_id = dpacct.dpam_id and pc5.boid = account.dpam_sba_no and pc5.boid = pc1.boid 
        and   ACCP_ACCPM_PROP_CD = 'bill_start_dt' 
		and  account.dpam_id = dppd_dpam_id
        and   left(accp_value,2) not in ('00','//')
		and   account.dpam_id = dpacct.dpam_id
		and   isnull(DPpD_FNAME,'')<>'' and HolderNum ='1'
		and  dpacct.dpam_deleted_ind = 1 	
		and DPPD_DELETED_IND = 1 
        and  dppd_master_id = poam_master_id    
--        and  case when @@dtoption = 'actdt' then convert(datetime,convert(datetime,ltrim(rtrim(substring(setupdate,1,2) + '/' + substring(setupdate,3,2) + '/' 
--+ substring(setupdate,5,4) )),103) ,103) 
--				  when @@dtoption = 'expdt' then convert(datetime,convert(datetime,ltrim(rtrim(substring(EffToDate,1,2) + '/' + substring(EffToDate,3,2) + '/' 
--				   + substring(EffToDate,5,4) )),103) ,103) end between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103) 
and case when @@dtoption = 'EXPDT' then pc5.EffToDate else pc5.setupdate end <> ''
				and  case when @@dtoption = 'ACTDT' then convert(datetime,convert(datetime,ltrim(rtrim(substring(setupdate,1,2) + '/' + substring(setupdate,3,2) + '/' 
				+ substring(setupdate,5,4) )),103) ,103) 
				  when @@dtoption = 'EXPDT' then convert(datetime,convert(datetime,ltrim(rtrim(substring(EffToDate,1,2) + '/' + substring(EffToDate,3,2) + '/' 
				   + substring(EffToDate,5,4) )),103) ,103) end between convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103) 
        order by account.dpam_sba_no,SetupDate

		
	--
	END
	
--
END

GO
