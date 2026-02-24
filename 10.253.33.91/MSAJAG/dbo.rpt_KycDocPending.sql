-- Object: PROCEDURE dbo.rpt_KycDocPending
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create proc rpt_KycDocPending
(@StatusId Varchar(15), @StatusName Varchar(25), @DateFrom Varchar(11), @DateTo Varchar(11), @ClientType varchar(3),  @FromParty_code Varchar(10) ,@ToParty_code Varchar(10),
@strOrderBy varchar(1) )

as
Declare 
@StrPartyCode Varchar(12),
@StrPartyName Varchar(100),
@StrClType Varchar(3),

@DocCode Varchar(10),
@DocName Varchar(100),
@DocStatus varchar(1),


@@PartyCur Cursor

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


if (@strOrderBy) =  '1'
	begin
		select dc.doc_cd,long_nm,/*min(dc.ctgry_code)*/ tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name,mandatory_flg,ky.REMARKS
		from document d,doc_ctgry dc,#tmpParty tmp left outer join kyc_master ky 
		on (tmp.party_code = ky.party_code
		and tmp.cl_status = ky.ctgry_code)
		where d.doc_cd = dc.doc_cd 
		and d.stat <> 'D' and dc.stat <> 'D'
		and mandatory_flg in ('M','O')
		AND dc.ctgry_code =tmp.cl_status
		and dc.effective_dateto like 'DEC 31 2049%'
		and (doc_completed = 'N' or doc_completed is null)
		group by dc.doc_cd,long_nm,tmp.party_code,tmp.long_name,tmp.cl_status,mandatory_flg,ky.REMARKS
		/*order by tmp.party_code */
		union all 
		Select dc.doc_cd,long_nm,tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name,mandatory_flg,ky.REMARKS
		from document d,doc_ctgry dc,#tmpParty tmp left outer join kyc_master ky 
		on (tmp.party_code = ky.party_code) 
		where d.doc_cd = dc.doc_cd and mandatory_flg in ('M','O') 
		and d.stat <>'D' 
		AND dc.ctgry_code = 'ALL' 
		and effective_dateto >= getdate()
		And dc.doc_cd not in ( select c.doc_cd from doc_ctgry c where 
		c.doc_cd = dc.doc_cd and c.mandatory_flg in ('M','O') 
		AND c.ctgry_code =tmp.cl_status
		and c.effective_dateto like 'DEC 31 2049%' )
		and (doc_completed = 'N' or doc_completed is null)
		group by dc.doc_cd,long_nm,tmp.party_code,tmp.long_name,tmp.cl_status,mandatory_flg,ky.REMARKS
		order by tmp.party_code 


	end


if (@strOrderBy) =  '2'
	begin
		select dc.doc_cd,long_nm,/*min(dc.ctgry_code)*/ tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name ,mandatory_flg,ky.REMARKS
		from document d,doc_ctgry dc,#tmpParty tmp left outer join kyc_master ky 
		on (tmp.party_code = ky.party_code
		and tmp.cl_status = ky.ctgry_code)
		where d.doc_cd = dc.doc_cd 
		and d.stat <> 'D' and dc.stat <> 'D'
		and mandatory_flg in ('M','O')
		AND dc.ctgry_code =tmp.cl_status
		and dc.effective_dateto like 'DEC 31 2049%'
		and (doc_completed = 'N' or doc_completed is null)
		group by dc.doc_cd,long_nm,tmp.party_code,tmp.long_name,tmp.cl_status,mandatory_flg,ky.REMARKS
		union all 
		Select dc.doc_cd,long_nm,tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name,mandatory_flg,ky.REMARKS
		from document d,doc_ctgry dc,#tmpParty tmp left outer join kyc_master ky 
		on (tmp.party_code = ky.party_code) 
		where d.doc_cd = dc.doc_cd and mandatory_flg in ('M','O') 
		and d.stat <>'D' 
		AND dc.ctgry_code = 'ALL' 
		and effective_dateto >= getdate()
		And dc.doc_cd not in ( select c.doc_cd from doc_ctgry c where 
		c.doc_cd = dc.doc_cd and c.mandatory_flg in ('M','O') 
		AND c.ctgry_code =tmp.cl_status
		and c.effective_dateto like 'DEC 31 2049%' )
		and (doc_completed = 'N' or doc_completed is null)
		group by dc.doc_cd,long_nm,tmp.party_code,tmp.long_name,tmp.cl_status,mandatory_flg,ky.REMARKS
		order by dc.doc_cd

	end

GO
