-- Object: PROCEDURE dbo.Stt_rounding_further
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Stt_rounding_further (@sett_type Varchar(2), @sauda_date Varchar(11), @fromparty Varchar(10), @toparty Varchar(10))  
As  
  
Declare @sttcur Cursor,  
@diff Numeric(18,4),  
@party_code Varchar(10),  
@contractno Varchar(7)  
  
Declare @settcur Cursor,  
@order_no Varchar(16),  
@trade_no Varchar(14),  
@scrip_cd Varchar(12),  
@ins_chrg Numeric(18,4)  
  
Select Sett_type, Party_code, Contractno, Total = Sum(ins_chrg), Actual = Round(sum(ins_chrg),0)   
Into #sett From STT_SETT_TABLE With(index(stt_index))
Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
And STT_SETT_TABLE.party_code Not In ( Select Newparty_code From Partymapping )  
Group By Sett_type, Party_code, Contractno  
Having Sum(ins_chrg) <> Round(sum(ins_chrg),0)  
  
Set @sttcur = Cursor For  
Select Party_code, Contractno, Diff = Total - Actual From #sett  
Order By Party_code, Contractno  
Open @sttcur  
Fetch Next From @sttcur Into @party_code, @contractno, @diff  
While @@fetch_status = 0 --1  
Begin  
 Set @settcur = Cursor For  
 Select Scrip_cd, Order_no, Trade_no, Ins_chrg From STT_SETT_TABLE    
 Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
 And Party_code = @party_code And Contractno = @contractno  
 And Ins_chrg > 0   
 Order By Ins_chrg Desc  
 Open @settcur  
 Fetch Next From @settcur Into @scrip_cd, @order_no, @trade_no, @ins_chrg  
 While @@fetch_status = 0 And @diff <> 0 --2  
 Begin  
  If @diff < 0   
  Begin  
   Update STT_SETT_TABLE Set Ins_chrg = Ins_chrg + Abs(@diff)  
	 From STT_SETT_TABLE With(index(stt_index))
   Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
   And Party_code = @party_code And Contractno = @contractno  
   And Ins_chrg > 0 And Scrip_cd = @scrip_cd And Order_no = @order_no   
    And Trade_no = @trade_no  
   Select @diff = 0   
  End  
 Else  
   Begin  
   If @diff >= @ins_chrg   
   Begin  
    Update STT_SETT_TABLE Set Ins_chrg = 0  
    From STT_SETT_TABLE With(index(stt_index))
    Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
    And Party_code = @party_code And Contractno = @contractno  
     And Ins_chrg > 0 And Scrip_cd = @scrip_cd And Order_no = @order_no   
     And Trade_no = @trade_no  
    Select @diff = @diff - @ins_chrg   
   End   
    Else  
   Begin  
    Update STT_SETT_TABLE Set Ins_chrg = @ins_chrg - @diff  
	  From STT_SETT_TABLE With(index(stt_index))
    Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
    And Party_code = @party_code And Contractno = @contractno  
     And Ins_chrg > 0 And Scrip_cd = @scrip_cd And Order_no = @order_no   
     And Trade_no = @trade_no  
    Select @diff = 0  
   End      
   End   
   Fetch Next From @settcur Into @scrip_cd, @order_no, @trade_no, @ins_chrg   
 End  
 Close @settcur  
 Deallocate @settcur  
 Fetch Next From @sttcur Into @party_code, @contractno, @diff  
End  
Close @sttcur  
Deallocate @sttcur

GO
