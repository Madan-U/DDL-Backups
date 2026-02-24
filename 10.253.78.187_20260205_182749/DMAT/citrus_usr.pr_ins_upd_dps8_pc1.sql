-- Object: PROCEDURE citrus_usr.pr_ins_upd_dps8_pc1
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

 
create proc [citrus_usr].[pr_ins_upd_dps8_pc1]
as
begin 
update s8 set  s8.Title=b9.Title
,s8.Name=b9.Name
,s8.MiddleName=b9.MiddleName
,s8.SearchName=b9.SearchName
,s8.Suffix=b9.Suffix
,s8.FthName=b9.FthName
,s8.Addr1=b9.Addr1
,s8.Addr2=b9.Addr2
,s8.Addr3=b9.Addr3
,s8.City=b9.City
,s8.State=b9.State
,s8.Country=b9.Country
,s8.PinCode=b9.PinCode
,s8.PriPhInd=b9.PriPhInd
,s8.PriPhNum=b9.PriPhNum
,s8.AltPhInd=b9.AltPhInd
,s8.AltPhNum=b9.AltPhNum
,s8.AddPh=b9.AddPh
,s8.Fax=b9.Fax
,s8.PANExCode=b9.PANExCode
,s8.PANGIR=b9.PANGIR
,s8.PANVerCode=b9.PANVerCode
,s8.ITCircle=b9.ITCircle
,s8.EMailId=b9.EMailId
,s8.UsrTxt1=b9.UsrTxt1
,s8.UsrTxt2=b9.UsrTxt2
,s8.UsrFld3=b9.UsrFld3
,s8.BOAcctStatus=b9.BOAcctStatus
,s8.FrzSusFlg=b9.FrzSusFlg
,s8.BOCategory=b9.BOCategory
,s8.BOCustType=b9.BOCustType
,s8.BOSubStatus=b9.BOSubStatus
,s8.ProdCode=b9.ProdCode
,s8.ClCorpId=b9.ClCorpId
,s8.ClMemId=b9.ClMemId
,s8.StockExch=b9.StockExch
,s8.TradingId=b9.TradingId
,s8.BOStatCycleCd=b9.BOStatCycleCd
,s8.AcctCreatDt=b9.AcctCreatDt
,s8.DPIntRefNum=b9.DPIntRefNum
,s8.ConfWaived=b9.ConfWaived
,s8.DateOfBirth=b9.DateOfBirth
,s8.BOActDt=b9.BOActDt
,s8.EletConf=b9.EletConf
,s8.ECS=b9.ECS
,s8.DivBankAcctNo=b9.DivBankAcctNo
,s8.DivBankCd=b9.DivBankCd
,s8.DivIFScd=b9.DivIFScd
,s8.DivBankCurr=b9.DivBankCurr
,s8.DivAcctType=b9.DivAcctType
,s8.AnnIncomeCd=b9.AnnIncomeCd
,s8.BenTaxDedStat=b9.BenTaxDedStat
,s8.BOSettPlanFlg=b9.BOSettPlanFlg
,s8.Edu=b9.Edu
,s8.GeogCd=b9.GeogCd
,s8.GroupCd=b9.GroupCd
,s8.LangCd=b9.LangCd
,s8.NatCd=b9.NatCd
,s8.Occupation=b9.Occupation
,s8.SecAccCd=b9.SecAccCd
,s8.SexCd=b9.SexCd
,s8.Staff=b9.Staff
,s8.StaffCd=b9.StaffCd
,s8.RBIRefNum=b9.RBIRefNum
,s8.RBIAppDt=b9.RBIAppDt
,s8.SEBIRegNum=b9.SEBIRegNum
,s8.ClosAppDt=b9.ClosAppDt
,s8.ClosDt=b9.ClosDt
,s8.TransBOId=b9.TransBOId
,s8.BalTrans=b9.BalTrans
,s8.ClosResCd=b9.ClosResCd
,s8.ClosInitBy=b9.ClosInitBy
,s8.ClosRemark=b9.ClosRemark
,s8.UnqIdenNum=b9.UnqIdenNum
,s8.Filler1=b9.Filler1
,s8.Filler2=b9.Filler2
,s8.Filler3=b9.Filler3
,s8.Filler4=b9.Filler4
,s8.Filler5=b9.Filler5
,s8.AnnlRep=b9.AnnlRep
,s8.Filler6=b9.Filler6
,s8.Filler7=b9.Filler7
,s8.Filler8=b9.Filler8
,s8.Filler9=b9.Filler9
,s8.mSTRPOAFLG=b9.mSTRPOAFLG
,s8.FAMILYACCTFLG=b9.FAMILYACCTFLG
,s8.CUSTODIANEMAILID=b9.CUSTODIANEMAILID
,s8.AFILLER1=b9.AFILLER1
,s8.AFILLER2=b9.AFILLER2
,s8.AFILLER3=b9.AFILLER3
,s8.AFILLER4=b9.AFILLER4
,s8.AFILLER5=b9.AFILLER5
,s8.TransSystemDate=b9.TransSystemDate
,s8.statecode=b9.statecode
,s8.countrycode=b9.countrycode
,s8.isd_pri=b9.isd_pri
,s8.isd_sec=b9.isd_sec
,s8.AFILLER6=b9.AFILLER6
,s8.AFILLER7=b9.AFILLER7
,s8.AFILLER8=b9.AFILLER8
,s8.AFILLER9=b9.AFILLER9
,s8.AFILLER10=b9.AFILLER10
,s8.smart_flag=b9.smart_flag
,s8.pri_email=b9.pri_email
,s8.sec_email=b9.sec_email
,s8.NOMINATION_OPT_OUT=b9.NOMINATION_OPT_OUT
,s8.NOMINATION_opt_dt=b9.NOMINATION_opt_dt
,s8.COMM_PREFER=b9.COMM_PREFER
from dps8_pc1 s8 , dpb9_pc1 b9 
where  s8.BOID =  b9.BOID 

insert into dps8_pc1(PurposeCode1,TypeOfTrans,Title,Name,MiddleName
,SearchName,Suffix,FthName,Addr1,Addr2,Addr3,City,State,Country,PinCode,PriPhInd,PriPhNum,AltPhInd,AltPhNum,AddPh,Fax
,PANExCode,PANGIR,PANVerCode,ITCircle,EMailId,UsrTxt1,UsrTxt2,UsrFld3,BOAcctStatus,FrzSusFlg,BOCategory,BOCustType,BOSubStatus
,ProdCode,ClCorpId,ClMemId,StockExch,TradingId,BOStatCycleCd,AcctCreatDt,DPIntRefNum,ConfWaived,DateOfBirth,BOActDt,EletConf
,ECS,DivBankAcctNo,DivBankCd,DivIFScd,DivBankCurr,DivAcctType,AnnIncomeCd,BenTaxDedStat,BOSettPlanFlg,Edu,GeogCd
,GroupCd,LangCd,NatCd,Occupation,SecAccCd,SexCd,Staff,StaffCd,RBIRefNum,RBIAppDt,SEBIRegNum,ClosAppDt,ClosDt,TransBOId,BalTrans
,ClosResCd,ClosInitBy,ClosRemark,UnqIdenNum,Filler1,Filler2,Filler3,Filler4,Filler5,AnnlRep,Filler6,Filler7,Filler8,Filler9,mSTRPOAFLG,FAMILYACCTFLG
,CUSTODIANEMAILID,AFILLER1,AFILLER2,AFILLER3,AFILLER4,AFILLER5,BOId,TransSystemDate,statecode,countrycode,isd_pri,isd_sec,AFILLER6
,AFILLER7,AFILLER8,AFILLER9,AFILLER10,smart_flag,pri_email,sec_email,NOMINATION_OPT_OUT,NOMINATION_opt_dt,COMM_PREFER)
select PurposeCode1,TypeOfTrans,Title,Name,MiddleName
,SearchName,Suffix,FthName,Addr1,Addr2,Addr3,City,State,Country,PinCode,PriPhInd,PriPhNum,AltPhInd,AltPhNum,AddPh,Fax
,PANExCode,PANGIR,PANVerCode,ITCircle,EMailId,UsrTxt1,UsrTxt2,UsrFld3,BOAcctStatus,FrzSusFlg,BOCategory,BOCustType,BOSubStatus
,ProdCode,ClCorpId,ClMemId,StockExch,TradingId,BOStatCycleCd,AcctCreatDt,DPIntRefNum,ConfWaived,DateOfBirth,BOActDt,EletConf
,ECS,DivBankAcctNo,DivBankCd,DivIFScd,DivBankCurr,DivAcctType,AnnIncomeCd,BenTaxDedStat,BOSettPlanFlg,Edu,GeogCd
,GroupCd,LangCd,NatCd,Occupation,SecAccCd,SexCd,Staff,StaffCd,RBIRefNum,RBIAppDt,SEBIRegNum,ClosAppDt,ClosDt,TransBOId,BalTrans
,ClosResCd,ClosInitBy,ClosRemark,UnqIdenNum,Filler1,Filler2,Filler3,Filler4,Filler5,AnnlRep,Filler6,Filler7,Filler8,Filler9,mSTRPOAFLG,FAMILYACCTFLG
,CUSTODIANEMAILID,AFILLER1,AFILLER2,AFILLER3,AFILLER4,AFILLER5,BOId,TransSystemDate,statecode,countrycode,isd_pri,isd_sec,AFILLER6
,AFILLER7,AFILLER8,AFILLER9,AFILLER10,smart_flag,pri_email,sec_email,NOMINATION_OPT_OUT,NOMINATION_opt_dt,COMM_PREFER
from dpb9_pc1 b9 where  not exists(SELECT BOID FROM DPS8_PC1 s8 WHERE s8.BOID = b9.boid)   

end

GO
