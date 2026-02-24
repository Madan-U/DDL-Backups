-- Object: PROCEDURE dbo.PAYOUT_RELEASE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

---PAYOUT_RELEASE 

create proc PAYOUT_RELEASE AS 
BEGIN 
SELECT DISTINCT
Party_Code=A.Party_Code,
scrip_cd=A.Scrip_CD,
CertNo=A.CertNo,
ReqQty=ReqQty,
BCltDpId=B.BCltDpId,
DpId=B.DpId,
EXCHANGE='NSE'           


FROM [ANGELDEMAT].MSAJAG.DBO.DelBranchMark_new A,[ANGELDEMAT].MSAJAG.DBO.Deltrans B
where ReqQty<>0   AND A.CertNo=B.CertNo AND A.Scrip_CD=B.scrip_cd
AND A.Party_Code=B.Party_Code AND DrCr='D'AND Delivered='0'AND Filler2='1'
union all
SELECT DISTINCT
Party_Code=A.Party_Code,
scrip_cd=A.Scrip_CD,
CertNo=A.CertNo,
ReqQty=ReqQty,
BCltDpId=B.BCltDpId,
DpId=B.DpId,
EXCHANGE='BSE' 
 from [ANGELDEMAT].MSAJAG.DBO.DelBranchMark_new A,[ANGELDEMAT].BSEDB.DBO.Deltrans B
where ReqQty<>0   AND A.CertNo=B.CertNo AND A.Scrip_CD=B.scrip_cd
AND A.Party_Code=B.Party_Code AND DrCr='D'AND Delivered='0'AND Filler2='1'
END

GO
