-- Object: PROCEDURE dbo.Rpt_KycDocReceived
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Rpt_KycDocReceived    Script Date: 02/21/2005 20:51:05 ******/    
CREATE proc Rpt_KycDocReceived    
(@StatusId Varchar(15), @StatusName Varchar(25), @DateFrom Varchar(11), @DateTo Varchar(11), @ClientType varchar(3),  @FromParty_code Varchar(10) ,@ToParty_code Varchar(10),    
@strOrderBy varchar(1) ,@Exchange varchar(3),@Segment Varchar(7) )        
    
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
    
    
if (@strOrderBy) ='1'    
 begin     
    
  Select d.doc_cd, long_nm , tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name,ky.REMARKS     
  from document d , kyc_master ky ,#tmpParty tmp    
  where d.doc_cd = ky.doc_cd     
  and d.stat <> 'D'     
  and tmp.party_code = ky.party_code    
  and doc_completed = 'Y'   
  and ky.Exchange = @Exchange     
  and ky.Segment = @Segment   
  order by tmp.party_code    
 end    
    
if (@strOrderBy) ='2'    
 begin     
    
  Select d.doc_cd, long_nm , tmp.cl_status as ctgry_code,tmp.party_code,tmp.long_name,ky.REMARKS     
  from document d , kyc_master ky ,#tmpParty tmp    
  where d.doc_cd = ky.doc_cd     
  and d.stat <> 'D'     
  and ky.Exchange = @Exchange     
  and ky.Segment = @Segment  
  and tmp.party_code = ky.party_code    
  and doc_completed = 'Y'    
  order by d.doc_cd    
 end

GO
