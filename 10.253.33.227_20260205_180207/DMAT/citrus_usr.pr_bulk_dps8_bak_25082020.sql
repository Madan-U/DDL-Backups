-- Object: PROCEDURE citrus_usr.pr_bulk_dps8_bak_25082020
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------




CREATE  proc [citrus_usr].[pr_bulk_dps8_bak_25082020](@pa_dbpath varchar(8000))  
as  
begin   
drop table dps8_source111
DROP TABLE dps8_source10    
DROP TABLE dps8_source1  
truncate table dps8_source  
set dateformat ymd

declare @@SSQL varchar(1000)  
     
SET @@SSQL = 'BULK INSERT vwdps8_source FROM ''' + @pa_dbpath +  ''' WITH      
(      
      
FIELDTERMINATOR=''\n'',      
ROWTERMINATOR = ''\n''        
)'      
      
--PRINT @@SSQL      
EXEC (@@SSQL)    
  

SELECT ID , value 
, convert(varchar(16),case when left(value,2) ='00' then citrus_usr.fn_splitval_by(value,2,'~') else '' end) boid   
, convert(varchar(16),case when left(value,2) ='00' then citrus_usr.fn_splitval_by(value,7,'~') else '' end) lastmoddate   
INTO dps8_source10 
FROM dps8_source order by id     
--alter table dps8_source1 alter column [value] varchar(5000)  
create index ix1 on dps8_source10(id)  
create index ix2 on dps8_source10(value)  
create index ix3 on dps8_source10(boid)  
create index ix4 on dps8_source10(lastmoddate)  


  
  
  
select id, value ,(select top 1 boid from dps8_source10 b where a.id >= b.id and B.boid  <> '' order by id desc) boid   
,(select top 1 lastmoddate from dps8_source10 b where a.id >= b.id and B.lastmoddate  <> '' order by id desc) lastmoddate   
into dps8_source111 from   dps8_source10 a  
where  left(value,1) not in ('H','T')   
order by id   



--
--select id, value , a.boid   
--,a.lastmoddate   
--into dps8_source1 from dps8_source111 a 
--, (
--select boid
--,max(lastmoddate) lastmoddate 
--from dps8_source111  
--group by boid) b
--where a.boid = b.boid 
--and isnull(a.lastmoddate,'') = isnull(b.lastmoddate ,'')
--order by id  


select id, value , a.boid   
,a.lastmoddate   
into dps8_source1
 from dps8_source111 a 
, (
select boid,left(value,2) pcd
--,max(lastmoddate) lastmoddate 
,replace(convert(varchar(11),max(convert(datetime,substring(lastmoddate,5,4)+'-'+substring(lastmoddate,3,2)+'-'+substring(lastmoddate,1,2)+' ' + substring(lastmoddate,9,2)+':'+ substring(lastmoddate,11,2)+':'+substring(lastmoddate,13,2))) ,103) ,'/','')
+replace(CONVERT(VARCHAR(8), max(convert(datetime,substring(lastmoddate,5,4)+'-'+substring(lastmoddate,3,2)+'-'+substring(lastmoddate,1,2)+' ' + substring(lastmoddate,9,2)+':'+ substring(lastmoddate,11,2)+':'+substring(lastmoddate,13,2))) , 108),':','') lastmoddate 
from dps8_source111  
group by boid,left(value,2)) b
where a.boid = b.boid 
and isnull(replace(convert(varchar(11),convert(datetime,substring(a.lastmoddate,5,4)+'-'+substring(a.lastmoddate,3,2)+'-'+substring(a.lastmoddate,1,2)+' ' + substring(a.lastmoddate,9,2)+':'+ substring(a.lastmoddate,11,2)+':'+substring(a.lastmoddate,13,2)) ,103) ,'/','')
+replace(CONVERT(VARCHAR(8), convert(datetime,substring(a.lastmoddate,5,4)+'-'+substring(a.lastmoddate,3,2)+'-'+substring(a.lastmoddate,1,2)+' ' + substring(a.lastmoddate,9,2)+':'+ substring(a.lastmoddate,11,2)+':'+substring(a.lastmoddate,13,2)) , 108),':','') ,'') = isnull(b.lastmoddate ,'')
and pcd = left(value,2)
order by id  

 
  
update dps8_source1 set value =  value  + '~' + boid + '~' where left(dps8_source1.value ,2) <> '00'   
  

  
   
--update dps table for existing data   
update a 
set PurposeCode0 = citrus_usr.fn_splitval_by(value,1,'~')   
,BOId   = citrus_usr.fn_splitval_by(value,2,'~') 
,BusinessDateOfTrans  = citrus_usr.fn_splitval_by(value,3,'~') 
,SourceDP  = citrus_usr.fn_splitval_by(value,4,'~') 
,OperatorId  = citrus_usr.fn_splitval_by(value,5,'~') 
,SourceOfTrans  = citrus_usr.fn_splitval_by(value,6,'~') 
,TransSystemDate   = citrus_usr.fn_splitval_by(value,7,'~') 
from dps8_source1 main,dps8_PC0 a where left(main.value ,2) = '00'   
and a.BOID = main.boid


--update a 
--set 
-- 	PurposeCode1	=	citrus_usr.fn_splitval_by(value,	1	,'~')
--,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
--,	Title	=	citrus_usr.fn_splitval_by(value,	3	,'~')
--,	Name	=	citrus_usr.fn_splitval_by(value,	4	,'~')
--,	MiddleName	=	citrus_usr.fn_splitval_by(value,	5	,'~')
--,	SearchName	=	citrus_usr.fn_splitval_by(value,	6	,'~')
--,	Suffix	=	citrus_usr.fn_splitval_by(value,	7	,'~')
--,	FthName	=	citrus_usr.fn_splitval_by(value,	8	,'~')
--,	Addr1	=	citrus_usr.fn_splitval_by(value,	9	,'~')
--,	Addr2	=	citrus_usr.fn_splitval_by(value,	10	,'~')
--,	Addr3	=	citrus_usr.fn_splitval_by(value,	11	,'~')
--,	City	=	citrus_usr.fn_splitval_by(value,	12	,'~')
--,	State	=	citrus_usr.fn_splitval_by(value,	13	,'~')
--,	Country	=	citrus_usr.fn_splitval_by(value,	14	,'~')
--,	PinCode	=	citrus_usr.fn_splitval_by(value,	15	,'~')
--,	PriPhInd	=	citrus_usr.fn_splitval_by(value,	16	,'~')
--,	PriPhNum	=	citrus_usr.fn_splitval_by(value,	17	,'~')
--,	AltPhInd	=	citrus_usr.fn_splitval_by(value,	18	,'~')
--,	AltPhNum	=	citrus_usr.fn_splitval_by(value,	19	,'~')
--,	AddPh	=	citrus_usr.fn_splitval_by(value,	20	,'~')
--,	Fax	=	citrus_usr.fn_splitval_by(value,	21	,'~')
--,	PANExCode	=	citrus_usr.fn_splitval_by(value,	22	,'~')
--,	PANGIR	=	citrus_usr.fn_splitval_by(value,	23	,'~')
--,	PANVerCode	=	citrus_usr.fn_splitval_by(value,	24	,'~')
--,	ITCircle	=	citrus_usr.fn_splitval_by(value,	25	,'~')
--,	EMailId	=	citrus_usr.fn_splitval_by(value,	26	,'~')
--,	UsrTxt1	=	citrus_usr.fn_splitval_by(value,	27	,'~')
--,	UsrTxt2	=	citrus_usr.fn_splitval_by(value,	28	,'~')
--,	UsrFld3	=	citrus_usr.fn_splitval_by(value,	29	,'~')
--,	BOAcctStatus	=	citrus_usr.fn_splitval_by(value,	30	,'~')
--,	FrzSusFlg	=	citrus_usr.fn_splitval_by(value,	31	,'~')
--,	BOCategory	=	citrus_usr.fn_splitval_by(value,	32	,'~')
--,	BOCustType	=	citrus_usr.fn_splitval_by(value,	33	,'~')
--,	BOSubStatus	=	citrus_usr.fn_splitval_by(value,	34	,'~')
--,	ProdCode	=	citrus_usr.fn_splitval_by(value,	35	,'~')
--,	ClCorpId	=	citrus_usr.fn_splitval_by(value,	36	,'~')
--,	ClMemId	=	citrus_usr.fn_splitval_by(value,	37	,'~')
--,	StockExch	=	citrus_usr.fn_splitval_by(value,	38	,'~')
--,	TradingId	=	citrus_usr.fn_splitval_by(value,	39	,'~')
--,	BOStatCycleCd	=	citrus_usr.fn_splitval_by(value,	40	,'~')
--,	AcctCreatDt	=	citrus_usr.fn_splitval_by(value,	41	,'~')
--,	DPIntRefNum	=	citrus_usr.fn_splitval_by(value,	42	,'~')
--,	ConfWaived	=	citrus_usr.fn_splitval_by(value,	43	,'~')
--,	DateOfBirth	=	citrus_usr.fn_splitval_by(value,	44	,'~')
--,	BOActDt	=	citrus_usr.fn_splitval_by(value,	45	,'~')
--,	EletConf	=	citrus_usr.fn_splitval_by(value,	46	,'~')
--,	ECS	=	citrus_usr.fn_splitval_by(value,	47	,'~')
--,	DivBankAcctNo	=	citrus_usr.fn_splitval_by(value,	48	,'~')
--,	DivBankCd	=	citrus_usr.fn_splitval_by(value,	49	,'~')
--,	DivIFScd	=	citrus_usr.fn_splitval_by(value,	50	,'~')
--,	DivBankCurr	=	citrus_usr.fn_splitval_by(value,	51	,'~')
--,	DivAcctType	=	citrus_usr.fn_splitval_by(value,	52	,'~')
--,	AnnIncomeCd	=	citrus_usr.fn_splitval_by(value,	53	,'~')
--,	BenTaxDedStat	=	citrus_usr.fn_splitval_by(value,	54	,'~')
--,	BOSettPlanFlg	=	citrus_usr.fn_splitval_by(value,	55	,'~')
--,	Edu	=	citrus_usr.fn_splitval_by(value,	56	,'~')
--,	GeogCd	=	citrus_usr.fn_splitval_by(value,	57	,'~')
--,	GroupCd	=	citrus_usr.fn_splitval_by(value,	58	,'~')
--,	LangCd	=	citrus_usr.fn_splitval_by(value,	59	,'~')
--,	NatCd	=	citrus_usr.fn_splitval_by(value,	60	,'~')
--,	Occupation	=	citrus_usr.fn_splitval_by(value,	61	,'~')
--,	SecAccCd	=	citrus_usr.fn_splitval_by(value,	62	,'~')
--,	SexCd	=	citrus_usr.fn_splitval_by(value,	63	,'~')
--,	Staff	=	citrus_usr.fn_splitval_by(value,	64	,'~')
--,	StaffCd	=	citrus_usr.fn_splitval_by(value,	65	,'~')
--,	RBIRefNum	=	citrus_usr.fn_splitval_by(value,	66	,'~')
--,	RBIAppDt	=	citrus_usr.fn_splitval_by(value,	67	,'~')
--,	SEBIRegNum	=	citrus_usr.fn_splitval_by(value,	68	,'~')
--,	ClosAppDt	=	citrus_usr.fn_splitval_by(value,	69	,'~')
--,	ClosDt	=	citrus_usr.fn_splitval_by(value,	70	,'~')
--,	TransBOId	=	citrus_usr.fn_splitval_by(value,	71	,'~')
--,	BalTrans	=	citrus_usr.fn_splitval_by(value,	72	,'~')
--,	ClosResCd	=	citrus_usr.fn_splitval_by(value,	73	,'~')
--,	ClosInitBy	=	citrus_usr.fn_splitval_by(value,	74	,'~')
--,	ClosRemark	=	citrus_usr.fn_splitval_by(value,	75	,'~')
--,	UnqIdenNum	=	citrus_usr.fn_splitval_by(value,	76	,'~')
--,	Filler1	=	citrus_usr.fn_splitval_by(value,	77	,'~')
--,	Filler2	=	citrus_usr.fn_splitval_by(value,	78	,'~')
--,	Filler3	=	citrus_usr.fn_splitval_by(value,	79	,'~')
--,	Filler4	=	citrus_usr.fn_splitval_by(value,	80	,'~')
--,	Filler5	=	citrus_usr.fn_splitval_by(value,	81	,'~')
--,	AnnlRep	=	citrus_usr.fn_splitval_by(value,	82	,'~')
--,	Filler6	=	citrus_usr.fn_splitval_by(value,	83	,'~')
--,	Filler7	=	citrus_usr.fn_splitval_by(value,	84	,'~')
--,	Filler8	=	citrus_usr.fn_splitval_by(value,	85	,'~')
--,	Filler9	=	citrus_usr.fn_splitval_by(value,	86	,'~')
--,mSTRPOAFLG =citrus_usr.fn_splitval_by(value,	87	,'~')
--,FAMILYACCTFLG=citrus_usr.fn_splitval_by(value,	88	,'~')
--,CUSTODIANEMAILID=citrus_usr.fn_splitval_by(value,	89	,'~')
--,AFILLER1=citrus_usr.fn_splitval_by(value,	90	,'~')
--,AFILLER2=citrus_usr.fn_splitval_by(value,	91	,'~')
--,AFILLER3=citrus_usr.fn_splitval_by(value,	92	,'~')
--,AFILLER4=citrus_usr.fn_splitval_by(value,	93	,'~')
--,AFILLER5=citrus_usr.fn_splitval_by(value,	94	,'~')
--,	BOId	=	citrus_usr.fn_splitval_by(value,	95	,'~')
--,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	96	,'~')
--from dps8_source1 main,DPS8_PC1 a  where left(main.value ,2) = '01'   
--and a.BOID =main.boid



update a 
set 
 	PurposeCode1	=citrus_usr.fn_splitval_by(value,	1	,'~'),
TypeOfTrans	=citrus_usr.fn_splitval_by(value,	2	,'~'),
Title	=citrus_usr.fn_splitval_by(value,	3	,'~'),
Name	=citrus_usr.fn_splitval_by(value,	4	,'~'),
MiddleName	=citrus_usr.fn_splitval_by(value,	5	,'~'),
SearchName	=citrus_usr.fn_splitval_by(value,	6	,'~'),
Suffix	=citrus_usr.fn_splitval_by(value,	7	,'~'),
FthName	=citrus_usr.fn_splitval_by(value,	8	,'~'),
Addr1	=citrus_usr.fn_splitval_by(value,	9	,'~'),
Addr2	=citrus_usr.fn_splitval_by(value,	10	,'~'),
Addr3	=citrus_usr.fn_splitval_by(value,	11	,'~'),
City	=citrus_usr.fn_splitval_by(value,	12	,'~'),
statecode	=citrus_usr.fn_splitval_by(value,	13	,'~'),
State	=citrus_usr.fn_splitval_by(value,	14	,'~'),
countrycode	=citrus_usr.fn_splitval_by(value,	15	,'~'),
Country	=citrus_usr.fn_splitval_by(value,	16	,'~'),
PinCode	=citrus_usr.fn_splitval_by(value,	17	,'~'),
smart_flag	=citrus_usr.fn_splitval_by(value,	18	,'~'),
isd_pri	=citrus_usr.fn_splitval_by(value,	19	,'~'),
PriPhNum	=citrus_usr.fn_splitval_by(value,	20	,'~'),
isd_sec	=citrus_usr.fn_splitval_by(value,	21	,'~'),
AltPhNum	=citrus_usr.fn_splitval_by(value,	22	,'~'),
pri_email	=citrus_usr.fn_splitval_by(value,	23	,'~'),
Fax	=citrus_usr.fn_splitval_by(value,	24	,'~'),
PANExCode	=citrus_usr.fn_splitval_by(value,	25	,'~'),
PANGIR	=citrus_usr.fn_splitval_by(value,	26	,'~'),
PANVerCode	=citrus_usr.fn_splitval_by(value,	27	,'~'),
ITCircle	=citrus_usr.fn_splitval_by(value,	28	,'~'),
sec_email	=citrus_usr.fn_splitval_by(value,	29	,'~'),
UsrTxt1	=citrus_usr.fn_splitval_by(value,	30	,'~'),
UsrTxt2	=citrus_usr.fn_splitval_by(value,	31	,'~'),
UsrFld3	=citrus_usr.fn_splitval_by(value,	32	,'~'),
BOAcctStatus	=citrus_usr.fn_splitval_by(value,	33	,'~'),
FrzSusFlg	=citrus_usr.fn_splitval_by(value,	34	,'~'),
BOCategory	=citrus_usr.fn_splitval_by(value,	35	,'~'),
BOCustType	=citrus_usr.fn_splitval_by(value,	36	,'~'),
BOSubStatus	=citrus_usr.fn_splitval_by(value,	37	,'~'),
ProdCode	=citrus_usr.fn_splitval_by(value,	38	,'~'),
ClCorpId	=citrus_usr.fn_splitval_by(value,	39	,'~'),
ClMemId	=citrus_usr.fn_splitval_by(value,	40	,'~'),
StockExch	=citrus_usr.fn_splitval_by(value,	41	,'~'),
TradingId	=citrus_usr.fn_splitval_by(value,	42	,'~'),
BOStatCycleCd	=citrus_usr.fn_splitval_by(value,	43	,'~'),
AcctCreatDt	=citrus_usr.fn_splitval_by(value,	44	,'~'),
DPIntRefNum	=citrus_usr.fn_splitval_by(value,	45	,'~'),
ConfWaived	=citrus_usr.fn_splitval_by(value,	46	,'~'),
DateOfBirth	=citrus_usr.fn_splitval_by(value,	47	,'~'),
BOActDt	=citrus_usr.fn_splitval_by(value,	48	,'~'),
EletConf	=citrus_usr.fn_splitval_by(value,	49	,'~'),
ECS	=citrus_usr.fn_splitval_by(value,	50	,'~'),
DivBankAcctNo	=citrus_usr.fn_splitval_by(value,	51	,'~'),
DivBankCd	=citrus_usr.fn_splitval_by(value,	52	,'~'),
DivIFScd	=citrus_usr.fn_splitval_by(value,	53	,'~'),
DivBankCurr	=citrus_usr.fn_splitval_by(value,	54	,'~'),
DivAcctType	=citrus_usr.fn_splitval_by(value,	55	,'~'),
AnnIncomeCd	=citrus_usr.fn_splitval_by(value,	56	,'~'),
BenTaxDedStat	=citrus_usr.fn_splitval_by(value,	57	,'~'),
BOSettPlanFlg	=citrus_usr.fn_splitval_by(value,	58	,'~'),
Edu	=citrus_usr.fn_splitval_by(value,	59	,'~'),
GeogCd	=citrus_usr.fn_splitval_by(value,	60	,'~'),
GroupCd	=citrus_usr.fn_splitval_by(value,	61	,'~'),
LangCd	=citrus_usr.fn_splitval_by(value,	62	,'~'),
NatCd	=citrus_usr.fn_splitval_by(value,	63	,'~'),
Occupation	=citrus_usr.fn_splitval_by(value,	64	,'~'),
SecAccCd	=citrus_usr.fn_splitval_by(value,	65	,'~'),
SexCd	=citrus_usr.fn_splitval_by(value,	66	,'~'),
Staff	=citrus_usr.fn_splitval_by(value,	67	,'~'),
StaffCd	=citrus_usr.fn_splitval_by(value,	68	,'~'),
RBIRefNum	=citrus_usr.fn_splitval_by(value,	69	,'~'),
RBIAppDt	=citrus_usr.fn_splitval_by(value,	70	,'~'),
SEBIRegNum	=citrus_usr.fn_splitval_by(value,	71	,'~'),
ClosAppDt	=citrus_usr.fn_splitval_by(value,	72	,'~'),
ClosDt	=citrus_usr.fn_splitval_by(value,	73	,'~'),
TransBOId	=citrus_usr.fn_splitval_by(value,	74	,'~'),
BalTrans	=citrus_usr.fn_splitval_by(value,	75	,'~'),
ClosResCd	=citrus_usr.fn_splitval_by(value,	76	,'~'),
ClosInitBy	=citrus_usr.fn_splitval_by(value,	77	,'~'),
ClosRemark	=citrus_usr.fn_splitval_by(value,	78	,'~'),
UnqIdenNum	=citrus_usr.fn_splitval_by(value,	79	,'~'),
Filler1	=citrus_usr.fn_splitval_by(value,	80	,'~'),
Filler2	=citrus_usr.fn_splitval_by(value,	81	,'~'),
Filler3	=citrus_usr.fn_splitval_by(value,	82	,'~'),
Filler4	=citrus_usr.fn_splitval_by(value,	83	,'~'),
Filler5	=citrus_usr.fn_splitval_by(value,	84	,'~'),
AnnlRep	=citrus_usr.fn_splitval_by(value,	85	,'~'),
Filler6	=citrus_usr.fn_splitval_by(value,	86	,'~'),
Filler7	=citrus_usr.fn_splitval_by(value,	87	,'~'),
Filler8	=citrus_usr.fn_splitval_by(value,	88	,'~'),
Filler9	=citrus_usr.fn_splitval_by(value,	89	,'~'),
mSTRPOAFLG	=citrus_usr.fn_splitval_by(value,	90	,'~'),
FAMILYACCTFLG	=citrus_usr.fn_splitval_by(value,	91	,'~'),
CUSTODIANEMAILID	=citrus_usr.fn_splitval_by(value,	92	,'~'),
AFILLER1	=citrus_usr.fn_splitval_by(value,	93	,'~'),
AFILLER6	=citrus_usr.fn_splitval_by(value,	94	,'~'),
AFILLER7	=citrus_usr.fn_splitval_by(value,	95	,'~'),
AFILLER8	=citrus_usr.fn_splitval_by(value,	96	,'~'),
AFILLER9	=citrus_usr.fn_splitval_by(value,	97	,'~'),
AFILLER10	=citrus_usr.fn_splitval_by(value,	98	,'~'),
AFILLER2	=citrus_usr.fn_splitval_by(value,	99	,'~'),
AFILLER3	=citrus_usr.fn_splitval_by(value,	100	,'~'),
AFILLER4	=citrus_usr.fn_splitval_by(value,	101	,'~'),
AFILLER5	=citrus_usr.fn_splitval_by(value,	102	,'~'),
BOId	=citrus_usr.fn_splitval_by(value,	103	,'~'),
TransSystemDate	=citrus_usr.fn_splitval_by(value,	104	,'~')
from dps8_source1 main,DPS8_PC1 a  where left(main.value ,2) = '01'   
and a.BOID =main.boid





--update a 
--set 	PurposeCode2	=	citrus_usr.fn_splitval_by(value,	1	,'~')
--,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
--,	Title	=	citrus_usr.fn_splitval_by(value,	3	,'~')
--,	Name	=	citrus_usr.fn_splitval_by(value,	4	,'~')
--,	MiddleName	=	citrus_usr.fn_splitval_by(value,	5	,'~')
--,	SearchName	=	citrus_usr.fn_splitval_by(value,	6	,'~')
--,	Suffix	=	citrus_usr.fn_splitval_by(value,	7	,'~')
--,	FthName	=	citrus_usr.fn_splitval_by(value,	8	,'~')
--,	PANExCd	=	citrus_usr.fn_splitval_by(value,	9	,'~')
--,	PANGIR	=	citrus_usr.fn_splitval_by(value,	10	,'~')
--,	PANVerCd	=	citrus_usr.fn_splitval_by(value,	11	,'~')
--,	ITCircle	=	citrus_usr.fn_splitval_by(value,	12	,'~')
--,	Addr1	=	citrus_usr.fn_splitval_by(value,	13	,'~')
--,	Addr2	=	citrus_usr.fn_splitval_by(value,	14	,'~')
--,	Addr3	=	citrus_usr.fn_splitval_by(value,	15	,'~')
--,	City	=	citrus_usr.fn_splitval_by(value,	16	,'~')
--,	State	=	citrus_usr.fn_splitval_by(value,	17	,'~')
--,	Country	=	citrus_usr.fn_splitval_by(value,	18	,'~')
--,	PinCode	=	citrus_usr.fn_splitval_by(value,	19	,'~')
--,	DateofSetup	=	citrus_usr.fn_splitval_by(value,	20	,'~')
--,	DateofBirth	=	citrus_usr.fn_splitval_by(value,	21	,'~')
--,	Email	=	citrus_usr.fn_splitval_by(value,	22	,'~')
--,	UniqueId	=	citrus_usr.fn_splitval_by(value,	23	,'~')
--,	Filler1	=	citrus_usr.fn_splitval_by(value,	24	,'~')
--,	Filler2	=	citrus_usr.fn_splitval_by(value,	25	,'~')
--,	Filler3	=	citrus_usr.fn_splitval_by(value,	26	,'~')
--,	Filler4	=	citrus_usr.fn_splitval_by(value,	27	,'~')
--,	Filler5	=	citrus_usr.fn_splitval_by(value,	28	,'~')
--,	Filler6	=	citrus_usr.fn_splitval_by(value,	29	,'~')
--,	Filler7	=	citrus_usr.fn_splitval_by(value,	30	,'~')
--,	Filler8	=	citrus_usr.fn_splitval_by(value,	31	,'~')
--,	Filler9	=	citrus_usr.fn_splitval_by(value,	32	,'~')
----,	Filler10	=	citrus_usr.fn_splitval_by(value,	33	,'~')
--,	BOId	=	citrus_usr.fn_splitval_by(value,	34	,'~')
--,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	35	,'~')

--from dps8_source1 main,DPS8_PC2 a  where left(main.value ,2) = '02'   
--and a.BOID =  main.boid



update a 
set 	PurposeCode2	=citrus_usr.fn_splitval_by(value,	1	,'~'),
TypeOfTrans	=citrus_usr.fn_splitval_by(value,	2	,'~'),
Title	=citrus_usr.fn_splitval_by(value,	3	,'~'),
Name	=citrus_usr.fn_splitval_by(value,	4	,'~'),
MiddleName	=citrus_usr.fn_splitval_by(value,	5	,'~'),
SearchName	=citrus_usr.fn_splitval_by(value,	6	,'~'),
Suffix	=citrus_usr.fn_splitval_by(value,	7	,'~'),
FthName	=citrus_usr.fn_splitval_by(value,	8	,'~'),
PANExCd	=citrus_usr.fn_splitval_by(value,	9	,'~'),
PANGIR	=citrus_usr.fn_splitval_by(value,	10	,'~'),
PANVerCd	=citrus_usr.fn_splitval_by(value,	11	,'~'),
ITCircle	=citrus_usr.fn_splitval_by(value,	12	,'~'),
Addr1	=citrus_usr.fn_splitval_by(value,	13	,'~'),
Addr2	=citrus_usr.fn_splitval_by(value,	14	,'~'),
Addr3	=citrus_usr.fn_splitval_by(value,	15	,'~'),
City	=citrus_usr.fn_splitval_by(value,	16	,'~'),
State	=citrus_usr.fn_splitval_by(value,	17	,'~'),
Country	=citrus_usr.fn_splitval_by(value,	18	,'~'),
PinCode	=citrus_usr.fn_splitval_by(value,	19	,'~'),
DateofSetup	=citrus_usr.fn_splitval_by(value,	20	,'~'),
DateofBirth	=citrus_usr.fn_splitval_by(value,	21	,'~'),
Email	=citrus_usr.fn_splitval_by(value,	22	,'~'),
UniqueId	=citrus_usr.fn_splitval_by(value,	23	,'~'),
Filler1	=citrus_usr.fn_splitval_by(value,	24	,'~'),
pri_isd	=citrus_usr.fn_splitval_by(value,	25	,'~'),
pri_ph_no	=citrus_usr.fn_splitval_by(value,	26	,'~'),
Filler2	=citrus_usr.fn_splitval_by(value,	27	,'~'),
Filler11	=citrus_usr.fn_splitval_by(value,	28	,'~'),
Filler12	=citrus_usr.fn_splitval_by(value,	29	,'~'),
Filler13	=citrus_usr.fn_splitval_by(value,	30	,'~'),
Filler14	=citrus_usr.fn_splitval_by(value,	31	,'~'),
Filler15	=citrus_usr.fn_splitval_by(value,	32	,'~'),
Filler3	=citrus_usr.fn_splitval_by(value,	33	,'~'),
Filler4	=citrus_usr.fn_splitval_by(value,	34	,'~'),
Filler5	=citrus_usr.fn_splitval_by(value,	35	,'~'),
Filler6	=citrus_usr.fn_splitval_by(value,	36	,'~'),
Filler7	=citrus_usr.fn_splitval_by(value,	37	,'~'),
Filler8	=citrus_usr.fn_splitval_by(value,	38	,'~'),
Filler9	=citrus_usr.fn_splitval_by(value,	39	,'~'),
BOId	=citrus_usr.fn_splitval_by(value,	40	,'~'),
TransSystemDate	=citrus_usr.fn_splitval_by(value,	41	,'~')
from dps8_source1 main,DPS8_PC2 a  where left(main.value ,2) = '02'   
and a.BOID =  main.boid



--update a 
--set 		PurposeCode3	=	citrus_usr.fn_splitval_by(value,	1	,'~')
--,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
--,	Title	=	citrus_usr.fn_splitval_by(value,	3	,'~')
--,	Name	=	citrus_usr.fn_splitval_by(value,	4	,'~')
--,	MiddleName	=	citrus_usr.fn_splitval_by(value,	5	,'~')
--,	SearchName	=	citrus_usr.fn_splitval_by(value,	6	,'~')
--,	Suffix	=	citrus_usr.fn_splitval_by(value,	7	,'~')
--,	FthName	=	citrus_usr.fn_splitval_by(value,	8	,'~')
--,	PANExCd	=	citrus_usr.fn_splitval_by(value,	9	,'~')
--,	PANGIR	=	citrus_usr.fn_splitval_by(value,	10	,'~')
--,	PANVerCd	=	citrus_usr.fn_splitval_by(value,	11	,'~')
--,	ITCircle	=	citrus_usr.fn_splitval_by(value,	12	,'~')
--,	Addr1	=	citrus_usr.fn_splitval_by(value,	13	,'~')
--,	Addr2	=	citrus_usr.fn_splitval_by(value,	14	,'~')
--,	Addr3	=	citrus_usr.fn_splitval_by(value,	15	,'~')
--,	City	=	citrus_usr.fn_splitval_by(value,	16	,'~')
--,	State	=	citrus_usr.fn_splitval_by(value,	17	,'~')
--,	Country	=	citrus_usr.fn_splitval_by(value,	18	,'~')
--,	PinCode	=	citrus_usr.fn_splitval_by(value,	19	,'~')
--,	DateofSetup	=	citrus_usr.fn_splitval_by(value,	20	,'~')
--,	DateofBirth	=	citrus_usr.fn_splitval_by(value,	21	,'~')
--,	Email	=	citrus_usr.fn_splitval_by(value,	22	,'~')
--,	UniqueId	=	citrus_usr.fn_splitval_by(value,	23	,'~')
--,	Filler1	=	citrus_usr.fn_splitval_by(value,	24	,'~')
--,	Filler2	=	citrus_usr.fn_splitval_by(value,	25	,'~')
--,	Filler3	=	citrus_usr.fn_splitval_by(value,	26	,'~')
--,	Filler4	=	citrus_usr.fn_splitval_by(value,	27	,'~')
--,	Filler5	=	citrus_usr.fn_splitval_by(value,	28	,'~')
--,	Filler6	=	citrus_usr.fn_splitval_by(value,	29	,'~')
--,	Filler7	=	citrus_usr.fn_splitval_by(value,	30	,'~')
--,	Filler8	=	citrus_usr.fn_splitval_by(value,	31	,'~')
--,	Filler9	=	citrus_usr.fn_splitval_by(value,	32	,'~')
----,	Filler10	=	citrus_usr.fn_splitval_by(value,	33	,'~')
--,	BOId	=	citrus_usr.fn_splitval_by(value,	34	,'~')
--,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	35	,'~')
--from dps8_source1 main,DPS8_PC3 a  where left(main.value ,2) = '03'   
--and a.boid = main.BOID 



update a 
set 		
PurposeCode3	=citrus_usr.fn_splitval_by(value,	1	,'~'),
TypeOfTrans	=citrus_usr.fn_splitval_by(value,	2	,'~'),
Title	=citrus_usr.fn_splitval_by(value,	3	,'~'),
Name	=citrus_usr.fn_splitval_by(value,	4	,'~'),
MiddleName	=citrus_usr.fn_splitval_by(value,	5	,'~'),
SearchName	=citrus_usr.fn_splitval_by(value,	6	,'~'),
Suffix	=citrus_usr.fn_splitval_by(value,	7	,'~'),
FthName	=citrus_usr.fn_splitval_by(value,	8	,'~'),
PANExCd	=citrus_usr.fn_splitval_by(value,	9	,'~'),
PANGIR	=citrus_usr.fn_splitval_by(value,	10	,'~'),
PANVerCd	=citrus_usr.fn_splitval_by(value,	11	,'~'),
ITCircle	=citrus_usr.fn_splitval_by(value,	12	,'~'),
Addr1	=citrus_usr.fn_splitval_by(value,	13	,'~'),
Addr2	=citrus_usr.fn_splitval_by(value,	14	,'~'),
Addr3	=citrus_usr.fn_splitval_by(value,	15	,'~'),
City	=citrus_usr.fn_splitval_by(value,	16	,'~'),
State	=citrus_usr.fn_splitval_by(value,	17	,'~'),
Country	=citrus_usr.fn_splitval_by(value,	18	,'~'),
PinCode	=citrus_usr.fn_splitval_by(value,	19	,'~'),
DateofSetup	=citrus_usr.fn_splitval_by(value,	20	,'~'),
DateofBirth	=citrus_usr.fn_splitval_by(value,	21	,'~'),
Email	=citrus_usr.fn_splitval_by(value,	22	,'~'),
UniqueId	=citrus_usr.fn_splitval_by(value,	23	,'~'),
Filler1	=citrus_usr.fn_splitval_by(value,	24	,'~'),
pri_isd	=citrus_usr.fn_splitval_by(value,	25	,'~'),
pri_ph_no	=citrus_usr.fn_splitval_by(value,	26	,'~'),
Filler2	=citrus_usr.fn_splitval_by(value,	27	,'~'),
Filler11	=citrus_usr.fn_splitval_by(value,	28	,'~'),
Filler12	=citrus_usr.fn_splitval_by(value,	29	,'~'),
Filler13	=citrus_usr.fn_splitval_by(value,	30	,'~'),
Filler14	=citrus_usr.fn_splitval_by(value,	31	,'~'),
Filler15	=citrus_usr.fn_splitval_by(value,	32	,'~'),
Filler3	=citrus_usr.fn_splitval_by(value,	33	,'~'),
Filler4	=citrus_usr.fn_splitval_by(value,	34	,'~'),
Filler5	=citrus_usr.fn_splitval_by(value,	35	,'~'),
Filler6	=citrus_usr.fn_splitval_by(value,	36	,'~'),
Filler7	=citrus_usr.fn_splitval_by(value,	37	,'~'),
Filler8	=citrus_usr.fn_splitval_by(value,	38	,'~'),
Filler9	=citrus_usr.fn_splitval_by(value,	39	,'~'),
BOId	=citrus_usr.fn_splitval_by(value,	40	,'~'),
TransSystemDate	=citrus_usr.fn_splitval_by(value,	41	,'~')

from dps8_source1 main,DPS8_PC3 a  where left(main.value ,2) = '03'   
and a.boid = main.BOID 


update a 
set 			PurposeCode4	=	citrus_usr.fn_splitval_by(value,	1	,'~')
,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
,	FreezeId	=	citrus_usr.fn_splitval_by(value,	3	,'~')
,	FreezeIniDt	=	citrus_usr.fn_splitval_by(value,	4	,'~')
,	FreezeActDt	=	citrus_usr.fn_splitval_by(value,	5	,'~')
,	FreezeExpDt	=	citrus_usr.fn_splitval_by(value,	6	,'~')
,	FreezeIniBy	=	citrus_usr.fn_splitval_by(value,	7	,'~')
,	FrozenFor	=	citrus_usr.fn_splitval_by(value,	8	,'~')
,	FreezeResCd	=	citrus_usr.fn_splitval_by(value,	9	,'~')
,	FreezeStatus	=	citrus_usr.fn_splitval_by(value,	10	,'~')
,	FreezeActType	=	citrus_usr.fn_splitval_by(value,	11	,'~')
,	FreezeSubOpt	=	citrus_usr.fn_splitval_by(value,	12	,'~')
,	FreezeRmks	=	citrus_usr.fn_splitval_by(value,	13	,'~')
,	BOId	=	citrus_usr.fn_splitval_by(value,	14	,'~')
,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	15	,'~')
from dps8_source1 main,DPS8_PC4 a  where left(main.value ,2) = '04'   
and a.boid = main.BOID 


select citrus_usr.fn_splitval_by(value,	12	,'~') cltid,citrus_usr.fn_splitval_by(value,	3	,'~') mastpoaid  
,max(citrus_usr.fn_splitval_by(value,	13	,'~')) maxmoddt 
,citrus_usr.fn_splitval_by(value,	10	,'~') HOLDER into #maxpoachange
from dpb9_source1 where  left(value ,2) = '05'  
group by citrus_usr.fn_splitval_by(value,	12	,'~') 
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
from dpb9_source1 main,DPS8_PC5 a , #maxpoachange c where left(main.value ,2) = '05'   
and a.boid = citrus_usr.fn_splitval_by(value,	12	,'~') and MasterPOAId = citrus_usr.fn_splitval_by(value,	3	,'~')
and SetupDate	=	citrus_usr.fn_splitval_by(value,	5	,'~')
and POARegNum	=	citrus_usr.fn_splitval_by(value,	4	,'~')
and HolderNum	=	citrus_usr.fn_splitval_by(value,	10	,'~')
and c.cltid = a.boid 
and c.maxmoddt = citrus_usr.fn_splitval_by(value,	13	,'~')
and c.mastpoaid = MasterPOAId
AND C.HOLDER =  citrus_usr.fn_splitval_by(value,	10	,'~')


--
--update a 
--set 				PurposeCode5	=	citrus_usr.fn_splitval_by(value,	1	,'~')
--,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
--,	MasterPOAId	=	citrus_usr.fn_splitval_by(value,	3	,'~')
--,	POARegNum	=	citrus_usr.fn_splitval_by(value,	4	,'~')
--,	GPABPAFlg	=	citrus_usr.fn_splitval_by(value,	6	,'~')
--,	EffFormDate	=	citrus_usr.fn_splitval_by(value,	7	,'~')
--,	EffToDate	=	citrus_usr.fn_splitval_by(value,	8	,'~')
--,	Remarks	=	citrus_usr.fn_splitval_by(value,	9	,'~')
--,	HolderNum	=	citrus_usr.fn_splitval_by(value,	10	,'~')
--,	POAStatus	=	citrus_usr.fn_splitval_by(value,	11	,'~')
--,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	13	,'~')
--from dps8_source1 main,DPS8_PC5 a  where left(main.value ,2) = '05'   
--and a.boid = main.BOID and MasterPOAId = citrus_usr.fn_splitval_by(value,	3	,'~')
--and SetupDate	=	citrus_usr.fn_splitval_by(value,	5	,'~')
--and POARegNum	=	citrus_usr.fn_splitval_by(value,	4	,'~')
--and HolderNum	=	citrus_usr.fn_splitval_by(value,	10	,'~')




--update a 
--set 	PurposeCode6	=	citrus_usr.fn_splitval_by(value,	1	,'~')
--,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
--,	Title	=	citrus_usr.fn_splitval_by(value,	3	,'~')
--,	Name	=	citrus_usr.fn_splitval_by(value,	4	,'~')
--,	MiddleName	=	citrus_usr.fn_splitval_by(value,	5	,'~')
--,	SearchName	=	citrus_usr.fn_splitval_by(value,	6	,'~')
--,	Suffix	=	citrus_usr.fn_splitval_by(value,	7	,'~')
--,	FthName	=	citrus_usr.fn_splitval_by(value,	8	,'~')
--,	Addr1	=	citrus_usr.fn_splitval_by(value,	9	,'~')
--,	Addr2	=	citrus_usr.fn_splitval_by(value,	10	,'~')
--,	Addr3	=	citrus_usr.fn_splitval_by(value,	11	,'~')
--,	City	=	citrus_usr.fn_splitval_by(value,	12	,'~')
--,	State	=	citrus_usr.fn_splitval_by(value,	13	,'~')
--,	Country	=	citrus_usr.fn_splitval_by(value,	14	,'~')
--,	PinCode	=	citrus_usr.fn_splitval_by(value,	15	,'~')
--,	PriPhInd	=	citrus_usr.fn_splitval_by(value,	16	,'~')
--,	PriPhNum	=	citrus_usr.fn_splitval_by(value,	17	,'~')
--,	AltPhInd	=	citrus_usr.fn_splitval_by(value,	18	,'~')
--,	AltPhNum	=	citrus_usr.fn_splitval_by(value,	19	,'~')
--,	AddPhones	=	citrus_usr.fn_splitval_by(value,	20	,'~')
--,	Fax	=	citrus_usr.fn_splitval_by(value,	21	,'~')
--,	PANGIR	=	citrus_usr.fn_splitval_by(value,	22	,'~')
--,	ItCircle	=	citrus_usr.fn_splitval_by(value,	23	,'~')
--,	EMailid	=	citrus_usr.fn_splitval_by(value,	24	,'~')
--,	DateOfSetup	=	citrus_usr.fn_splitval_by(value,	25	,'~')
--,	DateOfBirth	=	citrus_usr.fn_splitval_by(value,	26	,'~')
--,	UsrTxt1	=	citrus_usr.fn_splitval_by(value,	27	,'~')
--,	UsrTxt2	=	citrus_usr.fn_splitval_by(value,	28	,'~')
--,	UsrFld3	=	citrus_usr.fn_splitval_by(value,	29	,'~')
--,	Email	=	citrus_usr.fn_splitval_by(value,	30	,'~')
--,	UnqIdNum	=	citrus_usr.fn_splitval_by(value,	31	,'~')
--,	Filler1	=	citrus_usr.fn_splitval_by(value,	32	,'~')
--,	Filler2	=	citrus_usr.fn_splitval_by(value,	33	,'~')
--,	Filler3	=	citrus_usr.fn_splitval_by(value,	34	,'~')
--,	Filler4	=	citrus_usr.fn_splitval_by(value,	35	,'~')
--,	Filler5	=	citrus_usr.fn_splitval_by(value,	36	,'~')
--,	Filler6	=	citrus_usr.fn_splitval_by(value,	37	,'~')
--,	Filler7	=	citrus_usr.fn_splitval_by(value,	38	,'~')
--,	Filler8	=	citrus_usr.fn_splitval_by(value,	39	,'~')
--,	Filler9	=	citrus_usr.fn_splitval_by(value,	40	,'~')
--,	Filler10	=	citrus_usr.fn_splitval_by(value,	41	,'~')
----,	BOId	=	citrus_usr.fn_splitval_by(value,	42	,'~')
----,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	43	,'~')
--,	BOId	=	citrus_usr.fn_splitval_by(value,	46	,'~')
--,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	47	,'~')
--,   RES_SEC_FLg=	citrus_usr.fn_splitval_by(value,	42	,'~')
--,   NOM_Sr_No=	citrus_usr.fn_splitval_by(value,	43	,'~')
--,   rel_WITH_BO=	citrus_usr.fn_splitval_by(value,	44	,'~')
--,   perc_OF_SHARES=	citrus_usr.fn_splitval_by(value,	45	,'~')
--from dps8_source1 main,DPS8_PC6 a  where left(main.value ,2) = '06'   
--and a.boid = main.BOID 
--and a.NOM_Sr_No=citrus_usr.fn_splitval_by(value,	43	,'~')


update a 
set 	
PurposeCode6	=citrus_usr.fn_splitval_by(value,	1	,'~'),
TypeOfTrans	=citrus_usr.fn_splitval_by(value,	2	,'~'),
Title	=citrus_usr.fn_splitval_by(value,	3	,'~'),
Name	=citrus_usr.fn_splitval_by(value,	4	,'~'),
MiddleName	=citrus_usr.fn_splitval_by(value,	5	,'~'),
SearchName	=citrus_usr.fn_splitval_by(value,	6	,'~'),
Suffix	=citrus_usr.fn_splitval_by(value,	7	,'~'),
FthName	=citrus_usr.fn_splitval_by(value,	8	,'~'),
Addr1	=citrus_usr.fn_splitval_by(value,	9	,'~'),
Addr2	=citrus_usr.fn_splitval_by(value,	10	,'~'),
Addr3	=citrus_usr.fn_splitval_by(value,	11	,'~'),
City	=citrus_usr.fn_splitval_by(value,	12	,'~'),
statecode	=citrus_usr.fn_splitval_by(value,	13	,'~'),
State	=citrus_usr.fn_splitval_by(value,	14	,'~'),
countrycode	=citrus_usr.fn_splitval_by(value,	15	,'~'),
Country	=citrus_usr.fn_splitval_by(value,	16	,'~'),
PinCode	=citrus_usr.fn_splitval_by(value,	17	,'~'),
PriPhInd	=citrus_usr.fn_splitval_by(value,	18	,'~'),
PriPhNum	=citrus_usr.fn_splitval_by(value,	19	,'~'),
AltPhInd	=citrus_usr.fn_splitval_by(value,	20	,'~'),
AltPhNum	=citrus_usr.fn_splitval_by(value,	21	,'~'),
AddPhones	=citrus_usr.fn_splitval_by(value,	22	,'~'),
Fax	=citrus_usr.fn_splitval_by(value,	23	,'~'),
PANGIR	=citrus_usr.fn_splitval_by(value,	24	,'~'),
ItCircle	=citrus_usr.fn_splitval_by(value,	25	,'~'),
EMailid	=citrus_usr.fn_splitval_by(value,	26	,'~'),
DateOfSetup	=citrus_usr.fn_splitval_by(value,	27	,'~'),
DateOfBirth	=citrus_usr.fn_splitval_by(value,	28	,'~'),
UsrTxt1	=citrus_usr.fn_splitval_by(value,	29	,'~'),
UsrTxt2	=citrus_usr.fn_splitval_by(value,	30	,'~'),
UsrFld3	=citrus_usr.fn_splitval_by(value,	31	,'~'),
Email	=citrus_usr.fn_splitval_by(value,	32	,'~'),
UnqIdNum	=citrus_usr.fn_splitval_by(value,	33	,'~'),
Filler1	=citrus_usr.fn_splitval_by(value,	34	,'~'),
Filler2	=citrus_usr.fn_splitval_by(value,	35	,'~'),
Filler3	=citrus_usr.fn_splitval_by(value,	36	,'~'),
Filler4	=citrus_usr.fn_splitval_by(value,	37	,'~'),
Filler5	=citrus_usr.fn_splitval_by(value,	38	,'~'),
Filler6	=citrus_usr.fn_splitval_by(value,	39	,'~'),
Filler7	=citrus_usr.fn_splitval_by(value,	40	,'~'),
Filler8	=citrus_usr.fn_splitval_by(value,	41	,'~'),
Filler9	=citrus_usr.fn_splitval_by(value,	42	,'~'),
Filler10	=citrus_usr.fn_splitval_by(value,	43	,'~'),
RES_SEC_FLg	=citrus_usr.fn_splitval_by(value,	44	,'~'),
NOM_Sr_No	=citrus_usr.fn_splitval_by(value,	45	,'~'),
rel_WITH_BO	=citrus_usr.fn_splitval_by(value,	46	,'~'),
perc_OF_SHARES	=citrus_usr.fn_splitval_by(value,	47	,'~'),
Filler11	=citrus_usr.fn_splitval_by(value,	48	,'~'),
Filler12	=citrus_usr.fn_splitval_by(value,	49	,'~'),
Filler13	=citrus_usr.fn_splitval_by(value,	50	,'~'),
Filler14	=citrus_usr.fn_splitval_by(value,	51	,'~'),
Filler15	=citrus_usr.fn_splitval_by(value,	52	,'~'),
BOId	=citrus_usr.fn_splitval_by(value,	53	,'~'),
TransSystemDate	=citrus_usr.fn_splitval_by(value,	54	,'~')
from dps8_source1 main,DPS8_PC6 a  where left(main.value ,2) = '06'   
and a.boid = main.BOID 
and a.NOM_Sr_No=citrus_usr.fn_splitval_by(value,	45	,'~')


--update a 
--set 		PurposeCode7	=	citrus_usr.fn_splitval_by(value,	1	,'~')
--,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
--,	Title	=	citrus_usr.fn_splitval_by(value,	3	,'~')
--,	Name	=	citrus_usr.fn_splitval_by(value,	4	,'~')
--,	MiddleName	=	citrus_usr.fn_splitval_by(value,	5	,'~')
--,	SearchName	=	citrus_usr.fn_splitval_by(value,	6	,'~')
--,	Suffix	=	citrus_usr.fn_splitval_by(value,	7	,'~')
--,	FthName	=	citrus_usr.fn_splitval_by(value,	8	,'~')
--,	Addr1	=	citrus_usr.fn_splitval_by(value,	9	,'~')
--,	Addr2	=	citrus_usr.fn_splitval_by(value,	10	,'~')
--,	Addr3	=	citrus_usr.fn_splitval_by(value,	11	,'~')
--,	City	=	citrus_usr.fn_splitval_by(value,	12	,'~')
--,	State	=	citrus_usr.fn_splitval_by(value,	13	,'~')
--,	Country	=	citrus_usr.fn_splitval_by(value,	14	,'~')
--,	PinCode	=	citrus_usr.fn_splitval_by(value,	15	,'~')
--,	PriPhInd	=	citrus_usr.fn_splitval_by(value,	16	,'~')
--,	PriPhNum	=	citrus_usr.fn_splitval_by(value,	17	,'~')
--,	AltPhInd	=	citrus_usr.fn_splitval_by(value,	18	,'~')
--,	AltPhNum	=	citrus_usr.fn_splitval_by(value,	19	,'~')
--,	AddPhones	=	citrus_usr.fn_splitval_by(value,	20	,'~')
--,	Fax	=	citrus_usr.fn_splitval_by(value,	21	,'~')
--,	PANGIR	=	citrus_usr.fn_splitval_by(value,	22	,'~')
--,	ItCircle	=	citrus_usr.fn_splitval_by(value,	23	,'~')
--,	EMailid	=	citrus_usr.fn_splitval_by(value,	24	,'~')
--,	DateOfSetup	=	citrus_usr.fn_splitval_by(value,	25	,'~')
--,	DateOfBirth	=	citrus_usr.fn_splitval_by(value,	26	,'~')
--,	UsrTxt1	=	citrus_usr.fn_splitval_by(value,	27	,'~')
--,	UsrTxt2	=	citrus_usr.fn_splitval_by(value,	28	,'~')
--,	UsrFld3	=	citrus_usr.fn_splitval_by(value,	29	,'~')
--,	Email	=	citrus_usr.fn_splitval_by(value,	30	,'~')
--,	UnqIdNum	=	citrus_usr.fn_splitval_by(value,	31	,'~')
--,	Filler1	=	citrus_usr.fn_splitval_by(value,	32	,'~')
--,	Filler2	=	citrus_usr.fn_splitval_by(value,	33	,'~')
--,	Filler3	=	citrus_usr.fn_splitval_by(value,	34	,'~')
--,	Filler4	=	citrus_usr.fn_splitval_by(value,	35	,'~')
--,	Filler5	=	citrus_usr.fn_splitval_by(value,	36	,'~')
--,	Filler6	=	citrus_usr.fn_splitval_by(value,	37	,'~')
--,	Filler7	=	citrus_usr.fn_splitval_by(value,	38	,'~')
--,	Filler8	=	citrus_usr.fn_splitval_by(value,	39	,'~')
--,	Filler9	=	citrus_usr.fn_splitval_by(value,	40	,'~')
--,	Filler10	=	citrus_usr.fn_splitval_by(value,	41	,'~')
----,	BOId	=	citrus_usr.fn_splitval_by(value,	42	,'~')
----,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	43	,'~')
--,	BOId	=	citrus_usr.fn_splitval_by(value,	46	,'~')
--,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	47	,'~')
--,RES_SEC_FLg=	citrus_usr.fn_splitval_by(value,	42	,'~')
--,NOM_Sr_No=	citrus_usr.fn_splitval_by(value,	43	,'~')
--,rel_WITH_BO=	citrus_usr.fn_splitval_by(value,	44	,'~')
--,perc_OF_SHARES=	citrus_usr.fn_splitval_by(value,	45	,'~')
--from dps8_source1 main,DPS8_PC7 a  where left(main.value ,2) = '07'   
--and a.boid = main.BOID 
--and a.NOM_Sr_No=citrus_usr.fn_splitval_by(value,	43	,'~')


update a 
set 	PurposeCode7	=citrus_usr.fn_splitval_by(value,	1	,'~'),
TypeOfTrans	=citrus_usr.fn_splitval_by(value,	2	,'~'),
Title	=citrus_usr.fn_splitval_by(value,	3	,'~'),
Name	=citrus_usr.fn_splitval_by(value,	4	,'~'),
MiddleName	=citrus_usr.fn_splitval_by(value,	5	,'~'),
SearchName	=citrus_usr.fn_splitval_by(value,	6	,'~'),
Suffix	=citrus_usr.fn_splitval_by(value,	7	,'~'),
FthName	=citrus_usr.fn_splitval_by(value,	8	,'~'),
Addr1	=citrus_usr.fn_splitval_by(value,	9	,'~'),
Addr2	=citrus_usr.fn_splitval_by(value,	10	,'~'),
Addr3	=citrus_usr.fn_splitval_by(value,	11	,'~'),
City	=citrus_usr.fn_splitval_by(value,	12	,'~'),
statecode	=citrus_usr.fn_splitval_by(value,	13	,'~'),
State	=citrus_usr.fn_splitval_by(value,	14	,'~'),
countrycode	=citrus_usr.fn_splitval_by(value,	15	,'~'),
Country	=citrus_usr.fn_splitval_by(value,	16	,'~'),
PinCode	=citrus_usr.fn_splitval_by(value,	17	,'~'),
PriPhInd	=citrus_usr.fn_splitval_by(value,	18	,'~'),
PriPhNum	=citrus_usr.fn_splitval_by(value,	19	,'~'),
AltPhInd	=citrus_usr.fn_splitval_by(value,	20	,'~'),
AltPhNum	=citrus_usr.fn_splitval_by(value,	21	,'~'),
AddPhones	=citrus_usr.fn_splitval_by(value,	22	,'~'),
Fax	=citrus_usr.fn_splitval_by(value,	23	,'~'),
PANGIR	=citrus_usr.fn_splitval_by(value,	24	,'~'),
ItCircle	=citrus_usr.fn_splitval_by(value,	25	,'~'),
EMailid	=citrus_usr.fn_splitval_by(value,	26	,'~'),
DateOfSetup	=citrus_usr.fn_splitval_by(value,	27	,'~'),
DateOfBirth	=citrus_usr.fn_splitval_by(value,	28	,'~'),
UsrTxt1	=citrus_usr.fn_splitval_by(value,	29	,'~'),
UsrTxt2	=citrus_usr.fn_splitval_by(value,	30	,'~'),
UsrFld3	=citrus_usr.fn_splitval_by(value,	31	,'~'),
Email	=citrus_usr.fn_splitval_by(value,	32	,'~'),
UnqIdNum	=citrus_usr.fn_splitval_by(value,	33	,'~'),
Filler1	=citrus_usr.fn_splitval_by(value,	34	,'~'),
Filler2	=citrus_usr.fn_splitval_by(value,	35	,'~'),
Filler3	=citrus_usr.fn_splitval_by(value,	36	,'~'),
Filler4	=citrus_usr.fn_splitval_by(value,	37	,'~'),
Filler5	=citrus_usr.fn_splitval_by(value,	38	,'~'),
Filler6	=citrus_usr.fn_splitval_by(value,	39	,'~'),
Filler7	=citrus_usr.fn_splitval_by(value,	40	,'~'),
Filler8	=citrus_usr.fn_splitval_by(value,	41	,'~'),
Filler9	=citrus_usr.fn_splitval_by(value,	42	,'~'),
Filler10	=citrus_usr.fn_splitval_by(value,	43	,'~'),
RES_SEC_FLg	=citrus_usr.fn_splitval_by(value,	44	,'~'),
NOM_Sr_No	=citrus_usr.fn_splitval_by(value,	45	,'~'),
rel_WITH_BO	=citrus_usr.fn_splitval_by(value,	46	,'~'),
perc_OF_SHARES	=citrus_usr.fn_splitval_by(value,	47	,'~'),
Filler11	=citrus_usr.fn_splitval_by(value,	48	,'~'),
Filler12	=citrus_usr.fn_splitval_by(value,	49	,'~'),
Filler13	=citrus_usr.fn_splitval_by(value,	50	,'~'),
Filler14	=citrus_usr.fn_splitval_by(value,	51	,'~'),
Filler15	=citrus_usr.fn_splitval_by(value,	52	,'~'),
BOId	=citrus_usr.fn_splitval_by(value,	53	,'~'),
TransSystemDate	=citrus_usr.fn_splitval_by(value,	54	,'~')	
from dps8_source1 main,DPS8_PC7 a  where left(main.value ,2) = '07'   
and a.boid = main.BOID 
and a.NOM_Sr_No=citrus_usr.fn_splitval_by(value,	43	,'~')


--update a 
--set 	PurposeCode8	=	citrus_usr.fn_splitval_by(value,	1	,'~')
--,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
--,	Title	=	citrus_usr.fn_splitval_by(value,	3	,'~')
--,	Name	=	citrus_usr.fn_splitval_by(value,	4	,'~')
--,	MiddleName	=	citrus_usr.fn_splitval_by(value,	5	,'~')
--,	SearchName	=	citrus_usr.fn_splitval_by(value,	6	,'~')
--,	Suffix	=	citrus_usr.fn_splitval_by(value,	7	,'~')
--,	FthName	=	citrus_usr.fn_splitval_by(value,	8	,'~')
--,	Addr1	=	citrus_usr.fn_splitval_by(value,	9	,'~')
--,	Addr2	=	citrus_usr.fn_splitval_by(value,	10	,'~')
--,	Addr3	=	citrus_usr.fn_splitval_by(value,	11	,'~')
--,	City	=	citrus_usr.fn_splitval_by(value,	12	,'~')
--,	State	=	citrus_usr.fn_splitval_by(value,	13	,'~')
--,	Country	=	citrus_usr.fn_splitval_by(value,	14	,'~')
--,	PinCode	=	citrus_usr.fn_splitval_by(value,	15	,'~')
--,	PriPhInd	=	citrus_usr.fn_splitval_by(value,	16	,'~')
--,	PriPhNum	=	citrus_usr.fn_splitval_by(value,	17	,'~')
--,	AltPhInd	=	citrus_usr.fn_splitval_by(value,	18	,'~')
--,	AltPhNum	=	citrus_usr.fn_splitval_by(value,	19	,'~')
--,	AddPhones	=	citrus_usr.fn_splitval_by(value,	20	,'~')
--,	Fax	=	citrus_usr.fn_splitval_by(value,	21	,'~')
--,	PANGIR	=	citrus_usr.fn_splitval_by(value,	22	,'~')
--,	ItCircle	=	citrus_usr.fn_splitval_by(value,	23	,'~')
--,	EMailid	=	citrus_usr.fn_splitval_by(value,	24	,'~')
--,	DateOfSetup	=	citrus_usr.fn_splitval_by(value,	25	,'~')
--,	DateOfBirth	=	citrus_usr.fn_splitval_by(value,	26	,'~')
--,	UsrTxt1	=	citrus_usr.fn_splitval_by(value,	27	,'~')
--,	UsrTxt2	=	citrus_usr.fn_splitval_by(value,	28	,'~')
--,	UsrFld3	=	citrus_usr.fn_splitval_by(value,	29	,'~')
--,	Email	=	citrus_usr.fn_splitval_by(value,	30	,'~')
--,	UnqIdNum	=	citrus_usr.fn_splitval_by(value,	31	,'~')
--,	Filler1	=	citrus_usr.fn_splitval_by(value,	32	,'~')
--,	Filler2	=	citrus_usr.fn_splitval_by(value,	33	,'~')
--,	Filler3	=	citrus_usr.fn_splitval_by(value,	34	,'~')
--,	Filler4	=	citrus_usr.fn_splitval_by(value,	35	,'~')
--,	Filler5	=	citrus_usr.fn_splitval_by(value,	36	,'~')
--,	Filler6	=	citrus_usr.fn_splitval_by(value,	37	,'~')
--,	Filler7	=	citrus_usr.fn_splitval_by(value,	38	,'~')
--,	Filler8	=	citrus_usr.fn_splitval_by(value,	39	,'~')
--,	Filler9	=	citrus_usr.fn_splitval_by(value,	40	,'~')
--,	Filler10	=	citrus_usr.fn_splitval_by(value,	41	,'~')
----,	BOId	=	citrus_usr.fn_splitval_by(value,	42	,'~')
----,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	43	,'~')
--,	BOId	=	citrus_usr.fn_splitval_by(value,	46	,'~')
--,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	47	,'~')
--,RES_SEC_FLg=	citrus_usr.fn_splitval_by(value,	42	,'~')
--,NOM_Sr_No=	citrus_usr.fn_splitval_by(value,	43	,'~')
--,rel_WITH_BO=	citrus_usr.fn_splitval_by(value,	44	,'~')
--,perc_OF_SHARES=	citrus_usr.fn_splitval_by(value,	45	,'~')
--from dps8_source1 main,DPS8_PC8 a  where left(main.value ,2) = '08'   
--and a.boid = main.BOID 
--and a.NOM_Sr_No=citrus_usr.fn_splitval_by(value,	43	,'~')


update a 
set 	PurposeCode8	=citrus_usr.fn_splitval_by(value,	1	,'~'),
TypeOfTrans	=citrus_usr.fn_splitval_by(value,	2	,'~'),
Title	=citrus_usr.fn_splitval_by(value,	3	,'~'),
Name	=citrus_usr.fn_splitval_by(value,	4	,'~'),
MiddleName	=citrus_usr.fn_splitval_by(value,	5	,'~'),
SearchName	=citrus_usr.fn_splitval_by(value,	6	,'~'),
Suffix	=citrus_usr.fn_splitval_by(value,	7	,'~'),
FthName	=citrus_usr.fn_splitval_by(value,	8	,'~'),
Addr1	=citrus_usr.fn_splitval_by(value,	9	,'~'),
Addr2	=citrus_usr.fn_splitval_by(value,	10	,'~'),
Addr3	=citrus_usr.fn_splitval_by(value,	11	,'~'),
City	=citrus_usr.fn_splitval_by(value,	12	,'~'),
statecode	=citrus_usr.fn_splitval_by(value,	13	,'~'),
State	=citrus_usr.fn_splitval_by(value,	14	,'~'),
countrycode	=citrus_usr.fn_splitval_by(value,	15	,'~'),
Country	=citrus_usr.fn_splitval_by(value,	16	,'~'),
PinCode	=citrus_usr.fn_splitval_by(value,	17	,'~'),
PriPhInd	=citrus_usr.fn_splitval_by(value,	18	,'~'),
PriPhNum	=citrus_usr.fn_splitval_by(value,	19	,'~'),
AltPhInd	=citrus_usr.fn_splitval_by(value,	20	,'~'),
AltPhNum	=citrus_usr.fn_splitval_by(value,	21	,'~'),
AddPhones	=citrus_usr.fn_splitval_by(value,	22	,'~'),
Fax	=citrus_usr.fn_splitval_by(value,	23	,'~'),
PANGIR	=citrus_usr.fn_splitval_by(value,	24	,'~'),
ItCircle	=citrus_usr.fn_splitval_by(value,	25	,'~'),
EMailid	=citrus_usr.fn_splitval_by(value,	26	,'~'),
DateOfSetup	=citrus_usr.fn_splitval_by(value,	27	,'~'),
DateOfBirth	=citrus_usr.fn_splitval_by(value,	28	,'~'),
UsrTxt1	=citrus_usr.fn_splitval_by(value,	29	,'~'),
UsrTxt2	=citrus_usr.fn_splitval_by(value,	30	,'~'),
UsrFld3	=citrus_usr.fn_splitval_by(value,	31	,'~'),
Email	=citrus_usr.fn_splitval_by(value,	32	,'~'),
UnqIdNum	=citrus_usr.fn_splitval_by(value,	33	,'~'),
Filler1	=citrus_usr.fn_splitval_by(value,	34	,'~'),
Filler2	=citrus_usr.fn_splitval_by(value,	35	,'~'),
Filler3	=citrus_usr.fn_splitval_by(value,	36	,'~'),
Filler4	=citrus_usr.fn_splitval_by(value,	37	,'~'),
Filler5	=citrus_usr.fn_splitval_by(value,	38	,'~'),
Filler6	=citrus_usr.fn_splitval_by(value,	39	,'~'),
Filler7	=citrus_usr.fn_splitval_by(value,	40	,'~'),
Filler8	=citrus_usr.fn_splitval_by(value,	41	,'~'),
Filler9	=citrus_usr.fn_splitval_by(value,	42	,'~'),
Filler10	=citrus_usr.fn_splitval_by(value,	43	,'~'),
RES_SEC_FLg	=citrus_usr.fn_splitval_by(value,	44	,'~'),
NOM_Sr_No	=citrus_usr.fn_splitval_by(value,	45	,'~'),
rel_WITH_BO	=citrus_usr.fn_splitval_by(value,	46	,'~'),
perc_OF_SHARES	=citrus_usr.fn_splitval_by(value,	47	,'~'),
Filler11	=citrus_usr.fn_splitval_by(value,	48	,'~'),
Filler12	=citrus_usr.fn_splitval_by(value,	49	,'~'),
Filler13	=citrus_usr.fn_splitval_by(value,	50	,'~'),
Filler14	=citrus_usr.fn_splitval_by(value,	51	,'~'),
Filler15	=citrus_usr.fn_splitval_by(value,	52	,'~'),
BOId	=citrus_usr.fn_splitval_by(value,	53	,'~'),
TransSystemDate	=citrus_usr.fn_splitval_by(value,	54	,'~')
from dps8_source1 main,DPS8_PC8 a  where left(main.value ,2) = '08'   
and a.boid = main.BOID 
and a.NOM_Sr_No=citrus_usr.fn_splitval_by(value,	43	,'~')


--update a 
--set 		PurposeCode12	=	citrus_usr.fn_splitval_by(value,	1	,'~')
--,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
--,	Addr1	=	citrus_usr.fn_splitval_by(value,	3	,'~')
--,	Addr2	=	citrus_usr.fn_splitval_by(value,	4	,'~')
--,	Addr3	=	citrus_usr.fn_splitval_by(value,	5	,'~')
--,	City	=	citrus_usr.fn_splitval_by(value,	6	,'~')
--,	State	=	citrus_usr.fn_splitval_by(value,	7	,'~')
--,	Country	=	citrus_usr.fn_splitval_by(value,	8	,'~')
--,	PinCode	=	citrus_usr.fn_splitval_by(value,	9	,'~')
--,	PriPhNum	=	citrus_usr.fn_splitval_by(value,	10	,'~')
--,	Fax	=	citrus_usr.fn_splitval_by(value,	11	,'~')
--,	EMailId	=	citrus_usr.fn_splitval_by(value,	12	,'~')
--,	BOId	=	citrus_usr.fn_splitval_by(value,	13	,'~')
--,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	14	,'~')

--from dps8_source1 main,DPS8_PC12 a  where left(main.value ,2) = '12'   
--and a.boid = main.BOID 



update a 
set 		PurposeCode12	=citrus_usr.fn_splitval_by(value,	1	,'~'),
TypeOfTrans	=citrus_usr.fn_splitval_by(value,	2	,'~'),
Addr1	=citrus_usr.fn_splitval_by(value,	3	,'~'),
Addr2	=citrus_usr.fn_splitval_by(value,	4	,'~'),
Addr3	=citrus_usr.fn_splitval_by(value,	5	,'~'),
City	=citrus_usr.fn_splitval_by(value,	6	,'~'),
statecode	=citrus_usr.fn_splitval_by(value,	7	,'~'),
State	=citrus_usr.fn_splitval_by(value,	8	,'~'),
countrycode	=citrus_usr.fn_splitval_by(value,	9	,'~'),
Country	=citrus_usr.fn_splitval_by(value,	10	,'~'),
PinCode	=citrus_usr.fn_splitval_by(value,	11	,'~'),
PriPhNum	=citrus_usr.fn_splitval_by(value,	12	,'~'),
Fax	=citrus_usr.fn_splitval_by(value,	13	,'~'),
EMailId	=citrus_usr.fn_splitval_by(value,	14	,'~'),
BOId	=citrus_usr.fn_splitval_by(value,	15	,'~'),
TransSystemDate	=citrus_usr.fn_splitval_by(value,	16	,'~')
from dps8_source1 main,DPS8_PC12 a  where left(main.value ,2) = '12'   
and a.boid = main.BOID 



update a 
set 			PurposeCode16	=	citrus_usr.fn_splitval_by(value,	1	,'~')
,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
,	MobileNum	=	citrus_usr.fn_splitval_by(value,	3	,'~')
,	SetUpDate	=	citrus_usr.fn_splitval_by(value,	4	,'~')
,	EmailId	=	citrus_usr.fn_splitval_by(value,	5	,'~')
,	Remarks	=	citrus_usr.fn_splitval_by(value,	6	,'~')
,	PushPullFlg	=	citrus_usr.fn_splitval_by(value,	7	,'~')
,	BOId	=	citrus_usr.fn_splitval_by(value,	8	,'~')
,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	9	,'~')
from dps8_source1 main,DPS8_PC16 a  where left(main.value ,2) = '16'   
and a.boid = main.BOID 


update a 
set 	PurposeCode17	=	citrus_usr.fn_splitval_by(value,	1	,'~')
,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
,	CMId	=	citrus_usr.fn_splitval_by(value,	3	,'~')
,	ClientCode	=	citrus_usr.fn_splitval_by(value,	4	,'~')
,	RegRmks	=	citrus_usr.fn_splitval_by(value,	5	,'~')
,	RegStatus	=	citrus_usr.fn_splitval_by(value,	6	,'~')
,	RegAppDtByCm	=	citrus_usr.fn_splitval_by(value,	7	,'~')
,	RegDeregDate	=	citrus_usr.fn_splitval_by(value,	8	,'~')
,	BOId	=	citrus_usr.fn_splitval_by(value,	9	,'~')
,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	10	,'~')

from dps8_source1 main,DPS8_PC17 a  where left(main.value ,2) = '17'   
and a.boid = main.BOID 


--update a 
--set 	PurposeCode18	=	citrus_usr.fn_splitval_by(value,	1	,'~')
--,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
--,	NaSeqNum	=	citrus_usr.fn_splitval_by(value,	3	,'~')
--,	BOName	=	citrus_usr.fn_splitval_by(value,	4	,'~')
--,	Remarks	=	citrus_usr.fn_splitval_by(value,	5	,'~')
--,	BOId	=	citrus_usr.fn_splitval_by(value,	7	,'~')
--,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	8	,'~')
--,	Namechange	=	citrus_usr.fn_splitval_by(value,	6	,'~')


--from dps8_source1 main,DPS8_PC18 a  where left(main.value ,2) = '18'   
--and a.boid = main.BOID


--update a 
--set 	PurposeCode18	=citrus_usr.fn_splitval_by(value,	1	,'~'),
--TypeOfTrans	=citrus_usr.fn_splitval_by(value,	2	,'~'),
--NaSeqNum	=citrus_usr.fn_splitval_by(value,	3	,'~'),
--BOName	=citrus_usr.fn_splitval_by(value,	4	,'~'),
--Remarks	=citrus_usr.fn_splitval_by(value,	5	,'~'),
--MOBILE_NO_ISD	=citrus_usr.fn_splitval_by(value,	6	,'~'),
--MOBILE_NUMBER	=citrus_usr.fn_splitval_by(value,	7	,'~'),
--EMAILID	=citrus_usr.fn_splitval_by(value,	8	,'~'),
--uid	=citrus_usr.fn_splitval_by(value,	9	,'~'),
--UID_FLAG	=citrus_usr.fn_splitval_by(value,	10	,'~'),
--FILLER1	=citrus_usr.fn_splitval_by(value,	11	,'~'),
--FILLER2	=citrus_usr.fn_splitval_by(value,	12	,'~'),
--FILLER3	=citrus_usr.fn_splitval_by(value,	13	,'~'),
--FILLER4	=citrus_usr.fn_splitval_by(value,	14	,'~'),
--FILLER5	=citrus_usr.fn_splitval_by(value,	15	,'~'),
--BOId	=citrus_usr.fn_splitval_by(value,	16	,'~'),
--TransSystemDate	=citrus_usr.fn_splitval_by(value,	17	,'~')
--from dps8_source1 main,DPS8_PC18 a  where left(main.value ,2) = '18'   
--and a.boid = main.BOID
update a 
set 	PurposeCode18	=citrus_usr.fn_splitval_by(value,	1	,'~'),
TypeOfTrans	=citrus_usr.fn_splitval_by(value,	2	,'~'),
NaSeqNum	=citrus_usr.fn_splitval_by(value,	3	,'~'),
BOName	=citrus_usr.fn_splitval_by(value,	4	,'~'),
MIDDLE_NAME	=citrus_usr.fn_splitval_by(value,	5	,'~'),
LAST_NAME	=citrus_usr.fn_splitval_by(value,	6	,'~'),
Remarks	=citrus_usr.fn_splitval_by(value,	7	,'~'),
namechange=citrus_usr.fn_splitval_by(value,	8	,'~'),
MOBILE_NO_ISD	=citrus_usr.fn_splitval_by(value,	9	,'~'),
MOBILE_NUMBER	=citrus_usr.fn_splitval_by(value,	10	,'~'),
EMAILID	=citrus_usr.fn_splitval_by(value,	11	,'~'),
uid	=citrus_usr.fn_splitval_by(value,	12	,'~'),
UID_FLAG	=citrus_usr.fn_splitval_by(value,	13	,'~'),
FILLER1	=citrus_usr.fn_splitval_by(value,	14	,'~'),
FILLER2	=citrus_usr.fn_splitval_by(value,	15	,'~'),
FILLER3	=citrus_usr.fn_splitval_by(value,	16	,'~'),
FILLER4	=citrus_usr.fn_splitval_by(value,	17	,'~'),
FILLER5	=citrus_usr.fn_splitval_by(value,	18	,'~'),
BOId	=citrus_usr.fn_splitval_by(value,	19	,'~'),
TransSystemDate	=citrus_usr.fn_splitval_by(value,	20	,'~')
from dps8_source1 main,DPS8_PC18 a  where left(main.value ,2) = '18'   
and a.boid = main.BOID
and NaSeqNum	=	citrus_usr.fn_splitval_by(value,	3	,'~')



update a 
set 		PurposeCode19	=	citrus_usr.fn_splitval_by(value,	1	,'~')
,	TypeOfTrans	=	citrus_usr.fn_splitval_by(value,	2	,'~')
,	ImageFileName	=	citrus_usr.fn_splitval_by(value,	3	,'~')
,	SigSetupDate	=	citrus_usr.fn_splitval_by(value,	4	,'~')
,	BOId	=	citrus_usr.fn_splitval_by(value,	5	,'~')
,	TransSystemDate	=	citrus_usr.fn_splitval_by(value,	6	,'~')
from dps8_source1 main,DPS8_PC19 a  where left(main.value ,2) = '19'   
and a.boid = main.BOID

/*added line   23/06/2020*/
update a 
 set PURPOSECODE22 = citrus_usr.fn_splitval_by(value,	1	,'~')
,FILLER1= citrus_usr.fn_splitval_by(value,	2	,'~')
,LINK_STATUS= citrus_usr.fn_splitval_by(value,	3	,'~')
,FILLER2= citrus_usr.fn_splitval_by(value,	4	,'~')
,EXCHANGE_ID= citrus_usr.fn_splitval_by(value,5	,'~')
,UCC= citrus_usr.fn_splitval_by(value,	6	,'~')
,SEGMENT_CODE= citrus_usr.fn_splitval_by(value,7	,'~')
,CM_ID= citrus_usr.fn_splitval_by(value,	8	,'~')
,TM_CODE= citrus_usr.fn_splitval_by(value,	9	,'~')
,BOID= citrus_usr.fn_splitval_by(value,	10	,'~')
,TransSystemDate= citrus_usr.fn_splitval_by(value,	11	,'~')
from dps8_source1 main,DPS8_PC22 a  where left(main.value ,2) = '22'   
and a.boid = main.BOID
and EXCHANGE_ID= citrus_usr.fn_splitval_by(value,5	,'~')
and SEGMENT_CODE= citrus_usr.fn_splitval_by(value,7	,'~')

/*added line   23/06/2020*/


--update dps table for existing data 

--insert dps table for existing data   
    

exec pr_insert_dps8 '0'--30 sec  
exec pr_insert_dps8 '1'--1 min 9 sec  
exec pr_insert_dps8 '2'--2 sec  
exec pr_insert_dps8 '3'--0 sec  
exec pr_insert_dps8 '4'--0 sec  
exec pr_insert_dps8 '5'--22 sec  
exec pr_insert_dps8 '6'--18 sec  
exec pr_insert_dps8 '7'--0 sec  
exec pr_insert_dps8 '8'--0 sec  
exec pr_insert_dps8 '12'--26 sec  
exec pr_insert_dps8 '16'--12 sec  
exec pr_insert_dps8 '17'--0 sec  
exec pr_insert_dps8 '18'--0 sec  
exec pr_insert_dps8 '19'--30 sec  
/*added line   23/06/2020*/
exec pr_insert_dps8 '22'--30 sec  
/*added line   23/06/2020*/
  
--insert dps table for existing data   
  
   
  
  
end

GO
