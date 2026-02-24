-- Object: PROCEDURE citrus_usr.pr_bulk_dpb9_harm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



CREATE  proc [citrus_usr].[pr_bulk_dpb9_harm]
as
begin 

--pc19
truncate table dpb9_pc0
insert into dpb9_pc0
select distinct '00'
,ClntId ClntId
,''
,CNTRLSCTIESDPSTRYPTCPT
,'CDS',''
,''
from  [CLN_MSTR_CDSL]




--pc1 
truncate table dpb9_pc1 
insert into dpb9_pc1 
select isnull(Purpse.CDSL_Old_Values,'') Purpse
,''
,isnull(Titl ,'') Titl
,FrstNm FrstNm
,isnull(MddlNm ,'') MddlNm
,LastNm LastNm
,isnull(FSfx ,'') FSfx
,isnull(ScndHldrNmOfFthr ,'') ScndHldrNmOfFthr
,Adr1 Adr1
,Adr2 Adr2
,isnull(Adr3 ,'') Adr3
,Adr4 Adr4
,isnull(CtrySubDvsnCd.Meaning  ,'') CtrySubDvsnCd
,isnull(Ctry.Meaning ,'')  Ctry
,PstCd PstCd
,'' PriPhInd
,MobNb MobNb
,'' AltPhNum
,isnull(PhneNb ,'') PhneNb
,'' AddPh
,isnull(FaxNb ,'') FaxNb
,isnull(PANXmptnCd.CDSL_Old_Values ,'') PANXmptnCd
,PAN PAN
,case when isnull(PANVrfyFlg.CDSL_Old_Values ,'')='Not Applicable' then '' else  isnull(PANVrfyFlg.CDSL_Old_Values ,'') end  PANVrfyFlg
,isnull(ITCrcl ,'') ITCrcl
,'' emailid 
,isnull(LEI ,'') LEI
,''
,''
,isnull(AcctSts.CDSL_Old_Values ,'') AcctSts
,''
,isnull(BnfcryAcctCtgy.CDSL_Old_Values ,'') BnfcryAcctCtgy
,''--#N/A
,isnull(BnfcrySubTp.CDSL_Old_Values,'')  BnfcrySubTp
,isnull(PrdNb.CDSL_Old_Values ,'') PrdNb
,''
,''
,isnull(Xchg.CDSL_Old_Values ,'0') Xchg
,isnull(TradgId ,'') TradgId
,isnull(BnfclOwnrSttlmCyclCd.CDSL_Old_Values ,'') BnfclOwnrSttlmCyclCd
,replace(convert(varchar(11),convert(datetime,SetUpDt),103),'/','')
,SndrRefNb1 SndrRefNb1
,isnull(StgInstr.CDSL_Old_Values ,'') StgInstr
,replace(convert(varchar(11),convert(datetime,BirthDt),103),'/','')
,case when ClntActDtTm <> '' then replace(convert(varchar(11),convert(datetime,ClntActDtTm),103),'/','') else '' end 
,isnull(ElctrncConf.CDSL_Old_Values ,'') ElctrncConf
,isnull(Mndt.CDSL_Old_Values,'') Mndt
,isnull(BnfcryBkAcctNb ,'') BnfcryBkAcctNb
,isnull(MICRCd ,'') MICRCd
,isnull(INIFSC ,'') INIFSC
,isnull(DvddCcy ,'') DvddCcy
,isnull(BkAcctTp.CDSL_Old_Values ,'') BkAcctTp
,isnull(GrssAnlIncmRg.CDSL_Old_Values ,'') GrssAnlIncmRg
,isnull(BnfcryTaxDdctnSts.CDSL_Old_Values ,'0') BnfcryTaxDdctnSts
,''
,case when len(isnull(EdctnLvl.CDSL_Old_Values ,'0'))=1 then '' + isnull(EdctnLvl.CDSL_Old_Values ,'') else isnull(EdctnLvl.CDSL_Old_Values ,'0') end  EdctnLvl
,isnull(GeoCd.CDSL_Old_Values ,'')GeoCd
,''
,''
,isnull(Ntlty.CDSL_Old_Values ,'')Ntlty
,isnull(Ocptn.CDSL_Old_Values ,'')Ocptn
,''
,isnull(Gndr.CDSL_Old_Values ,'')Gndr
,''
,''
,isnull(RBIRefNb ,'')  RBIRefNb
,replace(convert(varchar(11),convert(datetime,RBIApprvdDt),103),'/','')  RBIApprvdDt
,isnull(SEBIRegNb ,'') SEBIRegNb
,case when BnAccClsrDt <> '' then replace(convert(varchar(11),convert(datetime,BnAccClsrDt),103),'/','') else '' end  BnAccClsrDt
,case when BnAccClsrDt <> '' then replace(convert(varchar(11),convert(datetime,BnAccClsrDt),103),'/','') else '' end  BnAccClsrDt
,isnull(TrgtClntID ,'') TrgtClntID
,''
,isnull(StsChgRsnOrClsrRsnCd.CDSL_Old_Values ,'0') StsChgRsnOrClsrRsnCd
,isnull(ClsrInitBy.CDSL_Old_Values ,'')ClsrInitBy
,isnull(Rmk,'')  Rmk
,isnull(UID ,'')  UID
,case when len(isnull(NmChgRsnCd.CDSL_Old_Values ,''))=1 then '0' + isnull(NmChgRsnCd.CDSL_Old_Values ,'') else isnull(NmChgRsnCd.CDSL_Old_Values ,'') end NmChgRsnCd
,isnull(FrstClntOptnToRcvElctrncStmtFlg.CDSL_Old_Values ,'')FrstClntOptnToRcvElctrncStmtFlg
,isnull(CASMd.CDSL_Old_Values ,'')CASMd
,isnull(PrfDpstryFldFrCAS.CDSL_Old_Values ,'')PrfDpstryFldFrCAS
,''
,''
,isnull(AnlRptFlg.CDSL_Old_Values ,'')AnlRptFlg
,isnull(PldgStgInstrFlg.CDSL_Old_Values ,'')PldgStgInstrFlg
,isnull(EmailRTADwnldFlg.CDSL_Old_Values ,'')EmailRTADwnldFlg
,isnull(BSDAFlg.CDSL_Old_Values ,'')BSDAFlg
,''
,isnull(FmlyFlgForEmailAdr.CDSL_Old_Values ,'')FmlyFlgForEmailAdr
,isnull(CustdPmsEmailId ,'')CustdPmsEmailId
,isnull(AdhrAuthntcnWthUID.CDSL_Old_Values ,'')AdhrAuthntcnWthUID
,isnull(AdrPrefFlg.CDSL_Old_Values ,'')AdrPrefFlg
,''
,isnull(AccntOpSrc.CDSL_Old_Values ,'')AccntOpSrc
,isnull(OneTmDclrtnFlgForGSECIDT.CDSL_Old_Values ,'')OneTmDclrtnFlgForGSECIDT
,ClntId ClntId
,''
,isnull(CtrySubDvsnCd.CDSL_Old_Values ,'') CtrySubDvsnCd
,isnull(Ctry.CDSL_Old_Values ,'') Ctry
,isnull(PrmryISDCd.CDSL_Old_Values ,'')PrmryISDCd
,isnull(ScndryISDCd.CDSL_Old_Values ,'')ScndryISDCd
,''
,''
,isnull(VrfStsMobNb.CDSL_Old_Values ,'')VrfStsMobNb
,isnull(VrfStsEmail.CDSL_Old_Values ,'')VrfStsEmail
,''
,isnull(SMSFclty.CDSL_Old_Values ,'')SMSFclty
,EmailAdr EmailAdr
,isnull(AltrnEmailAdr ,'') AltrnEmailAdr
,isnull(NoNmntnFlg.CDSL_Old_Values ,'')NoNmntnFlg
,''
,isnull(ComToBeSentTo.CDSL_Old_Values,'') ComToBeSentTo
,ClntBsdaOptOutDt
,RSNBSDAMod
,DtIntmnDms
,NmStmtFlg
from [CLN_MSTR_CDSL] 
left outer join (select * from standard_value_list PrdNb where  PrdNb.iso_tags ='PrdNb' ) PrdNb on PrdNb=PrdNb.Standard_Value
left outer join (select * from standard_value_list Purpse where  Purpse.iso_tags ='Purpse' ) Purpse on Purpse=Purpse.Standard_Value
left outer join (select * from standard_value_list CtrySubDvsnCd where  CtrySubDvsnCd.iso_tags ='CtrySubDvsnCd' ) CtrySubDvsnCd on CtrySubDvsnCd=CtrySubDvsnCd.Standard_Value
left outer join (select * from standard_value_list Ctry where  Ctry.iso_tags ='Ctry' ) Ctry on Ctry=Ctry.Standard_Value
left outer join (select * from standard_value_list PANXmptnCd where  PANXmptnCd.iso_tags ='PANXmptnCd' ) PANXmptnCd on PANXmptnCd=PANXmptnCd.Standard_Value
left outer join (select * from standard_value_list PANVrfyFlg where  PANVrfyFlg.iso_tags ='PANVrfyFlg' ) PANVrfyFlg on PANVrfyFlg=PANVrfyFlg.Standard_Value
left outer join (select * from standard_value_list AcctSts where  AcctSts.iso_tags ='AcctSts' ) AcctSts on AcctSts=AcctSts.Standard_Value
left outer join (select * from standard_value_list BnfcryAcctCtgy where  BnfcryAcctCtgy.iso_tags ='BnfcryAcctCtgy' ) BnfcryAcctCtgy on BnfcryAcctCtgy=BnfcryAcctCtgy.Standard_Value
left outer join (select * from standard_value_list BnfcrySubTp where  BnfcrySubTp.iso_tags ='BnfcrySubTp' ) BnfcrySubTp on BnfcrySubTp=BnfcrySubTp.Standard_Value
left outer join (select * from standard_value_list Xchg where  Xchg.iso_tags ='Xchg' ) Xchg on Xchg=Xchg.Standard_Value
left outer join (select * from standard_value_list BnfclOwnrSttlmCyclCd where  BnfclOwnrSttlmCyclCd.iso_tags ='BnfclOwnrSttlmCyclCd' ) BnfclOwnrSttlmCyclCd on BnfclOwnrSttlmCyclCd=BnfclOwnrSttlmCyclCd.Standard_Value
left outer join (select * from standard_value_list StgInstr where  StgInstr.iso_tags ='StgInstr' ) StgInstr on StgInstr=StgInstr.Standard_Value
left outer join (select * from standard_value_list ElctrncConf where  ElctrncConf.iso_tags ='ElctrncConf' ) ElctrncConf on ElctrncConf=ElctrncConf.Standard_Value
left outer join (select * from standard_value_list Mndt where  Mndt.iso_tags ='Mndt' ) Mndt on Mndt=Mndt.Standard_Value
left outer join (select * from standard_value_list BkAcctTp where  BkAcctTp.iso_tags ='BkAcctTp' ) BkAcctTp on BkAcctTp=BkAcctTp.Standard_Value
left outer join (select * from standard_value_list GrssAnlIncmRg where  GrssAnlIncmRg.iso_tags ='GrssAnlIncmRg' ) GrssAnlIncmRg on GrssAnlIncmRg=GrssAnlIncmRg.Standard_Value
left outer join (select * from standard_value_list BnfcryTaxDdctnSts where  BnfcryTaxDdctnSts.iso_tags ='BnfcryTaxDdctnSts' ) BnfcryTaxDdctnSts on BnfcryTaxDdctnSts=BnfcryTaxDdctnSts.Standard_Value
left outer join (select * from standard_value_list EdctnLvl where  EdctnLvl.iso_tags ='EdctnLvl' ) EdctnLvl on EdctnLvl=EdctnLvl.Standard_Value
left outer join (select * from standard_value_list GeoCd where  GeoCd.iso_tags ='GeoCd' ) GeoCd on GeoCd=GeoCd.Standard_Value
left outer join (select * from standard_value_list Ntlty where  Ntlty.iso_tags ='Ntlty' ) Ntlty on Ntlty=Ntlty.Standard_Value
left outer join (select * from standard_value_list Ocptn where  Ocptn.iso_tags ='Ocptn' ) Ocptn on Ocptn=Ocptn.Standard_Value
left outer join (select * from standard_value_list Gndr where  Gndr.iso_tags ='Gndr' ) Gndr on Gndr=Gndr.Standard_Value
left outer join (select * from standard_value_list StsChgRsnOrClsrRsnCd where  StsChgRsnOrClsrRsnCd.iso_tags ='StsChgRsnOrClsrRsnCd' ) StsChgRsnOrClsrRsnCd on StsChgRsnOrClsrRsnCd=StsChgRsnOrClsrRsnCd.Standard_Value
left outer join (select * from standard_value_list ClsrInitBy where  ClsrInitBy.iso_tags ='ClsrInitBy' ) ClsrInitBy on ClsrInitBy=ClsrInitBy.Standard_Value
left outer join (select * from standard_value_list NmChgRsnCd where  NmChgRsnCd.iso_tags ='NmChgRsnCd' ) NmChgRsnCd on NmChgRsnCd=NmChgRsnCd.Standard_Value
left outer join (select * from standard_value_list FrstClntOptnToRcvElctrncStmtFlg where  FrstClntOptnToRcvElctrncStmtFlg.iso_tags ='FrstClntOptnToRcvElctrncStmtFlg' ) FrstClntOptnToRcvElctrncStmtFlg on FrstClntOptnToRcvElctrncStmtFlg=FrstClntOptnToRcvElctrncStmtFlg.Standard_Value
left outer join (select * from standard_value_list CASMd where  CASMd.iso_tags ='CASMd' ) CASMd on CASMd=CASMd.Standard_Value
left outer join (select * from standard_value_list PrfDpstryFldFrCAS where  PrfDpstryFldFrCAS.iso_tags ='PrfDpstryFldFrCAS' ) PrfDpstryFldFrCAS on PrfDpstryFldFrCAS=PrfDpstryFldFrCAS.Standard_Value
left outer join (select * from standard_value_list AnlRptFlg where  AnlRptFlg.iso_tags ='AnlRptFlg' ) AnlRptFlg on AnlRptFlg=AnlRptFlg.Standard_Value
left outer join (select * from standard_value_list PldgStgInstrFlg where  PldgStgInstrFlg.iso_tags ='PldgStgInstrFlg' ) PldgStgInstrFlg on PldgStgInstrFlg=PldgStgInstrFlg.Standard_Value
left outer join (select * from standard_value_list EmailRTADwnldFlg where  EmailRTADwnldFlg.iso_tags ='EmailRTADwnldFlg' ) EmailRTADwnldFlg on EmailRTADwnldFlg=EmailRTADwnldFlg.Standard_Value
left outer join (select * from standard_value_list BSDAFlg where  BSDAFlg.iso_tags ='BSDAFlg' ) BSDAFlg on BSDAFlg=BSDAFlg.Standard_Value
left outer join (select * from standard_value_list FmlyFlgForEmailAdr where  FmlyFlgForEmailAdr.iso_tags ='FmlyFlgForEmailAdr' ) FmlyFlgForEmailAdr on FmlyFlgForEmailAdr=FmlyFlgForEmailAdr.Standard_Value
left outer join (select * from standard_value_list AdhrAuthntcnWthUID where  AdhrAuthntcnWthUID.iso_tags ='AdhrAuthntcnWthUID' ) AdhrAuthntcnWthUID on AdhrAuthntcnWthUID=AdhrAuthntcnWthUID.Standard_Value
left outer join (select * from standard_value_list AdrPrefFlg where  AdrPrefFlg.iso_tags ='AdrPrefFlg' ) AdrPrefFlg on AdrPrefFlg=AdrPrefFlg.Standard_Value
left outer join (select * from standard_value_list AccntOpSrc where  AccntOpSrc.iso_tags ='AccntOpSrc' ) AccntOpSrc on AccntOpSrc=AccntOpSrc.Standard_Value
left outer join (select * from standard_value_list OneTmDclrtnFlgForGSECIDT where  OneTmDclrtnFlgForGSECIDT.iso_tags ='OneTmDclrtnFlgForGSECIDT' ) OneTmDclrtnFlgForGSECIDT on OneTmDclrtnFlgForGSECIDT=OneTmDclrtnFlgForGSECIDT.Standard_Value
left outer join (select * from standard_value_list PrmryISDCd where  PrmryISDCd.iso_tags ='PrmryISDCd' ) PrmryISDCd on PrmryISDCd=PrmryISDCd.Standard_Value
left outer join (select * from standard_value_list ScndryISDCd where  ScndryISDCd.iso_tags ='ScndryISDCd' ) ScndryISDCd on ScndryISDCd=ScndryISDCd.Standard_Value
left outer join (select * from standard_value_list VrfStsMobNb where  VrfStsMobNb.iso_tags ='VrfStsMobNb' ) VrfStsMobNb on VrfStsMobNb=VrfStsMobNb.Standard_Value
left outer join (select * from standard_value_list VrfStsEmail where  VrfStsEmail.iso_tags ='VrfStsEmail' ) VrfStsEmail on VrfStsEmail=VrfStsEmail.Standard_Value
left outer join (select * from standard_value_list SMSFclty where  SMSFclty.iso_tags ='SMSFclty' ) SMSFclty on SMSFclty=SMSFclty.Standard_Value
left outer join (select * from standard_value_list NoNmntnFlg where  NoNmntnFlg.iso_tags ='NoNmntnFlg' ) NoNmntnFlg on NoNmntnFlg=NoNmntnFlg.Standard_Value
left outer join (select * from standard_value_list ComToBeSentTo where  ComToBeSentTo.iso_tags ='ComToBeSentTo' ) ComToBeSentTo on ComToBeSentTo=ComToBeSentTo.Standard_Value
where PURPSE ='FH' and PURPCD ='CORAD' 






update a set  BOCustType=  substring(subcm_Cd,3,2)  from dpb9_pc1 a , sub_ctgry_mstr 
where BOCustType =''  
and isnull(case when len(ProdCode)= 1 then '0' +  ProdCode else ProdCode   end ,'') = left(subcm_cd,2)
and isnull(case when len(BOSubStatus)= 1 then '0'+BOSubStatus else BOSubStatus end ,'')  
= substring(subcm_cd,5,3)


--pc2
truncate table dpb9_pc2
insert into dpb9_pc2 
select '02' Purpse
,''
,isnull(Titl ,'') Titl
,FrstNm FrstNm
,isnull(MddlNm ,'') MddlNm
,isnull(LastNm ,'') LastNm
,isnull(FSfx ,'') FSfx
,isnull(ScndHldrNmOfFthr ,'') ScndHldrNmOfFthr
,isnull(PANXmptnCd.CDSL_Old_Values ,'') PANXmptnCd
,PAN PAN
,case when isnull(PANVrfyFlg.CDSL_Old_Values ,'')='Not Applicable' then '' else  isnull(PANVrfyFlg.CDSL_Old_Values ,'') end  PANVrfyFlg
,isnull(ITCrcl ,'') ITCrcl
,isnull(Adr1 ,'') Adr1
,isnull(Adr2 ,'')Adr2
,isnull(Adr3 ,'')Adr3
,isnull(Adr4 ,'') Adr4
,CASE WHEN CtrySubDvsnCd <> 'dft' THEN isnull(CtrySubDvsnCd.Meaning ,'') ELSE '' END CtrySubDvsnCd
,CASE WHEN CtrySubDvsnCd <> 'dft' THEN  isnull(Ctry.Meaning ,'') ELSE ''  END  Ctry
,isnull(PstCd ,'') PstCd
,replace(convert(varchar(11),convert(datetime,SetUpDt),103),'/','') 
,replace(convert(varchar(11),convert(datetime,BirthDt),103),'/','')
,isnull(EmailAdr ,'') EmailAdr
,isnull(UID ,'') UID
,''
,''
,''
,''
,''
,''
,''
,''
,''
,ClntId ClntId
,''
,''
,''
,''
,''
,''
,case when isnulL(PRMRYISDCD,'') = 'DFT' then '' else isnulL(PRMRYISDCD,'') end  PRMRYISDCD
,isnull( MOBNB,'') MOBNB
,isnull(CtrySubDvsnCd.CDSL_Old_Values ,'') CtrySubDvsnCd
,isnull(Ctry.CDSL_Old_Values ,'') Ctry
from [CLN_MSTR_CDSL]  
left outer join (select * from standard_value_list PANXmptnCd where  PANXmptnCd.iso_tags ='PANXmptnCd' ) PANXmptnCd on PANXmptnCd=PANXmptnCd.Standard_Value
left outer join (select * from standard_value_list PANVrfyFlg where  PANVrfyFlg.iso_tags ='PANVrfyFlg' ) PANVrfyFlg on PANVrfyFlg=PANVrfyFlg.Standard_Value
left outer join (select * from standard_value_list CtrySubDvsnCd where  CtrySubDvsnCd.iso_tags ='CtrySubDvsnCd' ) CtrySubDvsnCd on CtrySubDvsnCd=CtrySubDvsnCd.Standard_Value
left outer join (select * from standard_value_list Ctry where  Ctry.iso_tags ='Ctry' ) Ctry on Ctry=Ctry.Standard_Value
where PURPSE ='SH' 


--pc3
truncate table dpb9_pc3
insert into dpb9_pc3
select '03' Purpse
,''
,isnull(Titl ,'') Titl
,FrstNm FrstNm
,isnull(MddlNm ,'') MddlNm
,isnull(LastNm ,'') LastNm
,isnull(FSfx ,'') FSfx
,isnull(ScndHldrNmOfFthr ,'') ScndHldrNmOfFthr
,isnull(PANXmptnCd.CDSL_Old_Values ,'') PANXmptnCd
,PAN PAN
,case when isnull(PANVrfyFlg.CDSL_Old_Values ,'')='Not Applicable' then '' else  isnull(PANVrfyFlg.CDSL_Old_Values ,'') end  PANVrfyFlg
,isnull(ITCrcl ,'') ITCrcl
,isnull(Adr1 ,'') Adr1
,isnull(Adr2 ,'')Adr2
,isnull(Adr3 ,'')Adr3
,isnull(Adr4 ,'') Adr4
,CASE WHEN CtrySubDvsnCd <> 'dft' THEN isnull(CtrySubDvsnCd.Meaning ,'') ELSE '' END CtrySubDvsnCd
,CASE WHEN CtrySubDvsnCd <> 'dft' THEN  isnull(Ctry.Meaning ,'') ELSE ''  END  Ctry
,isnull(PstCd ,'') PstCd
,replace(convert(varchar(11),convert(datetime,SetUpDt),103),'/','') 
,replace(convert(varchar(11),convert(datetime,BirthDt),103),'/','')
,isnull(EmailAdr ,'') EmailAdr
,isnull(UID ,'') UID
,''
,''
,''
,''
,''
,''
,''
,''
,''
,ClntId ClntId
,''
,''
,''
,''
,''
,''
,case when isnulL(PRMRYISDCD,'') = 'DFT' then '' else isnulL(PRMRYISDCD,'') end  PRMRYISDCD
,isnull( MOBNB,'') MOBNB
,isnull(CtrySubDvsnCd.CDSL_Old_Values ,'') CtrySubDvsnCd
,isnull(Ctry.CDSL_Old_Values ,'') Ctry
from [CLN_MSTR_CDSL]  
left outer join (select * from standard_value_list PANXmptnCd where  PANXmptnCd.iso_tags ='PANXmptnCd' ) PANXmptnCd on PANXmptnCd=PANXmptnCd.Standard_Value
left outer join (select * from standard_value_list PANVrfyFlg where  PANVrfyFlg.iso_tags ='PANVrfyFlg' ) PANVrfyFlg on PANVrfyFlg=PANVrfyFlg.Standard_Value
left outer join (select * from standard_value_list CtrySubDvsnCd where  CtrySubDvsnCd.iso_tags ='CtrySubDvsnCd' ) CtrySubDvsnCd on CtrySubDvsnCd=CtrySubDvsnCd.Standard_Value
left outer join (select * from standard_value_list Ctry where  Ctry.iso_tags ='Ctry' ) Ctry on Ctry=Ctry.Standard_Value
where PURPSE ='TH' 


--pc5
truncate table dpb9_pc5
insert into dpb9_pc5
select '05'
,''
,POAMstrID POAMstrID
,isnull(POAId ,'') POAId
,replace(convert(varchar(11),convert(datetime,SetUpDt),103) ,'/','')  SetUpDt
,isnull(GPABPAFlg.CDSL_Old_Values ,'') GPABPAFlg
,replace(convert(varchar(11),convert(datetime,FrDt ) ,103) ,'/','')  FrDt
,case when isnull(ToDt ,'')<>'' then replace(convert(varchar(11),convert(datetime,isnull(ToDt ,''))  ,103) ,'/','') else isnull(ToDt ,'') end  ToDt
,isnull(Rmk ,'') Rmk
,convert(numeric,PoaLnkPurpCd.CDSL_Old_Values ) PoaLnkPurpCd
,'A' -- Checked all client 
,ClntId ClntId
,''
from [CLN_MSTR_CDSL] 
left outer join (select * from standard_value_list Purpse where  Purpse.iso_tags ='Purpse' ) Purpse on Purpse=Purpse.Standard_Value
left outer join (select * from standard_value_list GPABPAFlg where  GPABPAFlg.iso_tags ='GPABPAFlg' ) GPABPAFlg on GPABPAFlg=GPABPAFlg.Standard_Value
left outer join (select * from standard_value_list PoaLnkPurpCd where  PoaLnkPurpCd.iso_tags ='PoaLnkPurpCd' ) PoaLnkPurpCd on PoaLnkPurpCd=PoaLnkPurpCd.Standard_Value
where  PURPSE ='POALB' 



--pc6
truncate table dpb9_pc6
insert into dpb9_pc6
SELECT '06' Purpse
,''
,ISNULL(Titl ,'') Titl
,FrstNm FrstNm
,ISNULL(MddlNm ,'') MddlNm
,ISNULL(LastNm ,'') LastNm
,ISNULL(FSfx ,'') FSfx
,ISNULL(ScndHldrNmOfFthr ,'') ScndHldrNmOfFthr
,ISNULL(Adr1 ,'') Adr1
,ISNULL(Adr2 ,'') Adr2
,ISNULL(Adr3 ,'') Adr3
,ISNULL(Adr4 ,'') Adr4
,ISNULL(CtrySubDvsnCd.Meaning ,'') CtrySubDvsnCd
,ISNULL(Ctry.Meaning ,'') Ctry
,ISNULL(PstCd ,'') PstCd
,''
,ISNULL(MobNb ,'') MobNb
,''
,ISNULL(PhneNb ,'') PhneNb
,''
,ISNULL(FaxNb ,'') FaxNb
,ISNULL(PAN ,'') PAN
,ISNULL(ITCrcl ,'') ITCrcl
,ISNULL(EmailAdr ,'')  EmailAdr
,replace(convert(varchar(11),convert(datetime,BirthDt),103),'/','')
,replace(convert(varchar(11),convert(datetime,SetUpDt),103),'/','')
,''
,''
,''
,ISNULL(EmailAdr ,'') EmailAdr
,ISNULL(UID ,'')  UID
,''
,''
,''
,''
,''
,''
,ISNULL(AdrPrefFlg.CDSL_Old_Values ,'')  AdrPrefFlg
,''
,''
,''
,ISNULL(ClntId ,'')  ClntId
,''
,ISNULL(RsdlSecFlg.CDSL_Old_Values ,'') RsdlSecFlg
,ISNULL(SrlNbr ,'') SrlNbr
,ISNULL(RltshWthBnfclOwnr.CDSL_Old_Values ,'') RltshWthBnfclOwnr
,ISNULL(NmneePctgOfShr ,'') NmneePctgOfShr
,ISNULL(CtrySubDvsnCd.CDSL_Old_Values ,'') CtrySubDvsnCd
,ISNULL(Ctry.CDSL_Old_Values ,'')  Ctry
,''
,''
,ISNULL(VrfStsMobNb.CDSL_Old_Values ,'') VrfStsMobNb
,ISNULL(VrfStsEmail.CDSL_Old_Values ,'') VrfStsEmail
,''
,''
,Drl
,Psprt
,''
FROM [CLN_MSTR_CDSL]  
left outer join (select * from standard_value_list CtrySubDvsnCd where  CtrySubDvsnCd.iso_tags ='CtrySubDvsnCd' ) CtrySubDvsnCd on CtrySubDvsnCd=CtrySubDvsnCd.Standard_Value
left outer join (select * from standard_value_list Ctry where  Ctry.iso_tags ='Ctry' ) Ctry on Ctry=Ctry.Standard_Value
left outer join (select * from standard_value_list AdrPrefFlg where  AdrPrefFlg.iso_tags ='AdrPrefFlg' ) AdrPrefFlg on AdrPrefFlg=AdrPrefFlg.Standard_Value
left outer join (select * from standard_value_list RsdlSecFlg where  RsdlSecFlg.iso_tags ='RsdlSecFlg' ) RsdlSecFlg on RsdlSecFlg=RsdlSecFlg.Standard_Value
left outer join (select * from standard_value_list RltshWthBnfclOwnr where  RltshWthBnfclOwnr.iso_tags ='RltshWthBnfclOwnr' ) RltshWthBnfclOwnr on RltshWthBnfclOwnr=RltshWthBnfclOwnr.Standard_Value
left outer join (select * from standard_value_list VrfStsMobNb where  VrfStsMobNb.iso_tags ='VrfStsMobNb' ) VrfStsMobNb on VrfStsMobNb=VrfStsMobNb.Standard_Value
left outer join (select * from standard_value_list VrfStsEmail where  VrfStsEmail.iso_tags ='VrfStsEmail' ) VrfStsEmail on VrfStsEmail=VrfStsEmail.Standard_Value
where PURPSE ='NM'  


--pc7
truncate table dpb9_pc7
insert into dpb9_pc7
SELECT '07' Purpse
,''
,ISNULL(Titl ,'') Titl
,FrstNm FrstNm
,ISNULL(MddlNm ,'') MddlNm
,ISNULL(LastNm ,'') LastNm
,ISNULL(FSfx ,'') FSfx
,ISNULL(ScndHldrNmOfFthr ,'') ScndHldrNmOfFthr
,ISNULL(Adr1 ,'') Adr1
,ISNULL(Adr2 ,'') Adr2
,ISNULL(Adr3 ,'') Adr3
,ISNULL(Adr4 ,'') Adr4
,ISNULL(CtrySubDvsnCd.Meaning ,'') CtrySubDvsnCd
,ISNULL(Ctry.Meaning ,'') Ctry
,ISNULL(PstCd ,'') PstCd
,''
,ISNULL(MobNb ,'') MobNb
,''
,ISNULL(PhneNb ,'') PhneNb
,''
,ISNULL(FaxNb ,'') FaxNb
,ISNULL(PAN ,'') PAN
,ISNULL(ITCrcl ,'') ITCrcl
,ISNULL(EmailAdr ,'')  EmailAdr
,case when BirthDt <> '' then replace(convert(varchar(11),convert(datetime,BirthDt),103),'/','') else '' end 
,case when SetUpDt <> '' then replace(convert(varchar(11),convert(datetime,SetUpDt),103),'/','') else '' end 
,'' 
,''
,''
,ISNULL(EmailAdr ,'') EmailAdr
,ISNULL(UID ,'')  UID
,''
,''
,''
,''
,''
,''
,ISNULL(AdrPrefFlg.CDSL_Old_Values ,'')  AdrPrefFlg
,''
,''
,''
,ISNULL(ClntId ,'')  ClntId
,''
,ISNULL(RsdlSecFlg.CDSL_Old_Values ,'') RsdlSecFlg
,ISNULL(SrlNbr ,'') SrlNbr
,ISNULL(RltshWthBnfclOwnr.CDSL_Old_Values ,'') RltshWthBnfclOwnr
,ISNULL(NmneePctgOfShr ,'') NmneePctgOfShr
,ISNULL(CtrySubDvsnCd.CDSL_Old_Values ,'') CtrySubDvsnCd
,ISNULL(Ctry.CDSL_Old_Values ,'')  Ctry
,''
,''
,ISNULL(VrfStsMobNb.CDSL_Old_Values ,'') VrfStsMobNb
,ISNULL(VrfStsEmail.CDSL_Old_Values ,'') VrfStsEmail
,''
,''
,Drl
,Psprt
,''
--,* 
FROM [CLN_MSTR_CDSL]  
left outer join (select * from standard_value_list CtrySubDvsnCd where  CtrySubDvsnCd.iso_tags ='CtrySubDvsnCd' ) CtrySubDvsnCd on CtrySubDvsnCd=CtrySubDvsnCd.Standard_Value
left outer join (select * from standard_value_list Ctry where  Ctry.iso_tags ='Ctry' ) Ctry on Ctry=Ctry.Standard_Value
left outer join (select * from standard_value_list AdrPrefFlg where  AdrPrefFlg.iso_tags ='AdrPrefFlg' ) AdrPrefFlg on AdrPrefFlg=AdrPrefFlg.Standard_Value
left outer join (select * from standard_value_list RsdlSecFlg where  RsdlSecFlg.iso_tags ='RsdlSecFlg' ) RsdlSecFlg on RsdlSecFlg=RsdlSecFlg.Standard_Value
left outer join (select * from standard_value_list RltshWthBnfclOwnr where  RltshWthBnfclOwnr.iso_tags ='RltshWthBnfclOwnr' ) RltshWthBnfclOwnr on RltshWthBnfclOwnr=RltshWthBnfclOwnr.Standard_Value
left outer join (select * from standard_value_list VrfStsMobNb where  VrfStsMobNb.iso_tags ='VrfStsMobNb' ) VrfStsMobNb on VrfStsMobNb=VrfStsMobNb.Standard_Value
left outer join (select * from standard_value_list VrfStsEmail where  VrfStsEmail.iso_tags ='VrfStsEmail' ) VrfStsEmail on VrfStsEmail=VrfStsEmail.Standard_Value
where PURPSE ='GD'   
 --and SRLNBR = 3


 
--pc8
truncate table dpb9_pc8
insert into dpb9_pc8
SELECT '08' Purpse
,''
,ISNULL(Titl ,'') Titl
,FrstNm FrstNm
,ISNULL(MddlNm ,'') MddlNm
,ISNULL(LastNm ,'') LastNm
,ISNULL(FSfx ,'') FSfx
,ISNULL(ScndHldrNmOfFthr ,'') ScndHldrNmOfFthr
,ISNULL(Adr1 ,'') Adr1
,ISNULL(Adr2 ,'') Adr2
,ISNULL(Adr3 ,'') Adr3
,ISNULL(Adr4 ,'') Adr4
,ISNULL(CtrySubDvsnCd.Meaning ,'') CtrySubDvsnCd
,ISNULL(Ctry.Meaning ,'') Ctry
,ISNULL(PstCd ,'') PstCd
,''
,ISNULL(MobNb ,'') MobNb
,''
,ISNULL(PhneNb ,'') PhneNb
,''
,ISNULL(FaxNb ,'') FaxNb
,ISNULL(PAN ,'') PAN
,ISNULL(ITCrcl ,'') ITCrcl
,ISNULL(EmailAdr ,'')  EmailAdr
,case when BirthDt <> '' then replace(convert(varchar(11),convert(datetime,BirthDt),103),'/','') else '' end 
,case when SetUpDt <> '' then replace(convert(varchar(11),convert(datetime,SetUpDt),103),'/','') else '' end 
,'' 
,''
,''
,ISNULL(EmailAdr ,'') EmailAdr
,ISNULL(UID ,'')  UID
,''
,''
,''
,''
,''
,''
,ISNULL(AdrPrefFlg.CDSL_Old_Values ,'')  AdrPrefFlg
,''
,''
,''
,ISNULL(ClntId ,'')  ClntId
,''
,ISNULL(RsdlSecFlg.CDSL_Old_Values ,'') RsdlSecFlg
,ISNULL(SrlNbr ,'') SrlNbr
,ISNULL(RltshWthBnfclOwnr.CDSL_Old_Values ,'') RltshWthBnfclOwnr
,ISNULL(NmneePctgOfShr ,'') NmneePctgOfShr
,ISNULL(CtrySubDvsnCd.CDSL_Old_Values ,'') CtrySubDvsnCd
,ISNULL(Ctry.CDSL_Old_Values ,'')  Ctry
,''
,''
,ISNULL(VrfStsMobNb.CDSL_Old_Values ,'') VrfStsMobNb
,ISNULL(VrfStsEmail.CDSL_Old_Values ,'') VrfStsEmail
,''
,''
,Drl
,Psprt
,''
--,* 
FROM [CLN_MSTR_CDSL]  
left outer join (select * from standard_value_list CtrySubDvsnCd where  CtrySubDvsnCd.iso_tags ='CtrySubDvsnCd' ) CtrySubDvsnCd on CtrySubDvsnCd=CtrySubDvsnCd.Standard_Value
left outer join (select * from standard_value_list Ctry where  Ctry.iso_tags ='Ctry' ) Ctry on Ctry=Ctry.Standard_Value
left outer join (select * from standard_value_list AdrPrefFlg where  AdrPrefFlg.iso_tags ='AdrPrefFlg' ) AdrPrefFlg on AdrPrefFlg=AdrPrefFlg.Standard_Value
left outer join (select * from standard_value_list RsdlSecFlg where  RsdlSecFlg.iso_tags ='RsdlSecFlg' ) RsdlSecFlg on RsdlSecFlg=RsdlSecFlg.Standard_Value
left outer join (select * from standard_value_list RltshWthBnfclOwnr where  RltshWthBnfclOwnr.iso_tags ='RltshWthBnfclOwnr' ) RltshWthBnfclOwnr on RltshWthBnfclOwnr=RltshWthBnfclOwnr.Standard_Value
left outer join (select * from standard_value_list VrfStsMobNb where  VrfStsMobNb.iso_tags ='VrfStsMobNb' ) VrfStsMobNb on VrfStsMobNb=VrfStsMobNb.Standard_Value
left outer join (select * from standard_value_list VrfStsEmail where  VrfStsEmail.iso_tags ='VrfStsEmail' ) VrfStsEmail on VrfStsEmail=VrfStsEmail.Standard_Value
where PURPSE ='GD'    
  --and SRLNBR = 3


  
--pc12
truncate table dpb9_pc12
insert into dpb9_pc12
select '12'
,''
,isnull(Adr1 ,'') Adr1
,isnull(Adr2 ,'') Adr2
,isnull(Adr3 ,'') Adr3
,isnull(Adr4 ,'') Adr4
,isnull(CtrySubDvsnCd.Meaning ,'') CtrySubDvsnCd
,isnull(Ctry.Meaning ,'') Ctry
,isnull(PstCd ,'') PstCd
,isnull(MobNb ,'') MobNb
,isnull(FaxNb ,'') FaxNb
,isnull(EmailAdr ,'') EmailAdr
,isnull(ClntId ,'') ClntId
,''
,isnull(CtrySubDvsnCd.CDSL_Old_Values ,'') CtrySubDvsnCd
,isnull(Ctry.CDSL_Old_Values ,'') Ctry
from [CLN_MSTR_CDSL]
left outer join (select * from standard_value_list CtrySubDvsnCd where  CtrySubDvsnCd.iso_tags ='CtrySubDvsnCd' ) CtrySubDvsnCd on CtrySubDvsnCd=CtrySubDvsnCd.Standard_Value
left outer join (select * from standard_value_list Ctry where  Ctry.iso_tags ='Ctry' ) Ctry on Ctry=Ctry.Standard_Value
where PURPSE ='FH' and PURPCD ='PERAD' 


--pc18
truncate table dpb9_pc18
insert into dpb9_pc18
select '18'
,''
,isnull(NbOfAuthSgnt ,'') NbOfAuthSgnt
,isnull(FrstNm ,'') FrstNm
,isnull(Rmk,'') 
,ClntId ClntId
,''
,''
,''
,isnull(MobNb ,'') MobNb
,isnull(EmailAdr ,'')EmailAdr
,isnull(UID ,'') UID
,isnull(AdhrAuthntcnWthUID.CDSL_Old_Values ,'') AdhrAuthntcnWthUID
,''
,''
,''
,''
,''
,isnull(MddlNm ,'') MddlNm
,isnull(LastNm ,'') LastNm
from [CLN_MSTR_CDSL] 
left outer join (select * from standard_value_list AdhrAuthntcnWthUID where  AdhrAuthntcnWthUID.iso_tags ='AdhrAuthntcnWthUID' ) AdhrAuthntcnWthUID on AdhrAuthntcnWthUID=AdhrAuthntcnWthUID.Standard_Value

where PURPSE ='AS' 


--pc19
truncate table dpb9_pc19
insert into dpb9_pc19
select '19'
,''
,SignFlNm SignFlNm
,SignStpDt SignStpDt
,ClntId ClntId
,''
from  [CLN_MSTR_CDSL]
where PURPSE ='SGNDT'



--pc22
truncate table dpb9_pc22
insert into dpb9_pc22
select '22'
,''
,''
,isnull(CnsntInd.CDSL_Old_Values ,'') CnsntInd
,isnull(Xchg.CDSL_Old_Values ,'') Xchg
,isnull(UnqClntId ,'') UnqClntId
,ltrim(rtrim(citrus_usr.fn_splitval_by (isnull(Sgmt.CDSL_Old_Values ,''),2,'/'))) Sgmt
,isnull(ClrMmbId ,'') ClrMmbId
,isnull(Brkr ,'') Brkr
,ClntId ClntId
,''
from [CLN_MSTR_CDSL]
left outer join (select * from standard_value_list CnsntInd where  CnsntInd.iso_tags ='CnsntInd' ) CnsntInd on CnsntInd=CnsntInd.Standard_Value
left outer join (select * from standard_value_list Xchg where  Xchg.iso_tags ='Xchg' ) Xchg on Xchg=Xchg.Standard_Value
left outer join (select * from standard_value_list Sgmt where  Sgmt.iso_tags ='Sgmt' ) Sgmt on Sgmt=Sgmt.Standard_Value
where PURPSE ='BOUCC'



end

GO
