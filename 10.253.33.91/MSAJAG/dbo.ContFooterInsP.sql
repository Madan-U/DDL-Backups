-- Object: PROCEDURE dbo.ContFooterInsP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.ContFooterInsP    Script Date: 11/07/2001 8:47:55 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterInsP    Script Date: 09/07/2001 11:08:52 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterInsP    Script Date: 7/1/01 2:26:22 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterInsP    Script Date: 06/26/2001 8:47:49 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterInsP    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterInsP    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterInsP    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterInsP    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterInsP    Script Date: 12/27/00 8:58:48 PM ******/

CREATE proc ContFooterInsP (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6), @sell_buy varchar(1),@flag smallint) as
if @flag = 1 
begin
  select Qty =isnull( sum(qty),0), Amount =isnull( sum(Amount),0), Brokerage =isnull( sum(brokerage),0), Ser = isnull(sum(ser),0) from contFootPSIns where 
  rtrim(sett_type) = @sett_type
  and sauda_date like  @sdate + '%'
  and (convert(int,contractno) = @contno )
  and sell_buy = @sell_buy
end
else if @flag = 2 
begin
  select Qty =isnull( sum(qty),0), Amount =isnull( sum(amount),0), Brokerage =isnull( sum(brokerage),0), Ser = isnull(sum(ser),0) from contFootPhIns where 
  rtrim(sett_type) = @sett_type
  and sauda_date like  @sdate + '%'
  and (convert(int,contractno) = @contno )
  and sell_buy = @sell_buy
end
else if @flag = 3 
begin
  select Qty =isnull( sum(qty),0), Amount =isnull( sum(amount),0), Brokerage =isnull( sum(brokerage),0), Ser = isnull(sum(ser),0) from contFootIns where 
  rtrim(sett_type) = @sett_type
  and sauda_date like  @sdate + '%'
  and (convert(int,contractno) = @contno )
  and sell_buy = @sell_buy
end

GO
