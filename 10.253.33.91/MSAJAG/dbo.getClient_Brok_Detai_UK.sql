-- Object: PROCEDURE dbo.getClient_Brok_Detai_UK
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*
EXEC MSAJAG.DBO.getClient_Brok_Detail '','',''
*/


CREATE Proc getClient_Brok_Detai_UK          
(@PartyCode varchar(12),                        
@Exchange varchar(3),                        
@Segment varchar(20))                        
 AS                                        
                                  
set transaction isolation level read uncommitted                                   
                                        
if @PartyCode <> ''                                         
 begin                                               
                        
   if @Exchange=''                        
   Begin                        
     Select m.Exchange as exchange1, m.Segment as segment1,                                
       isnull(c.Cl_code,'') ClCode, isnull(c.Fut_Brok,0) Fut_Brok1,convert(varchar,Active_Date,103) Active_Date1,                              
       convert(varchar,GetDate(),103) Trd_Eff_Dt1 , convert(varchar,GetDate(),103) Del_Eff_Dt1,                              
       convert(varchar,InActive_From,103) InActive_From1,convert(varchar,GetDate(),103) Brok_Eff_Date1 ,                                      
       isnull(c.Fut_Opt_Brok,0) Fut_Opt_Brok1,isnull(c.Fut_Fut_Fin_Brok,0) Fut_Fut_Fin_Brok1,isnull(c.Fut_Opt_Exc,0) Fut_Opt_Exc1,                                      
       isnull(c.Fut_Brok_Applicable,0) Fut_Brok_Applicable1,isnull(c.Fut_Stt,1) Fut_Stt1,isnull(c.Fut_Tran_Chrgs,1) Fut_Tran_Chrgs1,                                      
       isnull(c.Fut_SEBI_Fees,1) Fut_SEBI_Fees1,isnull(c.Fut_Stamp_Duty,1) Fut_Stamp_Duty1,isnull(c.Fut_Other_Chrgs,0) Fut_Other_Chrgs1,*,                                         
       isnull(c.Brok_Scheme,0)Brok_Scheme1                                    
     From                        
     pradnya.dbo.multicompany m                         
     Left Join                         
    (select * from client_brok_details (Nolock)                               
       Where Cl_code =@PartyCode) C                        
     on (m.exchange=c.exchange and m.segment=c.segment)                          
      Where primaryserver = 1                        
      Order By M.FLDSRNO,2,1 desc                        
   End                        
  Else                        
   Begin                        
     Select @Exchange as exchange1, @Segment as segment1,                                
       isnull(c.Cl_code,'') ClCode, isnull(c.Fut_Brok,0) Fut_Brok1,convert(varchar,Active_Date,103) Active_Date1,                              
       convert(varchar,GetDate(),103) Trd_Eff_Dt1 , convert(varchar,GetDate(),103) Del_Eff_Dt1,                              
       convert(varchar,InActive_From,103) InActive_From1,convert(varchar,GetDate(),103) Brok_Eff_Date1 ,       
       isnull(c.Fut_Opt_Brok,0) Fut_Opt_Brok1,isnull(c.Fut_Fut_Fin_Brok,0) Fut_Fut_Fin_Brok1,isnull(c.Fut_Opt_Exc,0) Fut_Opt_Exc1,                                      
       isnull(c.Fut_Brok_Applicable,0) Fut_Brok_Applicable1,isnull(c.Fut_Stt,1) Fut_Stt1,isnull(c.Fut_Tran_Chrgs,1) Fut_Tran_Chrgs1,                                      
       isnull(c.Fut_SEBI_Fees,1) Fut_SEBI_Fees1,isnull(c.Fut_Stamp_Duty,1) Fut_Stamp_Duty1,isnull(c.Fut_Other_Chrgs,0) Fut_Other_Chrgs1,*,                                         
       isnull(c.Brok_Scheme,0)Brok_Scheme1     
     From client_brok_details c  with(Index(ClientIdx), Nolock)                    
     Where C.Cl_Code = @PartyCode                          
     and c.Exchange = @Exchange  and c.Segment = @Segment                         
      Order By 2,1 desc            
                  
   End                        
 end                                        
else                                        
 begin                                        
                                        
   Select upper(Ltrim(RTrim(m.exchange))) as exchange1, Upper(LTrim(RTrim(m.segment))) as segment1,                                
        isnull(c.Cl_code,'') ClCode,isnull(c.Fut_Brok,0) Fut_Brok1,convert(varchar,Active_Date,103) Active_Date1,              
        convert(varchar,GetDate(),103) Trd_Eff_Dt1 , convert(varchar,GetDate(),103) Del_Eff_Dt1,                              
       convert(varchar,InActive_From,103) InActive_From1, convert(varchar,GetDate(),103) Brok_Eff_Date1,                                     
       isnull(c.Fut_Opt_Brok,0) Fut_Opt_Brok1,isnull(c.Fut_Fut_Fin_Brok,0) Fut_Fut_Fin_Brok1,isnull(c.Fut_Opt_Exc,0) Fut_Opt_Exc1,                                      
       isnull(c.Fut_Brok_Applicable,0) Fut_Brok_Applicable1,isnull(c.Fut_Stt,1) Fut_Stt1,isnull(c.Fut_Tran_Chrgs,1) Fut_Tran_Chrgs1,                                      
       isnull(c.Fut_SEBI_Fees,1) Fut_SEBI_Fees1,isnull(c.Fut_Stamp_Duty,1) Fut_Stamp_Duty1,isnull(c.Fut_Other_Chrgs,0) Fut_Other_Chrgs1,*,                                         
       isnull(c.Brok_Scheme,0)Brok_Scheme1     
    From                        
     pradnya.dbo.multicompany m                         
     Left Join                         
    (select * from client_brok_details                                
     Where Cl_code ='') C                        
     on (m.exchange=c.exchange and m.segment=c.segment)                          
        Where primaryserver = 1                        
      Order By M.FLDSRNO,2,1 desc            
 end

GO
