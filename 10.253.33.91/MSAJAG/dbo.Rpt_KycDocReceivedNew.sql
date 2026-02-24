-- Object: PROCEDURE dbo.Rpt_KycDocReceivedNew
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*********************************************************************************/

create proc Rpt_KycDocReceivedNew
(@StatusId Varchar(15), @StatusName Varchar(25), @DateFrom Varchar(11), @DateTo Varchar(11), @ClientType varchar(3),  @FromParty_code Varchar(10) ,@ToParty_code Varchar(10),
@strOrderBy varchar(1) )

as
Declare 
@StrPartyCode Varchar(12),
@StrPartyName Varchar(100),
@StrClType Varchar(3),

@DocCode Varchar(10),
@DocName Varchar(100),
@DocStatus varchar(1)

if (@ClientType) = 'ALL'
Begin
	Select @ClientType= '%' 
End	

if len(@FromParty_code) = 0 
Begin
	Select @FromParty_code=Min(Party_Code), @ToParty_code = Max(Party_Code) From Client2 
End	

select party_code,long_name,c1.cl_status 
into #tmpParty
from client2 C2,client1 c1,client5 c5
where c2.cl_code = c1.cl_code
and  c2.cl_code = c5.cl_code
and  c5.cl_code = c1.cl_code
and c5.activefrom >= @DateFrom
and c5.activefrom <= @DateTo
and cl_status like @ClientType
and C1.Branch_Cd Like (Case When @StatusId = 'branch' Then @statusname else '%' End)
and C1.sub_broker Like (Case When @StatusId = 'subbroker' Then @statusname else '%' End)
and C1.trader Like (Case When @StatusId = 'trader' Then @statusname else '%' End)
and C1.family Like (Case When @StatusId = 'family' Then @statusname else '%' End)
and C2.party_code Like (Case When @StatusId = 'client' Then @statusname else '%' End) 
and c2.party_code >= @FromParty_code
and c2.party_code <= @ToParty_code

if (@strOrderBy) ='1'
	begin	
--		Select d.doc_cd, long_nm , tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name, ky.remarks
		select tmp.party_code, tmp.long_name, ky.remarks, tmp.cl_status as ctgry_code

		from document d , kyc_master ky ,#tmpParty tmp
		where d.doc_cd = ky.doc_cd 
		and d.stat <> 'D' 
		and tmp.party_code = ky.party_code
		and doc_completed = 'Y'
		group by tmp.cl_status, tmp.party_code, tmp.long_name, ky.remarks
		order by tmp.party_code
	end

if (@strOrderBy) ='2'
	begin	

--		Select d.doc_cd, long_nm , tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name,ky.REMARKS 
		select tmp.party_code, tmp.long_name, ky.remarks, tmp.cl_status as ctgry_code
		from document d , kyc_master ky ,#tmpParty tmp
		where d.doc_cd = ky.doc_cd 
		and d.stat <> 'D' 
		and tmp.party_code = ky.party_code
		and doc_completed = 'Y'
		group by tmp.cl_status, tmp.party_code, tmp.long_name, ky.remarks
--		order by d.doc_cd
	end

GO
