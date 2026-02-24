-- Object: PROCEDURE dbo.rpt_KycDocPending
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_KycDocPending    Script Date: 02/21/2005 20:51:08 ******/        
CREATE proc rpt_KycDocPending        
(@StatusId Varchar(15), @StatusName Varchar(25), @DateFrom Varchar(11), @DateTo Varchar(11), @ClientType varchar(3),  @FromParty_code Varchar(10) ,@ToParty_code Varchar(10),        
@strOrderBy varchar(1),@Exchange varchar(3),@Segment Varchar(7) )        
        
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
 Select @FromParty_code='0', @ToParty_code = 'ZZZZZZZZZZ'         
End         
        
select CD.cl_code party_code,long_name,cl_status         
into #tmpParty        
 from client_details CD,Client_Brok_Details CBD        
where CD.cl_code = CBD.cl_code        
and CBD.active_Date >= @DateFrom        
and CBD.active_Date <= @DateTo        
and CD.cl_status like @ClientType        
and CD.Branch_Cd Like (Case When @StatusId = 'branch' Then @statusname else '%' End)        
and CD.sub_broker Like (Case When @StatusId = 'subbroker' Then @statusname else '%' End)        
and CD.trader Like (Case When @StatusId = 'trader' Then @statusname else '%' End)        
and CD.family Like (Case When @StatusId = 'family' Then @statusname else '%' End)        
and CD.cl_code Like (Case When @StatusId = 'client' Then @statusname else '%' End)         
and CD.cl_code >= @FromParty_code        
and CD.cl_code <= @ToParty_code      
and CBD.Exchange = @Exchange         
and CBD.Segment = @Segment          
  
if (@strOrderBy) =  '1'        
 begin        
  select dc.doc_cd,long_nm,/*min(dc.ctgry_code)*/ tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name,mandatory_flg,ky.REMARKS        
  from document d,doc_ctgry dc,#tmpParty tmp, kyc_master ky         
  where d.doc_cd = dc.doc_cd         
  and d.stat <> 'D' and dc.stat <> 'D'        
  and mandatory_flg in ('Y','N')        
  AND dc.ctgry_code =tmp.cl_status        
  and dc.effective_dateto like 'DEC 31 2049%'  
  and (doc_completed = 'N' or doc_completed is null)        
  and tmp.party_code = ky.party_code        
  and tmp.cl_status = ky.ctgry_code      
  and ky.Exchange = @Exchange       
  and ky.Segment = @Segment
  group by dc.doc_cd,long_nm,tmp.party_code,tmp.long_name,tmp.cl_status,mandatory_flg,ky.REMARKS        
  /*order by tmp.party_code */        
  union all         
  Select dc.doc_cd,long_nm,tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name,mandatory_flg,ky.REMARKS        
  from document d,doc_ctgry dc,#tmpParty tmp, kyc_master ky         
  where d.doc_cd = dc.doc_cd and mandatory_flg in ('Y','N')       
  and d.stat <>'D'         
  AND dc.ctgry_code = 'ALL'         
  and effective_dateto >= getdate()        
  And dc.doc_cd not in ( select c.doc_cd from doc_ctgry c where         
  c.doc_cd = dc.doc_cd and c.mandatory_flg in ('Y','N')     
  AND c.ctgry_code =tmp.cl_status        
  and c.effective_dateto like 'DEC 31 2049%' )        
  and (doc_completed = 'N' or doc_completed is null)        
  and tmp.party_code = ky.party_code      
  and ky.Exchange = @Exchange        
  and ky.Segment = @Segment
  group by dc.doc_cd,long_nm,tmp.party_code,tmp.long_name,tmp.cl_status,mandatory_flg,ky.REMARKS        
  order by tmp.party_code         
        
        
 end        
        
        
if (@strOrderBy) =  '2'        
 begin        
  select dc.doc_cd,long_nm,/*min(dc.ctgry_code)*/ tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name ,mandatory_flg,ky.REMARKS        
  from document d,doc_ctgry dc,#tmpParty tmp left outer join kyc_master ky         
  on (tmp.party_code = ky.party_code        
  and tmp.cl_status = ky.ctgry_code      
  and ky.Exchange = @Exchange        
  and ky.Segment = @Segment)         
  where d.doc_cd = dc.doc_cd         
  and d.stat <> 'D' and dc.stat <> 'D'        
  and mandatory_flg in ('Y','N')     
  AND dc.ctgry_code =tmp.cl_status        
  and dc.effective_dateto like 'DEC 31 2049%'        
  and (doc_completed = 'N' or doc_completed is null)        
  group by dc.doc_cd,long_nm,tmp.party_code,tmp.long_name,tmp.cl_status,mandatory_flg,ky.REMARKS        
  union all         
  Select dc.doc_cd,long_nm,tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name,mandatory_flg,ky.REMARKS        
  from document d,doc_ctgry dc,#tmpParty tmp left outer join kyc_master ky         
  on (tmp.party_code = ky.party_code      
  and ky.Exchange = @Exchange        
  and ky.Segment = @Segment)          
  where d.doc_cd = dc.doc_cd and mandatory_flg in ('Y','N')  
  and d.stat <>'D'         
  AND dc.ctgry_code = 'ALL'         
  and effective_dateto >= getdate()        
  And dc.doc_cd not in ( select c.doc_cd from doc_ctgry c where         
  c.doc_cd = dc.doc_cd and c.mandatory_flg in ('Y','N')  
  AND c.ctgry_code =tmp.cl_status        
  and c.effective_dateto like 'DEC 31 2049%' )        
  and (doc_completed = 'N' or doc_completed is null)        
  group by dc.doc_cd,long_nm,tmp.party_code,tmp.long_name,tmp.cl_status,mandatory_flg,ky.REMARKS        
  order by dc.doc_cd        
        
 end

GO
