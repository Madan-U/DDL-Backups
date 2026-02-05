-- Object: PROCEDURE citrus_usr.pr_insert_dps8_bak21082020
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------




create  proc [citrus_usr].[pr_insert_dps8_bak21082020](@pa_level numeric)
as
begin

declare @l_counter numeric
		,@l_count numeric
		,@l_str varchar(2500)



	if @pa_level = 0 
	begin 

		

	

		select identity(numeric,1,1) id ,
		'insert into dps8_pc0 values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc0 from dps8_source1 a 
		where left(a.value ,2) = '00' 
		and not exists(SELECT BOID FROM DPS8_PC0 b WHERE b.BOID = a.boid)   



		create index ix_1 on #tmpdps8_pc0(id)

		
		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc0 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc0 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc0


	end 
	if @pa_level = 1 
	begin 

		

		select identity(numeric,1,1) id ,
		'insert into dps8_pc1 (PurposeCode1,TypeOfTrans,Title,Name,MiddleName,SearchName,Suffix,FthName,Addr1,Addr2,Addr3,City,statecode,State
,countrycode,Country,PinCode,smart_flag,isd_pri,PriPhNum,isd_sec,AltPhNum,pri_email,Fax,PANExCode,PANGIR,PANVerCode,ITCircle
,sec_email,UsrTxt1,UsrTxt2,UsrFld3,BOAcctStatus,FrzSusFlg,BOCategory,BOCustType,BOSubStatus,ProdCode,ClCorpId,ClMemId
,StockExch,TradingId,BOStatCycleCd,AcctCreatDt,DPIntRefNum,ConfWaived,DateOfBirth,BOActDt,EletConf,ECS,DivBankAcctNo
,DivBankCd,DivIFScd,DivBankCurr,DivAcctType,AnnIncomeCd,BenTaxDedStat,BOSettPlanFlg,Edu,GeogCd,GroupCd,LangCd,NatCd,Occupation
,SecAccCd,SexCd,Staff,StaffCd,RBIRefNum,RBIAppDt,SEBIRegNum,ClosAppDt,ClosDt,TransBOId,BalTrans,ClosResCd,ClosInitBy,ClosRemark
,UnqIdenNum,Filler1,Filler2,Filler3,Filler4,Filler5,AnnlRep,Filler6,Filler7,Filler8,Filler9,mSTRPOAFLG,FAMILYACCTFLG,CUSTODIANEMAILID
,AFILLER1,AFILLER6,AFILLER7,AFILLER8,AFILLER9,AFILLER10,AFILLER2,AFILLER3,AFILLER4,AFILLER5,BOId,TransSystemDate)
values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc1 from dps8_source1 a 
		where left(a.value ,2) = '01' 
		and not exists(SELECT BOID FROM DPS8_PC1 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc1(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc1 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc1 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc1


	end 
    if @pa_level = 2
	begin 

		

		select identity(numeric,1,1) id ,
		case when len(value) - len(replace(value,'~','')) > 40  then  'insert into dps8_pc2 (PurposeCode2,TypeOfTrans,Title,Name,MiddleName,SearchName,Suffix,FthName,PANExCd
		,PANGIR,PANVerCd,ITCircle,Addr1,Addr2,Addr3,City,statecode,State,countrycode,Country,PinCode,DateofSetup,DateofBirth,Email
		,UniqueId,Filler1,pri_isd,pri_ph_no,Filler2,Filler11,Filler12,Filler13,Filler14,Filler15,Filler3,Filler4,Filler5,Filler6,Filler7,Filler8,Filler9,BOId,TransSystemDate
		) values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')'
		else 'insert into dps8_pc2 (PurposeCode2,TypeOfTrans,Title,Name,MiddleName,SearchName,Suffix,FthName,PANExCd
		,PANGIR,PANVerCd,ITCircle,Addr1,Addr2,Addr3,City,State,Country,PinCode,DateofSetup,DateofBirth,Email
		,UniqueId,Filler1,pri_isd,pri_ph_no,Filler2,Filler11,Filler12,Filler13,Filler14,Filler15,Filler3,Filler4,Filler5,Filler6,Filler7,Filler8,Filler9,BOId,TransSystemDate
		) values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' 
		end  insertstr
		
		 into #tmpdps8_pc2 from dps8_source1 a 
		where left(a.value ,2) = '02' 
		and not exists(SELECT BOID FROM DPS8_PC2 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc2(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc2 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc2 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc2


	end 
	if @pa_level = 3
	begin 

		

		select identity(numeric,1,1) id ,
		case when len(value) - len(replace(value,'~','')) > 40  then  'insert into dps8_pc3 (PurposeCode3,TypeOfTrans,Title,Name,MiddleName,SearchName,Suffix,FthName,PANExCd
,PANGIR,PANVerCd,ITCircle,Addr1,Addr2,Addr3,City,statecode,State,countrycode,Country,PinCode,DateofSetup,DateofBirth,Email
,UniqueId,Filler1,pri_isd,pri_ph_no,Filler2,Filler11,Filler12,Filler13,Filler14,Filler15,Filler3,Filler4,Filler5,Filler6,Filler7,Filler8,Filler9,BOId,TransSystemDate
) values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')'
else  'insert into dps8_pc3 (PurposeCode3,TypeOfTrans,Title,Name,MiddleName,SearchName,Suffix,FthName,PANExCd
,PANGIR,PANVerCd,ITCircle,Addr1,Addr2,Addr3,City,State,Country,PinCode,DateofSetup,DateofBirth,Email
,UniqueId,Filler1,pri_isd,pri_ph_no,Filler2,Filler11,Filler12,Filler13,Filler14,Filler15,Filler3,Filler4,Filler5,Filler6,Filler7,Filler8,Filler9,BOId,TransSystemDate
) values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')'  end  insertstr into #tmpdps8_pc3 from dps8_source1 a 
		where left(a.value ,2) = '03' 
		and not exists(SELECT BOID FROM DPS8_PC3 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc3(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc3 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc3 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc3


	end 
	if @pa_level = 4
	begin 

		

		select identity(numeric,1,1) id ,
		'insert into dps8_pc4 values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc4 from dps8_source1 a 
		where left(a.value ,2) = '04' 
		and not exists(SELECT BOID FROM DPS8_PC4 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc4(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc4 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc4 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc4


	end 
	if @pa_level = 5
	begin 

		

--		select identity(numeric,1,1) id ,
--		'insert into dps8_pc5 values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc5 from dps8_source1 a 
--		where left(a.value ,2) = '05' 
--		and not exists(SELECT BOID FROM DPS8_PC5 b WHERE b.BOID = a.boid 
--		and MasterPOAId = citrus_usr.fn_splitval_by(value,	3	,'~')
--		and SetupDate	=	citrus_usr.fn_splitval_by(value,	5	,'~')
--		and POARegNum	=	citrus_usr.fn_splitval_by(value,	4	,'~'))   
--        and citrus_usr.fn_splitval_by(a.value ,11,'~') = 'A' 


select citrus_usr.fn_splitval_by(value,	12	,'~') cltid,citrus_usr.fn_splitval_by(value,	3	,'~') mastpoaid  
,max(citrus_usr.fn_splitval_by(value,	13	,'~')) maxmoddt, citrus_usr.fn_splitval_by(value,	10	,'~')   holder into #maxpoachange
from dpb9_source1 where  left(value ,2) = '05'  
group by citrus_usr.fn_splitval_by(value,	12	,'~') ,citrus_usr.fn_splitval_by(value,	3	,'~')
,citrus_usr.fn_splitval_by(value,	10	,'~')   



select identity(numeric,1,1) id ,
		'insert into dps8_pc5 values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr 
		into #tmpdps8_pc5 from dpb9_source1 a  , #maxpoachange b 
		where left(a.value ,2) = '05' 
		and not exists(SELECT BOID FROM DPS8_PC5 b WHERE b.BOID = citrus_usr.fn_splitval_by(value,	12	,'~')
		and MasterPOAId = citrus_usr.fn_splitval_by(value,	3	,'~')
		and SetupDate	=	citrus_usr.fn_splitval_by(value,	5	,'~')
		and POARegNum	=	citrus_usr.fn_splitval_by(value,	4	,'~')
		and HolderNum	=	citrus_usr.fn_splitval_by(value,	10	,'~'))   
        and citrus_usr.fn_splitval_by(a.value ,11,'~') = 'A' 
and b.cltid = citrus_usr.fn_splitval_by(value,	12	,'~')
and b.maxmoddt =citrus_usr.fn_splitval_by(value,	13	,'~')
and b.mastpoaid = citrus_usr.fn_splitval_by(value,	3	,'~')
and b.holder = citrus_usr.fn_splitval_by(value,	10	,'~')






		create index ix_1 on #tmpdps8_pc5(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc5 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc5 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc5


	end 
	if @pa_level = 6
	begin 

		

		select identity(numeric,1,1) id ,
		'INSERT INTO DPs8_PC6(PurposeCode6
,TypeOfTrans
,Title
,Name
,MiddleName
,SearchName
,Suffix
,FthName
,Addr1
,Addr2
,Addr3
,City
,statecode
,State
,countrycode
,Country
,PinCode
,PriPhInd
,PriPhNum
,AltPhInd
,AltPhNum
,AddPhones
,Fax
,PANGIR
,ItCircle
,EMailid
,DateOfSetup
,DateOfBirth
,UsrTxt1
,UsrTxt2
,UsrFld3
,Email
,UnqIdNum
,Filler1
,Filler2
,Filler3
,Filler4
,Filler5
,Filler6
,Filler7
,Filler8
,Filler9
,Filler10
,RES_SEC_FLg
,NOM_Sr_No
,rel_WITH_BO
,perc_OF_SHARES
,Filler11
,Filler12
,Filler13
,Filler14
,Filler15
,BOId
,TransSystemDate
)  values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc6 from dps8_source1 a 
		where left(a.value ,2) = '06' 
		--and not exists(SELECT BOID FROM DPS8_PC6 b WHERE b.BOID = a.boid)   
		and not exists(SELECT BOID FROM DPS8_PC6 b WHERE b.BOID = a.boid and citrus_usr.fn_splitval_by(a.value,	45	,'~')=b.nom_sr_no)  -- 44 change to 43 on tp request.. 


		create index ix_1 on #tmpdps8_pc6(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc6 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc6 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc6


	end 
	if @pa_level = 7
	begin 

		

		select identity(numeric,1,1) id ,
		'INSERT INTO DPs8_PC7(PurposeCode7
,TypeOfTrans
,Title
,Name
,MiddleName
,SearchName
,Suffix
,FthName
,Addr1
,Addr2
,Addr3
,City
,statecode
,State
,countrycode
,Country
,PinCode
,PriPhInd
,PriPhNum
,AltPhInd
,AltPhNum
,AddPhones
,Fax
,PANGIR
,ItCircle
,EMailid
,DateOfSetup
,DateOfBirth
,UsrTxt1
,UsrTxt2
,UsrFld3
,Email
,UnqIdNum
,Filler1
,Filler2
,Filler3
,Filler4
,Filler5
,Filler6
,Filler7
,Filler8
,Filler9
,Filler10
,RES_SEC_FLg
,NOM_Sr_No
,rel_WITH_BO
,perc_OF_SHARES
,Filler11
,Filler12
,Filler13
,Filler14
,Filler15
,BOId
,TransSystemDate
)  values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc7 from dps8_source1 a 
		where left(a.value ,2) = '07' 
		and not exists(SELECT BOID FROM DPS8_PC7 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc7(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc7 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc7 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc7


	end 
	if @pa_level = 8
	begin 

		

		select identity(numeric,1,1) id ,
		'INSERT INTO DPs8_PC8(PurposeCode8
,TypeOfTrans
,Title
,Name
,MiddleName
,SearchName
,Suffix
,FthName
,Addr1
,Addr2
,Addr3
,City
,statecode
,State
,countrycode
,Country
,PinCode
,PriPhInd
,PriPhNum
,AltPhInd
,AltPhNum
,AddPhones
,Fax
,PANGIR
,ItCircle
,EMailid
,DateOfSetup
,DateOfBirth
,UsrTxt1
,UsrTxt2
,UsrFld3
,Email
,UnqIdNum
,Filler1
,Filler2
,Filler3
,Filler4
,Filler5
,Filler6
,Filler7
,Filler8
,Filler9
,Filler10
,RES_SEC_FLg
,NOM_Sr_No
,rel_WITH_BO
,perc_OF_SHARES
,Filler11
,Filler12
,Filler13
,Filler14
,Filler15
,BOId
,TransSystemDate
)  values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc8 from dps8_source1 a 
		where left(a.value ,2) = '08' 
		and not exists(SELECT BOID FROM DPS8_PC8 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc8(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc8 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc8 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc8


	end 
	if @pa_level = 12
	begin 

		

		select identity(numeric,1,1) id ,
		'insert into dps8_pc12(PurposeCode12
,TypeOfTrans
,Addr1
,Addr2
,Addr3
,City
,statecode
,State
,countrycode
,Country
,PinCode
,PriPhNum
,Fax
,EMailId
,BOId
,TransSystemDate
) values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc12 from dps8_source1 a 
		where left(a.value ,2) = '12' 
		and not exists(SELECT BOID FROM DPS8_PC12 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc12(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc12 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc12 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc12


	end 
	if @pa_level = 16
	begin 

		

		select identity(numeric,1,1) id ,
		'insert into dps8_pc16 values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc16 from dps8_source1 a 
		where left(a.value ,2) = '16' 
		and not exists(SELECT BOID FROM DPS8_PC16 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc16(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc16 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc16 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc16


	end 
	if @pa_level = 17
	begin 

		

		select identity(numeric,1,1) id ,
		'insert into dps8_pc17 values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc17 from dps8_source1 a 
		where left(a.value ,2) = '17' 
		and not exists(SELECT BOID FROM DPS8_PC17 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc17(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc17 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc17 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc17


	end 
	if @pa_level = 18
	begin 

		

		select identity(numeric,1,1) id ,
		'insert into dps8_pc18(PurposeCode18
,TypeOfTrans
,NaSeqNum
,BOName
,Remarks,Namechange
,MOBILE_NO_ISD
,MOBILE_NUMBER
,EMAILID
,uid
,UID_FLAG
,FILLER1
,FILLER2
,FILLER3
,FILLER4
,FILLER5
,BOId
,TransSystemDate
) values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc18 from dps8_source1 a 
		where left(a.value ,2) = '18' 
		and not exists(SELECT BOID FROM DPS8_PC18 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc18(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc18 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc18 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc18


	end 
	if @pa_level = 19
	begin 

		

		select identity(numeric,1,1) id ,
		'insert into dps8_pc19 values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc19 from dps8_source1 a 
		where left(a.value ,2) = '19' 
		and not exists(SELECT BOID FROM DPS8_PC19 b WHERE b.BOID = a.boid)   


		create index ix_1 on #tmpdps8_pc19(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc19

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc19 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc19


	end 
	
	/*added line   23/06/2020*/
	if @pa_level = 22
	begin 

		

		select identity(numeric,1,1) id ,
		'insert into dps8_pc22 values('''+ replace(replace(a.value,'''',''''''),'~',''',''') +''')' insertstr into #tmpdps8_pc22 from dps8_source1 a 
		where left(a.value ,2) = '22' 
		and not exists(SELECT BOID FROM DPS8_PC22 b WHERE b.BOID = a.boid
		and EXCHANGE_ID= citrus_usr.fn_splitval_by(value,5	,'~')
and SEGMENT_CODE= citrus_usr.fn_splitval_by(value,7	,'~')
)   


		create index ix_1 on #tmpdps8_pc22(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc22

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc22 where id = @l_counter
		print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc22


	end 

	/*added line   23/06/2020*/

end

GO
