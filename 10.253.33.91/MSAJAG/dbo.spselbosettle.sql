-- Object: PROCEDURE dbo.spselbosettle
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.spselbosettle    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.spselbosettle    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.spselbosettle    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.spselbosettle    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.spselbosettle    Script Date: 12/27/00 8:59:04 PM ******/

CREATE procedure spselbosettle (@trddate varchar(10)) as 
select st_tradeno , st_order , '11' , scrip_cd , 'EQ' , scrip_cd ,0 , 1 , 1 ,
4431 , '7549' ,'1' ,
 st_bs  , st_qty ,
st_rate = 
          ( case 
              when 
                 st_bs = '1'
              then
                 st_rate - st_brk 
              when      
                 st_bs ='2'
              then
                 st_rate + st_brk 
            End
           )   , 
            
1 , st_client , 'N' , 0, 7 , st_date , st_date ,'NIL' , 1 from bosettle
where convert(varchar,st_date,103) like @trddate
/* Market Rate = Brokerage - rate  when buy as rate includes brokerage */
/*  MarketRate = Brokerage + rate  when sell  as rate includes brokerage */

GO
