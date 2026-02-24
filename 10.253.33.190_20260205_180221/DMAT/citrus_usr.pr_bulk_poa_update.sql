-- Object: PROCEDURE citrus_usr.pr_bulk_poa_update
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


--begin tran
--exec pr_bulk_poa_update
--rollback 
--commit
/*
SELECT BOId, MasterPOAId , GPABPAFlg,EffFormDate,HolderNum  FROM dps8_pc5 GROUP BY BOId, MasterPOAId , GPABPAFlg,EffFormDate,HolderNum
HAVING COUNT(1)>1--3657
*/

--select id, count(1) from tempdata123_30012023 group by id having count(1)>1
--select distinct *  from tempdata123_30012023 where id = 2743456 
--select top 1 * from DP_POA_DTLS 


CREATE    proc pr_bulk_poa_update 
as 
begin


--select * into dps8_pc5_bak_300120231 from dps8_pc5  
--SELECT * INTO dp_poa_dtls_BAK30012023 FROM dp_poa_dtls

Select IDENTITY(NUMERIC,1,1) ID , value,boid,lastmoddate,dt into #temp   from dps8_source111_bak_dnd 
where CONVERT (datetime ,  right (substring (lastmoddate,1,8),4)+'-'+substring (substring (lastmoddate,1,8),3,2)+'-'+left (substring (lastmoddate,1,8),2)) >= 'Jan 21 2023' 
and citrus_usr.fn_splitval_by(value,1,'~') ='05'




select boid  cltid, isnull(citrus_usr.fn_splitval_by(value,	3	,'~'),'') mastpoaid  
,max(isnull(lastmoddate,'')) maxmoddt 
,citrus_usr.fn_splitval_by(value,	10	,'~') HOLDER into #maxpoachange
from #temp where  left(value ,2) = '05'  
group by boid 
,citrus_usr.fn_splitval_by(value,	3	,'~')
,citrus_usr.fn_splitval_by(value,	10	,'~')


update a 
set 				PurposeCode5	=	citrus_usr.fn_splitval_by(value,	1	,'~')
,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
,	MasterPOAId	=	citrus_usr.fn_splitval_by(value,	3	,'~')
,	POARegNum	=	citrus_usr.fn_splitval_by(value,	4	,'~')
,	GPABPAFlg	=	citrus_usr.fn_splitval_by(value,	6	,'~')
,	EffFormDate	=	citrus_usr.fn_splitval_by(value,	7	,'~')
,	EffToDate	=	citrus_usr.fn_splitval_by(value,	8	,'~')
,	Remarks	=	citrus_usr.fn_splitval_by(value,	9	,'~')
,	HolderNum	=	citrus_usr.fn_splitval_by(value,	10	,'~')
,	POAStatus	=	citrus_usr.fn_splitval_by(value,	11	,'~')
,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	13	,'~')
from #temp main,DPS8_PC5 a , #maxpoachange c where left(main.value ,2) = '05'   
and a.boid = citrus_usr.fn_splitval_by(value,	12	,'~') and MasterPOAId = citrus_usr.fn_splitval_by(value,	3	,'~')
and SetupDate	=	citrus_usr.fn_splitval_by(value,	5	,'~')
and POARegNum	=	citrus_usr.fn_splitval_by(value,	4	,'~')
and HolderNum	=	citrus_usr.fn_splitval_by(value,	10	,'~')
and c.cltid = a.boid 
and c.maxmoddt = citrus_usr.fn_splitval_by(value,	13	,'~')
and c.mastpoaid = MasterPOAId
AND C.HOLDER =  citrus_usr.fn_splitval_by(value,	10	,'~')
and 	GPABPAFlg	=	citrus_usr.fn_splitval_by(value,	6	,'~')



--select * from #maxpoachange



select identity(numeric,1,1) id ,
		'insert into dps8_pc5 values('''+ replace(replace(a.value+'~'+A.BOID+'~'+isnull(A.lastmoddate,'') ,'''',''''''),'~',''',''') +''')' insertstr 
		into #tmpdps8_pc5 
		from #temp a  , #maxpoachange b 
		where left(a.value ,2) = '05' 
		and not exists(SELECT BOID FROM DPS8_PC5 b WHERE b.BOID = A.BOID 
		and MasterPOAId = citrus_usr.fn_splitval_by(value,	3	,'~')
		and SetupDate	=	citrus_usr.fn_splitval_by(value,	5	,'~')
		and POARegNum	=	citrus_usr.fn_splitval_by(value,	4	,'~')
		and HolderNum	=	citrus_usr.fn_splitval_by(value,	10	,'~')
		and 	GPABPAFlg	=	citrus_usr.fn_splitval_by(value,	6	,'~'))   
        and citrus_usr.fn_splitval_by(a.value ,11,'~') = 'A' 
and b.cltid = A.BOID 
and isnull(b.maxmoddt,'') =isnull(A.lastmoddate,'')
and b.mastpoaid = citrus_usr.fn_splitval_by(value,	3	,'~')
and b.holder = citrus_usr.fn_splitval_by(value,	10	,'~')


declare @l_counter numeric
		,@l_count numeric
		,@l_str varchar(2500)


		create index ix_1 on #tmpdps8_pc5(id)

		

		set @l_counter =1
		set @l_count = 0 
		set @l_str = ''

		select @l_count = count(1) from #tmpdps8_pc5 

		while @l_count  > = @l_counter
		begin

		select @l_str = insertstr from #tmpdps8_pc5 where id = @l_counter
		--print @l_str
		exec(@l_str)
		set @l_counter = @l_counter + 1 

		end 

		drop table #tmpdps8_pc5


declare @l_dppd_max numeric
select @l_dppd_max  = isnull(max(dppd_id ),0) from (select dppd_id from dp_poa_dtls union  select dppd_id from DP_POA_DTLS_MAK ) a  



insert into dp_poa_dtls
select distinct  id+@l_dppd_max id ,dpam_id ,case when HolderNum ='1' then ISNULL(ltrim(rtrim('1ST HOLDER')),'') when HolderNum ='2' then ISNULL(ltrim(rtrim('2ND HOLDER')),'')  else ISNULL(ltrim(rtrim('1ST HOLDER')),'')  end  holdertype
,'' poatype,ISNULL(ltrim(rtrim(dpam_sba_name)),'')  name1
,'' name2,'' name3,'' fthname,'' dob,'' pan,'' gender,'MIG' cb,GETDATE() cd,'MIG' lb,GETDATE() ld, 1 did
,CONVERT(VARCHAR(20),ISNULL(ltrim(rtrim(POARegNum)),''))  POARegNum
,CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(PC5.SetupDate),103))= 1 THEN CONVERT(datetime,CITRUS_USR.FNGETDATE(PC5.SetupDate) ,103) ELSE '' END    SETUP
,ISNULL(ltrim(rtrim(GPABPAFlg)),'')   gpabpa
,CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103))= 1 THEN CONVERT(datetime,CITRUS_USR.FNGETDATE(EffFormDate),103) ELSE '' END EFD 

,CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103))= 1 THEN CONVERT(datetime,CITRUS_USR.FNGETDATE(EffToDate),103) ELSE '' END    etd
,MasterPOAId poam_master_id
-- into tempdata123_30012023 
from dps8_pc5 pc5, #temp t , dp_acct_mstr  DPAM
where pc5.BOId = t.boid and pc5.BOId = DPAM_SBA_no 
and MasterPOAId = citrus_usr.fn_splitval_by(value,	3	,'~')
		and SetupDate	=	citrus_usr.fn_splitval_by(value,	5	,'~')
		and POARegNum	=	citrus_usr.fn_splitval_by(value,	4	,'~')
		and HolderNum	=	citrus_usr.fn_splitval_by(value,	10	,'~')
		and 	GPABPAFlg	=	citrus_usr.fn_splitval_by(value,	6	,'~')
and   not exists(SELECT 1 FROM DP_POA_DTLS  b WHERE b.DPPD_DPAM_ID = DPAM.DPAM_ID 
		and PC5.MasterPOAId = dppd_master_id
		and PC5.SetupDate	=	CASE WHEN ISDATE(CONVERT(datetime,CITRUS_USR.FNGETDATE(PC5.SetupDate),103))= 1 THEN convert(varchar,CONVERT(datetime,CITRUS_USR.FNGETDATE(PC5.SetupDate) ,103),103) ELSE '' END   
		and PC5.POARegNum	=	dppd_poa_id
		and PC5.HolderNum	=	case when HolderNum ='1' then ISNULL(ltrim(rtrim('1ST HOLDER')),'') when HolderNum ='2' then ISNULL(ltrim(rtrim('2ND HOLDER')),'')  else ISNULL(ltrim(rtrim('1ST HOLDER')),'')  end  
		and 	PC5.GPABPAFlg	=	dppd_gpabpa_flg)   

end

GO
