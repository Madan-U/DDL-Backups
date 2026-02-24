-- Object: PROCEDURE dbo.ContFooterP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ContFooterP    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterP    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterP    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterP    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.ContFooterP    Script Date: 12/27/00 8:58:48 PM ******/

CREATE proc ContFooterP (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6), @sell_buy varchar(1),@flag smallint) as
if @flag = 1 
begin
 select Qty =isnull( sum(qty),0), Amount =isnull( sum(amount),0), Brokerage =isnull( sum(brokerage),0), Ser = isnull(sum(ser),0) from contFootPS where 
 rtrim(sett_type) = @sett_type
 and sauda_date like  @sdate + '%'
 and (convert(int,contractno) = @contno )
 and sell_buy = @sell_buy
end
else if @flag = 2 
begin
 select Qty =isnull( sum(qty),0), Amount =isnull( sum(amount),0), Brokerage =isnull( sum(brokerage),0), Ser = isnull(sum(ser),0) from contFootPh where 
 rtrim(sett_type) = @sett_type
 and sauda_date like  @sdate + '%'
 and (convert(int,contractno) = @contno )
 and sell_buy = @sell_buy
end
else if @flag = 3 
begin
 select Qty =isnull( sum(qty),0), Amount =isnull( sum(amount),0), Brokerage =isnull( sum(brokerage),0), Ser = isnull(sum(ser),0) from contFoot where 
 rtrim(sett_type) = @sett_type
 and sauda_date like  @sdate + '%'
 and (convert(int,contractno) = @contno )
 and sell_buy = @sell_buy
end

GO
